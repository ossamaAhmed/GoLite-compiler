/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 13 "joos.y" /* yacc.c:339  */

 
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "tree.h"

extern CLASSFILE *theclassfile;
 

#line 77 "y.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "y.tab.h".  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    tABSTRACT = 258,
    tBOOLEAN = 259,
    tBREAK = 260,
    tBYTE = 261,
    tCASE = 262,
    tCATCH = 263,
    tCHAR = 264,
    tCLASS = 265,
    tCONST = 266,
    tCONTINUE = 267,
    tDEFAULT = 268,
    tDO = 269,
    tDOUBLE = 270,
    tELSE = 271,
    tEXTENDS = 272,
    tEXTERN = 273,
    tFINAL = 274,
    tFINALLY = 275,
    tFLOAT = 276,
    tFOR = 277,
    tGOTO = 278,
    tIF = 279,
    tIMPLEMENTS = 280,
    tIMPORT = 281,
    tIN = 282,
    tINSTANCEOF = 283,
    tINT = 284,
    tINTERFACE = 285,
    tLONG = 286,
    tMAIN = 287,
    tMAINARGV = 288,
    tNATIVE = 289,
    tNEW = 290,
    tNULL = 291,
    tPACKAGE = 292,
    tPRIVATE = 293,
    tPROTECTED = 294,
    tPUBLIC = 295,
    tRETURN = 296,
    tSHORT = 297,
    tSTATIC = 298,
    tSUPER = 299,
    tSWITCH = 300,
    tSYNCHRONIZED = 301,
    tTHIS = 302,
    tTHROW = 303,
    tTHROWS = 304,
    tTRANSIENT = 305,
    tTRY = 306,
    tVOID = 307,
    tVOLATILE = 308,
    tWHILE = 309,
    tEQ = 310,
    tLEQ = 311,
    tGEQ = 312,
    tNEQ = 313,
    tAND = 314,
    tOR = 315,
    tINC = 316,
    tPATH = 317,
    tERROR = 318,
    tINTCONST = 319,
    tBOOLCONST = 320,
    tCHARCONST = 321,
    tSTRINGCONST = 322,
    tIDENTIFIER = 323
  };
#endif
/* Tokens.  */
#define tABSTRACT 258
#define tBOOLEAN 259
#define tBREAK 260
#define tBYTE 261
#define tCASE 262
#define tCATCH 263
#define tCHAR 264
#define tCLASS 265
#define tCONST 266
#define tCONTINUE 267
#define tDEFAULT 268
#define tDO 269
#define tDOUBLE 270
#define tELSE 271
#define tEXTENDS 272
#define tEXTERN 273
#define tFINAL 274
#define tFINALLY 275
#define tFLOAT 276
#define tFOR 277
#define tGOTO 278
#define tIF 279
#define tIMPLEMENTS 280
#define tIMPORT 281
#define tIN 282
#define tINSTANCEOF 283
#define tINT 284
#define tINTERFACE 285
#define tLONG 286
#define tMAIN 287
#define tMAINARGV 288
#define tNATIVE 289
#define tNEW 290
#define tNULL 291
#define tPACKAGE 292
#define tPRIVATE 293
#define tPROTECTED 294
#define tPUBLIC 295
#define tRETURN 296
#define tSHORT 297
#define tSTATIC 298
#define tSUPER 299
#define tSWITCH 300
#define tSYNCHRONIZED 301
#define tTHIS 302
#define tTHROW 303
#define tTHROWS 304
#define tTRANSIENT 305
#define tTRY 306
#define tVOID 307
#define tVOLATILE 308
#define tWHILE 309
#define tEQ 310
#define tLEQ 311
#define tGEQ 312
#define tNEQ 313
#define tAND 314
#define tOR 315
#define tINC 316
#define tPATH 317
#define tERROR 318
#define tINTCONST 319
#define tBOOLCONST 320
#define tCHARCONST 321
#define tSTRINGCONST 322
#define tIDENTIFIER 323

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 26 "joos.y" /* yacc.c:355  */

   struct CLASSFILE *classfile;
   struct CLASS *class;
   struct FIELD *field;
   struct TYPE *type;
   struct ID *id;
   struct CONSTRUCTOR *constructor;
   struct METHOD *method;
   struct FORMAL *formal;
   struct STATEMENT *statement;
   struct EXP *exp;
   struct RECEIVER *receiver;
   struct ARGUMENT *argument;
   int modifier;
   int intconst;
   int boolconst;
   char charconst;
   char *stringconst;

#line 273 "y.tab.c" /* yacc.c:355  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 288 "y.tab.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  7
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   540

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  87
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  70
/* YYNRULES -- Number of rules.  */
#define YYNRULES  151
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  317

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   323

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    85,     2,     2,     2,    84,     2,     2,
      73,    74,    82,    80,    72,    81,    86,    83,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,    71,
      78,    77,    79,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    75,     2,    76,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    69,     2,    70,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    97,    97,    99,   103,   104,   107,   113,   114,   116,
     120,   122,   126,   132,   133,   137,   139,   141,   143,   148,
     149,   153,   155,   159,   163,   165,   169,   171,   175,   186,
     188,   192,   197,   198,   202,   204,   208,   213,   214,   218,
     220,   224,   226,   228,   230,   234,   236,   240,   242,   247,
     248,   252,   254,   258,   260,   264,   266,   268,   273,   275,
     280,   281,   285,   287,   291,   293,   295,   297,   299,   301,
     305,   309,   311,   313,   315,   319,   323,   327,   329,   331,
     333,   337,   342,   346,   358,   363,   368,   369,   371,   372,
     375,   376,   386,   395,   399,   401,   403,   405,   408,   413,
     414,   418,   422,   424,   428,   430,   434,   436,   440,   442,
     444,   448,   450,   452,   454,   456,   458,   462,   464,   466,
     472,   474,   476,   478,   482,   484,   489,   491,   493,   496,
     499,   503,   505,   509,   511,   513,   515,   517,   521,   525,
     529,   531,   533,   538,   539,   543,   545,   549,   551,   553,
     555,   557
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "tABSTRACT", "tBOOLEAN", "tBREAK",
  "tBYTE", "tCASE", "tCATCH", "tCHAR", "tCLASS", "tCONST", "tCONTINUE",
  "tDEFAULT", "tDO", "tDOUBLE", "tELSE", "tEXTENDS", "tEXTERN", "tFINAL",
  "tFINALLY", "tFLOAT", "tFOR", "tGOTO", "tIF", "tIMPLEMENTS", "tIMPORT",
  "tIN", "tINSTANCEOF", "tINT", "tINTERFACE", "tLONG", "tMAIN",
  "tMAINARGV", "tNATIVE", "tNEW", "tNULL", "tPACKAGE", "tPRIVATE",
  "tPROTECTED", "tPUBLIC", "tRETURN", "tSHORT", "tSTATIC", "tSUPER",
  "tSWITCH", "tSYNCHRONIZED", "tTHIS", "tTHROW", "tTHROWS", "tTRANSIENT",
  "tTRY", "tVOID", "tVOLATILE", "tWHILE", "tEQ", "tLEQ", "tGEQ", "tNEQ",
  "tAND", "tOR", "tINC", "tPATH", "tERROR", "tINTCONST", "tBOOLCONST",
  "tCHARCONST", "tSTRINGCONST", "tIDENTIFIER", "'{'", "'}'", "';'", "','",
  "'('", "')'", "'['", "']'", "'='", "'<'", "'>'", "'+'", "'-'", "'*'",
  "'/'", "'%'", "'!'", "'.'", "$accept", "classfile", "imports", "class",
  "classmods", "externclasses", "externclass", "extension", "type",
  "fields", "nefields", "field", "idlist", "constructors", "constructor",
  "externconstructors", "externconstructor", "formals", "neformals",
  "formal", "methods", "nemethods", "method", "methodmods", "mainargv",
  "externmethods", "externnemethods", "externmethod", "externmods",
  "returntype", "statements", "nestatements", "statement", "declaration",
  "simplestatement", "ifthenstatement", "ifthenelsestatement",
  "statementnoshortif", "ifthenelsestatementnoshortif", "whilestatement",
  "whilestatementnoshortif", "forstatement", "forstatementnoshortif",
  "listassignexp", "nelistassignexp", "listbooleanexp",
  "incrementexpression", "expressionstatement", "statementexpression",
  "returnstatement", "returnexpression", "assignment", "expression",
  "orexpression", "andexpression", "eqexpression", "relexpression",
  "addexpression", "multexpression", "unaryexpression",
  "unaryexpressionnotminus", "castexpression", "postfixexpression",
  "primaryexpression", "classinstancecreation", "methodinvocation",
  "receiver", "arguments", "nearguments", "literal", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   123,
     125,    59,    44,    40,    41,    91,    93,    61,    60,    62,
      43,    45,    42,    47,    37,    33,    46
};
# endif

#define YYPACT_NINF -284

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-284)))

#define YYTABLE_NINF -142

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
       7,    -9,    57,   -21,     7,  -284,    15,  -284,    15,  -284,
    -284,  -284,  -284,  -284,    49,    69,    14,    18,    76,    76,
      35,    84,    44,  -284,    47,    77,    51,    17,    82,    77,
    -284,    91,  -284,  -284,  -284,  -284,    56,    65,   102,  -284,
    -284,    80,   104,  -284,  -284,   -10,    85,     4,  -284,    79,
     115,  -284,    87,   403,  -284,    94,   117,  -284,  -284,    99,
      17,    23,  -284,   119,  -284,  -284,    85,  -284,    23,   105,
    -284,   359,  -284,    17,  -284,  -284,  -284,    87,    23,   106,
    -284,   405,  -284,  -284,   108,   112,   107,  -284,   124,   148,
     129,   125,   127,   134,   133,  -284,   142,    17,   137,   143,
     144,    17,   160,   146,    17,   170,  -284,    17,   166,    17,
     162,  -284,    17,   164,   167,   168,   -51,   169,   171,   172,
     174,   178,   394,   179,   176,   177,   183,   187,   282,   184,
    -284,   190,  -284,  -284,  -284,  -284,  -284,  -284,  -284,   -57,
     235,   430,   430,  -284,  -284,   200,   202,     0,    40,   -14,
     141,  -284,  -284,  -284,  -284,   180,  -284,  -284,   182,   188,
     191,  -284,  -284,   189,   201,   282,   282,   199,   203,   394,
     204,   -47,   282,  -284,   394,    56,   205,   282,  -284,  -284,
    -284,  -284,  -284,  -284,  -284,  -284,  -284,   207,  -284,  -284,
    -284,   194,   195,  -284,   211,   394,   214,   215,   206,  -284,
    -284,   430,   430,   430,   430,   217,   430,   430,   430,   430,
     430,   430,   430,   430,   430,   226,   225,   394,  -284,  -284,
     227,   237,   465,   394,   234,  -284,   394,  -284,   239,   236,
      -1,  -284,  -284,  -284,   394,  -284,   430,   455,   202,     0,
      40,    40,  -284,   -14,   -14,   -14,   -14,   141,   141,  -284,
    -284,  -284,   240,   282,  -284,  -284,  -284,   -13,   241,   242,
    -284,   245,  -284,   247,  -284,  -284,  -284,   248,  -284,  -284,
     394,   254,   394,   465,   330,   282,  -284,   251,  -284,   244,
    -284,  -284,   255,   257,   258,  -284,   311,   316,  -284,  -284,
    -284,  -284,  -284,   465,   465,   394,   394,   282,   259,   264,
     263,   266,  -284,   282,   394,   330,   330,  -284,   267,   325,
    -284,   465,   330,   268,  -284,   330,  -284
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       4,     0,     0,     0,     3,    10,     7,     1,     7,     5,
       2,    11,     9,     8,     0,     0,     0,     0,    13,    13,
       0,     0,     0,    14,     0,    19,     0,     0,     0,    20,
      21,     0,    17,    16,    18,    15,     0,     0,    37,    26,
      22,     0,    49,    29,    24,     0,     0,     0,    27,     0,
      38,    39,     0,     0,    30,     0,    50,    51,    23,     0,
      32,     0,    45,     0,    46,    58,    15,    59,     0,     0,
       6,     0,    40,    32,    56,    55,    57,    15,     0,     0,
      12,     0,    52,    25,     0,     0,    33,    34,     0,     0,
       0,     0,     0,     0,     0,    36,     0,     0,     0,     0,
       0,    32,     0,     0,    32,     0,    35,    32,     0,    32,
       0,    31,    32,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   143,     0,     0,     0,     0,     0,    60,     0,
      54,     0,   151,   142,   134,   147,   148,   149,   150,   131,
       0,     0,     0,   103,   145,   102,   104,   106,   108,   111,
     117,   120,   124,   128,   126,   132,   136,   137,     0,     0,
     144,   133,    43,     0,     0,    60,    60,     0,     0,    99,
       0,    15,    60,    71,     0,     0,     0,    61,    62,    65,
      64,    66,    67,    68,    69,    97,    73,     0,    74,    94,
     141,    96,    95,    53,     0,     0,     0,     0,   131,   125,
     127,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    47,    48,
       0,     0,    86,     0,     0,   100,     0,    92,     0,     0,
       0,    42,    63,    93,   143,   101,     0,   135,   105,   107,
     109,   110,   116,   114,   115,   112,   113,   118,   119,   121,
     122,   123,     0,    60,   146,    44,    41,   140,     0,    87,
      88,     0,    98,     0,    72,   135,    70,     0,   130,   129,
     143,     0,    90,     0,     0,     0,   138,     0,    28,     0,
      91,    89,     0,     0,     0,    75,    64,     0,    78,    79,
      80,    82,   139,    86,    86,     0,     0,     0,     0,     0,
       0,     0,    76,     0,    90,     0,     0,    84,     0,     0,
      83,    86,     0,     0,    81,     0,    85
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -284,  -284,  -284,  -284,   265,  -284,   270,   324,   186,  -284,
    -284,   315,   181,  -284,   307,  -284,   318,    31,  -284,   260,
    -284,  -284,   308,  -284,  -284,  -284,  -284,   305,  -284,   154,
    -163,  -284,  -176,  -284,  -270,  -284,  -284,  -200,  -284,  -284,
    -284,  -284,  -284,  -283,  -284,    60,  -284,  -284,  -210,  -284,
    -284,  -100,   -67,  -284,   175,   165,  -115,   -55,  -102,  -136,
     132,  -284,  -284,  -128,  -112,   -85,  -284,  -219,  -284,  -284
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     2,     3,    10,    14,     4,     5,    21,   175,    28,
      29,    30,    45,    38,    39,    42,    43,    85,    86,    87,
      49,    50,    51,    68,   117,    55,    56,    57,    78,    69,
     176,   177,   178,   179,   180,   181,   182,   287,   288,   183,
     289,   184,   290,   258,   259,   279,   185,   186,   187,   188,
     224,   189,   144,   145,   146,   147,   148,   149,   150,   151,
     152,   153,   154,   155,   156,   157,   158,   159,   160,   161
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
     190,   232,   220,   221,   286,   199,   200,    61,    32,   228,
     298,   299,   260,    33,   227,   267,   191,   124,    12,     8,
     195,    32,   143,    62,   125,     1,    33,    32,   313,  -140,
     195,     6,    33,    34,    13,   286,   286,   190,   190,  -140,
     143,     9,   286,   192,   190,   286,    34,    63,   227,   190,
      64,   277,    34,   191,   191,   203,    65,     7,   204,    16,
     191,    58,    59,   281,   195,   191,   210,   211,   205,   143,
     266,    59,    66,   197,   143,    65,   249,   250,   251,    17,
     192,   192,    18,   260,   260,    35,    19,   192,   240,   241,
     271,    35,   192,    20,   190,   143,   206,   207,   285,   291,
     268,   260,   225,    23,    92,   309,   310,   229,   247,   248,
     191,    24,   314,    25,    26,   316,    27,   143,   208,   209,
      31,   302,    37,   143,    44,   190,   143,   307,   235,   285,
     291,    41,   110,    46,   143,   113,   302,   192,   115,   307,
     118,   191,    47,   120,    53,   190,   190,   190,    52,    70,
     254,   243,   244,   245,   246,    71,   261,    81,    60,   263,
      73,   191,   191,   191,    80,   190,   190,    83,   192,   190,
     143,    89,   143,    91,    94,   190,    95,   190,   190,    97,
      99,   191,   191,   190,   190,   191,    96,   190,   192,   192,
     192,   191,    98,   191,   191,   143,   143,   100,   101,   191,
     191,   102,   103,   191,   143,   280,   104,    79,   192,   192,
     107,   105,   192,    36,   114,    88,   108,   109,   192,   112,
     192,   192,    90,   212,   213,   214,   192,   192,   300,   301,
     192,   111,    93,    67,   116,    79,   119,   280,   121,    67,
     122,   128,   123,   126,   196,   127,    84,    67,   129,   130,
     162,   163,   165,   164,    67,   193,   166,    67,   194,    84,
     201,   202,   216,   217,    67,   218,  -141,    67,   215,   219,
     131,   132,   222,    15,    11,   231,   223,   226,   233,   133,
    -136,  -137,   134,    84,   234,   242,    32,    84,   236,   237,
      84,    33,  -140,    84,   252,    84,   253,   255,    84,   135,
     136,   137,   138,   139,   167,   262,   168,   256,   140,   264,
     265,    34,   272,   270,   273,   293,   141,   131,   132,   274,
     142,   275,   276,   169,   278,   292,   133,   -77,   294,   134,
     295,   296,   297,   303,    32,   304,   170,   305,   311,    33,
     306,   312,   315,    22,    40,    48,   135,   136,   137,   138,
     171,   172,   282,   173,   283,   174,   230,   106,    72,    34,
      54,    82,    61,    32,   308,   131,   132,   239,    33,   269,
       0,   169,     0,     0,   133,     0,   238,   134,    62,     0,
       0,     0,     0,     0,   284,     0,     0,     0,    34,     0,
       0,     0,     0,     0,   135,   136,   137,   138,   171,   172,
       0,   173,    63,   174,     0,    64,    74,    32,    74,    32,
       0,    65,    33,     0,    33,     0,     0,     0,     0,     0,
       0,     0,    75,     0,    75,     0,     0,    35,     0,   131,
     132,     0,    34,     0,    34,     0,     0,     0,   133,     0,
       0,   134,     0,     0,     0,     0,     0,     0,     0,    76,
       0,    76,     0,     0,     0,    65,     0,    65,   135,   136,
     137,   138,   139,     0,     0,   131,   132,   140,     0,     0,
       0,    77,     0,    35,   133,   141,     0,   134,     0,   142,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     131,   132,     0,     0,   135,   136,   137,   138,   198,   133,
     131,   132,   134,   140,     0,     0,     0,     0,     0,   133,
       0,   141,   134,     0,     0,   142,     0,     0,     0,   135,
     136,   137,   138,   198,     0,     0,     0,     0,   140,   135,
     136,   137,   138,   257,     0,     0,     0,     0,   174,     0,
     142
};

static const yytype_int16 yycheck[] =
{
     128,   177,   165,   166,   274,   141,   142,     3,     4,   172,
     293,   294,   222,     9,    61,   234,   128,    68,     3,    40,
      77,     4,   122,    19,    75,    18,     9,     4,   311,    86,
      77,    40,     9,    29,    19,   305,   306,   165,   166,    86,
     140,    62,   312,   128,   172,   315,    29,    43,    61,   177,
      46,   270,    29,   165,   166,    55,    52,     0,    58,    10,
     172,    71,    72,   273,    77,   177,    80,    81,    28,   169,
      71,    72,    68,   140,   174,    52,   212,   213,   214,    10,
     165,   166,    68,   293,   294,    68,    68,   172,   203,   204,
     253,    68,   177,    17,   222,   195,    56,    57,   274,   275,
     236,   311,   169,    68,    73,   305,   306,   174,   210,   211,
     222,    27,   312,    69,    67,   315,    39,   217,    78,    79,
      69,   297,    40,   223,    68,   253,   226,   303,   195,   305,
     306,    40,   101,    68,   234,   104,   312,   222,   107,   315,
     109,   253,    40,   112,    40,   273,   274,   275,    68,    70,
     217,   206,   207,   208,   209,    40,   223,    40,    73,   226,
      73,   273,   274,   275,    70,   293,   294,    68,   253,   297,
     270,    52,   272,    68,    68,   303,    68,   305,   306,    72,
      32,   293,   294,   311,   312,   297,    74,   315,   273,   274,
     275,   303,    68,   305,   306,   295,   296,    68,    73,   311,
     312,    74,    68,   315,   304,   272,    73,    53,   293,   294,
      73,    69,   297,    27,    44,    61,    73,    73,   303,    73,
     305,   306,    68,    82,    83,    84,   311,   312,   295,   296,
     315,    71,    78,    47,    68,    81,    74,   304,    74,    53,
      73,    69,    74,    74,     9,    74,    60,    61,    74,    71,
      71,    75,    69,    76,    68,    71,    69,    71,    68,    73,
      60,    59,    74,    72,    78,    76,    86,    81,    86,    68,
      35,    36,    73,     8,     4,    70,    73,    73,    71,    44,
      86,    86,    47,    97,    73,    68,     4,   101,    74,    74,
     104,     9,    86,   107,    68,   109,    71,    70,   112,    64,
      65,    66,    67,    68,    22,    71,    24,    70,    73,    70,
      74,    29,    71,    73,    72,    71,    81,    35,    36,    74,
      85,    74,    74,    41,    70,    74,    44,    16,    73,    47,
      73,    73,    16,    74,     4,    71,    54,    74,    71,     9,
      74,    16,    74,    19,    29,    38,    64,    65,    66,    67,
      68,    69,    22,    71,    24,    73,   175,    97,    50,    29,
      42,    56,     3,     4,   304,    35,    36,   202,     9,   237,
      -1,    41,    -1,    -1,    44,    -1,   201,    47,    19,    -1,
      -1,    -1,    -1,    -1,    54,    -1,    -1,    -1,    29,    -1,
      -1,    -1,    -1,    -1,    64,    65,    66,    67,    68,    69,
      -1,    71,    43,    73,    -1,    46,     3,     4,     3,     4,
      -1,    52,     9,    -1,     9,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    19,    -1,    19,    -1,    -1,    68,    -1,    35,
      36,    -1,    29,    -1,    29,    -1,    -1,    -1,    44,    -1,
      -1,    47,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    46,
      -1,    46,    -1,    -1,    -1,    52,    -1,    52,    64,    65,
      66,    67,    68,    -1,    -1,    35,    36,    73,    -1,    -1,
      -1,    68,    -1,    68,    44,    81,    -1,    47,    -1,    85,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      35,    36,    -1,    -1,    64,    65,    66,    67,    68,    44,
      35,    36,    47,    73,    -1,    -1,    -1,    -1,    -1,    44,
      -1,    81,    47,    -1,    -1,    85,    -1,    -1,    -1,    64,
      65,    66,    67,    68,    -1,    -1,    -1,    -1,    73,    64,
      65,    66,    67,    68,    -1,    -1,    -1,    -1,    73,    -1,
      85
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    18,    88,    89,    92,    93,    40,     0,    40,    62,
      90,    93,     3,    19,    91,    91,    10,    10,    68,    68,
      17,    94,    94,    68,    27,    69,    67,    39,    96,    97,
      98,    69,     4,     9,    29,    68,    95,    40,   100,   101,
      98,    40,   102,   103,    68,    99,    68,    40,   101,   107,
     108,   109,    68,    40,   103,   112,   113,   114,    71,    72,
      73,     3,    19,    43,    46,    52,    68,    95,   110,   116,
      70,    40,   109,    73,     3,    19,    46,    68,   115,   116,
      70,    40,   114,    68,    95,   104,   105,   106,   116,    52,
     116,    68,   104,   116,    68,    68,    74,    72,    68,    32,
      68,    73,    74,    68,    73,    69,   106,    73,    73,    73,
     104,    71,    73,   104,    44,   104,    68,   111,   104,    74,
     104,    74,    73,    74,    68,    75,    74,    74,    69,    74,
      71,    35,    36,    44,    47,    64,    65,    66,    67,    68,
      73,    81,    85,   138,   139,   140,   141,   142,   143,   144,
     145,   146,   147,   148,   149,   150,   151,   152,   153,   154,
     155,   156,    71,    75,    76,    69,    69,    22,    24,    41,
      54,    68,    69,    71,    73,    95,   117,   118,   119,   120,
     121,   122,   123,   126,   128,   133,   134,   135,   136,   138,
     150,   151,   152,    71,    68,    77,     9,   139,    68,   146,
     146,    60,    59,    55,    58,    28,    56,    57,    78,    79,
      80,    81,    82,    83,    84,    86,    74,    72,    76,    68,
     117,   117,    73,    73,   137,   139,    73,    61,   117,   139,
      99,    70,   119,    71,    73,   139,    74,    74,   141,   142,
     143,   143,    68,   144,   144,   144,   144,   145,   145,   146,
     146,   146,    68,    71,   139,    70,    70,    68,   130,   131,
     135,   139,    71,   139,    70,    74,    71,   154,   146,   147,
      73,   117,    71,    72,    74,    74,    74,   154,    70,   132,
     139,   135,    22,    24,    54,   119,   121,   124,   125,   127,
     129,   119,    74,    71,    73,    73,    73,    16,   130,   130,
     139,   139,   119,    74,    71,    74,    74,   119,   132,   124,
     124,    71,    16,   130,   124,    74,   124
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    87,    88,    88,    89,    89,    90,    91,    91,    91,
      92,    92,    93,    94,    94,    95,    95,    95,    95,    96,
      96,    97,    97,    98,    99,    99,   100,   100,   101,   102,
     102,   103,   104,   104,   105,   105,   106,   107,   107,   108,
     108,   109,   109,   109,   109,   110,   110,   111,   111,   112,
     112,   113,   113,   114,   114,   115,   115,   115,   116,   116,
     117,   117,   118,   118,   119,   119,   119,   119,   119,   119,
     120,   121,   121,   121,   121,   122,   123,   124,   124,   124,
     124,   125,   126,   127,   128,   129,   130,   130,   131,   131,
     132,   132,   133,   134,   135,   135,   135,   135,   136,   137,
     137,   138,   139,   139,   140,   140,   141,   141,   142,   142,
     142,   143,   143,   143,   143,   143,   143,   144,   144,   144,
     145,   145,   145,   145,   146,   146,   147,   147,   147,   148,
     148,   149,   149,   150,   150,   150,   150,   150,   151,   152,
     153,   153,   153,   154,   154,   155,   155,   156,   156,   156,
     156,   156
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     1,     0,     2,    10,     0,     1,     1,
       1,     2,    12,     0,     2,     1,     1,     1,     1,     0,
       1,     1,     2,     4,     1,     3,     1,     2,    13,     1,
       2,     6,     0,     1,     1,     3,     2,     0,     1,     1,
       2,    10,     9,     8,    10,     1,     1,     4,     4,     0,
       1,     1,     2,     8,     7,     1,     1,     1,     1,     1,
       0,     1,     1,     2,     1,     1,     1,     1,     1,     1,
       3,     1,     3,     1,     1,     5,     7,     1,     1,     1,
       1,     7,     5,     5,     9,     9,     0,     1,     1,     3,
       0,     1,     2,     2,     1,     1,     1,     1,     3,     0,
       1,     3,     1,     1,     1,     3,     1,     3,     1,     3,
       3,     1,     3,     3,     3,     3,     3,     1,     3,     3,
       1,     3,     3,     3,     1,     2,     1,     2,     1,     4,
       4,     1,     1,     1,     1,     3,     1,     1,     5,     6,
       1,     1,     1,     0,     1,     1,     3,     1,     1,     1,
       1,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 98 "joos.y" /* yacc.c:1646  */
    {theclassfile = makeCLASSFILE((yyvsp[0].class),NULL);}
#line 1654 "y.tab.c" /* yacc.c:1646  */
    break;

  case 3:
#line 100 "joos.y" /* yacc.c:1646  */
    {theclassfile = (yyvsp[0].classfile);}
#line 1660 "y.tab.c" /* yacc.c:1646  */
    break;

  case 6:
#line 109 "joos.y" /* yacc.c:1646  */
    {(yyval.class) = makeCLASS((yyvsp[-6].stringconst),(yyvsp[-5].stringconst),0,NULL,(yyvsp[-8].modifier),(yyvsp[-3].field),(yyvsp[-2].constructor),(yyvsp[-1].method));}
#line 1666 "y.tab.c" /* yacc.c:1646  */
    break;

  case 7:
#line 113 "joos.y" /* yacc.c:1646  */
    {(yyval.modifier) = noneMod;}
#line 1672 "y.tab.c" /* yacc.c:1646  */
    break;

  case 8:
#line 115 "joos.y" /* yacc.c:1646  */
    {(yyval.modifier) = finalMod;}
#line 1678 "y.tab.c" /* yacc.c:1646  */
    break;

  case 9:
#line 117 "joos.y" /* yacc.c:1646  */
    {(yyval.modifier) = abstractMod;}
#line 1684 "y.tab.c" /* yacc.c:1646  */
    break;

  case 10:
#line 121 "joos.y" /* yacc.c:1646  */
    {(yyval.classfile) = makeCLASSFILE((yyvsp[0].class),NULL);}
#line 1690 "y.tab.c" /* yacc.c:1646  */
    break;

  case 11:
#line 123 "joos.y" /* yacc.c:1646  */
    {(yyval.classfile) = makeCLASSFILE((yyvsp[0].class),(yyvsp[-1].classfile));}
#line 1696 "y.tab.c" /* yacc.c:1646  */
    break;

  case 12:
#line 128 "joos.y" /* yacc.c:1646  */
    {(yyval.class) = makeCLASS((yyvsp[-7].stringconst),(yyvsp[-6].stringconst),1,(yyvsp[-4].stringconst),(yyvsp[-9].modifier),NULL,(yyvsp[-2].constructor),(yyvsp[-1].method));}
#line 1702 "y.tab.c" /* yacc.c:1646  */
    break;

  case 13:
#line 132 "joos.y" /* yacc.c:1646  */
    {(yyval.stringconst) = NULL;}
#line 1708 "y.tab.c" /* yacc.c:1646  */
    break;

  case 14:
#line 134 "joos.y" /* yacc.c:1646  */
    {(yyval.stringconst) = (yyvsp[0].stringconst);}
#line 1714 "y.tab.c" /* yacc.c:1646  */
    break;

  case 15:
#line 138 "joos.y" /* yacc.c:1646  */
    {(yyval.type) = makeTYPEref((yyvsp[0].stringconst));}
#line 1720 "y.tab.c" /* yacc.c:1646  */
    break;

  case 16:
#line 140 "joos.y" /* yacc.c:1646  */
    {(yyval.type) = makeTYPEchar();}
#line 1726 "y.tab.c" /* yacc.c:1646  */
    break;

  case 17:
#line 142 "joos.y" /* yacc.c:1646  */
    {(yyval.type) = makeTYPEbool();}
#line 1732 "y.tab.c" /* yacc.c:1646  */
    break;

  case 18:
#line 144 "joos.y" /* yacc.c:1646  */
    {(yyval.type) = makeTYPEint();}
#line 1738 "y.tab.c" /* yacc.c:1646  */
    break;

  case 19:
#line 148 "joos.y" /* yacc.c:1646  */
    {(yyval.field) = NULL;}
#line 1744 "y.tab.c" /* yacc.c:1646  */
    break;

  case 20:
#line 150 "joos.y" /* yacc.c:1646  */
    {(yyval.field) = (yyvsp[0].field);}
#line 1750 "y.tab.c" /* yacc.c:1646  */
    break;

  case 21:
#line 154 "joos.y" /* yacc.c:1646  */
    {(yyval.field) = (yyvsp[0].field);}
#line 1756 "y.tab.c" /* yacc.c:1646  */
    break;

  case 22:
#line 156 "joos.y" /* yacc.c:1646  */
    {(yyval.field) = appendFIELD((yyvsp[0].field),(yyvsp[-1].field));}
#line 1762 "y.tab.c" /* yacc.c:1646  */
    break;

  case 23:
#line 160 "joos.y" /* yacc.c:1646  */
    {(yyval.field) = makeFIELDlist((yyvsp[-1].id),(yyvsp[-2].type));}
#line 1768 "y.tab.c" /* yacc.c:1646  */
    break;

  case 24:
#line 164 "joos.y" /* yacc.c:1646  */
    {(yyval.id) = makeID((yyvsp[0].stringconst),NULL);}
#line 1774 "y.tab.c" /* yacc.c:1646  */
    break;

  case 25:
#line 166 "joos.y" /* yacc.c:1646  */
    {(yyval.id) = makeID((yyvsp[0].stringconst),(yyvsp[-2].id));}
#line 1780 "y.tab.c" /* yacc.c:1646  */
    break;

  case 26:
#line 170 "joos.y" /* yacc.c:1646  */
    {(yyval.constructor) = (yyvsp[0].constructor);}
#line 1786 "y.tab.c" /* yacc.c:1646  */
    break;

  case 27:
#line 172 "joos.y" /* yacc.c:1646  */
    {(yyval.constructor) = (yyvsp[0].constructor); (yyval.constructor)->next = (yyvsp[-1].constructor);}
#line 1792 "y.tab.c" /* yacc.c:1646  */
    break;

  case 28:
#line 177 "joos.y" /* yacc.c:1646  */
    {(yyval.constructor) = makeCONSTRUCTOR((yyvsp[-11].stringconst),(yyvsp[-9].formal),
                                    makeSTATEMENTsequence(
                                        makeSTATEMENTsupercons((yyvsp[-4].argument)),
                                        (yyvsp[-1].statement)
                                    ),
                                    NULL
                    );}
#line 1804 "y.tab.c" /* yacc.c:1646  */
    break;

  case 29:
#line 187 "joos.y" /* yacc.c:1646  */
    {(yyval.constructor) = (yyvsp[0].constructor);}
#line 1810 "y.tab.c" /* yacc.c:1646  */
    break;

  case 30:
#line 189 "joos.y" /* yacc.c:1646  */
    {(yyval.constructor) = (yyvsp[0].constructor); (yyval.constructor)->next = (yyvsp[-1].constructor);}
#line 1816 "y.tab.c" /* yacc.c:1646  */
    break;

  case 31:
#line 193 "joos.y" /* yacc.c:1646  */
    {(yyval.constructor) = makeCONSTRUCTOR((yyvsp[-4].stringconst),(yyvsp[-2].formal),NULL,NULL);}
#line 1822 "y.tab.c" /* yacc.c:1646  */
    break;

  case 32:
#line 197 "joos.y" /* yacc.c:1646  */
    {(yyval.formal) = NULL;}
#line 1828 "y.tab.c" /* yacc.c:1646  */
    break;

  case 33:
#line 199 "joos.y" /* yacc.c:1646  */
    {(yyval.formal) = (yyvsp[0].formal);}
#line 1834 "y.tab.c" /* yacc.c:1646  */
    break;

  case 34:
#line 203 "joos.y" /* yacc.c:1646  */
    {(yyval.formal) = (yyvsp[0].formal);}
#line 1840 "y.tab.c" /* yacc.c:1646  */
    break;

  case 35:
#line 205 "joos.y" /* yacc.c:1646  */
    {(yyval.formal) = (yyvsp[0].formal); (yyval.formal)->next = (yyvsp[-2].formal);}
#line 1846 "y.tab.c" /* yacc.c:1646  */
    break;

  case 36:
#line 209 "joos.y" /* yacc.c:1646  */
    {(yyval.formal) = makeFORMAL((yyvsp[0].stringconst),(yyvsp[-1].type),NULL);}
#line 1852 "y.tab.c" /* yacc.c:1646  */
    break;

  case 37:
#line 213 "joos.y" /* yacc.c:1646  */
    {(yyval.method) = NULL;}
#line 1858 "y.tab.c" /* yacc.c:1646  */
    break;

  case 38:
#line 215 "joos.y" /* yacc.c:1646  */
    {(yyval.method) = (yyvsp[0].method);}
#line 1864 "y.tab.c" /* yacc.c:1646  */
    break;

  case 39:
#line 219 "joos.y" /* yacc.c:1646  */
    {(yyval.method) = (yyvsp[0].method);}
#line 1870 "y.tab.c" /* yacc.c:1646  */
    break;

  case 40:
#line 221 "joos.y" /* yacc.c:1646  */
    {(yyval.method) = (yyvsp[0].method); (yyval.method)->next = (yyvsp[-1].method);}
#line 1876 "y.tab.c" /* yacc.c:1646  */
    break;

  case 41:
#line 225 "joos.y" /* yacc.c:1646  */
    {(yyval.method) = makeMETHOD((yyvsp[-6].stringconst),(yyvsp[-8].modifier),(yyvsp[-7].type),(yyvsp[-4].formal),(yyvsp[-1].statement),NULL);}
#line 1882 "y.tab.c" /* yacc.c:1646  */
    break;

  case 42:
#line 227 "joos.y" /* yacc.c:1646  */
    {(yyval.method) = makeMETHOD((yyvsp[-6].stringconst),noneMod,(yyvsp[-7].type),(yyvsp[-4].formal),(yyvsp[-1].statement),NULL);}
#line 1888 "y.tab.c" /* yacc.c:1646  */
    break;

  case 43:
#line 229 "joos.y" /* yacc.c:1646  */
    {(yyval.method) = makeMETHOD((yyvsp[-4].stringconst),abstractMod,(yyvsp[-5].type),(yyvsp[-2].formal),NULL,NULL);}
#line 1894 "y.tab.c" /* yacc.c:1646  */
    break;

  case 44:
#line 231 "joos.y" /* yacc.c:1646  */
    {(yyval.method) = makeMETHOD("main",staticMod,makeTYPEvoid(),NULL,(yyvsp[-1].statement),NULL);}
#line 1900 "y.tab.c" /* yacc.c:1646  */
    break;

  case 45:
#line 235 "joos.y" /* yacc.c:1646  */
    {(yyval.modifier) = finalMod;}
#line 1906 "y.tab.c" /* yacc.c:1646  */
    break;

  case 46:
#line 237 "joos.y" /* yacc.c:1646  */
    {(yyval.modifier) = synchronizedMod;}
#line 1912 "y.tab.c" /* yacc.c:1646  */
    break;

  case 47:
#line 241 "joos.y" /* yacc.c:1646  */
    {if (strcmp((yyvsp[-3].stringconst),"String")!=0) yyerror("type String expected");}
#line 1918 "y.tab.c" /* yacc.c:1646  */
    break;

  case 48:
#line 243 "joos.y" /* yacc.c:1646  */
    {if (strcmp((yyvsp[-3].stringconst),"String")!=0) yyerror("type String expected");}
#line 1924 "y.tab.c" /* yacc.c:1646  */
    break;

  case 49:
#line 247 "joos.y" /* yacc.c:1646  */
    {(yyval.method) = NULL;}
#line 1930 "y.tab.c" /* yacc.c:1646  */
    break;

  case 50:
#line 249 "joos.y" /* yacc.c:1646  */
    {(yyval.method) = (yyvsp[0].method);}
#line 1936 "y.tab.c" /* yacc.c:1646  */
    break;

  case 51:
#line 253 "joos.y" /* yacc.c:1646  */
    {(yyval.method) = (yyvsp[0].method);}
#line 1942 "y.tab.c" /* yacc.c:1646  */
    break;

  case 52:
#line 255 "joos.y" /* yacc.c:1646  */
    {(yyval.method) = (yyvsp[0].method); (yyval.method)->next = (yyvsp[-1].method);}
#line 1948 "y.tab.c" /* yacc.c:1646  */
    break;

  case 53:
#line 259 "joos.y" /* yacc.c:1646  */
    {(yyval.method) = makeMETHOD((yyvsp[-4].stringconst),(yyvsp[-6].modifier),(yyvsp[-5].type),(yyvsp[-2].formal),NULL,NULL);}
#line 1954 "y.tab.c" /* yacc.c:1646  */
    break;

  case 54:
#line 261 "joos.y" /* yacc.c:1646  */
    {(yyval.method) = makeMETHOD((yyvsp[-4].stringconst),noneMod,(yyvsp[-5].type),(yyvsp[-2].formal),NULL,NULL);}
#line 1960 "y.tab.c" /* yacc.c:1646  */
    break;

  case 55:
#line 265 "joos.y" /* yacc.c:1646  */
    {(yyval.modifier) = finalMod;}
#line 1966 "y.tab.c" /* yacc.c:1646  */
    break;

  case 56:
#line 267 "joos.y" /* yacc.c:1646  */
    {(yyval.modifier) = abstractMod;}
#line 1972 "y.tab.c" /* yacc.c:1646  */
    break;

  case 57:
#line 269 "joos.y" /* yacc.c:1646  */
    {(yyval.modifier) = synchronizedMod;}
#line 1978 "y.tab.c" /* yacc.c:1646  */
    break;

  case 58:
#line 274 "joos.y" /* yacc.c:1646  */
    {(yyval.type) = makeTYPEvoid();}
#line 1984 "y.tab.c" /* yacc.c:1646  */
    break;

  case 59:
#line 276 "joos.y" /* yacc.c:1646  */
    {(yyval.type) = (yyvsp[0].type);}
#line 1990 "y.tab.c" /* yacc.c:1646  */
    break;

  case 60:
#line 280 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = NULL;}
#line 1996 "y.tab.c" /* yacc.c:1646  */
    break;

  case 61:
#line 282 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = (yyvsp[0].statement);}
#line 2002 "y.tab.c" /* yacc.c:1646  */
    break;

  case 62:
#line 286 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = (yyvsp[0].statement);}
#line 2008 "y.tab.c" /* yacc.c:1646  */
    break;

  case 63:
#line 288 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = makeSTATEMENTsequence((yyvsp[-1].statement),(yyvsp[0].statement));}
#line 2014 "y.tab.c" /* yacc.c:1646  */
    break;

  case 64:
#line 292 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = (yyvsp[0].statement);}
#line 2020 "y.tab.c" /* yacc.c:1646  */
    break;

  case 65:
#line 294 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = (yyvsp[0].statement);}
#line 2026 "y.tab.c" /* yacc.c:1646  */
    break;

  case 66:
#line 296 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = (yyvsp[0].statement);}
#line 2032 "y.tab.c" /* yacc.c:1646  */
    break;

  case 67:
#line 298 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = (yyvsp[0].statement);}
#line 2038 "y.tab.c" /* yacc.c:1646  */
    break;

  case 68:
#line 300 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = (yyvsp[0].statement);}
#line 2044 "y.tab.c" /* yacc.c:1646  */
    break;

  case 69:
#line 302 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = (yyvsp[0].statement);}
#line 2050 "y.tab.c" /* yacc.c:1646  */
    break;

  case 70:
#line 306 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = makeSTATEMENTlocal(makeLOCALlist((yyvsp[-1].id),(yyvsp[-2].type)));}
#line 2056 "y.tab.c" /* yacc.c:1646  */
    break;

  case 71:
#line 310 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = makeSTATEMENTskip();}
#line 2062 "y.tab.c" /* yacc.c:1646  */
    break;

  case 72:
#line 312 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = makeSTATEMENTblock((yyvsp[-1].statement));}
#line 2068 "y.tab.c" /* yacc.c:1646  */
    break;

  case 73:
#line 314 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = (yyvsp[0].statement);}
#line 2074 "y.tab.c" /* yacc.c:1646  */
    break;

  case 74:
#line 316 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = (yyvsp[0].statement);}
#line 2080 "y.tab.c" /* yacc.c:1646  */
    break;

  case 75:
#line 320 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = makeSTATEMENTif((yyvsp[-2].exp),(yyvsp[0].statement));}
#line 2086 "y.tab.c" /* yacc.c:1646  */
    break;

  case 76:
#line 324 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = makeSTATEMENTifelse((yyvsp[-4].exp),(yyvsp[-2].statement),(yyvsp[0].statement));}
#line 2092 "y.tab.c" /* yacc.c:1646  */
    break;

  case 77:
#line 328 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = (yyvsp[0].statement);}
#line 2098 "y.tab.c" /* yacc.c:1646  */
    break;

  case 78:
#line 330 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = (yyvsp[0].statement);}
#line 2104 "y.tab.c" /* yacc.c:1646  */
    break;

  case 79:
#line 332 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = (yyvsp[0].statement);}
#line 2110 "y.tab.c" /* yacc.c:1646  */
    break;

  case 80:
#line 334 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = (yyvsp[0].statement);}
#line 2116 "y.tab.c" /* yacc.c:1646  */
    break;

  case 81:
#line 339 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = makeSTATEMENTifelse((yyvsp[-4].exp),(yyvsp[-2].statement),(yyvsp[0].statement));}
#line 2122 "y.tab.c" /* yacc.c:1646  */
    break;

  case 82:
#line 343 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = makeSTATEMENTwhile((yyvsp[-2].exp),(yyvsp[0].statement));}
#line 2128 "y.tab.c" /* yacc.c:1646  */
    break;

  case 83:
#line 347 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = makeSTATEMENTwhile((yyvsp[-2].exp),(yyvsp[0].statement));}
#line 2134 "y.tab.c" /* yacc.c:1646  */
    break;

  case 84:
#line 359 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = makeSTATEMENTsequence((yyvsp[-6].statement),makeSTATEMENTwhile((yyvsp[-4].exp),makeSTATEMENTsequence((yyvsp[0].statement),(yyvsp[-2].statement))));}
#line 2140 "y.tab.c" /* yacc.c:1646  */
    break;

  case 85:
#line 364 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = makeSTATEMENTsequence((yyvsp[-6].statement),makeSTATEMENTwhile((yyvsp[-4].exp),makeSTATEMENTsequence((yyvsp[0].statement),(yyvsp[-2].statement))));}
#line 2146 "y.tab.c" /* yacc.c:1646  */
    break;

  case 86:
#line 368 "joos.y" /* yacc.c:1646  */
    { (yyval.statement) = NULL; }
#line 2152 "y.tab.c" /* yacc.c:1646  */
    break;

  case 87:
#line 369 "joos.y" /* yacc.c:1646  */
    { (yyval.statement) = (yyvsp[0].statement); }
#line 2158 "y.tab.c" /* yacc.c:1646  */
    break;

  case 88:
#line 371 "joos.y" /* yacc.c:1646  */
    { (yyval.statement) = makeSTATEMENTexp((yyvsp[0].exp)); }
#line 2164 "y.tab.c" /* yacc.c:1646  */
    break;

  case 89:
#line 373 "joos.y" /* yacc.c:1646  */
    { (yyval.statement) = makeSTATEMENTsequence((yyvsp[-2].statement), makeSTATEMENTexp((yyvsp[0].exp))); }
#line 2170 "y.tab.c" /* yacc.c:1646  */
    break;

  case 90:
#line 375 "joos.y" /* yacc.c:1646  */
    { (yyval.exp) = makeEXPboolconst(1); }
#line 2176 "y.tab.c" /* yacc.c:1646  */
    break;

  case 91:
#line 376 "joos.y" /* yacc.c:1646  */
    { (yyval.exp) = (yyvsp[0].exp); }
#line 2182 "y.tab.c" /* yacc.c:1646  */
    break;

  case 92:
#line 387 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPassign((yyvsp[-1].stringconst), makeEXPplus(makeEXPid((yyvsp[-1].stringconst)),makeEXPintconst(1))); }
#line 2188 "y.tab.c" /* yacc.c:1646  */
    break;

  case 93:
#line 396 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = makeSTATEMENTexp((yyvsp[-1].exp));}
#line 2194 "y.tab.c" /* yacc.c:1646  */
    break;

  case 94:
#line 400 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2200 "y.tab.c" /* yacc.c:1646  */
    break;

  case 95:
#line 402 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2206 "y.tab.c" /* yacc.c:1646  */
    break;

  case 96:
#line 404 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2212 "y.tab.c" /* yacc.c:1646  */
    break;

  case 97:
#line 405 "joos.y" /* yacc.c:1646  */
    { (yyval.exp) = (yyvsp[0].exp); }
#line 2218 "y.tab.c" /* yacc.c:1646  */
    break;

  case 98:
#line 409 "joos.y" /* yacc.c:1646  */
    {(yyval.statement) = makeSTATEMENTreturn((yyvsp[-1].exp));}
#line 2224 "y.tab.c" /* yacc.c:1646  */
    break;

  case 99:
#line 413 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = NULL;}
#line 2230 "y.tab.c" /* yacc.c:1646  */
    break;

  case 100:
#line 415 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2236 "y.tab.c" /* yacc.c:1646  */
    break;

  case 101:
#line 419 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPassign((yyvsp[-2].stringconst),(yyvsp[0].exp));}
#line 2242 "y.tab.c" /* yacc.c:1646  */
    break;

  case 102:
#line 423 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2248 "y.tab.c" /* yacc.c:1646  */
    break;

  case 103:
#line 425 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2254 "y.tab.c" /* yacc.c:1646  */
    break;

  case 104:
#line 429 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2260 "y.tab.c" /* yacc.c:1646  */
    break;

  case 105:
#line 431 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPor((yyvsp[-2].exp),(yyvsp[0].exp));}
#line 2266 "y.tab.c" /* yacc.c:1646  */
    break;

  case 106:
#line 435 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2272 "y.tab.c" /* yacc.c:1646  */
    break;

  case 107:
#line 437 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPand((yyvsp[-2].exp),(yyvsp[0].exp));}
#line 2278 "y.tab.c" /* yacc.c:1646  */
    break;

  case 108:
#line 441 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2284 "y.tab.c" /* yacc.c:1646  */
    break;

  case 109:
#line 443 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPeq((yyvsp[-2].exp),(yyvsp[0].exp));}
#line 2290 "y.tab.c" /* yacc.c:1646  */
    break;

  case 110:
#line 445 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPneq((yyvsp[-2].exp),(yyvsp[0].exp));}
#line 2296 "y.tab.c" /* yacc.c:1646  */
    break;

  case 111:
#line 449 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2302 "y.tab.c" /* yacc.c:1646  */
    break;

  case 112:
#line 451 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPlt((yyvsp[-2].exp),(yyvsp[0].exp));}
#line 2308 "y.tab.c" /* yacc.c:1646  */
    break;

  case 113:
#line 453 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPgt((yyvsp[-2].exp),(yyvsp[0].exp));}
#line 2314 "y.tab.c" /* yacc.c:1646  */
    break;

  case 114:
#line 455 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPleq((yyvsp[-2].exp),(yyvsp[0].exp));}
#line 2320 "y.tab.c" /* yacc.c:1646  */
    break;

  case 115:
#line 457 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPgeq((yyvsp[-2].exp),(yyvsp[0].exp));}
#line 2326 "y.tab.c" /* yacc.c:1646  */
    break;

  case 116:
#line 459 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPinstanceof((yyvsp[-2].exp),(yyvsp[0].stringconst));}
#line 2332 "y.tab.c" /* yacc.c:1646  */
    break;

  case 117:
#line 463 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2338 "y.tab.c" /* yacc.c:1646  */
    break;

  case 118:
#line 465 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPplus((yyvsp[-2].exp),(yyvsp[0].exp));}
#line 2344 "y.tab.c" /* yacc.c:1646  */
    break;

  case 119:
#line 467 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPminus((yyvsp[-2].exp),(yyvsp[0].exp));}
#line 2350 "y.tab.c" /* yacc.c:1646  */
    break;

  case 120:
#line 473 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2356 "y.tab.c" /* yacc.c:1646  */
    break;

  case 121:
#line 475 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPtimes((yyvsp[-2].exp),(yyvsp[0].exp));}
#line 2362 "y.tab.c" /* yacc.c:1646  */
    break;

  case 122:
#line 477 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPdiv((yyvsp[-2].exp),(yyvsp[0].exp));}
#line 2368 "y.tab.c" /* yacc.c:1646  */
    break;

  case 123:
#line 479 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPmod((yyvsp[-2].exp),(yyvsp[0].exp));}
#line 2374 "y.tab.c" /* yacc.c:1646  */
    break;

  case 124:
#line 483 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2380 "y.tab.c" /* yacc.c:1646  */
    break;

  case 125:
#line 485 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPuminus((yyvsp[0].exp));}
#line 2386 "y.tab.c" /* yacc.c:1646  */
    break;

  case 126:
#line 490 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2392 "y.tab.c" /* yacc.c:1646  */
    break;

  case 127:
#line 492 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPnot((yyvsp[0].exp));}
#line 2398 "y.tab.c" /* yacc.c:1646  */
    break;

  case 128:
#line 494 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2404 "y.tab.c" /* yacc.c:1646  */
    break;

  case 129:
#line 497 "joos.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].exp)->kind!=idK) yyerror("identifier expected");
                  (yyval.exp) = makeEXPcast((yyvsp[-2].exp)->val.idE.name,(yyvsp[0].exp));}
#line 2411 "y.tab.c" /* yacc.c:1646  */
    break;

  case 130:
#line 500 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPcharcast((yyvsp[0].exp));}
#line 2417 "y.tab.c" /* yacc.c:1646  */
    break;

  case 131:
#line 504 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPid((yyvsp[0].stringconst));}
#line 2423 "y.tab.c" /* yacc.c:1646  */
    break;

  case 132:
#line 506 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2429 "y.tab.c" /* yacc.c:1646  */
    break;

  case 133:
#line 510 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2435 "y.tab.c" /* yacc.c:1646  */
    break;

  case 134:
#line 512 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPthis();}
#line 2441 "y.tab.c" /* yacc.c:1646  */
    break;

  case 135:
#line 514 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[-1].exp);}
#line 2447 "y.tab.c" /* yacc.c:1646  */
    break;

  case 136:
#line 516 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2453 "y.tab.c" /* yacc.c:1646  */
    break;

  case 137:
#line 518 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = (yyvsp[0].exp);}
#line 2459 "y.tab.c" /* yacc.c:1646  */
    break;

  case 138:
#line 522 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPnew((yyvsp[-3].stringconst),(yyvsp[-1].argument));}
#line 2465 "y.tab.c" /* yacc.c:1646  */
    break;

  case 139:
#line 526 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPinvoke((yyvsp[-5].receiver),(yyvsp[-3].stringconst),(yyvsp[-1].argument));}
#line 2471 "y.tab.c" /* yacc.c:1646  */
    break;

  case 140:
#line 530 "joos.y" /* yacc.c:1646  */
    {(yyval.receiver) = makeRECEIVERobject(makeEXPid((yyvsp[0].stringconst)));}
#line 2477 "y.tab.c" /* yacc.c:1646  */
    break;

  case 141:
#line 532 "joos.y" /* yacc.c:1646  */
    {(yyval.receiver) = makeRECEIVERobject((yyvsp[0].exp));}
#line 2483 "y.tab.c" /* yacc.c:1646  */
    break;

  case 142:
#line 534 "joos.y" /* yacc.c:1646  */
    {(yyval.receiver) = makeRECEIVERsuper();}
#line 2489 "y.tab.c" /* yacc.c:1646  */
    break;

  case 143:
#line 538 "joos.y" /* yacc.c:1646  */
    {(yyval.argument) = NULL;}
#line 2495 "y.tab.c" /* yacc.c:1646  */
    break;

  case 144:
#line 540 "joos.y" /* yacc.c:1646  */
    {(yyval.argument) = (yyvsp[0].argument);}
#line 2501 "y.tab.c" /* yacc.c:1646  */
    break;

  case 145:
#line 544 "joos.y" /* yacc.c:1646  */
    {(yyval.argument) = makeARGUMENT((yyvsp[0].exp),NULL);}
#line 2507 "y.tab.c" /* yacc.c:1646  */
    break;

  case 146:
#line 546 "joos.y" /* yacc.c:1646  */
    {(yyval.argument) = makeARGUMENT((yyvsp[0].exp),(yyvsp[-2].argument));}
#line 2513 "y.tab.c" /* yacc.c:1646  */
    break;

  case 147:
#line 550 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPintconst((yyvsp[0].intconst));}
#line 2519 "y.tab.c" /* yacc.c:1646  */
    break;

  case 148:
#line 552 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPboolconst((yyvsp[0].boolconst));}
#line 2525 "y.tab.c" /* yacc.c:1646  */
    break;

  case 149:
#line 554 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPcharconst((yyvsp[0].charconst));}
#line 2531 "y.tab.c" /* yacc.c:1646  */
    break;

  case 150:
#line 556 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPstringconst((yyvsp[0].stringconst));}
#line 2537 "y.tab.c" /* yacc.c:1646  */
    break;

  case 151:
#line 558 "joos.y" /* yacc.c:1646  */
    {(yyval.exp) = makeEXPnull();}
#line 2543 "y.tab.c" /* yacc.c:1646  */
    break;


#line 2547 "y.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
