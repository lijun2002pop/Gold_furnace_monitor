
import sys
import traceback
import threading

def dump_traces():
    print('py-common-utils dump_traces...')
    for threadId, stack in sys._current_frames().items():
        print(str(threadId) + str(traceback.extract_stack(stack)))
    actives = threading.enumerate()
    print('len-%s' % str(len(actives)))
    for item in actives:
        print(item)
