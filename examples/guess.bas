10 REM GUESS THE NUMBER GAME
11 REM BY NATHAN STORY (2014)
20 LET A=RND(10)+1
21 LET C=0
30 PRINT "I AM THINKING OF A NUMBER BETWEEN ONE AND TEN."
40 PRINT "CAN YOU GUESS MY NUMBER?"
41 LET C=C+1
50 INPUT G
60 IF G = A THEN GOTO 90
70 IF G < A THEN GOTO 100
80 IF G > A THEN GOTO 110
90 PRINT "YOU ARE CORRECT!"
91 PRINT "I WAS THINKING OF "; A; "."
92 PRINT "YOU MADE "; C; " GUESSES."
92 END
100 PRINT "INCORRECT!"
101 PRINT "YOUR GUESS IS TOO LOW."
102 GOTO 40
110 PRINT "INCORRECT!"
111 PRINT "YOUR GUESS IS TOO HIGH."
112 GOTO 40