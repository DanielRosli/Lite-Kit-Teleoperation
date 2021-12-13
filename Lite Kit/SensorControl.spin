{
  Project: EE-6 Assignment 6
  Platform: Parallax Project USB Board
  Revision: 1.1
  Author: Muhammad Daniel bin Rosli
  Date: 04/11/21
  Log:
        Date: 04/11/21  Added Movement functions
        Date: 08/11/21  Added Core functions
        Date: 21/11/21  Combined reading of Ultra and ToF into one function
        Date: 21/11/21  Removed CON data for MCU to allow central control in MyLiteKit
        Date: 28/11/21  Moved Init from readSensor to Start
}

CON
  'Front US1
  ultra1SCL = 6
  ultra1SDA = 7
  'Back US2
  ultra2SCL = 8
  ultra2SDA = 9

  'Front TOF1
  tof1SCL = 0
  tof1SDA = 1
  tof1RST = 14

  'Back TOF2
  tof2SCL = 2
  tof2SDA = 3
  tof2RST = 15

  tofAdd = $29    'Address of ToF


VAR 'Global Variables

  long sensorID, _Ms_001
  long sensorStack[128]


OBJ

  Term   : "FullDuplexSerial"
  Ultra  : "EE-7_Ultra.spin"                         'Sz 2 array, 2 diff obj with same functions
  ToF[2] : "EE-7_Tof.spin"

PUB Init


  ToF[0].Init(tof1SCL, tof1SDA, tof1RST)                '(SCL, SDA, ResetPin)
  ToF[0].ChipReset(1)
  Pause(1000)                                           'Let reset pin stabilise
  ToF[0].FreshReset(tofAdd)
  ToF[0].MandatoryLoad(tofAdd)
  ToF[0].RecommendedLoad(tofAdd)
  Tof[0].FreshReset(tofAdd)


  ToF[1].Init(tof2SCL, tof2SDA, tof2RST)
  ToF[1].ChipReset(1)
  Pause(1000)
  ToF[1].FreshReset(tofAdd)
  ToF[1].MandatoryLoad(tofAdd)
  ToF[1].RecommendedLoad(tofAdd)
  Tof[1].FreshReset(tofAdd)

  Ultra.Init(ultra1SCL, ultra1SDA, 0)                   'Initialise and starts the sensors
  Ultra.Init(ultra2SCL, ultra2SDA, 1)

 return

PUB Start(MsVal, ultra1Add, ultra2Add, tof1Add, tof2Add)

  _Ms_001 := MsVal

  StopCore

  sensorID := cognew(readSensor(ultra1Add, ultra2Add, tof1Add, tof2Add), @sensorStack)

  return


PUB StopCore

  if sensorID
   cogstop(sensorID~)

  return

PUB readSensor(ultra1Add, ultra2Add, tof1Add, tof2Add)

  Init

  repeat
   long[ultra1Add] := Ultra.readSensor(0)                         'Val shown in cm
   long[ultra2Add] := Ultra.readSensor(1)
   long[tof1Add] := ToF[0].GetSingleRange(tofAdd)
   long[tof2Add] := ToF[1].GetSingleRange(tofAdd)
   Pause(50)


PRI Pause(ms) | t
  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _Ms_001)
  return
