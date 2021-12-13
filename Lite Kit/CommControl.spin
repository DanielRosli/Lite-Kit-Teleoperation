{
  Project: EE-6 Assignment 6
  Platform: Parallax Project USB Board
  Revision: 1.1
  Author: Muhammad Daniel bin Rosli
  Date: 21/11/21
  Log:
        Date: 21/11/21  Added CommControl CON and CommControl function provided in EE8 lesson
        Date: 21/11/21  Changed rxVal to be an input variable rather than function variable, also added MotorControl and SensorControl OBJ
        Date: 24/11/21  _Ms_001 val now in Start, Start also runs Command
}

CON

  commRxPin = 18
  commTxPin = 19
  commBaud = 9600

  commStart = $7A
  commForward = $01
  commReverse = $02
  commLeft = $03
  commRight = $04
  commStopAll = $AA

VAR
  long  _Ms_001, commID
  long  commStack[128]

OBJ
  Term      : "FullDuplexSerial.spin"
  Move      : "MotorControl.spin"
  Sense     : "SensorControl.spin"

PUB Start(MsVal, movAdd)

  _Ms_001 := MsVal

  cognew(Command(movAdd), @commStack)


PUB Command(movAdd)  | rxVal

  Term.Start(commRxPin, commTxPin, 0, commBaud)
  Pause(3000)


  repeat
   rxVal := Term.RxCheck
   if rxVal == commStart
    repeat
     rxVal := Term.RxCheck
     case rxVal
      commForward:
       long[movAdd] := 1
      commReverse:
       long[movAdd] := 2
      commLeft:
       long[movAdd] := 3
      commRight:
       long[movAdd] := 4
      commStopAll:
       long[movAdd] := 5


PRI Pause(ms) | t
  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _Ms_001)
  return
