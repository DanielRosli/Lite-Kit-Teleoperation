{
  Project: EE-7 Assignment 7
  Platform: Parallax Project USB Board
  Revision: 1.1
  Author: Muhammad Daniel bin Rosli
  Date: 10/11/21
  Log:
        Date: 10/11/21  Added Movement functions
        Date: 21/11/21  Removed CON data for MCU to allow central control in MyLiteKit
        Date: 28/11/21
}

CON

  'Pins for Motor
  motor1 = 10
  motor2 = 11
  motor3 = 12
  motor4 = 13

  'Motor setting for no movement
  motor1Zero = 1480
  motor2Zero = 1480
  motor3Zero = 1480
  motor4Zero = 1480

VAR 'Global Variables

  long  motorStack[64]
  long  motorID, _Ms_001

OBJ
  Motors : "Servo8Fast_vZ2"
  Term   : "FullDuplexSerial"


PUB Start(MsVal, moveAdd)
  _Ms_001 := MsVal

  StopCore

  motorID := cognew(Motion(moveAdd), @motorStack)


PUB Motion(direction)

  Init

 repeat
  case long[direction]
   1:
    Forward
   2:
    Reverse
   3:
    Left
   4:
    Right
   5:
    StopAllMotors
  Pause(100)

PUB Init

  Motors.Init
  Motors.AddFastPin(motor1)
  Motors.AddFastPin(motor2)
  Motors.AddFastPin(motor3)
  Motors.AddFastPin(motor4)
  Motors.Start
  Pause(1000)

PUB StopCore

  if motorID
   cogstop(motorID~)


PUB StopAllMotors

  Motors.Set(motor1, motor1Zero)
  Motors.Set(motor2, motor2Zero)
  Motors.Set(motor3, motor3Zero)
  Motors.Set(motor4, motor4Zero)


PUB Reverse

    Motors.Set(motor1, motor1Zero + 150)
    Motors.Set(motor2, motor2Zero + 150)
    Motors.Set(motor3, motor3Zero + 150)
    Motors.Set(motor4, motor4Zero + 150)


PUB Forward

    Motors.Set(motor1, motor1Zero - 150)
    Motors.Set(motor2, motor2Zero - 150)
    Motors.Set(motor3, motor3Zero - 150)
    Motors.Set(motor4, motor4Zero - 150)


PUB Right

     Motors.Set(motor2, motor2Zero - 150)
     Motors.Set(motor4, motor4Zero - 150)
     Motors.Set(motor1, motor1Zero + 150)
     Motors.Set(motor3, motor3Zero + 150)


PUB Left

     Motors.Set(motor2, motor2Zero + 150)
     Motors.Set(motor4, motor4Zero + 150)
     Motors.Set(motor1, motor1Zero - 150)
     Motors.Set(motor3, motor3Zero - 150)


PRI Pause(ms) | t
  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _Ms_001)
  return
