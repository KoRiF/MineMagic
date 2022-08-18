
import time

import random as rnd

DELAY0_SEC = 5
LOOP = mine_loop.Value #delphi
DELAY_LOOP_SEC = mine_loopdelay.Value #delphi
COUNTDOWN0 = mine_countdown.Value #delphi     

from delphi_module import *

handlers = MineHandler.handlers

default_handler = DefaultHandler()
handlers['TERMINATE'] = TerminateHandler()

#todo move

print(f"Message: {mine_message.Value}")

keywords = delphi_define_commands()
print(f"Supported keywords: {keywords}")

for keyword in keywords:
    handlers[keyword] = delphi_request_instance(keyword)

print(f"Registered handlers: {MineHandler.handlers}")

def check_loop_condition():
    if not hasattr(check_loop_condition, "loop_countdown"):
        check_loop_condition.loop_countdown = COUNTDOWN0
        return mine_loop.Value
    check_loop_condition.loop_countdown -= 1
    return check_loop_condition.loop_countdown > 0


while (check_loop_condition()):
    cmd = delphi_request_loop_command()
    if (cmd):
        print(f"command keyword: {cmd.KeyWord}; parameters: {cmd.Paramsline}")
        keyword = cmd.KeyWord
        cmdline = cmd.Paramsline
        
        while keyword in handlers.keys():
            print(f"current processing: {keyword} in {keywords}")
            print(f"current handler: {handlers[keyword]}")
            cmdline = handlers[keyword](cmdline)
            if (cmdline):
                keyword = cmdline.split()[0]
            else:
                keyword = cmdline            
        else:
            default_handler(cmdline)
            
        activities = MineDaemon.list_active_daemons()
        print(f"active: {activities}")
        delphi_synchronize_activities(activities)
        
        continue
    
    daemons = MineDaemon.daemons
    print(f"active daemons: {daemons}")
    
    for daemon in daemons.values():
        if daemon:
            daemon()
    #Delay
    time.sleep(DELAY_LOOP_SEC)
else:
    print("Magic is done!")    