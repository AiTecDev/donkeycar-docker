
from donkeycar.parts.controller import Joystick, JoystickController


class MyJoystick(Joystick):
    #An interface to a physical joystick available at /dev/input/js0
    def __init__(self, *args, **kwargs):
        super(MyJoystick, self).__init__(*args, **kwargs)

            
        self.button_names = {
            0x130 : 'A',
            0x131 : 'B',
            0x134 : 'Y',
            0x133 : 'X',
            0x137 : 'UR',
            0x139 : 'BR',
            0x136 : 'UL',
            0x138 : 'BL',
            0x13a : 'select',
            0x13b : 'start',
        }


        self.axis_names = {
            0x1 : 'LA',
            0x11 : 'controlL',
        }



class MyJoystickController(JoystickController):
    #A Controller object that maps inputs to actions
    def __init__(self, *args, **kwargs):
        super(MyJoystickController, self).__init__(*args, **kwargs)


    def init_js(self):
        #attempt to init joystick
        try:
            self.js = MyJoystick(self.dev_fn)
            self.js.init()
        except FileNotFoundError:
            print(self.dev_fn, "not found.")
            self.js = None
        return self.js is not None


    def init_trigger_maps(self):
        #init set of mapping from buttons to function calls
            
        self.button_down_trigger_map = {
            'select' : self.decrease_max_throttle,
            'X' : self.toggle_mode,
            'A' : self.emergency_stop,
            'UL' : self.increase_max_throttle,
            'Y' : self.erase_last_N_records,
            'B' : self.toggle_manual_recording,
        }


        self.axis_trigger_map = {
            'controlL' : self.set_steering,
            'LA' : self.set_throttle,
        }


