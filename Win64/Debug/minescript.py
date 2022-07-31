#import the minecraft.py module from the minecraft directory
import mcpi.minecraft as minecraft
#import minecraft block module
import mcpi.block as block
#import time, so delays can be used
import time

import random as rnd

#function to round players float position to integer position
def roundVec3(vec3):
    return minecraft.Vec3(int(vec3.x), int(vec3.y), int(vec3.z))

DELAY0_SEC = 5
LOOP = mine_loop #delphi
DELAY_LOOP_SEC = mine_loopdelay #delphi

COUNTDOWN0 = mine_countdown #delphi 	
MOVE_THRSHLD = 0.2

def check_loop_condition():
    if not hasattr(check_loop_condition, "loop_countdown"):
        check_loop_condition.loop_countdown = COUNTDOWN0
        return mine_loop
    check_loop_condition.loop_countdown -= 1
    return check_loop_condition.loop_countdown > 0


def get_player_movement(playerPos, lastPlayerPos):
    #Find the difference between the player's position and the last position
    movementX = lastPlayerPos.x - playerPos.x
    movementZ = lastPlayerPos.z - playerPos.z
    movementY = lastPlayerPos.y - playerPos.y 
    return movementX, movementY, movementZ
    
def check_player_movement(movementX, movementY, movementZ):    
    return (movementX < -MOVE_THRSHLD) or (movementX > MOVE_THRSHLD) or (movementZ < -MOVE_THRSHLD) or (movementZ > MOVE_THRSHLD)

def project_until_next_block(playerPos, v):
    movementX , movementY, movementZ = v
    nextPlayerPos = playerPos
    # keep adding the movement to the players location till the next block is found
    while ((int(playerPos.x) == int(nextPlayerPos.x)) and (int(playerPos.z) == int(nextPlayerPos.z))):
        nextPlayerPos = minecraft.Vec3(nextPlayerPos.x - movementX, nextPlayerPos.y, nextPlayerPos.z - movementZ)
    return nextPlayerPos

def get_block_below_position(position):
    blockBelowPos = roundVec3(position)
    #to resolve issues with negative positions
    if blockBelowPos.z < 0: blockBelowPos.z = blockBelowPos.z - 1
    if blockBelowPos.x < 0: blockBelowPos.x = blockBelowPos.x - 1
    blockBelowPos.y = blockBelowPos.y - 1
    return blockBelowPos
    


def magic_bridge(material = block.DIAMOND_BLOCK):
    #Post a message to the minecraft chat window
    mc.postToChat("Hi, Minecraft - Auto Bridge Active")
    mc.postToChat("www.stuffaboutcode.com")

    if not hasattr(magic_bridge, "lastPlayerPos"):
    #Get the players position
        magic_bridge.lastPlayerPos = mc.player.getPos()
    lastPlayerPos = magic_bridge.lastPlayerPos
#    while (check_loop_condition()):

    #Get the players position
    playerPos = mc.player.getPos()

    movementX, movementY, movementZ = get_player_movement(playerPos, lastPlayerPos)
    #Has the player moved more than 0.2 in any horizontal (x,z) direction
    if (check_player_movement(movementX, movementY, movementZ)):        
        #Project players direction forward to the next square
        nextPlayerPos = project_until_next_block(playerPos, (movementX, 0, movementZ))
        #Is the block below the next player pos air, if so fill it in with DIAMOND
        blockBelowPos = get_block_below_position(nextPlayerPos)
        blockBelow = mc.getBlock(blockBelowPos)
        if (blockBelow == block.AIR) or (blockBelow == block.WATER):
            mc.setBlock(blockBelowPos.x, blockBelowPos.y, blockBelowPos.z, material)
        #Store players last position
        magic_bridge.lastPlayerPos = playerPos

tasks = [magic_bridge]

if __name__ == "__main__":

    time.sleep(DELAY0_SEC)

    #Connect to minecraft by creating the minecraft object
    # - minecraft needs to be running and in a game
    mc = minecraft.Minecraft.create()
    while (check_loop_condition()):
        #run stuff  here
        for task in tasks:
            task()
        #Delay
        time.sleep(DELAY_LOOP_SEC)
    else:
        mc.postToChat("Bridge is done!")