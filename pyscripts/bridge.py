class MineBridge(MineDaemon):
    def __init__(self, mc):
        super().__init__(mc)
        self.dynamic = MineDynamic(self.mc)
        self.mc.postToChat("Hi, Minecraft - Auto Bridge Active")
        self.mc.postToChat("www.stuffaboutcode.com")        
    
    def build_next_bridge_block(self, material=block.DIAMOND_BLOCK):
        #Has the player moved more than 0.2 in any horizontal (x,z) direction
        if (check_movement()):
            #Project players direction forward to the next square
            nextPlayerPos = project_until_next_block(playerPos)
            blockBelowPos, blockBelow = get_block_below_position(nextPlayerPos)
            if (blockBelow == block.AIR) or (blockBelow == block.WATER):
                mc.setBlock(blockBelowPos.x, blockBelowPos.y, blockBelowPos.z, material)

    def do_step(self):
        self.dynamic.update()
        self.build_next_bridge_block()
        self.dynamic.store()