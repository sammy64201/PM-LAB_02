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
; CONFIGURACION DE MCU 
//*****************************************************************************

SETUP: 
	
; DEJAMOS LA FRECUENCIA DEL CRISTAL EN 16MHz

	; ACTIVACION DE LOS PUERTOS TX Y RX PARA QUE SE PUEDAN USAR COMO PINES NORMALES
	LDI R16,0x00
	STS UCSR0B, R16

	;DECLARACION DE PUERTOS COMO SALIDA 
	SBI DDRD, PD7
	SBI DDRD, PD6
	SBI DDRD, PD5
	SBI DDRD, PD4
	SBI DDRD, PD3
	SBI DDRD, PD2
	SBI DDRD, PD1

	;DECLARACION DE PUERTOS COMO ENTRADA
	SBI PORTC, PC0
	SBI PORTC, PC1
	

	;CARGAR VALOR A R16 PARA EL CONTADOR 
	LDI R16, 0b0000_0000
	LDI R17, 0b0000_0000
	;CARGAR VALOR A DELAY
	LDI R21, 0xFF
	LDI R22, 0xFF
	LDI R23, 0X0F

//*****************************************************************************
; LOOP 
//*****************************************************************************



LOOP2:
	IN R17, PINC 
	CPI R17, 0b0000_0011 ; LEEMOS LOS BOTONES
	BREQ LOOP2
	CALL DELAY ; LLAMAMOS A NUESTRO ANTIREBOTE 
	CPI R17, 0b0000_0010 ;VOLVEMOS A LEER BOTON POR BOTON 
	BREQ PULSOI 
	CPI R17, 0b0000_0001
	BREQ PULSOD
	RJMP LOOP2


//*****************************************************************************
; SUBRUTINAS
//*****************************************************************************

PULSOI: 
	CALL CONTI	; FUNCION QUE INCREMENTA EL REGISTRO DE CONTADOR 
	CALL PUN_TAB	; FUNCION QUE APUNTA PARA EL DISPLAY DE 7 SEGMENTOS 
	OUT PORTD, R18 ; MUESTRA LO QUE ENCONTRO EN LA TABLA 
	RJMP LOOP2

PULSOD:
	CALL CONTD
	CALL PUN_TAB
	OUT PORTD, R18
	RJMP LOOP2


CONTI:
	INC R16 
	SBRC R16, 4 
	CLR R16 
	RET

CONTD:
	DEC R16
	SBRC R16,4
	LDI R16, 0x0F
	RET
	
PUN_TAB:
	LDI ZH, HIGH(TABLA7SEG << 1)
	LDI ZL, LOW (TABLA7SEG << 1)
	ADD ZL, R16
	LPM R18, Z
	RET

Delay:
DEC R21 
CPI R21, 0b0000_0000 
BRNE Delay 
LDI R21, 0b1111_1111
DEC R22
CPI R22, 0b0000_0000
BRNE DELAY
LDI R22, 0b1111_1111
DEC R23 
CPI R23, 0b0000_0000
BRNE DELAY
LDI R23, 0b0000_1111 // Delay
RET
	

//*****************************************************************************
; TABLA DE VALORES
//*****************************************************************************

TABLA7SEG: .DB/*0*/ 0b1110_1110, /*1*/ 0b1000_1000, /*2*/ 0b1101_0110, /*3*/ 0b1101_1100, /*4*/ 0b1011_1000, /*5*/ 0b0111_1100, /*6*/ 0b0011_1110,/*7*/ 0b1100_1000,/*8*/ 0b1111_1110,/*9*/ 0b1111_1000,/*A*/ 0b1111_1010,/*B*/ 0b0011_1110,/*C*/ 0b0110_0110,/*D*/ 0b1110_1110,/*E*/ 0b0111_0110,/*F*/ 0b0111_0010
