from operator import mul
MOVE_THRSHLD = 0.2
import mcpi.minecraft as minecraft
#function to round players float position to integer position
def roundVec3(vec3):
    return minecraft.Vec3(int(vec3.x), int(vec3.y), int(vec3.z))

class MineDynamic():
    def __init__(self, mc):
        self.mc = mc        
        self.move_thrshld_X = MOVE_THRSHLD
        self.move_thrshld_Y = MOVE_THRSHLD
        self.move_thrshld_Z = MOVE_THRSHLD
        
        self.lastPlayerPos = self.mc.player.getPos()
        self.playerPos = self.lastPlayerPos
        
    def update(self):
        self.playerPos = self.mc.player.getPos()
        self.movementX = self.lastPlayerPos.x - self.playerPos.x
        self.movementZ = self.lastPlayerPos.z - self.playerPos.z
        self.movementY = self.lastPlayerPos.y - self.playerPos.y
    
    def store(self):
        self.lastPlayerPos = self.playerPos
        
    def get_player_movement(self):
    #Find the difference between the player's position and the last position 
        return self.movementX, self.movementY, self.movementZ
        
    def check_movement(self, v=None, factorX = 1, factorY = 0, factorZ = 1):
        if v == None:
            v = self.get_player_movement()
        movementX, movementY, movementZ = v    
        return (factorX * abs(movementX) > self.move_thrshld_X) or (factorZ * abs(movementZ) > self.move_thrshld_Z) or (factorY * abs(movementY) > self.move_thrshld_Y)
        
    def project_until_next_block(self, position=None, v=None, factors=(1,0,1)):
        #if position == None:
        #    position = self.playerPos if self.playerPos else self.mc.player.getPos()
        if v == None:
            v = self.get_player_movement()
        movementX , movementY, movementZ = tuple(map(mul, v, factors))
        print(f"({movementX} , {movementY} , {movementZ})")
        nextPos = position
        # keep adding the movement to the players location till the next block is found
        while ((int(position.x) == int(nextPos.x)) and (int(position.z) == int(nextPos.z))):
            nextPos = minecraft.Vec3(nextPos.x - movementX, nextPos.y - movementY, nextPos.z - movementZ)
        return nextPos
        
    def get_block_below_position(self, position, deep = 1):
        blockBelowPos = roundVec3(position)
        #to resolve issues with negative positions
        if blockBelowPos.z < 0: blockBelowPos.z = blockBelowPos.z - 1
        if blockBelowPos.x < 0: blockBelowPos.x = blockBelowPos.x - 1
        blockBelowPos.y = blockBelowPos.y - deep
        return blockBelowPos, self.mc.getBlock(blockBelowPos)