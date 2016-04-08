/*
 * JOOS is Copyright (C) 1997 Laurie Hendren & Michael I. Schwartzbach
 *
 * Reproduction of all or part of this software is permitted for
 * educational or research use on condition that this copyright notice is
 * included in any copy. This software comes with no warranty of any
 * kind. In no event will the authors be liable for any damages resulting from
 * use of this software.
 *
 * email: hendren@cs.mcgill.ca, mis@brics.dk
 */

/**
 * dup
 * astore x
 * pop
 * aload x
 * -------->
 *  (blank)
 *
 *  if local x is not accessed again
 *
 *  removes 226 bytes
 */
int removeSavesAstore(CODE **c){
  int x,k;
  if (is_dup(*c) &&
      is_astore(next(*c),&x) && 
      is_pop(next(next(*c))) &&
      is_aload(next(next(next(*c))),&k) &&
      x==k
     ){
        CODE * cursor = *c;
        cursor = next(*c);
        while(cursor!=NULL){
            /*if not a basic block then exit*/
            if(uses_label(cursor,&k)){
                return 0;
            }
            else if(is_aload(cursor,&k)){
                /*can't replace because variable is read again*/
                return 0;
            }
            /*local not accessed*/
            else if(is_return(cursor) || is_areturn(cursor) || is_ireturn(cursor)|| (is_astore(cursor,&k) && k==x)){
                /*can replace*/
                return replace(c,4,NULL);
            }
            cursor = next(cursor);
        }
     return 0;
  }
  return 0;
}
/* iload x        iload x        iload x
 * ldc 0          ldc 1          ldc 2
 * imul           imul           imul
 * ------>        ------>        ------>
 * ldc 0          iload x        iload x
 *                               dup
 *                               iadd
 */

int simplify_multiplication_right(CODE **c)
{ int x,k;
  if (is_iload(*c,&x) && 
      is_ldc_int(next(*c),&k) && 
      is_imul(next(next(*c)))) {
     if (k==0) return replace(c,3,makeCODEldc_int(0,NULL));
     else if (k==1) return replace(c,3,makeCODEiload(x,NULL));
     else if (k==2) return replace(c,3,makeCODEiload(x,
                                       makeCODEdup(
                                       makeCODEiadd(NULL))));
     return 0;
  }
  return 0;
}

/* dup
 * astore x
 * pop
 * -------->
 * astore x
 */
int simplify_astore(CODE **c)
{ int x;
  if (is_dup(*c) &&
      is_astore(next(*c),&x) &&
      is_pop(next(next(*c)))) {
     return replace(c,3,makeCODEastore(x,NULL));
  }
  return 0;
}

/* dup
 * istore x
 * pop
 * -------->
 * istore x
 * Added by OSSAMA this reduces the benchmark from 20537 to 20077
 */
int simplify_istore(CODE **c)
{ int x;
  if (is_dup(*c) &&
      is_istore(next(*c),&x) &&
      is_pop(next(next(*c)))) {
     return replace(c,3,makeCODEistore(x,NULL));
  }
  return 0;
}

/* iload x
 * ldc k   (0<=k<=127)
 * iadd
 * istore x
 * --------->
 * iinc x k
 */ 
int positive_increment(CODE **c)
{ int x,y,k;
  if (is_iload(*c,&x) &&
      is_ldc_int(next(*c),&k) &&
      is_iadd(next(next(*c))) &&
      is_istore(next(next(next(*c))),&y) &&
      x==y && 0<=k && k<=127) {
     return replace(c,4,makeCODEiinc(x,k,NULL));
  }
  return 0;
}

/* 
 * ldc k   (0<=k<=127)
 * iload x 
 * iadd
 * istore x
 * --------->
 * iinc x k
 */ 
int positive_increment1(CODE **c)
{ int x,y,k;
  if ( is_ldc_int(*c,&k) &&
      is_iload(next(*c),&x) &&
      is_iadd(next(next(*c))) &&
      is_istore(next(next(next(*c))),&y) &&
      x==y && 0<=k && k<=127) {
     return replace(c,4,makeCODEiinc(x,k,NULL));
  }
  return 0;
}

/* goto L1
 * ...
 * L1:
 * goto L2
 * ...
 * L2:
 * --------->
 * goto L2
 * ...
 * L1:    (reference count reduced by 1)
 * goto L2
 * ...
 * L2:    (reference count increased by 1)  
 */
int simplify_goto_goto(CODE **c)
{ int l1,l2;
  if (is_goto(*c,&l1) && is_goto(next(destination(l1)),&l2) && l1>l2) {
     droplabel(l1);
     copylabel(l2);
     return replace(c,1,makeCODEgoto(l2,NULL));
  }
  return 0;
}

/* goto L1
 * ...
 * L1: (refrence count equals 1)
 * L2:
 * --------->
 * goto L2
 * ....
 * L1:
 * L2:    (reference count increased by 1)  
 */
int simplify_goto_label(CODE **c)
{ int l1,l2;
  if (is_goto(*c,&l1) && is_label(next(destination(l1)),&l2) && l1>l2) {
     droplabel(l1);
     copylabel(l2);
     return replace(c,1,makeCODEgoto(l2,NULL));
  }
  return 0;
}

/* goto L1
 * ...
 * L1: (refrence count equals 1)
 * L2:
 * --------->
 * goto L2
 * ....
 * L2:    (reference count increased by 1)  
 */
int delete_dead_goto_label(CODE **c)
{ int l1;
  if (is_label(*c,&l1) && deadlabel(l1)) {
     return replace(c,1,NULL);
  }
  return 0;
}



/* astore x
 * aload x
 * dup
 * -------->
 * dup
 * dup
 * astore 6
 * ADDED BY OSSAMA this reduces the benchmark from 20544 to 20537
 */

int simplify_aload_after_astore(CODE **c)
{ int x;
  int y;
  if(is_astore(*c,&x) &&
     is_aload(next(*c),&y) &&
     (x==y)&&
     is_dup(next(next(*c)))
    ){
    return replace(c,3,makeCODEdup(
                                    makeCODEdup(
                                    makeCODEastore(x,NULL))));
  }
  return 0;
}

/* astore x
 * aload x
 * -------->
 * dup
 * astore 6
 * ADDED BY OSSAMA this had 20077 to 20044
 */

int simplify_aload_after_astore2(CODE **c)
{ int x;
  int y;
  if(is_astore(*c,&x) &&
     is_aload(next(*c),&y) &&
     (x==y)
    ){
    return replace(c,3, makeCODEdup(
                        makeCODEastore(x,NULL)));
  }
  return 0;
}

/* istore x
 * iload x
 * dup
 * -------->
 * dup
 * dup
 * istore 6
 * ADDED BY OSSAMA this had no effect for the benchmark
 */

int simplify_iload_after_istore(CODE **c)
{ int x;
  int y;
  if(is_istore(*c,&x) &&
     is_iload(next(*c),&y) &&
     (x==y)&&
     is_dup(next(next(*c)))
    ){
    return replace(c,3,makeCODEdup(
                                    makeCODEdup(
                                    makeCODEistore(x,NULL))));
  }
  return 0;
}

/* istore x
 * iload x
 * -------->
 * dup
 * istore 6
 * ADDED BY OSSAMA this had 20077 to 20044
 */

int simplify_iload_after_istore2(CODE **c)
{ int x;
  int y;
  if(is_istore(*c,&x) &&
     is_iload(next(*c),&y) &&
     (x==y)
    ){
    return replace(c,3, makeCODEdup(
                        makeCODEistore(x,NULL)));
  }
  return 0;
}

/*iconst_0
  *istore_2
  *iconst_0
  *istore 5
 * -------->
 * iconst_0
 * dup
  *istore_2
  *istore 5
 * istore 6
 * TO BE IMPLEMENTED
 */

/* iinc x 0
 * --------->
 * null
 */ 
int positive_increment_0(CODE **c)
{ int x,k;
  if (is_iinc(*c,&x, &k) &&
      (k==0)) {
     return replace(c,1,NULL);
  }
  return 0;
}

/* iload x       
 * ldc 0       
 * iadd          
 * ------>       
 * iload x         
 *                        
 *                             
 */

int simplify_addition_right(CODE **c)
{ int x,k;
  if (is_iload(*c,&x) && 
      is_ldc_int(next(*c),&k) && 
      is_iadd(next(next(*c)))) {
     if (k==0) return replace(c,3,makeCODEiload(x,NULL));
  }
  return 0;
}

 /* aload_0
  * getfield Decoder/uti Llib/JoosBitwise;
  * aload_0
  * getfield Decoder/con LConversion;       
 * ------>       
  * aload_0
  * dup
  * getfield Decoder/uti Llib/JoosBitwise;
  * getfield Decoder/con LConversion;        
 *                        
 *                             
 */

int simplify_aload_severalgetfield(CODE **c)
{ int x,y;
  char *field1;
  char *field2;
  if (is_aload(*c,&x) && 
      is_getfield(next(*c), &field1) &&
      is_aload(next(next(*c)),&y) &&
      is_getfield(next(next(next(*c))), &field2)){
     if (x==y) return replace(c,4,makeCODEaload(x,
                                       makeCODEdup(
                                       makeCODEgetfield(field1, makeCODEgetfield(field2,NULL)))));
  }
  return 0;
}


 /* getfield Decoder/uti Llib/JoosBitwise;
  * getfield Decoder/uti Llib/JoosBitwise;       
 * ------>       
  * getfield Decoder/uti Llib/JoosBitwise;
 *  dup                         
 *                             
 */

int simplify_severalgetfield(CODE **c)
{ char *field1;
  char *field2;
  if ( is_getfield(*c, &field1) &&
      is_getfield(next(*c), &field2) &&
      (field1==field2) ){
     return replace(c,2, makeCODEgetfield(field1, makeCODEdup(NULL)));
  }
  return 0;
}

 /*  invokenonvirtual java/util/Vector/<init>(I)V
 *    dup
 *    aload_0
 *    swap
 *    putfield SudokuSolver/grid Ljava/util/Vector;
*     pop 
 * ------>       
*     invokenonvirtual java/util/Vector/<init>(I)V
 *    aload_0
 *    swap
 *    putfield SudokuSolver/grid Ljava/util/Vector;
 */

int simplify_pop_afterinvokenonvirtual(CODE **c)
{ int x;
  char *virtualmethod;
  char *field;
  if(is_invokenonvirtual(*c,&virtualmethod) &&
     is_dup(next(*c))  &&
     is_aload(next(next(*c)),&x)   &&
     is_swap(next(next(next(*c)))) &&
     is_putfield(next(next(next(next(*c)))), &field) &&
     is_pop(next(next(next(next(next(*c))))))
    ) {
    return replace(c,6,makeCODEinvokenonvirtual(virtualmethod,
                                       makeCODEaload(x, 
                                       makeCODEswap(
                                       makeCODEputfield(field , NULL)))));
  }
  return 0;
}

 /*  
 *    dup
 *    aload_0
 *    swap
 *    putfield SudokuSolver/grid Ljava/util/Vector;
*     pop 
 * ------>       
 *    aload_0
 *    swap
 *    putfield SudokuSolver/grid Ljava/util/Vector;
 */

int simplify_pop_afterinvokevirtual(CODE **c)
{ int x;
  char *virtualmethod;
  char *field;
  if(
     is_dup(*c)  &&
     is_aload(next(*c),&x)   &&
     is_swap(next(next(*c))) &&
     is_putfield(next(next(next(*c))), &field) &&
     is_pop(next(next(next(next(*c)))))
    ) {
    return replace(c,5,
                                       makeCODEaload(x, 
                                       makeCODEswap(
                                       makeCODEputfield(field , NULL))));
  }
  return 0;
}
/*
#define OPTS 4

OPTI optimization[OPTS] = {simplify_multiplication_right,
                           simplify_astore,
                           positive_increment,
                           simplify_goto_goto};
*/

int init_patterns()
{ 
    ADD_PATTERN(removeSavesAstore);
    /*ADD_PATTERN(simplify_multiplication_right);
    ADD_PATTERN(simplify_astore);
    ADD_PATTERN(positive_increment);
    ADD_PATTERN(simplify_goto_goto);
    ADD_PATTERN(simplify_aload_after_astore);
    ADD_PATTERN(simplify_iload_after_istore);
    ADD_PATTERN(simplify_istore);
    ADD_PATTERN(simplify_iload_after_istore2);
    ADD_PATTERN(simplify_aload_after_astore2);
    ADD_PATTERN(positive_increment_0);
    ADD_PATTERN(positive_increment1);
    ADD_PATTERN(simplify_addition_right);*/
/*    ADD_PATTERN(simplify_goto_label); //didnt decrease anything but decreased sizeof emitted j code not the size in bytes, dont know why !!*/
/*    ADD_PATTERN(delete_dead_goto_label); //didnt decrease anything WIERD*/
/*    ADD_PATTERN(simplify_aload_severalgetfield);
     ADD_PATTERN(simplify_pop_afterinvokenonvirtual);
    ADD_PATTERN(simplify_pop_afterinvokevirtual);
    ADD_PATTERN(simplify_severalgetfield);*/
    return 1;
}
