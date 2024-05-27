PROGRAM ProgrammsFormatting(INPUT, OUTPUT);
VAR
  Ch, Flag: CHAR;
BEGIN
  Flag := '!';
  WHILE NOT EOLN
  DO
    BEGIN
      READ(Ch);
      IF ((Ch = ' ') OR (Ch = ';')) AND (Flag = 'B')
      THEN
        Flag := 'S';
        
      IF (Ch <> ' ') AND (Flag = '!')
      THEN
        Flag := 'B';
        
      IF (Ch = ';') AND (Flag = 'S')
      THEN
        BEGIN
          WRITELN;
          WRITE('  ');
          Flag := ';' 
        END;
        
      IF (Ch <> ' ') AND (Flag = 'S')
      THEN
        BEGIN
          WRITELN;
          Flag := 'T'
        END;
      
      IF (Ch = 'E') AND (Flag = 'T')
      THEN
        Flag := 'E';
      
      IF (Ch <> 'E') AND (Flag = 'T')
      THEN
        BEGIN
          WRITE('  ');
          Flag := 'O'
        END;
        
      IF ((Ch = ' ') OR (Ch = ';')) AND ((Flag = 'O') OR (Flag = ')'))
      THEN
        Flag := 'W';
      
      IF (Ch = 'E') AND ((Flag = 'W') OR (Flag = ')'))
      THEN
        BEGIN
          WRITELN;
          Flag := 'E'
        END;
      
      IF (Ch = ';') AND (Flag = 'W')
      THEN
        Flag := ';';
        
      IF (Ch = '(') AND ((Flag = 'W') OR (Flag = 'O')) 
      THEN
        Flag := '(';
      IF (Ch = ')') AND (Flag = '(')
      THEN
        Flag := ')';
      
      IF (Ch = ',') AND (Flag = '(')
      THEN
        WRITE(', '); 
      
      IF (Ch <> ' ') AND (Ch <> ';') AND (Flag = ';')
      THEN
        BEGIN
          WRITELN;
          IF Ch <> 'E'
          THEN
            BEGIN
              WRITE('  ');
              Flag := 'O'
            END
          ELSE
            Flag := 'E'
        END; 
      
      IF (Ch <> ' ') AND (Ch <> ',')
      THEN
        WRITE(Ch)
    END;
  WRITELN
END.
