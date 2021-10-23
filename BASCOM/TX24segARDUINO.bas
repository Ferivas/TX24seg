'Main.bas
'
'                 WATCHING Soluciones Tecnológicas
'                    Fernando Vásquez - 25.06.15
'
' Programa para almacenar los datos que se reciben por el puerto serial a una
' memoria SD
'


$regfile = "m328Pdef.dat"                                   ' used micro
$crystal = 16000000                                         ' used xtal
$baud = 4800                                                ' baud rate we want
$hwstack = 80
$swstack = 80
$framesize = 80

$projecttime = 32
$version 0 , 0 , 25



'Declaracion de constantes



'Configuracion de entradas/salidas
Led1 Alias Portb.5                                          'LED ROJO
Config Led1 = Output

Chi Alias Portb.1
Config Chi = Output

Ptt Alias Pind.2
Ptt1 Alias Pind.3
P14 Alias Pind.4

Config P14 = Input
Config Ptt = Input
Config Ptt1 = Input

Set Portd.2
Set Portd.3
Set Portd.4



'Configuración de Interrupciones
'TIMER0
Config Timer0 = Timer , Prescale = 64                       'Ints a 100Hz si Timer0=184
On Timer0 Int_timer0
Enable Timer0
Start Timer0

'TIMER0
Config Timer1 = Timer , Prescale = 1024                     'Ints a 100Hz si Timer0=184
On Timer1 Int_timer1
Enable Timer1
Start Timer1

' Puerto serial 1
Open "com1:" For Binary As #1
On Urxc At_ser1
Enable Urxc

Config Int0 = Falling
On Int0 Int0_int


Config Int1 = Falling
On Int1 Int1_int

Enable Int0
Enable Int1

Enable Interrupts


'*******************************************************************************
'* Archivos incluidos
'*******************************************************************************
$include "TX24segARDUINO_archivos.bas"



'Programa principal

Call Inivar()


Do

   If Sernew = 1 Then                                       'DATOS SERIAL 1
      Reset Sernew
      Print #1 , "SER1=" ; Serproc
      Call Procser()
   End If
   If Ini_count = 1 Then
      If Newseg = 1 Then
         Decr Cntr_seg
         Decena = Cntr_seg / 10
         Unidad = Decena * 10
         Unidad = Cntr_seg - Unidad
         Call Disp_buffer(cntr_seg)
         If Cntr_seg = 0 Then
            Reset Ini_count
            Waitms 500
            Print #1, "$SP"
            Print #1 , "$SP"
            Print #1 , "$SP"
            Print #1 , "$SP"
            Set Chi
            Wait 1
            Reset Chi
            Cntr_seg = Top_value
            Topled = 488
            Decena = Cntr_seg / 10
            Unidad = Decena * 10
            Unidad = Cntr_seg - Unidad
            Call Disp_buffer(cntr_seg)
         End If
         Reset Newseg
      End If
   Else
'      If Initx = 1 Then
'         Reset Initx
      If Newseg = 1 Then
         Reset Newseg
         Call Disp_buffer(cntr_seg)
      End If
'      End If
   End If


   If Ini_test1 = 1 Then
      Reset Ini_test1
      Waitms 40
      If Ptt1 = 0 Then
         Print #1 , "I1"
         Cntr_seg = Top_value
         Decena = Cntr_seg / 10
         Unidad = Decena * 10
         Unidad = Cntr_seg - Unidad
         Call Disp_buffer(cntr_seg)
         'Cntr_ms = 0
     End If
   End If

   If Ini_test = 1 Then
      Reset Ini_test
      Waitms 40
      If Ptt = 0 Then
         Print #1 , "I0"
         Ini_count = Ini_count Xor 1
         If Ini_count = 1 Then
            Topled = 144
         Else
            Topled = 488
         End If
         Cntr_led = 0
'         Incr Cntrptt
'         Lcd Cntrptt ; " "
      End If
   End If

   If P14 = 0 Then
      Waitms 40
      If P14 = 0 Then
         Cntr_seg = 14
         Decena = Cntr_seg / 10
         Unidad = Decena * 10
         Unidad = Cntr_seg - Unidad
         Call Disp_buffer(cntr_seg)
         'Cntr_ms = 0
      End If
   End If

Loop