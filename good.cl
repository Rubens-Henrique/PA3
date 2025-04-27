class A {
    a : Int <- 0;
    b : Bool <- true;
    c : String <- "cool";
  
    f(x : Int, y : Int) : Int {
      x + y
    };
  
    g(s : String) : String {
      s.concat(" World")
    };
  
    h() : Bool {
      isvoid a
    };
  
    i(x : Int) : Int {
      while x < 10 loop
        x <- x + 1
      pool
    };
  
    j() : Object {
        let x : Int <- 5 in
          x
      };
  
    k(x : Object) : Int {
    case x of
        y : Int => y + 1
    esac
    };
  
    l() : Int {
      if a < 5 then
        a + 1
      else
        a - 1
      fi
    };
  
    m() : Int {
      ~a
    };
  
    n() : Bool {
      not b
    };
  
    o() : A {
      new A
    };
  
    p() : Int {
      a * 2 / (3 + 1)
    };
  
    q() : Int {
      self.f(1, 2)
    };
  
    r(x : A) : Int {
      x.f(5, 10)
    };
  
    s(x : A) : Int {
      x@A.f(5, 10)
    };
};
  
class B inherits A {
    y : Int;
};
  