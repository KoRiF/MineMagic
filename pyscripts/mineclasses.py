class MineTask():
    def __init__(self, mc):
        self.mc = mc
    def do(self):
        pass
    def __call__(self):
        do()

class MineDaemon(MineTask):
    daemons = {}
    @classmethod
    def list_active_daemons(cls):
        keywords = ''
        for keyword, daemon in cls.daemons.items():
            if daemon:
                keywords += keyword + ' '
        print(f"active keywords: {keywords}")        
        return keywords.strip()
        
    def __init__(self, mc):
        super().__init__(mc)
        self.params = []
        self.live = True
    def step(self):
        pass
    def terminate(self):
        self.live = False
        pass
    def __call__(self):
        self.step()
        return self if self.live else None
        
class MineHandler():
    handlers = {}
    def __init__(self):
        self._keyword = ""
        #handlers[self._keyword] = self
        pass        
    def handle(self, params):
        pass        
    def __call__(self, commandline):
        print(f"handle commandline: {commandline}")
        params = commandline.split()
        params = self.handle(params)
        commandline = " ".join(params) if params else "" 
        return commandline
    
    

class DefaultHandler(MineHandler):
    def __init__(self):
        self._keyword = "DEFAULT"
        
        pass        
    def handle(self, params):
        print(f"default handler params:  {params}")
        return [""]

class TerminateHandler(MineHandler):
    def __init__(self):
        self._keyword = "TERMINATE"
    def handle(self, params):
        daemons = MineDaemon.daemons
        ix = params.index(self._keyword) if self._keyword in params else -1
        if ix > 0: 
            ix = 0
        else:
            ix = ix + 1
        print(f"ix={ix}")    
        if len(params) > ix:
            nickname = params[ix]
            if nickname in daemons.keys():
                print(f"daemon pop {nickname}")
                daemon = daemons.pop(nickname)
                if daemon:
                    print(f"Terminate daemon {nickname}...")
                    daemon.terminate()
            params.remove(nickname)
        return [""]
            
class DaemonHandler(MineHandler):
    def create_daemon(self, params):
        pass
    def update_daemon(self, daemon, params):
        if (daemon):
            daemon.params = params
    def handle(self, params):
        daemons = MineDaemon.daemons
        keyword = self._keyword        
        if "TERMINATE" in params:
            if (params[0] == "TERMINATE"):
                #if keyword in daemons.keys():
                    #daemon.terminate()
                return["TERMINATE", self._keyword]            
        if keyword in daemons.keys():
            daemon = daemons[keyword]
            self.update_daemon(daemon, params)
        else:
            daemon = self.create_daemon(params)
            print(f"Created daemon {daemon}")
            daemons[keyword] = daemon
        return params if daemon else [""] 