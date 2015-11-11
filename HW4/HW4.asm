/*
 * HW4.asm
 *
 *  Created: 10/22/2015 1:18:03 PM
 *  Author: Robyn
 *
 *	Basic Logic:
 *	The board has two status's
 *  Button pressed or button not pressed
 *	Two sets of delay loops for each status
 *	Button pressed has a faster frequency, so the
 *  delay is shorter for that set of loops.
 */ 

			.include	<atxmega256a3budef.inc>
			.CSEG
			.ORG		0x00
			JMP			start

			.ORG		0xF6
	start:
			LDI			R16,0xff		;Sets all pins of port R as out
			STS			PORTR_DIR,R16	;	*

			LDI			R17,0b00000010	;turn off the two yellow LEDs
			STS			PORTR_OUT,R17	;

	// PORT E(5) SWITCH (#1 top left)
	// Sets the pin connected to the button as input
	loop:	LDS			R16,PORTE_IN	;Check to see if the button is pressed
			ANDI		R16,0b00100000	;	*
			BREQ		else			;if it is pressed then jump to else
	
	/*This set of loops executes if button is not pressed
	* 32 x 20 x 250 x 5 = 800,000 cycles	
	* Not perfect, has some extra cycles from looping
	* LED <? 0 => on
	*/	
	outLoop:LDI			R17,0b00000010	;Turns bit 0 off, bit 1 on
			STS			PORTR_OUT,R17	;	*
			LDI			R18, 32		
	loop12:	LDI			R19, 20
	loop22:	LDI			R20, 250
	loop32:	NOP
			NOP
			DEC			R20
			BRNE		loop32
			DEC			R19
			BRNE		loop22
			DEC			R18
			BRNE		loop12
			//Swaps the LEDs back on status after the delay
			LDI			R17,0b00000001	
			STS			PORTR_OUT,R17
			JMP			outLoop2
	//Swaps the LEDs back on status after the delay
	outLoop2:LDI		R18, 32		
	loop42:	LDI			R19, 20
	loop52:	LDI			R20, 250
	loop62:	NOP
			NOP
			DEC			R20
			BRNE		loop62
			DEC			R19
			BRNE		loop52
			DEC			R18
			BRNE		loop42
			LDI			R17,0b00000001	;Turns bit 1 off, bit 0 on
			STS			PORTR_OUT,R17	;	*
			JMP			loop
	
	/*This set of loops executes if button is pressed
	* 32 x 20 x 25 x 5 = 80,000 cycles	
	* Not perfect, has some extra cycles from looping
	* LED <? 0 => on
	*/	
	else:	
	inLoop:	LDI			R17,0b00000010	;Turns bit 0 off, bit 1 on
			STS			PORTR_OUT,R17	;	*
			LDI			R18, 32			
	loop1:	LDI			R19, 20
	loop2:	LDI			R20, 25
	loop3:	NOP
			NOP
			DEC			R20
			BRNE		loop3
			DEC			R19
			BRNE		loop2
			DEC			R18
			BRNE		loop1
			
			LDI			R17,0b00000001	;Turns bit 1 off, bit 0 on
			STS			PORTR_OUT,R17	;	*
			JMP			inLoop2
	
	inLoop2:LDI			R18, 32		
	loop4:	LDI			R19, 20
	loop5:	LDI			R20, 25
	loop6:	NOP
			NOP
			DEC			R20
			BRNE		loop6
			DEC			R19
			BRNE		loop5
			DEC			R18
			BRNE		loop4
			LDI			R17,0b00000001	;Turns bit 1 off, bit 0 on
			STS			PORTR_OUT,R17	;	*
			JMP			endif			;else
	endif:	JMP			loop			;end loop
	
	
	here:	RJMP		here			;do nothing forever	

