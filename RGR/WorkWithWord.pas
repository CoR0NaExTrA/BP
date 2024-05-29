UNIT WorkWithWord;

INTERFACE  
TYPE
  CompResult = (More, Less, Equal);
  
FUNCTION ReadWord(VAR InF: TEXT): STRING;
FUNCTION WordComparison(Word1, Word2: STRING): CompResult;

IMPLEMENTATION
CONST
  Alphabet = ['A' .. 'Z', 'a' .. 'z', 'À' .. 'ß', 'à' .. 'ÿ', '¨', '¸'];
  HighAlphabetEng : ARRAY['A' .. 'Z'] OF CHAR = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z');
  HighAlphabetRus : ARRAY['À' .. 'ß'] OF CHAR = ('à', 'á', 'â', 'ã', 'ä', 'å', 'æ', 'ç', 'è', 'é', 'ê', 'ë', 'ì', 'í', 'î', 'ï', 'ð', 'ñ', 'ò', 'ó', 'ô', 'õ', 'ö', '÷', 'ø', 'ù', 'ú', 'û', 'ü', 'ý', 'þ', 'ÿ');
  LowAlphabet = 'abcdefghijklmnopqrstuvwxyzàáâãäå¸æçèéêëìíîïðñòóôõö÷øùúûüýþÿ';
  
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
            FoundWord := TRUE 
    END;  
  ReadWord := Word
END; {ReadWord}

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

BEGIN {WorkWithWord}
  
END. {WorkWithWord}
