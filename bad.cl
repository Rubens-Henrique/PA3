
(*
 *  execute "coolc bad.cl" to see the error messages that the coolc parser
 *  generates
 *
 *  execute "myparser bad.cl" to see the error messages that your parser
 *  generates
 *)

(* no error *)
class A {
};

(* error:  b is not a type identifier *)
Class b inherits A {
};

(* error:  a is not a type identifier *)
Class C inherits a {
};

(* error:  keyword inherits is misspelled *)
Class D inherts A {
};

(* error:  closing brace is missing *)
Class E inherits A {
;

(*  *)
class Main inherits IO { 
    main() : Object { 
        out_string("Método sem ';'\n") 
    }
} ;

(*  *)
class Main inherits IO {
  main(): IO {
    out_string(string sem fechamento\n"); 
  };
};

(*  *)
class 123Main inherits IO { 
  main(): IO { out_string("Valid output"); }; 
};

(*  *)
class Test {
  main(): Real { out_string("This will cause an error"); };
};

(*  *)
class Test {
  main(): IO { let x: Int <- 10 +; out_int(x); };
};

(*  *)
class Test {
  main(): IO { out_string "Missing parentheses"; };
};
