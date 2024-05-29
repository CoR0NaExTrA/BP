UNIT WorkWithTree;
INTERFACE
PROCEDURE InsertWordTree(Data: STRING);
PROCEDURE PrintWords(VAR OutF: TEXT);

IMPLEMENTATION
USES
  WorkWithWord;
  
TYPE
  Tree = ^NodePtr;
  NodePtr = RECORD
              Word: STRING;
              Count: INTEGER;
              LLink, RLink: Tree;
            END;

VAR
  Root: Tree;



PROCEDURE Insert(VAR Ptr: Tree; Data: STRING);
BEGIN {Insert}
  IF Ptr = NIL
  THEN
    BEGIN
      NEW(Ptr);
      Ptr^.Word := Data;
      Ptr^.Count := 1;
      Ptr^.LLink := NIL;
      Ptr^.RLink := NIL
    END
  ELSE
    CASE WordComparison(Ptr^.Word, Data) OF
      More: Insert(Ptr^.RLink, Data);
      Less: Insert(Ptr^.LLink, Data);
      Equal: Ptr^.Count := Ptr^.Count + 1
    END
END; {Insert}

PROCEDURE Print(Ptr: Tree; VAR OutF: TEXT);
VAR
  Wo: STRING;
BEGIN {Print}
  IF Ptr <> NIL
  THEN
    BEGIN
      Print(Ptr^.LLink, OutF);
      WRITELN(OutF, Ptr^.Word, ' ', Ptr^.Count);
      Print(Ptr^.RLink, OutF)
    END
END; {Print}

PROCEDURE InsertWordTree(Data: STRING);
BEGIN
  Insert(Root, Data)
END;

PROCEDURE PrintWords(VAR OutF: TEXT);
BEGIN
  Print(Root, OutF)
END;

BEGIN
  Root := NIL
END.
