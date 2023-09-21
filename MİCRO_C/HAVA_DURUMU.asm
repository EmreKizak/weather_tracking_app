
_StartSignal:

;HAVA_DURUMU.c,20 :: 		void StartSignal(){
;HAVA_DURUMU.c,21 :: 		TRISD.B0 = 0;  //RD0'ý çýkýþ olarak yapýlandýrýldý
	BCF        TRISD+0, 0
;HAVA_DURUMU.c,22 :: 		PORTD.B0 = 0;  //RD0 sensöre 0 gönderir
	BCF        PORTD+0, 0
;HAVA_DURUMU.c,23 :: 		delay_ms(18);
	MOVLW      59
	MOVWF      R12+0
	MOVLW      111
	MOVWF      R13+0
L_StartSignal0:
	DECFSZ     R13+0, 1
	GOTO       L_StartSignal0
	DECFSZ     R12+0, 1
	GOTO       L_StartSignal0
	NOP
	NOP
;HAVA_DURUMU.c,24 :: 		PORTD.B0 = 1;   //RD0 sensöre 1 gönderir
	BSF        PORTD+0, 0
;HAVA_DURUMU.c,25 :: 		delay_us(30);
	MOVLW      24
	MOVWF      R13+0
L_StartSignal1:
	DECFSZ     R13+0, 1
	GOTO       L_StartSignal1
	NOP
	NOP
;HAVA_DURUMU.c,26 :: 		TRISD.B0 = 1;   //RD0'ý giriþ olarak yapýlandýrýn
	BSF        TRISD+0, 0
;HAVA_DURUMU.c,27 :: 		}
L_end_StartSignal:
	RETURN
; end of _StartSignal

_CheckResponse:

;HAVA_DURUMU.c,28 :: 		void CheckResponse(){        //sinyal geldiði sürece sürekli çalýþmasýný saðlýyor
;HAVA_DURUMU.c,29 :: 		Check = 0;
	CLRF       _Check+0
;HAVA_DURUMU.c,30 :: 		delay_us(40);
	MOVLW      33
	MOVWF      R13+0
L_CheckResponse2:
	DECFSZ     R13+0, 1
	GOTO       L_CheckResponse2
;HAVA_DURUMU.c,31 :: 		if (PORTD.B0 == 0){
	BTFSC      PORTD+0, 0
	GOTO       L_CheckResponse3
;HAVA_DURUMU.c,32 :: 		delay_us(80);
	MOVLW      66
	MOVWF      R13+0
L_CheckResponse4:
	DECFSZ     R13+0, 1
	GOTO       L_CheckResponse4
	NOP
;HAVA_DURUMU.c,33 :: 		if (PORTD.B0 == 1)
	BTFSS      PORTD+0, 0
	GOTO       L_CheckResponse5
;HAVA_DURUMU.c,34 :: 		Check = 1; delay_us(40);
	MOVLW      1
	MOVWF      _Check+0
L_CheckResponse5:
	MOVLW      33
	MOVWF      R13+0
L_CheckResponse6:
	DECFSZ     R13+0, 1
	GOTO       L_CheckResponse6
;HAVA_DURUMU.c,35 :: 		}
L_CheckResponse3:
;HAVA_DURUMU.c,36 :: 		}
L_end_CheckResponse:
	RETURN
; end of _CheckResponse

_ReadData:

;HAVA_DURUMU.c,37 :: 		char ReadData(){
;HAVA_DURUMU.c,39 :: 		for(j = 0; j < 8; j++){
	CLRF       R3+0
L_ReadData7:
	MOVLW      8
	SUBWF      R3+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_ReadData8
;HAVA_DURUMU.c,40 :: 		while(!PORTD.B0);  //PORTD.B0 YÜKSEK olana kadar bekleyin
L_ReadData10:
	BTFSC      PORTD+0, 0
	GOTO       L_ReadData11
	GOTO       L_ReadData10
L_ReadData11:
;HAVA_DURUMU.c,41 :: 		delay_us(30);
	MOVLW      24
	MOVWF      R13+0
L_ReadData12:
	DECFSZ     R13+0, 1
	GOTO       L_ReadData12
	NOP
	NOP
;HAVA_DURUMU.c,42 :: 		if(PORTD.B0 == 0)
	BTFSC      PORTD+0, 0
	GOTO       L_ReadData13
;HAVA_DURUMU.c,43 :: 		i&= ~(1<<(7 - j)); //Clear bit (7-b)
	MOVF       R3+0, 0
	SUBLW      7
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      R1+0
	MOVLW      1
	MOVWF      R0+0
	MOVF       R1+0, 0
L__ReadData53:
	BTFSC      STATUS+0, 2
	GOTO       L__ReadData54
	RLF        R0+0, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__ReadData53
L__ReadData54:
	COMF       R0+0, 1
	MOVF       R0+0, 0
	ANDWF      R2+0, 1
	GOTO       L_ReadData14
L_ReadData13:
;HAVA_DURUMU.c,45 :: 		i|= (1 << (7 - j)); //Set bit (7-b)
	MOVF       R3+0, 0
	SUBLW      7
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      R1+0
	MOVLW      1
	MOVWF      R0+0
	MOVF       R1+0, 0
L__ReadData55:
	BTFSC      STATUS+0, 2
	GOTO       L__ReadData56
	RLF        R0+0, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__ReadData55
L__ReadData56:
	MOVF       R0+0, 0
	IORWF      R2+0, 1
;HAVA_DURUMU.c,46 :: 		while(PORTD.B0);
L_ReadData15:
	BTFSS      PORTD+0, 0
	GOTO       L_ReadData16
	GOTO       L_ReadData15
L_ReadData16:
;HAVA_DURUMU.c,47 :: 		}
L_ReadData14:
;HAVA_DURUMU.c,39 :: 		for(j = 0; j < 8; j++){
	INCF       R3+0, 1
;HAVA_DURUMU.c,48 :: 		}
	GOTO       L_ReadData7
L_ReadData8:
;HAVA_DURUMU.c,49 :: 		return i;
	MOVF       R2+0, 0
	MOVWF      R0+0
;HAVA_DURUMU.c,50 :: 		}
L_end_ReadData:
	RETURN
; end of _ReadData

_main:

;HAVA_DURUMU.c,52 :: 		void main() {
;HAVA_DURUMU.c,53 :: 		TRISB.B0 = 0;
	BCF        TRISB+0, 0
;HAVA_DURUMU.c,54 :: 		TRISD.B0 = 0;
	BCF        TRISD+0, 0
;HAVA_DURUMU.c,55 :: 		ANSEL=0x09;
	MOVLW      9
	MOVWF      ANSEL+0
;HAVA_DURUMU.c,56 :: 		Lcd_Cmd(_LCD_CURSOR_OFF); // cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HAVA_DURUMU.c,57 :: 		Lcd_Cmd(_LCD_CLEAR); // clear LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HAVA_DURUMU.c,58 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;HAVA_DURUMU.c,59 :: 		while(1){
L_main17:
;HAVA_DURUMU.c,60 :: 		StartSignal(); //FONKSÝYON
	CALL       _StartSignal+0
;HAVA_DURUMU.c,61 :: 		CheckResponse(); //FONKSÝYON
	CALL       _CheckResponse+0
;HAVA_DURUMU.c,62 :: 		if(Check == 1){   //KONTROL
	MOVF       _Check+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main19
;HAVA_DURUMU.c,63 :: 		RH_byte1 = ReadData();
	CALL       _ReadData+0
	MOVF       R0+0, 0
	MOVWF      _RH_byte1+0
;HAVA_DURUMU.c,64 :: 		RH_byte2 = ReadData();
	CALL       _ReadData+0
	MOVF       R0+0, 0
	MOVWF      _RH_byte2+0
;HAVA_DURUMU.c,65 :: 		T_byte1 = ReadData();
	CALL       _ReadData+0
	MOVF       R0+0, 0
	MOVWF      _T_byte1+0
;HAVA_DURUMU.c,66 :: 		T_byte2 = ReadData();
	CALL       _ReadData+0
	MOVF       R0+0, 0
	MOVWF      _T_byte2+0
;HAVA_DURUMU.c,67 :: 		Sum = ReadData();
	CALL       _ReadData+0
	MOVF       R0+0, 0
	MOVWF      _Sum+0
	CLRF       _Sum+1
;HAVA_DURUMU.c,68 :: 		if(Sum == ((RH_byte1+RH_byte2+T_byte1+T_byte2) & 0XFF)){
	MOVF       _RH_byte2+0, 0
	ADDWF      _RH_byte1+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       _T_byte1+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       _T_byte2+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVLW      255
	ANDWF      R0+0, 0
	MOVWF      R2+0
	MOVF       R0+1, 0
	MOVWF      R2+1
	MOVLW      0
	ANDWF      R2+1, 1
	MOVF       _Sum+1, 0
	XORWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main58
	MOVF       R2+0, 0
	XORWF      _Sum+0, 0
L__main58:
	BTFSS      STATUS+0, 2
	GOTO       L_main20
;HAVA_DURUMU.c,69 :: 		Temp= T_byte1;
	MOVF       _T_byte1+0, 0
	MOVWF      _Temp+0
	CLRF       _Temp+1
;HAVA_DURUMU.c,70 :: 		RH = RH_byte1;      //SICAKLIK VE NEM SENSÖRLERÝ
	MOVF       _RH_byte1+0, 0
	MOVWF      _RH+0
	CLRF       _RH+1
;HAVA_DURUMU.c,71 :: 		water = ADC_Read(3)/10;     //su seviyesi sensörünün adc iþlemi
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _water+0
	MOVF       R0+1, 0
	MOVWF      _water+1
;HAVA_DURUMU.c,72 :: 		basinc = ADC_Read(0)*10 / 8.39215686;   //basýnc sensörünün adc iþlemi
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	CALL       _word2double+0
	MOVLW      70
	MOVWF      R4+0
	MOVLW      70
	MOVWF      R4+1
	MOVLW      6
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2word+0
	MOVF       R0+0, 0
	MOVWF      _basinc+0
	MOVF       R0+1, 0
	MOVWF      _basinc+1
;HAVA_DURUMU.c,73 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HAVA_DURUMU.c,74 :: 		Lcd_Out(1, 1, "Sicaklik: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_HAVA_DURUMU+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HAVA_DURUMU.c,75 :: 		Lcd_Out(2, 1, "Nem: ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_HAVA_DURUMU+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HAVA_DURUMU.c,76 :: 		LCD_Chr(1, 12, 48 + ((Temp / 10) % 10));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _Temp+0, 0
	MOVWF      R0+0
	MOVF       _Temp+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;HAVA_DURUMU.c,77 :: 		LCD_Chr(1, 13, 48 + (Temp % 10));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _Temp+0, 0
	MOVWF      R0+0
	MOVF       _Temp+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;HAVA_DURUMU.c,78 :: 		LCD_Chr(2, 12, 48 + ((RH / 10) % 10));
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _RH+0, 0
	MOVWF      R0+0
	MOVF       _RH+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;HAVA_DURUMU.c,79 :: 		LCD_Chr(2, 13, 48 + (RH % 10));
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _RH+0, 0
	MOVWF      R0+0
	MOVF       _RH+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;HAVA_DURUMU.c,80 :: 		Delay_ms( 1000 );
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main21:
	DECFSZ     R13+0, 1
	GOTO       L_main21
	DECFSZ     R12+0, 1
	GOTO       L_main21
	DECFSZ     R11+0, 1
	GOTO       L_main21
	NOP
;HAVA_DURUMU.c,81 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HAVA_DURUMU.c,82 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HAVA_DURUMU.c,83 :: 		Lcd_Out(1, 1, "Su Seviyesi: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_HAVA_DURUMU+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HAVA_DURUMU.c,84 :: 		LCD_Chr(1, 14, 48 + ((water / 100) % 10));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _water+0, 0
	MOVWF      R0+0
	MOVF       _water+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;HAVA_DURUMU.c,85 :: 		LCD_Chr(1, 15, 48 + ((water / 10) % 10));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _water+0, 0
	MOVWF      R0+0
	MOVF       _water+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;HAVA_DURUMU.c,86 :: 		LCD_Chr(1, 16, 48 + (water % 10));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      16
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _water+0, 0
	MOVWF      R0+0
	MOVF       _water+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;HAVA_DURUMU.c,87 :: 		Delay_ms( 1000 );
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main22:
	DECFSZ     R13+0, 1
	GOTO       L_main22
	DECFSZ     R12+0, 1
	GOTO       L_main22
	DECFSZ     R11+0, 1
	GOTO       L_main22
	NOP
;HAVA_DURUMU.c,88 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HAVA_DURUMU.c,89 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HAVA_DURUMU.c,90 :: 		Lcd_Out(1, 1, "Basinc: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_HAVA_DURUMU+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HAVA_DURUMU.c,91 :: 		LCD_Chr(1, 13, 48 + ((basinc / 1000) % 10));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	MOVF       _basinc+0, 0
	MOVWF      R0+0
	MOVF       _basinc+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;HAVA_DURUMU.c,92 :: 		LCD_Chr(1, 14, 48 + ((basinc / 100) % 10));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _basinc+0, 0
	MOVWF      R0+0
	MOVF       _basinc+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;HAVA_DURUMU.c,93 :: 		LCD_Chr(1, 15, 48 + ((basinc / 10) % 10));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _basinc+0, 0
	MOVWF      R0+0
	MOVF       _basinc+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;HAVA_DURUMU.c,94 :: 		LCD_Chr(1, 16, 48 + (basinc % 10));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      16
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _basinc+0, 0
	MOVWF      R0+0
	MOVF       _basinc+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;HAVA_DURUMU.c,95 :: 		Delay_ms( 1000 );
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main23:
	DECFSZ     R13+0, 1
	GOTO       L_main23
	DECFSZ     R12+0, 1
	GOTO       L_main23
	DECFSZ     R11+0, 1
	GOTO       L_main23
	NOP
;HAVA_DURUMU.c,96 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HAVA_DURUMU.c,97 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HAVA_DURUMU.c,98 :: 		if((Temp<=5)&(RH<=20)&(basinc>1020)){  //koþullarýn   yazýlmasý
	MOVF       _Temp+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main59
	MOVF       _Temp+0, 0
	SUBLW      5
L__main59:
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVF       _RH+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main60
	MOVF       _RH+0, 0
	SUBLW      20
L__main60:
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	ANDWF      R1+0, 1
	MOVF       _basinc+1, 0
	SUBLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__main61
	MOVF       _basinc+0, 0
	SUBLW      252
L__main61:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_main24
;HAVA_DURUMU.c,99 :: 		Lcd_Out(1, 1, "KAR RISKI");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_HAVA_DURUMU+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HAVA_DURUMU.c,100 :: 		if(water<30){
	MOVLW      0
	SUBWF      _water+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main62
	MOVLW      30
	SUBWF      _water+0, 0
L__main62:
	BTFSC      STATUS+0, 0
	GOTO       L_main25
;HAVA_DURUMU.c,101 :: 		Lcd_Out(2, 1, "KAR YAGMIYOR");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_HAVA_DURUMU+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HAVA_DURUMU.c,102 :: 		}
L_main25:
;HAVA_DURUMU.c,103 :: 		if((water>=30)&&(water<60)){
	MOVLW      0
	SUBWF      _water+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main63
	MOVLW      30
	SUBWF      _water+0, 0
L__main63:
	BTFSS      STATUS+0, 0
	GOTO       L_main28
	MOVLW      0
	SUBWF      _water+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main64
	MOVLW      60
	SUBWF      _water+0, 0
L__main64:
	BTFSC      STATUS+0, 0
	GOTO       L_main28
L__main49:
;HAVA_DURUMU.c,104 :: 		Lcd_Out(2, 1, "AZ KAR YAGIYOR");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_HAVA_DURUMU+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HAVA_DURUMU.c,105 :: 		}
L_main28:
;HAVA_DURUMU.c,106 :: 		if((water>=60)&&(water<80)){
	MOVLW      0
	SUBWF      _water+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main65
	MOVLW      60
	SUBWF      _water+0, 0
L__main65:
	BTFSS      STATUS+0, 0
	GOTO       L_main31
	MOVLW      0
	SUBWF      _water+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main66
	MOVLW      80
	SUBWF      _water+0, 0
L__main66:
	BTFSC      STATUS+0, 0
	GOTO       L_main31
L__main48:
;HAVA_DURUMU.c,107 :: 		Lcd_Out(2, 1, "ORTA KAR YAGIYOR");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_HAVA_DURUMU+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HAVA_DURUMU.c,108 :: 		}
L_main31:
;HAVA_DURUMU.c,109 :: 		if(water>80){
	MOVF       _water+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main67
	MOVF       _water+0, 0
	SUBLW      80
L__main67:
	BTFSC      STATUS+0, 0
	GOTO       L_main32
;HAVA_DURUMU.c,110 :: 		Lcd_Out(2, 1, "SAGANAK KAR");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_HAVA_DURUMU+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HAVA_DURUMU.c,111 :: 		}
L_main32:
;HAVA_DURUMU.c,112 :: 		Delay_ms( 1000 );
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main33:
	DECFSZ     R13+0, 1
	GOTO       L_main33
	DECFSZ     R12+0, 1
	GOTO       L_main33
	DECFSZ     R11+0, 1
	GOTO       L_main33
	NOP
;HAVA_DURUMU.c,113 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HAVA_DURUMU.c,114 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HAVA_DURUMU.c,115 :: 		}
L_main24:
;HAVA_DURUMU.c,116 :: 		if((Temp<=15)&(RH>45)&(basinc<1020)){  //koþullarýn   yazýlmasý
	MOVF       _Temp+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main68
	MOVF       _Temp+0, 0
	SUBLW      15
L__main68:
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVF       _RH+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main69
	MOVF       _RH+0, 0
	SUBLW      45
L__main69:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	ANDWF      R1+0, 1
	MOVLW      3
	SUBWF      _basinc+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main70
	MOVLW      252
	SUBWF      _basinc+0, 0
L__main70:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_main34
;HAVA_DURUMU.c,117 :: 		Lcd_Out(1, 1, "YAGMUR RISKI");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr10_HAVA_DURUMU+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HAVA_DURUMU.c,118 :: 		if(water<30){
	MOVLW      0
	SUBWF      _water+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main71
	MOVLW      30
	SUBWF      _water+0, 0
L__main71:
	BTFSC      STATUS+0, 0
	GOTO       L_main35
;HAVA_DURUMU.c,119 :: 		Lcd_Out(2, 1, "YAGMUR YAGMIYOR");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr11_HAVA_DURUMU+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HAVA_DURUMU.c,120 :: 		}
L_main35:
;HAVA_DURUMU.c,121 :: 		if((water>30)&&(water<=60)){
	MOVF       _water+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main72
	MOVF       _water+0, 0
	SUBLW      30
L__main72:
	BTFSC      STATUS+0, 0
	GOTO       L_main38
	MOVF       _water+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main73
	MOVF       _water+0, 0
	SUBLW      60
L__main73:
	BTFSS      STATUS+0, 0
	GOTO       L_main38
L__main47:
;HAVA_DURUMU.c,122 :: 		Lcd_Out(2, 1, "YAGIS AZ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr12_HAVA_DURUMU+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HAVA_DURUMU.c,123 :: 		}
L_main38:
;HAVA_DURUMU.c,124 :: 		if((water>60)&&(water<=80)){
	MOVF       _water+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main74
	MOVF       _water+0, 0
	SUBLW      60
L__main74:
	BTFSC      STATUS+0, 0
	GOTO       L_main41
	MOVF       _water+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main75
	MOVF       _water+0, 0
	SUBLW      80
L__main75:
	BTFSS      STATUS+0, 0
	GOTO       L_main41
L__main46:
;HAVA_DURUMU.c,125 :: 		Lcd_Out(2, 1, "YAGIS ORTA");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr13_HAVA_DURUMU+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HAVA_DURUMU.c,126 :: 		}
L_main41:
;HAVA_DURUMU.c,127 :: 		if(water>80){
	MOVF       _water+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main76
	MOVF       _water+0, 0
	SUBLW      80
L__main76:
	BTFSC      STATUS+0, 0
	GOTO       L_main42
;HAVA_DURUMU.c,128 :: 		Lcd_Out(2, 1, "SAGANAK YAGIS");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr14_HAVA_DURUMU+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HAVA_DURUMU.c,129 :: 		}
L_main42:
;HAVA_DURUMU.c,130 :: 		Delay_ms( 1000 );
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main43:
	DECFSZ     R13+0, 1
	GOTO       L_main43
	DECFSZ     R12+0, 1
	GOTO       L_main43
	DECFSZ     R11+0, 1
	GOTO       L_main43
	NOP
;HAVA_DURUMU.c,131 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HAVA_DURUMU.c,132 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HAVA_DURUMU.c,133 :: 		}
L_main34:
;HAVA_DURUMU.c,134 :: 		if((Temp>30)&(RH>=75)&(basinc<1000)){  //koþullarýn   yazýlmasý
	MOVF       _Temp+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main77
	MOVF       _Temp+0, 0
	SUBLW      30
L__main77:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVLW      0
	SUBWF      _RH+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main78
	MOVLW      75
	SUBWF      _RH+0, 0
L__main78:
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	ANDWF      R1+0, 1
	MOVLW      3
	SUBWF      _basinc+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main79
	MOVLW      232
	SUBWF      _basinc+0, 0
L__main79:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_main44
;HAVA_DURUMU.c,135 :: 		Lcd_Out(1, 1, "SICAK HAVA");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr15_HAVA_DURUMU+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;HAVA_DURUMU.c,136 :: 		Delay_ms( 1000 );
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main45:
	DECFSZ     R13+0, 1
	GOTO       L_main45
	DECFSZ     R12+0, 1
	GOTO       L_main45
	DECFSZ     R11+0, 1
	GOTO       L_main45
	NOP
;HAVA_DURUMU.c,137 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HAVA_DURUMU.c,138 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;HAVA_DURUMU.c,139 :: 		}
L_main44:
;HAVA_DURUMU.c,140 :: 		}
L_main20:
;HAVA_DURUMU.c,141 :: 		}
L_main19:
;HAVA_DURUMU.c,142 :: 		}}
	GOTO       L_main17
L_end_main:
	GOTO       $+0
; end of _main
