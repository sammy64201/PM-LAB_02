//*****************************************************************************
// Universidad del Valle de Guatemala
// IE2023 Programacion de Microcontroladores
// Autor: Edgar Chavarria 22055
// Proyecto: PM-Lab_01.asm
// Descripcion: Contador binario de 4 bits
// Hardware: ATMega328P
// Created: 1/28/2024 7:08:48 PM
// Author : Samuel
//*****************************************************************************
//Encabezado
.INCLUDE "M328PDEF.inc"
.CSEG
.ORG 0x00
//*****************************************************************************
// STACK POINTER 
//*****************************************************************************
LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R17, HIGH(RAMEND)
OUT SPH, R17 
//*****************************************************************************

//*****************************************************************************
// TABLA DE VALORES 
//*****************************************************************************

//*****************************************************************************
// CONFIGURACION MCU 
//*****************************************************************************
SETUP:
	
	LDI R16, (1 << CLKPCE) 
	STS CLKPR, R16

	LDI R16, 0b0000_0001 ;DEFINO LA FRECUENCIA EN 4MHz
	STS CLKPR, R16

	CALL TIM0

	SBI DDRB, PB0 ; usare el PB5 como salida
	CBI PORTB, PB0 ; apago el vit pb5 del puerto B
	SBI DDRB, PB1
	CBI PORTB, PB1
	SBI DDRB, PB2
	CBI PORTB, PB2
	SBI DDRB, PB3
	CBI PORTB, PB3

	LDI R17, 0x00 ;LO USARE COMO EL CONTADOR QUE COMIENZA EN 0



LOOP:
	IN R16, TIFR0
	CPI R16, (1<<TOV0) ;COMPARO CON LA BANDERA DE OVERFLOW
	BRNE LOOP		   ;SI NO ESTA ENCENDIDA REGRESAMOS AL LOOP
	
	LDI R16, 158     
	OUT TCNT0, R16

	SBI TIFR0, TOV0

	INC R20  ;INCREMENTAMOS EL CONTADOR
	CPI R20, 100 ;VA COMPARAR HASTA QUE LLEGUE A 50
	BRNE LOOP

	CLR R20

	INC R17					;INCREMENTO EL CONTADOR DE LED
	;CPI R17, 16	;COMPARO SI LAS LEDS YA ESTAN ENCENDIDAS
	;BREQ PASAR				


	OUT PINB, R17 ;ENCENDEMOS ALGO
	RJMP LOOP ;AL BUCLE INICIAL

//*****************************************************************************

//*****************************************************************************
// SUBRUTINAS
//*****************************************************************************

TIM0:	
	LDI R16, (1 << CS02) | (1 << CS00) ; EL PRESCALER SE QUEDO EN 1024
	OUT TCCR0B, R16 

	LDI R16, 158 ; LE CARGO EL VALOR EXACTO DE DESBORDAMIENTO
	OUT TCNT0, R16 ;CARGO EL VALOR INICIAL DEL CONTADOR

	RET 

;PASAR:
;	CLR R17		;SI YA ESTAN ENCENDIDAS TODAS, LIMPIO MI REGISRO PARA QUE CUENTE DESDE 0 NUEVAMENTE
;	RET
	

