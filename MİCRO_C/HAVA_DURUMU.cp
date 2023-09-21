#line 1 "C:/Users/emrek/OneDrive/Masaüstü/EMRE_KIZAK_13018463668/MÝCRO_C/HAVA_DURUMU.c"
sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;

sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD3_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

unsigned char Check, T_byte1, T_byte2,
 RH_byte1, RH_byte2, Ch ;
 unsigned Temp, RH, Sum,water,basinc ;
 char basinc2[10];
 char water2[10];
void StartSignal(){
 TRISD.B0 = 0;
 PORTD.B0 = 0;
 delay_ms(18);
 PORTD.B0 = 1;
 delay_us(30);
 TRISD.B0 = 1;
 }
 void CheckResponse(){
 Check = 0;
 delay_us(40);
 if (PORTD.B0 == 0){
 delay_us(80);
 if (PORTD.B0 == 1)
 Check = 1; delay_us(40);
 }
 }
 char ReadData(){
 char i, j;
 for(j = 0; j < 8; j++){
 while(!PORTD.B0);
 delay_us(30);
 if(PORTD.B0 == 0)
 i&= ~(1<<(7 - j));
 else {
 i|= (1 << (7 - j));
 while(PORTD.B0);
 }
 }
 return i;
 }

void main() {
 TRISB.B0 = 0;
 TRISD.B0 = 0;
 ANSEL=0x09;
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Init();
 while(1){
 StartSignal();
 CheckResponse();
 if(Check == 1){
 RH_byte1 = ReadData();
 RH_byte2 = ReadData();
 T_byte1 = ReadData();
 T_byte2 = ReadData();
 Sum = ReadData();
 if(Sum == ((RH_byte1+RH_byte2+T_byte1+T_byte2) & 0XFF)){
 Temp= T_byte1;
 RH = RH_byte1;
 water = ADC_Read(3)/10;
 basinc = ADC_Read(0)*10 / 8.39215686;
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1, 1, "Sicaklik: ");
 Lcd_Out(2, 1, "Nem: ");
 LCD_Chr(1, 12, 48 + ((Temp / 10) % 10));
 LCD_Chr(1, 13, 48 + (Temp % 10));
 LCD_Chr(2, 12, 48 + ((RH / 10) % 10));
 LCD_Chr(2, 13, 48 + (RH % 10));
 Delay_ms( 1000 );
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, "Su Seviyesi: ");
 LCD_Chr(1, 14, 48 + ((water / 100) % 10));
 LCD_Chr(1, 15, 48 + ((water / 10) % 10));
 LCD_Chr(1, 16, 48 + (water % 10));
 Delay_ms( 1000 );
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, "Basinc: ");
 LCD_Chr(1, 13, 48 + ((basinc / 1000) % 10));
 LCD_Chr(1, 14, 48 + ((basinc / 100) % 10));
 LCD_Chr(1, 15, 48 + ((basinc / 10) % 10));
 LCD_Chr(1, 16, 48 + (basinc % 10));
 Delay_ms( 1000 );
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 if((Temp<=5)&(RH<=20)&(basinc>1020)){
 Lcd_Out(1, 1, "KAR RISKI");
 if(water<30){
 Lcd_Out(2, 1, "KAR YAGMIYOR");
 }
 if((water>=30)&&(water<60)){
 Lcd_Out(2, 1, "AZ KAR YAGIYOR");
 }
 if((water>=60)&&(water<80)){
 Lcd_Out(2, 1, "ORTA KAR YAGIYOR");
 }
 if(water>80){
 Lcd_Out(2, 1, "SAGANAK KAR");
 }
 Delay_ms( 1000 );
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 }
 if((Temp<=15)&(RH>45)&(basinc<1020)){
 Lcd_Out(1, 1, "YAGMUR RISKI");
 if(water<30){
 Lcd_Out(2, 1, "YAGMUR YAGMIYOR");
 }
 if((water>30)&&(water<=60)){
 Lcd_Out(2, 1, "YAGIS AZ");
 }
 if((water>60)&&(water<=80)){
 Lcd_Out(2, 1, "YAGIS ORTA");
 }
 if(water>80){
 Lcd_Out(2, 1, "SAGANAK YAGIS");
 }
 Delay_ms( 1000 );
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 }
 if((Temp>30)&(RH>=75)&(basinc<1000)){
 Lcd_Out(1, 1, "SICAK HAVA");
 Delay_ms( 1000 );
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 }
 }
 }
}}
