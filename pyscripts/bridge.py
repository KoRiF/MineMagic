class MineBridge(MineDaemon):
    def __init__(self, mc):
        super().__init__(mc)
        self.dynamic = mc.dynamic()
        self.mc.postToChat("Hi, Minecraft - Auto Bridge Active")
        self.mc.postToChat("www.stuffaboutcode.com")
        self.material = None
    
    def build_next_bridge_block(self, material): #=block.DIAMOND_BLOCK
        #Has the player moved more than 0.2 in any horizontal (x,z) direction
        if (self.material):
            material = self.material #todo debug&rewrite defaults
        if (self.dynamic.check_movement()):
            #Project players direction forward to the next square
            nextPlayerPos = self.dynamic.project_until_next_block(playerPos)
            blockBelowPos, blockBelow = get_block_below_position(nextPlayerPos)
            if (blockBelow == block.AIR) or (blockBelow == block.WATER):
                mc.setBlock(blockBelowPos.x, blockBelowPos.y, blockBelowPos.z, material)
    def parse_material(material_name):
        materials = {}#block_materials
        if material_name in materials.keys():
            return materials[material_name]
        else:
            return None
    def step(self):
        if (self.dynamic):
            #self.dynamic.update()
            #self.build_next_bridge_block()
            #self.dynamic.store()
            pass
        else:
            print("Do Bridge Step!")
class BridgeHandler(DaemonHandler):
    def __init__(self):
        self._keyword = "BRIDGE"
        MineHandler.handlers[self._keyword] = self
        pass
    def create_daemon(self, params):
        print(f"Create daemon with params: {params}")
        bridge_daemon = MineBridge(MineController())
        self.update_daemon(bridge_daemon, params)
        return bridge_daemon
    def update_daemon(self, daemon, params):
        keyword_block = "BLOCK"
        pos_block = params.index(keyword_block) if keyword_block in params else len(params)
        keyword_material = "MATERIAL"
        pos_material = params.index(keyword_material) if keyword_material in params else 0
        if pos_block > pos_material :
            pp = params[pos_block:pos_material]
            block_material = " ".join(pp)
            print(block_material)
            daemon.material = daemon.parse_material()
            print(daemon.material)
            if daemon.material:
                for p in pp:
                    params.remove(p)
    def handle(self, params):
        print("Bridge handler...")
        return super().handle(params)