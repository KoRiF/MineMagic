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
        

    