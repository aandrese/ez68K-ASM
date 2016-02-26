*-----------------------------------------------------------
* Program    :
* Written by : Alex Andresen
* Date       :
* Description: makes a negative version, a flipped version,
*              and a bright version of the original image
*-----------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ORG     $0900           ;start program at this address
LAB4    BSR     NEG
        BSR     LSRT
        BSR     BRT
        BSR     FRM
        BRA     STOP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        
NEG     LEA     IMAGE,A0        ;LOAD IMAGE ADRESS
        LEA     IMNEG,A1        ;LOAD NEGATIVE ADRESS
NOOP    CMPI.L  #$C0C0C0C0,(A0) ;CHECK FOR...
        BEQ     NEGS            ;THE END
                                ;
        MOVE.W  (A0)+,(A1)      ;MOVE &
        NOT.W   (A1)+           ;COMPLIMENT
        BRA     NOOP            ;
NEGS    RTS                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LSRT    LEA     IMAGE,A0        ;LOAD PRE LOC
        LEA     IMLSR,A1        ;LOAD POST LOC
                                ;
ROOP1   CMPI.L  #$C0C0C0C0,(A0) ;CHECK FOR...
        BEQ     LSRE            ;THE END
                                ;
        MOVE.W  (A0)+,D0        ;MOVE TO D1
        MOVE.B  #16,D2          ;SET D2 AS COUNTER
        CLR.W   D1              ;CLEAR D1 FOR RESULT
                                ;
ROOP2   ROL.W   #1,D0           ;DATA REGISTER
        BCC     SKIP            ;LOOP
        BSET    #0,D1           ;SET BIT IF SET,
                                ;SKIP IF NOT
                                ;
SKIP    ROR.W   #1,D1           ;ROTATE & LOOP
        SUBQ.B  #1,D2           ;DECREMENT COUNTER
        BNE     ROOP2           ;
                                ;
        MOVE.W  D1,(A1)+        ;MOVE TO POST
        BRA     ROOP1           ;
        
LSRE    RTS                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BRT     LEA     IMAGE,A0        ;LOAD PRE LOC
        LEA     IMBRT,A1        ;LOAD POST LOC
                                ;
BOOP    CMPI.L  #$C0C0C0C0,(A0) ;CHECK FOR...
        BEQ     BRTS            ;THE END
                                ;
        MOVE.L  (A0)+,D0        ;MOVE TO D0
        MOVE.L  D0,D1           ;SET D1 FOR RESULT
        MOVE.B  #8,D3           ;D3 = ROL COUNTER
                                ;
                                ;
                                ;
                                ;
                                ;
                                ;
TEST1   BTST    #30,D0          ;TEST FOR :
        BEQ     TEST2           ;
        BTST    #14,D0          ;       X 1
        BEQ     TEST2           ;       X 1
        BSR     MASK1           ;MASK
TEST2   BTST    #31,D0          ;TEST FOR :
        BEQ     SKIP1           ;
        BTST    #15,D0          ;       1 X
        BEQ     SKIP1           ;       1 X
        BSR     MASK2           ;MASK
                                ;
SKIP1   ROL.L   #2,D0           ;
        ROL.L   #2,D1           ;
        SUBQ    #1,D3           ;
        BNE     TEST1           ;

        SWAP    D1              ;MOVE INTO PLACE
        MOVE.L  D1,(A1)+        ;
        BRA     BOOP            ;
                                ;
                                ;
                                ;
MASK1   BSET    #30,D1          ;SET TO :
        BSET    #14,D1          ;       0 1
        BCLR    #31,D1          ;       0 1
        BCLR    #15,D1          ;
        RTS                     ;
MASK2   BSET    #31,D1          ;SET TO :
        BSET    #15,D1          ;       1 0
        BCLR    #30,D1          ;       1 0
        BCLR    #14,D1          ;
        RTS                     ;
                                ;
                                ;
BRTS    RTS                     ;
                                ;
                                ;
                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FRM     LEA     IMAGE,A0        ;LOAD PRE LOC
        MOVE.B  #6,D0
        ORI.L   #$FFFF8001,(A0)+
FRMSKP  ORI.L   #$80018001,(A0)+
        SUBQ    #1,D0
        BNE     FRMSKP
        ORI.L   #$8001FFFF,(A0)+
        RTS       
                                ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ORG     $0C00           ;at this address, create an image
IMAGE   DC.W    $0000           ;................
        DC.W    $0000           ;................
        DC.W    $3FE0           ;..111111111.....
        DC.W    $3FF0           ;..1111111111....
        DC.W    $3878           ;..111....1111...
        DC.W    $3838           ;..111.....111...
        DC.W    $3838           ;..111.....111...
        DC.W    $3870           ;..111....111....
        DC.W    $3FE0           ;..111111111.....
        DC.W    $3FE0           ;..111111111.....
        DC.W    $3870           ;..111....111....
        DC.W    $3870           ;..111....111....
        DC.W    $3838           ;..111.....111...
        DC.W    $3838           ;..111.....111...
        DC.W    $0000           ;................
        DC.W    $0000           ;................ 
        DC.L    $C0C0C0C0       ;a marker at the end of original image
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                ;
        ORG     $0C40           ;at this address
IMNEG   DS.W    16              ;allocate space for negative image
        DC.L    $C4C4C4C4       ;a marker at the end of negative image
                                ;
                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ORG     $0C80           ;at this address 
IMLSR   DS.W    16              ;allocate space for left side right image
        DC.L    $C8C8C8C8       ;a marker at the end of flipped image
                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ORG     $0CC0           ;at this address
IMBRT   DS.W    16              ;allocate space for rotate image 
        DC.L    $CCCCCCCC       ;a marker at the end of bright image
                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
STOP    MOVE.B #9,D0            ;
        TRAP #15                ;
        END  LAB4               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
