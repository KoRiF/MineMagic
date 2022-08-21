from mineclasses import *
from minecontrol import *
import mcpi.block as block

from minematerials import block_materials
class MineBridge(MineDaemon):    
    def __init__(self, mc):
        super().__init__(mc)
        self.mc = mc.controller()
        print(self.mc)
        self.dynamic = mc.dynamic
        print(self.dynamic)
        self.mc.postToChat("Hi, Minecraft - Auto Bridge Active")
        self.mc.postToChat("www.stuffaboutcode.com")
        self.material = block.DIAMOND_BLOCK

    def build_next_bridge_block(self, material=None): #=block.DIAMOND_BLOCK
        if (not material):
            material = self.material #todo debug&rewrite defaults
        #Has the player moved more than 0.2 in any horizontal (x,z) direction
        if (self.dynamic.check_movement()):
            #Project players direction forward to the next square
            nextPlayerPos = self.dynamic.project_until_next_block(self.dynamic.playerPos)
            blockBelowPos, blockBelow = self.dynamic.get_block_below_position(nextPlayerPos)
            if (blockBelow == block.AIR) or (blockBelow == block.WATER):
                self.mc.postToChat(f"Build block {material}")
                self.mc.setBlock(blockBelowPos.x, blockBelowPos.y, blockBelowPos.z, material)
    def parse_material(self, material_name):
        print(f"parsing of {material_name}...")
        materials = block_materials
        if material_name in materials.keys():
            return materials[material_name]
        else:
            print(materials.keys()) 
            return None
    def step(self):
        if (self.dynamic):
            import mcpi.block as block
            #print(self.dynamic)
            self.dynamic.update()
            self.build_next_bridge_block()#block.DIAMOND_BLOCK block.NETHER_REACTOR_CORE
            self.dynamic.store()
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
        bridge_daemon = MineBridge(MinecraftController())
        self.update_daemon(bridge_daemon, params)
        return bridge_daemon
    def update_daemon(self, daemon, params):
        keyword_block = "BLOCK"
        pos_block = params.index(keyword_block) if keyword_block in params else len(params)
        keyword_material = "MATERIAL"
        pos_material = params.index(keyword_material) if keyword_material in params else len(params)#0
        if pos_block < pos_material:
            pos_material = pos_block + 1
        pp = params[0:pos_material]
        block_material = " ".join(pp)
        #print(block_material)
        parsed_material = daemon.parse_material(block_material)
        print(parsed_material)
        if parsed_material: 
            daemon.material = parsed_material
            for p in pp:
                params.remove(p)
    def handle(self, params):
        print("Bridge handler...")
        return super().handle(params)