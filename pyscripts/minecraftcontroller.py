from minecontrol import MineController        
from minedynamic import *
class MinecraftController(MineController):
    #import the minecraft.py module from the minecraft directory
    import mcpi.minecraft as minecraft
    #import minecraft block module
    import mcpi.block as block    
    mc = minecraft.Minecraft.create()
    dynamic = MineDynamic(mc)
    @classmethod
    def controller(cls):
        return cls.mc    
