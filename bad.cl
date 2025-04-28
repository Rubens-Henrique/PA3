
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
(* Comentário: Definição correta de uma classe vazia. Não deve gerar erro. *)

(* error: b is not a type identifier *)
Class b inherits A {
};
(* Comentário: Erro de sintaxe — o nome da classe ('b') não está em maiúsculo, violando a regra que apenas Identificadores de Tipo (iniciais maiúsculas) podem aparecer após 'Class'. *)

(* error: a is not a type identifier *)
Class C inherits a {
};
(* Comentário: Erro de sintaxe — o identificador 'a' (não iniciado por maiúscula) é usado como superclasse, o que é inválido. Tipos devem começar com letra maiúscula. *)

(* error: keyword inherits is misspelled *)
Class D inherts A {
};
(* Comentário: Erro léxico/sintático — palavra-chave 'inherits' foi escrita incorretamente como 'inherts', causando falha de reconhecimento de herança. *)

(* error: closing brace is missing *)
Class E inherits A {
;
(* Comentário: Erro de estrutura — a classe não tem a chave de fechamento '}', o que causa erro na delimitação da definição da classe. *)

(* erro: ausência de ponto e vírgula após expressão *)
class Main inherits IO { 
    main() : Object { 
        out_string("Método sem ';'\n") 
    }
} ;
(* Comentário: Erro de sintaxe — falta o ponto e vírgula ';' após a expressão 'out_string', obrigatório para finalizar expressões em métodos. *)

(* erro: string mal formada (sem fechamento de aspas) *)
class Main inherits IO {
  main(): IO {
    out_string(string sem fechamento\n"); 
  };
};
(* Comentário: Erro léxico — a string passada para 'out_string' não possui aspas de abertura corretas, causando erro de formação de string. *)

(* erro: identificador inválido iniciando com número *)
class 123Main inherits IO { 
  main(): IO { out_string("Valid output"); }; 
};
(* Comentário: Erro léxico — nomes de classes não podem começar com dígitos, identificadores válidos devem começar com letras. *)

(* erro: tipo de retorno inexistente 'Real' *)
class Test {
  main(): Real { out_string("This will cause an error"); };
};
(* Comentário: Erro semântico (detectado no parser se verificar tipos) — 'Real' não é um tipo válido no COOL, apenas Int, Bool, String, Object, SELF_TYPE e tipos definidos são aceitos. *)

(* erro: expressão incompleta após operador '+' *)
class Test {
  main(): IO { let x: Int <- 10 +; out_int(x); };
};
(* Comentário: Erro de sintaxe — operador '+' está sem segundo operando, resultando em erro de expressão incompleta. *)

(* erro: falta de parênteses na chamada de função *)
class Test {
  main(): IO { out_string "Missing parentheses"; };
};
(* Comentário: Erro de sintaxe — chamada de função 'out_string' sem parênteses ao redor do argumento, obrigatório em COOL para invocar métodos. *)