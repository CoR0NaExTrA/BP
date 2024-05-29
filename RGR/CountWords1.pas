PROGRAM CountWords1(INPUT, OUTPUT);

USES WorkWithWord, WorkWithTree;

VAR
  W: STRING;

BEGIN
  WHILE NOT EOF
  DO
    BEGIN
      W := ReadWord(INPUT);
      IF W <> ''
      THEN
        InsertWordTree(W)
    END;
  PrintWords(OUTPUT)
END.
