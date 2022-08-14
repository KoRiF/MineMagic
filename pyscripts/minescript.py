
import time

import random as rnd

DELAY0_SEC = 5
LOOP = mine_loop.Value #delphi
DELAY_LOOP_SEC = mine_loopdelay.Value #delphi

COUNTDOWN0 = mine_countdown.Value #delphi 	


from delphi_module import *

keywords = PythonEvent0_define_commands()
print(keywords)

daemons = dict.fromkeys(keywords) #[MineBridge()]

print(daemons)

def add_daemon(nickname, daemon):
    daemons[nickname] = daemon

def remove_daemon(nickname):
    daemons[nickname] = None

def list_active_daemons():
    keywords = ''
    for keyword, daemon in daemons.items():
        if daemon:
            keywords += keyword + ' '
        print(keywords)        
    return keywords.strip()        


def check_loop_condition():
    if not hasattr(check_loop_condition, "loop_countdown"):
        check_loop_condition.loop_countdown = COUNTDOWN0
        return mine_loop.Value
    check_loop_condition.loop_countdown -= 1
    return check_loop_condition.loop_countdown > 0



while (check_loop_condition()):
    cmd = PythonEvent1_request_loop_command()
    if (cmd):
        print(cmd.KeyWord)
        new_daemon = PythonEvent2_request_instance(cmd.KeyWord)
        daemons[cmd.KeyWord] = new_daemon
        
        activities = list_active_daemons()
        print(f"active: {activities}")
        PythonEvent3_synchronize_activities(activities)
        continue
    
    print(mine_message.Value)
    print(daemons)
    
    for daemon in daemons.values():
        if daemon:
            daemon()
    #Delay
    time.sleep(DELAY_LOOP_SEC)
else:
    print("Magic is done!")