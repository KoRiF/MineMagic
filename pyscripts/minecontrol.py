class MineController():
    mc = None
    dynamic = None
    @classmethod
    def controller(cls):
        return cls
    @classmethod
    def dynamic(cls):
        return cls.dynamic
    def postToChat(self, message):
        print(message)
        
    
class MinecraftController(MineController):
    #import the minecraft.py module from the minecraft directory
    import mcpi.minecraft as minecraft
    #import minecraft block module
    import mcpi.block as block
    #import time, so delays can be used
    mc = minecraft.Minecraft.create()
    dynamic = MineDynamic(mc)
    @classmethod
    def controller(cls):
        return cls.mc    
    
#class StubController(MineController):
    