       IDENTIFICATION DIVISION.
       PROGRAM-ID. SUM-AMOUNT.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO 'test_data.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUTPUT-FILE ASSIGN TO 'result.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
               
       DATA DIVISION.
       FILE SECTION.
       FD  INPUT-FILE.
       01  INPUT-RECORD.
           05  IN-ITEM-ID      PIC X(4).
           05  IN-ITEM-NAME    PIC X(10).
           05  IN-PRICE        PIC 9(6).
           
       FD  OUTPUT-FILE.
       01  OUTPUT-RECORD.
           05  OUT-LABEL       PIC X(14).
           05  OUT-TOTAL       PIC 9(7).
           
       WORKING-STORAGE SECTION.
       01  WS-EOF-FLAG         PIC X VALUE 'N'.
       01  WS-TOTAL-AMOUNT     PIC 9(7) VALUE 0.
       
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           OPEN INPUT INPUT-FILE
           OPEN OUTPUT OUTPUT-FILE
           
           DISPLAY "--- START PROCESSING ---"
           
           PERFORM READ-RECORD
           PERFORM UNTIL WS-EOF-FLAG = 'Y'
               ADD IN-PRICE TO WS-TOTAL-AMOUNT
               PERFORM READ-RECORD
           END-PERFORM
           
           MOVE 'TOTAL AMOUNT: ' TO OUT-LABEL
           MOVE WS-TOTAL-AMOUNT TO OUT-TOTAL
           WRITE OUTPUT-RECORD
           
           DISPLAY "--- END PROCESSING ---"
           DISPLAY "Check 'result.txt' for the output."
           
           CLOSE INPUT-FILE
           CLOSE OUTPUT-FILE
           
           STOP RUN.
           
       READ-RECORD.
           READ INPUT-FILE
               AT END
                   MOVE 'Y' TO WS-EOF-FLAG
               NOT AT END
                   DISPLAY "Read Record -> ID:" IN-ITEM-ID 
                           ", NAME:" IN-ITEM-NAME 
                           ", PRICE:" IN-PRICE
           END-READ.
