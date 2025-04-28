class A {
    a : Int <- 0;
    b : Bool <- true;
    c : String <- "cool";
    (* Comentário: Definição de atributos com inicializações simples para tipos básicos. *)

    f(x : Int, y : Int) : Int {
      x + y
    };
    (* Comentário: Método que soma dois inteiros. Testa parâmetros múltiplos e retorno de expressão aritmética. *)

    g(s : String) : String {
      s.concat(" World")
    };
    (* Comentário: Método que concatena uma string. Testa chamada de método sobre objeto do tipo String. *)

    h() : Bool {
      isvoid a
    };
    (* Comentário: Método que usa o operador 'isvoid' para checar se um atributo está vazio. *)

    i(x : Int) : Int {
      while x < 10 loop
        x <- x + 1
      pool
    };
    (* Comentário: Método com laço de repetição 'while'. Testa controle de fluxo com atualização de variável. *)

    j() : Object {
        let x : Int <- 5 in
          x
      };
    (* Comentário: Método usando expressão 'let' para declaração e uso de variável local. *)

    k(x : Object) : Int {
    case x of
        y : Int => y + 1
    esac
    };
    (* Comentário: Método usando 'case' para despacho baseado no tipo de variável. Testa expressão de escolha condicional. *)

    l() : Int {
      if a < 5 then
        a + 1
      else
        a - 1
      fi
    };
    (* Comentário: Método com estrutura condicional 'if-then-else'. Testa avaliação e seleção de ramos. *)

    m() : Int {
      ~a
    };
    (* Comentário: Método aplicando operador de negação aritmética '~' sobre um inteiro. *)

    n() : Bool {
      not b
    };
    (* Comentário: Método aplicando operador lógico 'not' sobre um booleano. *)

    o() : A {
      new A
    };
    (* Comentário: Método instanciando um novo objeto da classe A usando o operador 'new'. *)

    p() : Int {
      a * 2 / (3 + 1)
    };
    (* Comentário: Método realizando operação aritmética combinada com precedência entre operadores. *)

    q() : Int {
      self.f(1, 2)
    };
    (* Comentário: Método chamando outro método da própria instância usando 'self'. *)

    r(x : A) : Int {
      x.f(5, 10)
    };
    (* Comentário: Método chamando método 'f' de outra instância da classe A. *)

    s(x : A) : Int {
      x@A.f(5, 10)
    };
    (* Comentário: Método realizando chamada estática de método usando operador de dispatch '@'. *)
};

class B inherits A {
    y : Int;
};
(* Comentário: Definição de classe B herdando de A, adicionando atributo próprio. Testa herança de classe. *)
