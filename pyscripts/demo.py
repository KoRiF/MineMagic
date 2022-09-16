from mineclasses import *
from minecontrol0 import MineController

class MineDemo(MineDaemon):    
    def __init__(self, mc):
        super().__init__(mc)
        self.mc = mc.controller()
        print(self.mc)
        #self.mc.postToChat("Hi! Auto Demo Active")
    def step(self):
            print("Do Bridge Step!")
class DemoHandler(DaemonHandler):
    def __init__(self):
        self._keyword = "DEMO"
        MineHandler.handlers[self._keyword] = self
        pass
    def create_daemon(self, params):
        print(f"Create daemon with params: {params}")
        demo_daemon = MineDemo(MineController())
        self.update_daemon(demo_daemon, params)
        return demo_daemon
    def handle(self, params):
        print("Demo handler...")
        return super().handle(params)