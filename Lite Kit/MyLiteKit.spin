{
  Project: EE-6 Assignment 8
  Platform: Parallax Project USB Board
  Revision: 1.1
  Author: Muhammad Daniel bin Rosli
  Date: 04/11/21
  Log:
        Date: 04/11/21  Added Movement functions
        Date: 08/11/21  Added Core functions
        Date: 20/11/21  Include ultra and tof global variables. cognew for sense objects
        Date: 21/11/21  Changed order of functions and functions used based off changes in MotorControl and SensorControl
        Date: 21/11/21  Added functions to possibly make use of CommControl
}


CON
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

  'Creating a pause
  _ConClkFreq = ((_clkmode - xtal1) >> 6 * _xinfreq)
  _Ms_001  = _ConClkFreq / 1_000

  Forward = 1
  Reverse = 2
  Left = 3
  Right = 4
  Stop = 5

  ultraSafe = 300
  tofSafe = 190

  {
  commStart = $7A
  commForward = $01
  commReverse = $02
  commLeft = $03
  commRight = $04
  commStopAll = $AA
  }

VAR 'Global Variables

   long ultra1Val, ultra2Val, tof1Val, tof2Val, commVal
   long motion, decision

OBJ

  Sensor  : "SensorControl.spin"
  Move   : "MotorControl.spin"
  Comm   : "CommControl.spin"

PUB Main

  'Use of Comm
  Sensor.Start(_Ms_001, @ultra1Val, @ultra2Val, @tof1Val, @tof2Val)
  Move.Start(_Ms_001, @motion)
  Comm.Start(_Ms_001, @decision)


  repeat
   case decision
    Forward:
     if ultra1Val > ultraSafe AND tof1Val < tofSafe
        motion := Forward
     elseif ultra1Val < ultraSafe OR tof1Val > tofSafe
         motion := Stop
    Reverse:
     if ultra2Val > ultraSafe AND tof2Val < tofSafe
      motion := Reverse
     elseif ultra2Val < ultraSafe OR tof2Val > tofSafe
       motion := Stop
    Left:
     motion := Left

    Right:
     motion := Right

    Stop:
     motion := Stop
   Pause(50)

PRI Pause(ms) | t
  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _Ms_001)
  return