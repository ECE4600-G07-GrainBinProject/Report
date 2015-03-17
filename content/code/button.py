import RPi.GPIO as GPIO
from time import sleep
from sys import exit
import os

# to use Raspberry Pi board pin numbers
GPIO.setmode(GPIO.BCM)

# set up the GPIO channels - one input and one output
GPIO.setup(17, GPIO.IN) #push button
GPIO.setup(23, GPIO.OUT) #led

# input from pin 11
#input_value = GPIO.input(17)

try:
  while True:
    # output to pin 12
    if(GPIO.input(17) == True):
      #print("ON!")
      GPIO.output(23, True)
      sleep(0.5)
      GPIO.output(23, False)
      sleep(0.5)
      os.system("sh gbintest.sh 18 18 45 50")
     #else:
      #print("OFF!")
      
finally: GPIO.cleanup()
