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
 * ifeq true_1
 * iconst_0
 * goto stop_2
 * true_1
 * iconst_1
 * stop_2
 * ifeq stop_0
 * ----------->
 *  ifneq stop_0
 */

/**
 * aload x
 * aload k
 * swap
 * ------>
 *  aload k
 *  aload x
 *
 * removes swaps
 * removes73 bytes
 * ADDED BY SHABBIR
 */

int remove_swap(CODE **c){
  int x,k;
  char * arg;
  if (is_aload(*c,&x) || is_iload(*c,&x) || is_ldc_int(*c,&x) || is_ldc_string(*c,&arg) ){
    if (is_aload(next(*c),&k) || is_iload(next(*c),&k) || is_ldc_int(next(*c),&k)|| is_ldc_string(next(*c),&arg)){
      if (is_swap(next(next(*c)))){
        CODE *i1 = *c;
        CODE *i2 = i1->next;
        i1 = i2;
        i2 = *c;
        *c= i1->next->next;
      }
  }
  }
  return 0;
}


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
 *  ADDED BY SHABBIR
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

/**
 * dup
 * istore x
 * pop
 * iload x
 * -------->
 *  (blank)
 *
 *  if local x is not accessed again
 *
 *  removes 114 bytes
 *  ADDED BY SHABBIR 
 */
int removeSavesIstore(CODE **c){
  int x,k;
  if (is_dup(*c) &&
      is_istore(next(*c),&x) && 
      is_pop(next(next(*c))) &&
      is_iload(next(next(next(*c))),&k) &&
      x==k
     ){
        CODE * cursor = *c;
        cursor = next(*c);
        while(cursor!=NULL){
            /*if not a basic block then exit*/
            if(uses_label(cursor,&k)){
                return 0;
            }
            else if(is_iload(cursor,&k)){
                /*can't replace because variable is read again*/
                return 0;
            }
            /*local not accessed*/
            else if(is_return(cursor) || is_areturn(cursor) || is_ireturn(cursor)|| (is_istore(cursor,&k) && k==x)){
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
 * iinc x k   ADDED BY OSSAMA
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
 ADDED BY OSSAMA  
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
 ADDED BY OSSAMA
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
 ADDED BY OSSAMA
 */
int delete_dead_goto_label(CODE **c)
{ int l1;
  if (is_label(*c,&l1) && deadlabel(l1)) {
     return kill_line(c);
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
    return replace(c,2, makeCODEdup(
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
    return replace(c,2, makeCODEdup(
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
 ADDED BY OSSAMA
 */ 
int positive_increment_0(CODE **c)
{ int x,k;
  if (is_iinc(*c,&x, &k) &&
      (k==0)) {
     return kill_line(c);
  }
  return 0;
}

 /*
  iload_2
  iconst_1
  isub
  istore_2
  --------->
  iinc 2 -1
  ADDED BY MICHAEL
*/
int negative_increment(CODE **c)
{ int x,y,k;
  if ( is_iload(*c,&k) &&
      is_ldc_int(next(*c),&x) &&
      is_isub(next(next(*c))) &&
      is_istore(next(next(next(*c))),&y) &&
      k==y && 0<=x && x<=127) {
     return replace(c,4,makeCODEiinc(k,x,NULL));
  }
  return 0;
}

/* iload x       
 * ldc 0       
 * iadd          
 * ------>       
 * iload x 
 ADDED BY OSSAMA        
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

/*ldc 0  
 * iload x             
 * iadd          
 * ------>       
 * iload x 
 ADDED BY OSSAMA        
 *                        
 *                             
 */

int simplify_addition_right1(CODE **c)
{ int x,k;
  if (is_ldc_int(*c,&k) &&
      is_iload(next(*c),&x) && 
      is_iadd(next(next(*c)))) {
     if (k==0) return replace(c,3,makeCODEiload(x,NULL));
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
 ADDED BY OSSAMA
 */

int simplify_pop_afterinvokenonvirtual(CODE **c){
  int x;
  char *virtualmethod;
  char *field;
  if (is_invokenonvirtual(*c,&virtualmethod) &&
      is_dup(next(*c))  &&
      is_aload(next(next(*c)),&x)   &&
      is_swap(next(next(next(*c)))) &&
      is_putfield(next(next(next(next(*c)))), &field) &&
      is_pop(next(next(next(next(next(*c))))))) {
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
 ADDED BY OSSAMA
 */

int simplify_pop_afterinvokevirtual(CODE **c){
  int x;
  char *field;
  if (is_dup(*c) &&
      is_aload(next(*c),&x)   &&
      is_swap(next(next(*c))) &&
      is_putfield(next(next(next(*c))), &field) &&
      is_pop(next(next(next(next(*c)))))) {
      return replace(c,5,makeCODEaload(x, makeCODEswap(makeCODEputfield(field , NULL))));
  }
  return 0;
}

/**
  if( col >= 8 )
      this.solveCell( row, col + 1 ) ;
  else
      this.solveCell( row + 1, 0 ) ;
    }
===>
if_icmpge label1 
iconst_0
goto label2 
label1:
iconst_1
label2:
ifeq label3 
------->
if_icmplt label3
 ADDED BY OSSAMA
*/
int simplify_if_else_with_icmpge(CODE **c) {
  int label1, label2, label3, labeltemp;
  int x, y;
  if (is_if_icmpge(*c, &label1) &&
      is_ldc_int(next(*c), &x) && 
      (x==0)  &&
      is_goto(next(next(*c)), &label2)  &&
      is_label(next(next(next(*c))), &labeltemp) && 
      (labeltemp==label1) &&
      is_ldc_int(next(next(next(next(*c)))), &y) && 
      (y==1) &&
      is_label(next(next(next(next(next(*c))))), &labeltemp) && 
      ( labeltemp== label2) &&
      is_ifeq(next(next(next(next(next(next(*c)))))), &label3) && 
      uniquelabel(label1) && uniquelabel(label2))  {
    droplabel(label1);
    droplabel(label2);
    return replace(c, 7, makeCODEif_icmplt(label3,NULL));
  }
  return 0;
}

/**
  if( col < 8 )
      this.solveCell( row, col + 1 ) ;
  else
      this.solveCell( row + 1, 0 ) ;
    }
===>
if_icmplt label1 
iconst_0
goto label2 
label1:
iconst_1
label2:
ifeq label3 
------->
if_icmpge label3
 ADDED BY OSSAMA
*/
int simplify_if_else_with_icmplt(CODE **c) {
  int label1, label2, label3, labeltemp;
  int x, y;
  if (is_if_icmplt(*c, &label1) &&
      is_ldc_int(next(*c), &x) && 
      (x==0)  &&
      is_goto(next(next(*c)), &label2)  &&
      is_label(next(next(next(*c))), &labeltemp) && 
      (labeltemp==label1) &&
      is_ldc_int(next(next(next(next(*c)))), &y) && 
      (y==1) &&
      is_label(next(next(next(next(next(*c))))), &labeltemp) && 
      ( labeltemp== label2) &&
      is_ifeq(next(next(next(next(next(next(*c)))))), &label3) && 
      uniquelabel(label1) && uniquelabel(label2))  {
    droplabel(label1);
    droplabel(label2);
    return replace(c, 7, makeCODEif_icmpge(label3,NULL));
  }
  return 0;
}

/**
  if( col > 8 )
      this.solveCell( row, col + 1 ) ;
  else
      this.solveCell( row + 1, 0 ) ;
    }
===>
if_icmpgt label1 
iconst_0
goto label2 
label1:
iconst_1
label2:
ifeq label3 
------->
if_icmple label3
 ADDED BY OSSAMA
*/
int simplify_if_else_with_icmpgt(CODE **c) {
  int label1, label2, label3, labeltemp;
  int x, y;
  if (is_if_icmpgt(*c, &label1) &&
      is_ldc_int(next(*c), &x) && 
      (x==0)  &&
      is_goto(next(next(*c)), &label2)  &&
      is_label(next(next(next(*c))), &labeltemp) && 
      (labeltemp==label1) &&
      is_ldc_int(next(next(next(next(*c)))), &y) && 
      (y==1) &&
      is_label(next(next(next(next(next(*c))))), &labeltemp) && 
      ( labeltemp== label2) &&
      is_ifeq(next(next(next(next(next(next(*c)))))), &label3) && 
      uniquelabel(label1) && uniquelabel(label2))  {
    droplabel(label1);
    droplabel(label2);
    return replace(c, 7, makeCODEif_icmple(label3,NULL));
  }
  return 0;
}

/**
  if( col <= 8 )
      this.solveCell( row, col + 1 ) ;
  else
      this.solveCell( row + 1, 0 ) ;
    }
===>
if_icmple label1 
iconst_0
goto label2 
label1:
iconst_1
label2:
ifeq label3 
------->
if_icmpgt label3
 ADDED BY OSSAMA
*/
int simplify_if_else_with_icmple(CODE **c) {
  int label1, label2, label3, labeltemp;
  int x, y;
  if (is_if_icmple(*c, &label1) &&
      is_ldc_int(next(*c), &x) && 
      (x==0)  &&
      is_goto(next(next(*c)), &label2)  &&
      is_label(next(next(next(*c))), &labeltemp) && 
      (labeltemp==label1) &&
      is_ldc_int(next(next(next(next(*c)))), &y) && 
      (y==1) &&
      is_label(next(next(next(next(next(*c))))), &labeltemp) && 
      ( labeltemp== label2) &&
      is_ifeq(next(next(next(next(next(next(*c)))))), &label3) && 
      uniquelabel(label1) && uniquelabel(label2))  {
    droplabel(label1);
    droplabel(label2);
    return replace(c, 7, makeCODEif_icmpgt(label3,NULL));
  }
  return 0;
}

/**
  if( col != 8 )
      this.solveCell( row, col + 1 ) ;
  else
      this.solveCell( row + 1, 0 ) ;
    }
===>
if_icmpne label1 
iconst_0
goto label2 
label1:
iconst_1
label2:
ifeq label3 
------->
if_icmpeq label3
 ADDED BY OSSAMA
*/
int simplify_if_else_with_icmpne(CODE **c) {
  int label1, label2, label3, labeltemp;
  int x, y;
  if (is_if_icmpne(*c, &label1) &&
      is_ldc_int(next(*c), &x) && 
      (x==0)  &&
      is_goto(next(next(*c)), &label2)  &&
      is_label(next(next(next(*c))), &labeltemp) && 
      (labeltemp==label1) &&
      is_ldc_int(next(next(next(next(*c)))), &y) && 
      (y==1) &&
      is_label(next(next(next(next(next(*c))))), &labeltemp) && 
      ( labeltemp== label2) &&
      is_ifeq(next(next(next(next(next(next(*c)))))), &label3) && 
      uniquelabel(label1) && uniquelabel(label2))  {
    droplabel(label1);
    droplabel(label2);
    return replace(c, 7, makeCODEif_icmpeq(label3,NULL));
  }
  return 0;
}
/**
  if( o1 != o2 )
      this.solveCell( row, col + 1 ) ;
  else
      this.solveCell( row + 1, 0 ) ;
    }
===>
if_icmpne label1 
iconst_0
goto label2 
label1:
iconst_1
label2:
ifeq label3 
------->
if_icmpeq label3
 ADDED BY OSSAMA
*/
int simplify_if_else_with_acmpne(CODE **c) {
  int label1, label2, label3, labeltemp;
  int x, y;
  if (is_if_acmpne(*c, &label1) &&
      is_ldc_int(next(*c), &x) && 
      (x==0)  &&
      is_goto(next(next(*c)), &label2)  &&
      is_label(next(next(next(*c))), &labeltemp) && 
      (labeltemp==label1) &&
      is_ldc_int(next(next(next(next(*c)))), &y) && 
      (y==1) &&
      is_label(next(next(next(next(next(*c))))), &labeltemp) && 
      ( labeltemp== label2) &&
      is_ifeq(next(next(next(next(next(next(*c)))))), &label3) && 
      uniquelabel(label1) && uniquelabel(label2))  {
    droplabel(label1);
    droplabel(label2);
    return replace(c, 7, makeCODEif_acmpeq(label3,NULL));
  }
  return 0;
}


/**
  if( col == 8 )
      this.solveCell( row, col + 1 ) ;
  else
      this.solveCell( row + 1, 0 ) ;
    }
===>
if_icmpeq label1 
iconst_0
goto label2 
label1:
iconst_1
label2:
ifeq label3 
------->
if_icmpne label3
 ADDED BY OSSAMA
*/
int simplify_if_else_with_icmpeq(CODE **c) {
  int label1, label2, label3, labeltemp;
  int x, y;
  if (is_if_icmpeq(*c, &label1) &&
      is_ldc_int(next(*c), &x) && 
      (x==0)  &&
      is_goto(next(next(*c)), &label2)  &&
      is_label(next(next(next(*c))), &labeltemp) && 
      (labeltemp==label1) &&
      is_ldc_int(next(next(next(next(*c)))), &y) && 
      (y==1) &&
      is_label(next(next(next(next(next(*c))))), &labeltemp) && 
      ( labeltemp== label2) &&
      is_ifeq(next(next(next(next(next(next(*c)))))), &label3) && 
      uniquelabel(label1) && uniquelabel(label2))  {
    droplabel(label1);
    droplabel(label2);
    return replace(c, 7, makeCODEif_icmpne(label3,NULL));
  }
  return 0;
}
/**
  if( o1 == o2 )
      this.solveCell( row, col + 1 ) ;
  else
      this.solveCell( row + 1, 0 ) ;
    }
===>
if_acmpeq label1 
iconst_0
goto label2 
label1:
iconst_1
label2:
ifeq label3 
------->
if_acmpne label3
 ADDED BY OSSAMA
*/
int simplify_if_else_with_acmpeq(CODE **c) {
  int label1, label2, label3, labeltemp;
  int x, y;
  if (is_if_acmpeq(*c, &label1) &&
      is_ldc_int(next(*c), &x) && 
      (x==0)  &&
      is_goto(next(next(*c)), &label2)  &&
      is_label(next(next(next(*c))), &labeltemp) && 
      (labeltemp==label1) &&
      is_ldc_int(next(next(next(next(*c)))), &y) && 
      (y==1) &&
      is_label(next(next(next(next(next(*c))))), &labeltemp) && 
      ( labeltemp== label2) &&
      is_ifeq(next(next(next(next(next(next(*c)))))), &label3) && 
      uniquelabel(label1) && uniquelabel(label2))  {
    droplabel(label1);
    droplabel(label2);
    return replace(c, 7, makeCODEif_acmpne(label3,NULL));
  }
  return 0;
}
/**
iload_3
iconst_0
if_icmpeq label1
iconst_0
goto label2
label1:
iconst_1
label2:
dup     1 1   0 0
ifne label3
pop empty
.
.
. 
label3: 
------->
iconst_1
iload_3 
iconst_0
if_icmpeq label3
pop
.
.
.
label3: 1

 ADDED BY OSSAMA
*/
int simplify_if_else_with_icmpeq_ne(CODE **c) {
  int cmp1, cmp2;
  int label1, label2, label3, labeltemp;
  int x, y;
  CODE **q;
  if (is_iload(*c, &cmp1) &&
      is_ldc_int(next(*c), &cmp2) &&
      is_if_icmpeq(next(next(*c)), &label1) &&
      is_ldc_int(next(next(next(*c))), &x) && 
      (x==0)  &&
      is_goto(next(next(next(next(*c)))), &label2)  &&
      is_label(next(next(next(next(next(*c))))), &labeltemp) && 
      (labeltemp==label1) &&
      is_ldc_int(next(next(next(next(next(next(*c)))))), &y) && 
      (y==1) &&
      is_label(next(next(next(next(next(next(next(*c))))))), &labeltemp) && 
      ( labeltemp== label2) &&
      is_dup(next(next(next(next(next(next(next(next(*c))))))))) &&
      is_ifne(next(next(next(next(next(next(next(next(next(*c))))))))), &label3) && 
      is_pop(next(next(next(next(next(next(next(next(next(next(*c))))))))))) &&
      uniquelabel(label1) && uniquelabel(label2))  {
         droplabel(label1);
         droplabel(label2);     
         return replace(c, 11,makeCODEldc_int(y,makeCODEiload(cmp1, makeCODEldc_int(cmp2,makeCODEif_icmpeq(label3,makeCODEpop(NULL))))));

  }
  return 0;
}
/**
iload_3
iconst_0
if_icmpne label1
iconst_0
goto label2
label1:
iconst_1
label2:
dup     1 1   0 0
ifeq label3
pop empty
.
.
. 
label3: 
------->
iconst_0
iload_3 
iconst_0
if_icmpeq label3
pop
.
.
.
label3: 1

 ADDED BY OSSAMA
*/
int simplify_if_else_with_icmpne_eq(CODE **c) {
  int cmp1, cmp2;
  int label1, label2, label3, labeltemp;
  int x, y;
  CODE **q;
  if (is_iload(*c, &cmp1) &&
      is_ldc_int(next(*c), &cmp2) &&
      is_if_icmpne(next(next(*c)), &label1) &&
      is_ldc_int(next(next(next(*c))), &x) && 
      (x==0)  &&
      is_goto(next(next(next(next(*c)))), &label2)  &&
      is_label(next(next(next(next(next(*c))))), &labeltemp) && 
      (labeltemp==label1) &&
      is_ldc_int(next(next(next(next(next(next(*c)))))), &y) && 
      (y==1) &&
      is_label(next(next(next(next(next(next(next(*c))))))), &labeltemp) && 
      ( labeltemp== label2) &&
      is_dup(next(next(next(next(next(next(next(next(*c))))))))) &&
      is_ifeq(next(next(next(next(next(next(next(next(next(*c))))))))), &label3) && 
      is_pop(next(next(next(next(next(next(next(next(next(next(*c))))))))))) &&
      uniquelabel(label1) && uniquelabel(label2))  {
         droplabel(label1);
         droplabel(label2);     
         return replace(c, 11,makeCODEldc_int(x,makeCODEiload(cmp1, makeCODEldc_int(cmp2,makeCODEif_icmpeq(label3,makeCODEpop(NULL))))));

  }
  return 0;
}

/**
  ifnull null_8
  goto stop_9
  null_8:
  pop
  ldc "null"
------->
ifnonnull stop_9
pop
ldc "null"

 ADDED BY OSSAMA
*/
int simplify_if_null(CODE **c) {
  int label1, label2, labeltemp;
  char* x;
  if (is_ifnull(*c, &label1) &&
      is_goto(next(*c), &label2)  &&
      is_label(next(next(*c)), &labeltemp) && 
      (labeltemp==label1) &&
      is_pop(next(next(next(*c)))) &&
      is_ldc_string(next(next(next(next(*c)))), &x) && 
      is_label(next(next(next(next(next(*c))))), &labeltemp) && 
      ( labeltemp== label2) &&
      uniquelabel(label1))  {
    droplabel(label1);
    return replace(c, 5, makeCODEifnonnull(label2,makeCODEpop(makeCODEldc_string(x,NULL))) );
  }
  return 0;
}

/**
  ifnonnull null_8
  goto stop_9
  null_8:
  pop
  ldc "null"
------->
ifnull stop_9
pop
ldc "null"

 ADDED BY OSSAMA
*/
int simplify_if_nonnull(CODE **c) {
  int label1, label2, labeltemp;
  char* x;
  if (is_ifnonnull(*c, &label1) &&
      is_goto(next(*c), &label2)  &&
      is_label(next(next(*c)), &labeltemp) && 
      (labeltemp==label1) &&
      is_pop(next(next(next(*c)))) &&
      is_ldc_string(next(next(next(next(*c)))), &x) && 
      is_label(next(next(next(next(next(*c))))), &labeltemp) && 
      ( labeltemp== label2) &&
      uniquelabel(label1))  {
    droplabel(label1);
    return replace(c, 5, makeCODEifnull(label2,makeCODEpop(makeCODEldc_string(x,NULL))) );
  }
  return 0;
}


/* nop
 * ------->
 */
int remove_nop(CODE **c) {
  if (is_nop(*c)) {
    return replace(c,1,NULL);
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
    ADD_PATTERN(simplify_if_else_with_icmpeq_ne);
    ADD_PATTERN(simplify_if_else_with_icmpne_eq); 
    ADD_PATTERN(simplify_if_else_with_icmple);
    ADD_PATTERN(simplify_if_else_with_icmpgt);
    ADD_PATTERN(simplify_if_else_with_icmplt);
    ADD_PATTERN(simplify_if_else_with_icmpge);
    ADD_PATTERN(simplify_if_else_with_icmpne);
    ADD_PATTERN(simplify_if_else_with_icmpeq);
    ADD_PATTERN(simplify_addition_right1);
    ADD_PATTERN(simplify_if_else_with_acmpeq);
    ADD_PATTERN(simplify_if_else_with_acmpne);
    ADD_PATTERN(simplify_if_null);
    ADD_PATTERN(simplify_if_nonnull);

    // // ADD_PATTERN(removeSavesIstore);
    // // ADD_PATTERN(removeSavesAstore);
    ADD_PATTERN(simplify_astore);
    ADD_PATTERN(simplify_istore);
    ADD_PATTERN(positive_increment);
    ADD_PATTERN(simplify_multiplication_right);
    ADD_PATTERN(simplify_goto_goto);
    ADD_PATTERN(simplify_aload_after_astore);
    ADD_PATTERN(simplify_iload_after_istore);
    ADD_PATTERN(simplify_iload_after_istore2);
    ADD_PATTERN(simplify_aload_after_astore2);
    ADD_PATTERN(positive_increment_0);
    ADD_PATTERN(positive_increment1);
    ADD_PATTERN(simplify_addition_right);
    ADD_PATTERN(simplify_goto_label); 
    ADD_PATTERN(simplify_pop_afterinvokenonvirtual);
    ADD_PATTERN(simplify_pop_afterinvokevirtual);
    ADD_PATTERN(delete_dead_goto_label);
    // ADD_PATTERN(remove_swap);
    // ADD_PATTERN(remove_nop);
    return 1;
}
