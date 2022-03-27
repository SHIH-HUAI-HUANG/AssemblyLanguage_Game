;       b1085154 
;       shih huai huang 
;       test for final homework
;      
    AREA	GAME,CODE,READONLY

SWI_WriteC	EQU	&0
SWI_Write0	EQU	&2
SWI_ReadC	EQU	&4
SWI_Time	EQU	&63
SWI_Clock	EQU	&61
SWI_Exit	EQU	&11
;
		ENTRY
PLAYER  MOV r3, #&30		;store the player's score in register-3
ENEMY 	MOV r5, #&30		;store the enemy's score in register-5
LEVEL   MOV r4, #&30		;put the level in register-4
	ADRL r0, COVER
	SWI SWI_Write0
	SWI SWI_ReadC
START
	ADRL	r0, RULE		;RULE introduction
	SWI	SWI_Write0
;Player choose the skill
	SWI	SWI_ReadC
	MOV r6, r0		;saving player's skill 
;Product the random skill
DICE	SWI	SWI_Time
	MOV	r10,r0
	SWI	SWI_Clock
	MOV	r7,r0
;ensure the random is 1 ~ 3
CYC	CMP	r7,#3
	SUBGE	r7,r7,#3
	CMP	r7,#3
	BGE	CYC
	ADD	r7,r7,#1
;print enemy's skill
	CMP r7, #1
	BLEQ ONE
	CMP r7, #2
	BLEQ TWO
	CMP r7, #3
	BLEQ THREE
;print play's skill
	CMP	r6, #&31
	BLEQ	ONE		;cut
	CMP	r6, #&32
	BLEQ	TWO		;stone
	CMP	r6, #&33
	BLEQ	THREE	;paper
;check the score
	CMP r6, #&31
	BLEQ	JUGE1
	CMP	r6, #&32
	BLEQ	JUGE2
	CMP	r6, #&33
	BLEQ	JUGE3

	ADRL	r0, PSCORE		;print player's score
	SWI	SWI_Write0
	MOV r0, r3		;print score
	SWI	SWI_WriteC

	ADRL	r0, ESCORE		;print enemy's score
	SWI	SWI_Write0
	MOV r0, r5		;print score
	SWI	SWI_WriteC
	ADD r4, r4, #&1	;level plus 1
	CMP r4, #&35	;define the numbers of level  (5)
	BEQ FINISH
	B START
FINISH	SWI	SWI_Exit	;********** end game **********

;Juge the score
JUGE1 CMP r7, #1
	BEQ BRANCH1
	CMP r7, #2
	BEQ BRANCH2
	CMP r7, #3
	BEQ BRANCH3
BRANCH1	ADRL r0, TIE
	SWI	SWI_Write0
	MOV	pc,r14
BRANCH2	ADRL r0, DEFEAT
	SWI	SWI_Write0 
	ADD r5, r5, #&1
	MOV	pc,r14
BRANCH3	ADRL r0, VICTORY 
	SWI	SWI_Write0
	ADD r3, r3, #&1
	MOV	pc,r14	;**********
JUGE2 CMP r7, #1
	BEQ BRANCH4
	CMP r7, #2
	BEQ BRANCH5
	CMP r7, #3
	BEQ BRANCH6
BRANCH4	ADRL r0, VICTORY
	SWI	SWI_Write0
	MOV	pc,r14
BRANCH5	ADRL r0, TIE
	SWI	SWI_Write0 
	MOV	pc,r14
BRANCH6	ADRL r0, DEFEAT 
	SWI	SWI_Write0
	ADD r5, r5, #&1
	MOV	pc,r14	;**********
JUGE3 CMP r7, #1
	BEQ BRANCH7
	CMP r7, #2
	BEQ BRANCH8
	CMP r7, #3
	BEQ BRANCH9
BRANCH7	ADRL r0, DEFEAT
	SWI	SWI_Write0
	ADD r5, r5, #&1
	MOV	pc,r14
BRANCH8	ADRL r0, VICTORY
	SWI	SWI_Write0 
	ADD r3, r3, #&1
	MOV	pc,r14
BRANCH9	ADRL r0, TIE 
	SWI	SWI_Write0
	MOV	pc,r14	;**********
;Print skill
ONE	ADRL r0, CUT
	SWI	SWI_Write0
	MOV	pc,r14
TWO	ADRL	r0, STONE
	SWI	SWI_Write0
	MOV	pc,r14
THREE	ADRL	r0, PAPER
	SWI	SWI_Write0
	MOV	pc,r14
;Print the rule
RULE     = &0a,&0a,&0a,&0a,"    //    / /     //   / /     / /        / /        //   ) )       //   ) )     //    / /     // | |     / /        / /        //   / /     /|    / /     //   ) )     //   / /     //   ) )",&0a, &0d
RULE1      =   "   //___ / /     //____       / /        / /        //   / /       //           //___ / /     //__| |    / /        / /        //____       //|   / /     //           //____       //___/ /",&0a, &0d
RULE2      =   "  / ___   /     / ____       / /        / /        //   / /       //           / ___   /     / ___  |   / /        / /        / ____       // |  / /     //  ____     / ____       / ___ (",&0a, &0d
RULE3      =   " //    / /     //           / /        / /        //   / /       //           //    / /     //    | |  / /        / /        //           //  | / /     //    / /    //           //   | |",&0a, &0d
RULE4      =   "//    / /     //____/ /    / /____/ / / /____/ / ((___/ /       ((____/ /    //    / /     //     | | / /____/ / / /____/ / //____/ /    //   |/ /     ((____/ /    //____/ /    //    | |",&0a, &0d
RULE5   =	&0a, &0a, " First is Stone ~ ", &0a, &0a, 0
;Print Victory
VICTORY  =	&0a, &0d, " VICTORY ", &0a, &0a, 0
;Print Defeat
DEFEAT   =	&0a, &0d, " DEFEAT ", &0a, &0a, 0
;Print tie
TIE   =	&0a, &0d, " TIE ", &0a, &0a, 0
CUT      =   "   \\  /   ",&0a, &0d
CUT1     =   "    \\/    ",&0a, &0d
CUT2     =   "   _/\\_   ",&0a, &0d
CUT3     =   " ( /  \\ ) ",&0a, &0a, 0  
STONE    =   "   _____   ",&0a, &0d
STONE1   =   "  /___ /|  ",&0a, &0d
STONE2   =   " |    | |  ",&0a, &0d
STONE3   =   " |____|/   ",&0a, &0a, 0
PAPER    =   "  _______  ",&0a, &0d
PAPER1   =   " (     (_) ",&0a, &0d
PAPER2   =   "  )     )  ",&0a, &0d
PAPER3   =   " /______/  ",&0a, &0a, 0

COVER	=	&0a, &0a, &0a, &0a, &0a, &0a, "_______________________________________________________________________________________  ", &0a
COVER1	=	"        __   __     _     _          __   __     _     _      _    _   _____    _     _  ", &0a
COVER2	=	"        /    / |    /|   /           /    / |    /|   /       /  ,'    /    '   /|   /   ", &0a
COVER3	=	"-------/----/__|---/-| -/-----------/----/__|---/-| -/-------/_.'-----/__------/-| -/--  ", &0a
COVER4	=	"      /    /   |  /  | /           /    /   |  /  | /       /  \\     /        /  | /     ", &0a
COVER5	=	"_(___/____/____|_/___|/_______(___/____/____|_/___|/_______/____\\___/____ ___/___|/____  ", &0a, &0a, &0a
COVER6  =	"                                     .. . ..		", &0a
COVER7  =	"                                    '  ':'	 '		", &0a
COVER9  =	"                                     ___:____     |-\\/-|			", &0a
COVER10  =	"                                   ,'        `.    \\  /			", &0a
COVER11  =	"                                   |  O        \\___/ |			", &0a
COVER12  =	"                                 ~^~^~^~^~^~^~^~^~^~^~^~^~			", &0a, &0a, &0a, &0a, &0a
COVER13  =	"			                                 PRESEE   START										", &0a
COVER14  =	"			", &0a, &0a, &0a, &0a, &0a, &0a, &0a, &0a
COVER15  =	"**********************************************************************************************", &0a,0

PSCORE	=	&0a, "Player's score = ", 0
ESCORE	=	&0a, "Enemy's score  = ", 0




	END
