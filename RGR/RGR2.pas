PROGRAM CountWords(INPUT, OUTPUT);
CONST
  Alphabet = ['A' .. 'Z', 'a' .. 'z', 'À' .. 'ß', 'à' .. 'ÿ', '¨', '¸'];
  HighAlphabetEng : ARRAY['A' .. 'Z'] OF CHAR = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z');
  HighAlphabetRus : ARRAY['À' .. 'ß'] OF CHAR = ('à', 'á', 'â', 'ã', 'ä', 'å', 'æ', 'ç', 'è', 'é', 'ê', 'ë', 'ì', 'í', 'î', 'ï', 'ð', 'ñ', 'ò', 'ó', 'ô', 'õ', 'ö', '÷', 'ø', 'ù', 'ú', 'û', 'ü', 'ý', 'þ', 'ÿ');
  {HighAlphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅ¨ÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞß';}
  LowAlphabet = 'abcdefghijklmnopqrstuvwxyzàáâãäå¸æçèéêëìíîïðñòóôõö÷øùúûüýþÿ';
TYPE
  Tree = ^NodePtr;
  NodePtr = RECORD
              Word: STRING;
              Count: INTEGER;
              LLink, RLink: Tree;
            END;
  CompResult = (More, Less, Equal);

VAR
  W: STRING;
  Root: Tree;

FUNCTION CaseReduction(Ch: CHAR): CHAR;
VAR
  I: INTEGER;
  Found: BOOLEAN;
BEGIN {CaseReduction}
  CASE Ch OF
    'A' .. 'Z': CaseReduction := HighAlphabetEng[Ch];
    'À' .. 'ß': CaseReduction := HighAlphabetRus[Ch]; 
    '¨': CaseReduction := '¸';
  ELSE
    CaseReduction := Ch;
  END  
END; {CaseReduction}               

FUNCTION WordComparison(Word1, Word2: STRING): CompResult;
VAR
  I, Val1, Val2: INTEGER;
  Comp: CompResult;
BEGIN
  I := 1;
  Comp := Equal;
  WHILE (LENGTH(Word1) >= I) AND (LENGTH(Word2) >= I) AND (Comp = Equal)
  DO
    BEGIN
      Val1 := INDEX(LowAlphabet, Word1[I]);
      Val2 := INDEX(LowAlphabet, Word2[I]);
      IF Val1 > Val2
      THEN
        Comp := Less
      ELSE
        IF Val1 < Val2 
        THEN
          Comp := More;
      I := I + 1 
    END;
  IF (LENGTH(Word1) > LENGTH(Word2)) AND (Comp = Equal)
  THEN
    Comp := Less
  ELSE
    IF (LENGTH(Word1) < LENGTH(Word2)) AND (Comp = Equal)
    THEN
      Comp := More;
  WordComparison := Comp
END;

PROCEDURE InsertWordTree(VAR Ptr: Tree; Data: STRING);
BEGIN {InsertWordTree}
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
      More: InsertWordTree(Ptr^.RLink, Data);
      Less: InsertWordTree(Ptr^.LLink, Data);
      Equal: Ptr^.Count := Ptr^.Count + 1
    END
END; {InsertWordTree}

FUNCTION ReadWord(VAR InF: TEXT): STRING;
VAR
  Ch, State: CHAR;
  FoundWord: BOOLEAN;
  Word: STRING;
BEGIN {ReadWord}
  Word := '';
  FoundWord := FALSE;
  State := 'B';
  WHILE NOT EOF(InF) AND NOT FoundWord                                       
  DO
    BEGIN
      IF NOT EOLN(InF)
      THEN
        READ(InF, Ch)                                             
      ELSE
        BEGIN
          READLN(InF);
          Ch := ']'
        END;
        
        IF (Ch IN Alphabet) AND (State <> 'D')
        THEN
          BEGIN
            Word := Word + CaseReduction(Ch);
            State := 'W'
          END
        ELSE
          IF (Ch IN Alphabet) AND (State = 'D')
          THEN
            BEGIN
              Word := Word + '-';
              Word := Word + CaseReduction(Ch);
              State := 'W'
            END;
          IF (Ch = '-') AND (State = 'D')
          THEN
            FoundWord := TRUE;
          IF (Ch = '-') AND (State = 'W')
          THEN
            State := 'D';
          IF (NOT(Ch IN Alphabet)) AND (State <> 'D')
          THEN
            FoundWord := TRUE;
          
    END;  
  ReadWord := Word;
END; {ReadWord}

PROCEDURE PrintWords(Ptr: Tree; VAR InF, OutF: TEXT);
VAR
  Wo: STRING;
BEGIN {PrintWords}
  IF Ptr <> NIL
  THEN
    BEGIN
      PrintWords(Ptr^.LLink, InF, OutF);
      WRITELN(OutF, Ptr^.Word, ' ', Ptr^.Count);
      PrintWords(Ptr^.RLink, InF, OutF)
    END
END; {PrintWords}

BEGIN {CountWords}
  Root := NIL;
  WHILE NOT EOF
  DO
    BEGIN
      W := ReadWord(INPUT);
      IF W <> ''
      THEN
        InsertWordTree(Root, W)
    END;
  PrintWords(Root, INPUT, OUTPUT);
END. {CountWords}
