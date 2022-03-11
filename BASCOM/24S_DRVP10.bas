'DRV16X64



$version 0 , 1 , 165
$regfile = "M8Adef.dat"
$crystal = 11059200
$baud = 4800


$hwstack = 80
$swstack = 80
$framesize = 80


'Declaracion de constantes
Const Nummatriz = 1                                         'Una matriz esunmodulo P10 de 16x32
Const Longbuf = Nummatriz * 64
Const Longdat = Nummatriz * 32
Const Longdat_mas_uno = Longdat + 1
Const Longbuf_mas_uno = Longbuf + 1
Const Numtxser = Longbuf / 4
Const Numtxser_2 = Numtxser / 2


'Configuracion de entradas/salidas
Led1 Alias Portb.0                                          'LED ROJO
Config Led1 = Output

'DRIVER P10
Sela Alias Portc.0
Config Sela = Output

Selb Alias Portc.1
Config Selb = Output

Sck Alias Portc.2
Config Sck = Output


Datos Alias Portc.3
Config Datos = Output


Lena Alias Portb.2
Config Lena = Output

Oena Alias Portb.1
Config Oena = Output
Set Oena


'Lena2 Alias Portc.5
'Config Lena2 = Output

'Oena2 Alias Portc.4
'Config Oena2 = Output
'Set Oena2

'Pinbug Alias Portb.3
'Config Pinbug = Output

'SW ENTRA ON

'Swsaleon Alias Pind.2
'Config Swsaleon = Input
'Set Portd.2

'Swentraon Alias Pind.7
'Config Swentraon = Input

'Set Portd.7


'Rele1 Alias Portd.3
'Config Rele1 = Output

'Rele2 Alias Portd.4
'Config Rele2 = Output

'Reset Rele1
'Reset Rele2

'Configuración de Interrupciones
'TIMER0
Config Timer0 = Timer , Prescale = 1024                     'Ints a 100Hz si Timer0=184
On Timer0 Int_timer0
'Enable Timer0
Start Timer0


' Puerto serial 1
Open "com1:" For Binary As #1
On Urxc At_ser1
Enable Urxc

Enable Interrupts


'*******************************************************************************
'* Archivos incluidos
'*******************************************************************************
$include "24S_DRVP10_archivos.bas"



'Programa principal
   Dato8 = &H00
   For Kk = 1 To Numtxser
      Shiftout Datos , Sck , Dato8 , 1
   Next

   Set Lena
   Reset Lena


Call Inivar()

Print #1 , "MAIN"

Do

   If Sernew = 1 Then                                       'DATOS SERIAL 1
      Reset Sernew
      Print #1 , "SER1=" ; Serproc
      Call Procser()
   End If

   If New24seg = 1 Then
      Reset New24seg
      Print #1 , "TX24=" ; Serproc
      If Len(serproc) = 4 Then
         Tmpstr2 = Mid(serproc , 4 , 1)
         Unidad = Val(tmpstr2)
         Print #1 , Unidad

         Call Gendig(unidad , 2)
         Tmpstr2 = Mid(serproc , 3 , 1)
         Decena = Val(tmpstr2)
         print #1, decena
         If Decena = 0 Then Decena = 10
         Call Gendig(decena , 1)
      End If
   End If


Loop