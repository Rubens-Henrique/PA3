/*
 *  cool.y
 *              Parser definition for the COOL language.
 *
 */
%{
#include <iostream>
#include "cool-tree.h"
#include "stringtab.h"
#include "utilities.h"

extern char *curr_filename;

void yyerror(char *s);        /*  defined below; called for each parse error */
extern int yylex();           /*  the entry point to the lexer  */

/************************************************************************/
/*                DONT CHANGE ANYTHING IN THIS SECTION                  */

Program ast_root;	      /* the result of the parse  */
Classes parse_results;        /* for use in semantic analysis */
int omerrs = 0;               /* number of errors in lexing and parsing */
%}

/* A union of all the types that can be the result of parsing actions. */
%union {
  Boolean boolean;
  Symbol symbol;
  Program program;
  Class_ class_;
  Classes classes;
  Feature feature;
  Features features;
  Formal formal;
  Formals formals;
  Case case_;
  Cases cases;
  Expression expression;
  Expressions expressions;
  char *error_msg;
}

/* Token declarations */
%token CLASS 258 ELSE 259 FI 260 IF 261 IN 262 
%token INHERITS 263 LET 264 LOOP 265 POOL 266 THEN 267 WHILE 268
%token CASE 269 ESAC 270 OF 271 DARROW 272 NEW 273 ISVOID 274
%token <symbol>  STR_CONST 275 INT_CONST 276 
%token <boolean> BOOL_CONST 277
%token <symbol>  TYPEID 278 OBJECTID 279 
%token ASSIGN 280 NOT 281 LE 282 ERROR 283

/* Non-terminal types */
%type <program> program
%type <classes> class_list
%type <class_> class
%type <features> feature_list dummy_feature_list
%type <feature> feature
%type <formal> formal
%type <formals> formal_list formal_list_non_empty
%type <expression> expr
%type <expressions> expr_list expr_list_non_empty 
%type <case_> case
%type <cases> case_list

/* Precedence rules (optional but recommended for associativity/conflicts) */
%left '+' '-'
%left '*' '/'
%left '=' '<' LE
%right ASSIGN
%left NOT
%nonassoc ISVOID '~'

%%

/* Save the root of the abstract syntax tree in a global variable. */
program : class_list { ast_root = program($1); }
        ;

class_list
	: class                          { $$ = single_Classes($1); parse_results = $$; }
	| class_list class               { $$ = append_Classes($1, single_Classes($2)); parse_results = $$; }
	;

class
    : CLASS TYPEID '{' dummy_feature_list '}' ';'
        { $$ = class_($2, idtable.add_string(const_cast<char*>("Object")), $4,
                     stringtable.add_string(curr_filename)); }
    | CLASS TYPEID INHERITS TYPEID '{' dummy_feature_list '}' ';'
        { $$ = class_($2, $4, $6, stringtable.add_string(curr_filename)); }
    | CLASS error '{' dummy_feature_list '}' ';'
        { yyerrok; $$ = class_(idtable.add_string("<error>"), idtable.add_string("Object"), $4,
                     stringtable.add_string(curr_filename)); }

dummy_feature_list
        : /* empty */               { $$ = nil_Features(); }
        | feature_list              { $$ = $1; }
        ;

feature_list
        : feature                   { $$ = single_Features($1); }
        | feature_list feature      { $$ = append_Features($1, single_Features($2)); }
        ;

feature
    : OBJECTID '(' formal_list ')' ':' TYPEID '{' expr '}'';'
        { $$ = method($1, $3, $6, $8); }
    | OBJECTID ':' TYPEID ASSIGN expr ';'                    
        { $$ = attr($1, $3, $5); }
    | OBJECTID ':' TYPEID ';'                                
        { $$ = attr($1, $3, no_expr()); }
    | error ';' { yyerrok; $$ = attr(idtable.add_string("<error>"), idtable.add_string("Object"), no_expr()); }
;

formal_list
        : /* empty */               { $$ = nil_Formals(); }
        | formal_list_non_empty     { $$ = $1; }
        ;

formal_list_non_empty
    : formal                           { $$ = single_Formals($1); }
    | formal_list_non_empty ',' formal { $$ = append_Formals($1, single_Formals($3)); }
    | formal_list_non_empty ',' error  { yyerrok; $$ = $1; };

formal
        : OBJECTID ':' TYPEID       { $$ = formal($1, $3); }
        ;

expr_list
        : /* empty */               { $$ = nil_Expressions(); }
        | expr_list_non_empty       { $$ = $1; }
        ;

expr_list_non_empty
        : expr                            { $$ = single_Expressions($1); }
        | expr_list_non_empty ',' expr    { $$ = append_Expressions($1, single_Expressions($3)); }
        ;

expr
        : OBJECTID ASSIGN expr            { $$ = assign($1, $3); }
        | expr '+' expr                   { $$ = plus($1, $3); }
        | expr '-' expr                   { $$ = sub($1, $3); }
        | expr '*' expr                   { $$ = mul($1, $3); }
        | expr '/' expr                   { $$ = divide($1, $3); }
        | '(' expr ')'                    { $$ = $2; }
        | INT_CONST                       { $$ = int_const($1); }
        | STR_CONST                       { $$ = string_const($1); }
        | BOOL_CONST                      { $$ = bool_const($1); }
        | OBJECTID                        { $$ = object($1); }
        | IF expr THEN expr ELSE expr FI  { $$ = cond($2, $4, $6); }
        | WHILE expr LOOP expr POOL       { $$ = loop($2, $4); }
        | '{' expr_list '}'               { $$ = block($2); }
        | LET OBJECTID ':' TYPEID IN expr { $$ = let($2, $4, no_expr(), $6); }
        | LET OBJECTID ':' TYPEID ASSIGN expr IN expr
                                          { $$ = let($2, $4, $6, $8); }
        | CASE expr OF case_list ESAC     { $$ = typcase($2, $4); }
        | NEW TYPEID                      { $$ = new_($2); }
        | ISVOID expr                     { $$ = isvoid($2); }
        | '~' expr                        { $$ = comp($2); }
        | NOT expr                        { $$ = neg($2); }
        | expr '<' expr                   { $$ = lt($1, $3); }
        | expr LE expr                    { $$ = leq($1, $3); }
        | expr '=' expr                   { $$ = eq($1, $3); }
        | '{' error '}'                   { yyerrok; $$ = block(nil_Expressions()); }
        | OBJECTID '(' expr_list ')'      { $$ = dispatch(object($1), $1, $3); }
        | expr '.' OBJECTID '(' expr_list ')' 
                                          { $$ = dispatch($1, $3, $5); }
        | expr '@' TYPEID '.' OBJECTID '(' expr_list ')'
                                          { $$ = static_dispatch($1, $3, $5, $7); }
        ;

case_list
        : case                           { $$ = single_Cases($1); }
        | case_list case                 { $$ = append_Cases($1, single_Cases($2)); }
        ;

case
        : OBJECTID ':' TYPEID DARROW expr { $$ = branch($1, $3, $5); }
        ;

%%

void yyerror(char *s)
{
  extern int curr_lineno;

  cerr << "\"" << curr_filename << "\", line " << curr_lineno << ": " \
    << s << " at or near ";
  print_cool_token(yychar);
  cerr << endl;
  omerrs++;

  if(omerrs > 50) {
    fprintf(stdout, "More than 50 errors\n");
    exit(1);
  }
}