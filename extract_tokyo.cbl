       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXTRACT-TOKYO.
       AUTHOR. TNDK.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IN-FILE ASSIGN TO "input_data.txt"
                  ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUT-FILE ASSIGN TO "output_tokyo.txt"
                  ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  IN-FILE.
       01  IN-RECORD-BUFFER PIC X(265).

       FD  OUT-FILE.
       01  OUT-RECORD       PIC X(265).

       WORKING-STORAGE SECTION.
       01  END-OF-FILE      PIC X(1) VALUE "N".
       
       01  WS-RECORD.
           05  WS-MYNUMBER  PIC X(12).
           05  WS-NAME      PIC X(90).
           05  WS-ADDRESS   PIC X(150).
           05  WS-PHONE     PIC X(13).

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           OPEN INPUT IN-FILE
           OPEN OUTPUT OUT-FILE

           PERFORM UNTIL END-OF-FILE = "Y"
               READ IN-FILE INTO WS-RECORD
                   AT END
                       MOVE "Y" TO END-OF-FILE
                   NOT AT END
                       *> UTF-8で「東京都」は9バイト(3バイト×3文字)
                       IF WS-ADDRESS(1:9) = "東京都"
                           WRITE OUT-RECORD FROM WS-RECORD
                       END-IF
               END-READ
           END-PERFORM

           CLOSE IN-FILE
           CLOSE OUT-FILE

           DISPLAY "抽出処理が完了しました。"
           STOP RUN.
