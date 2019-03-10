requires "smt.k"

module SMTLIB2-TEST-DRIVER
  imports Z3
  imports CVC4

  configuration <k> $PGM:SMTLIB2Script </k>
                <z3> .K </z3>
                <cvc4> .K </cvc4>

  syntax SMTLIB2SimpleSymbol ::= "emptysetx"  [token]
                               | "unionx"     [token]
                               | "intersectx" [token]
                               | "in"         [token]
                               | "disjointx"  [token]
                               | "const"      [token]
                               | "SetInt"     [token]
                               | "n"          [token]
                               | "x"          [token]
                               | "y"          [token]

  syntax SMTLIB2Script ::= "Z3Prelude" [function]
  rule Z3Prelude
    => ( ( define-sort SetInt (.SMTLIB2SortList) ( Array Int  Bool ) )
         ( define-fun emptysetx (.SMTLIB2SortedVarList) SetInt ( ( as const SetInt ) false ) )
         ( define-fun singleton ( ( x Int ) ) SetInt ( store emptysetx  x  true ) )
         ( define-fun in ( ( n Int ) ( x SetInt ) ) Bool ( select x  n ) )
         ( define-fun unionx ( ( x SetInt )  ( y SetInt ) ) SetInt ( ( underscore map or ) x  y ) )
         ( define-fun intersectx ( ( x SetInt )  ( y SetInt ) ) SetInt ( ( underscore map and ) x  y ) )
         ( define-fun disjointx ( ( x SetInt )  ( y SetInt ) ) Bool ( = ( intersectx x  y ) emptysetx ) )
       )

  syntax SMTLIB2Script ::= "CVC4Prelude" [function]
  rule CVC4Prelude
    => ( ( define-sort SetInt (.SMTLIB2SortList) ( Set Int ) )
         ( define-fun emptysetx (.SMTLIB2SortedVarList) SetInt ( as emptyset SetInt ) )
         ( define-fun in ( ( n Int )  ( x SetInt )  ) Bool ( member n  x) )
         ( define-fun unionx ( ( x SetInt )  ( y SetInt )  ) SetInt ( union x y  ) )
         ( define-fun intersectx ( ( x SetInt )  ( y SetInt )  ) SetInt ( intersection x  y  ) )
         ( define-fun disjointx ( ( x SetInt )  ( y SetInt )  ) Bool ( = ( intersectx x  y  ) emptysetx ) )
       )

  rule <k> SCRIPT:SMTLIB2Script </k>
       <z3> .K => Z3CheckSAT(Z3Prelude ++SMTLIB2Script SCRIPT) </z3>
  rule <k> SCRIPT:SMTLIB2Script </k>
       <cvc4> .K => CVC4CheckSAT(CVC4Prelude ++SMTLIB2Script SCRIPT) </cvc4>
endmodule
