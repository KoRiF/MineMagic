#import the minecraft.py module from the minecraft directory
import mcpi.minecraft as minecraft
#import minecraft block module
import mcpi.block as block
#import time, so delays can be used
import time

import random as rnd

DELAY0_SEC = 5
LOOP = mine_loop.Value #delphi
DELAY_LOOP_SEC = mine_loopdelay.Value #delphi

COUNTDOWN0 = mine_countdown.Value #delphi 	
MOVE_THRSHLD = 0.2

def check_loop_condition():
    if not hasattr(check_loop_condition, "loop_countdown"):
        check_loop_condition.loop_countdown = COUNTDOWN0
        return mine_loop.Value
    check_loop_condition.loop_countdown -= 1
    return check_loop_condition.loop_countdown > 0


mc = minecraft.Minecraft.create()
while (check_loop_condition()):
    mc.postToChat(mine_message.Value)
    #Delay
    time.sleep(DELAY_LOOP_SEC)
else:
    mc.postToChat("Magic is done!")