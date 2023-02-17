import sdl2
from pythonfmu import Fmi2Causality, Fmi2Variability, Fmi2Slave, Real, String, Boolean
import time


def id_finder(joystick_name):
    id_number = -1
    for i in range(6):
        sdl2.SDL_JoystickEventState(sdl2.SDL_DISABLE)
        joystick = sdl2.SDL_JoystickOpen(i)
        if sdl2.SDL_JoystickName(joystick) == joystick_name:
            id_number = i
            break
    return id_number


def encoder(name):
    true_name = name.encode()
    return true_name


class GenericJoystick(Fmi2Slave):
    author = "AVL"
    description = "Generic FMU Model"

    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        self.is_running = True
        self.av = 0
        self.bv = 0

        self.time_step = 0.01
        self.val = 0

        self.torque_lst = []

        # Wheel Name
        self.joystick_name = " "
        self.register_variable(
            String("joystick_name",
                   causality=Fmi2Causality.parameter,
                   variability=Fmi2Variability.tunable,
                   description="Joystick Name"))

        self.torque_enabled = True
        self.register_variable(
            Boolean( "torque_enabled",
                     causality=Fmi2Causality.parameter,
                     variability=Fmi2Variability.tunable,
                     description="Enable/Disable Force Feedback"))

        self.gain_torque = 1000
        self.register_variable(
            Real("gain_torque",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description="Calibration gain for the steering torque"))

        self.length_torque = 5
        self.register_variable(
            Real("length_torque",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description="Length[ms] of a force effect"))

        self.torque_avg = 0
        self.register_variable(
            Real("torque_avg",
                 causality=Fmi2Causality.output))

        # axis_ type

        self.axis_0 = 0
        self.register_variable(
            Real("axis_0",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.axis_1 = 1
        self.register_variable(
            Real("axis_1",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.axis_2 = 2
        self.register_variable(
            Real("axis_2",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.axis_3 = 3
        self.register_variable(
            Real("axis_3",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        # button_ type

        self.button_0 = 0
        self.register_variable(
            Real("button_0",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_1 = 1
        self.register_variable(
            Real("button_1",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_2 = 2
        self.register_variable(
            Real("button_2",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_3 = 3
        self.register_variable(
            Real("button_3",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_4 = 4
        self.register_variable(
            Real("button_4",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_5 = 5
        self.register_variable(
            Real("button_5",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_6 = 6
        self.register_variable(
            Real("button_6",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_7 = 7
        self.register_variable(
            Real("button_7",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_8 = 8
        self.register_variable(
            Real("button_8",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_9 = 9
        self.register_variable(
            Real("button_9",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_10 = 10
        self.register_variable(
            Real("button_10",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_11 = 11
        self.register_variable(
            Real("button_11",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_12 = 12
        self.register_variable(
            Real("button_12",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_13 = 13
        self.register_variable(
            Real("button_13",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_14 = 14
        self.register_variable(
            Real("button_14",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_15 = 15
        self.register_variable(
            Real("button_15",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_16 = 16
        self.register_variable(
            Real("button_16",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_17 = 17
        self.register_variable(
            Real("button_17",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_18 = 18
        self.register_variable(
            Real("button_18",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_19 = 19
        self.register_variable(
            Real("button_19",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_20 = 20
        self.register_variable(
            Real("button_20",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_21 = 21
        self.register_variable(
            Real("button_21",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_22 = 22
        self.register_variable(
            Real("button_22",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_23 = 23
        self.register_variable(
            Real("button_23",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_24 = 24
        self.register_variable(
            Real("button_24",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_25 = 25
        self.register_variable(
            Real("button_25",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_26 = 26
        self.register_variable(
            Real("button_26",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_27 = 27
        self.register_variable(
            Real("button_27",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_28 = 28
        self.register_variable(
            Real("button_28",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_29 = 29
        self.register_variable(
            Real("button_29",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_30 = 30
        self.register_variable(
            Real("button_30",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_31 = 31
        self.register_variable(
            Real("button_31",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_32 = 32
        self.register_variable(
            Real("button_32",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_33 = 33
        self.register_variable(
            Real("button_33",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_34 = 34
        self.register_variable(
            Real("button_34",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_35 = 35
        self.register_variable(
            Real("button_35",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_36 = 36
        self.register_variable(
            Real("button_36",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_37 = 37
        self.register_variable(
            Real("button_37",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=""))

        self.button_38 = 38
        self.register_variable(
            Real("button_38",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_39 = 39
        self.register_variable(
            Real("button_39",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_40 = 40
        self.register_variable(
            Real("button_40",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_41 = 41
        self.register_variable(
            Real("button_41",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_42 = 42
        self.register_variable(
            Real("button_42",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_43 = 43
        self.register_variable(
            Real("button_43",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_44 = 44
        self.register_variable(
            Real("button_44",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_45 = 45
        self.register_variable(
            Real("button_45",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_46 = 46
        self.register_variable(
            Real("button_46",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_47 = 47
        self.register_variable(
            Real("button_47",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_48 = 48
        self.register_variable(
            Real("button_48",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_49 = 49
        self.register_variable(
            Real("button_49",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_50 = 50
        self.register_variable(
            Real("button_50",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_51 = 51
        self.register_variable(
            Real("button_51",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_52 = 52
        self.register_variable(
            Real("button_52",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_53 = 53
        self.register_variable(
            Real("button_53",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_54 = 54
        self.register_variable(
            Real("button_54",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_55 = 55
        self.register_variable(
            Real("button_55",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_56 = 56
        self.register_variable(
            Real("button_56",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_57 = 57
        self.register_variable(
            Real("button_57",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=""))

        self.button_58 = 58
        self.register_variable(
            Real("button_58",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_59 = 59
        self.register_variable(
            Real("button_59",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_60 = 60
        self.register_variable(
            Real("button_60",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_61 = 61
        self.register_variable(
            Real("button_61",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_62 = 62
        self.register_variable(
            Real("button_62",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_63 = 63
        self.register_variable(
            Real("button_63",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_64 = 64
        self.register_variable(
            Real("button_64",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_65 = 65
        self.register_variable(
            Real("button_65",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_66 = 66
        self.register_variable(
            Real("button_66",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_67 = 67
        self.register_variable(
            Real("button_67",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_68 = 68
        self.register_variable(
            Real("button_68",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_69 = 69
        self.register_variable(
            Real("button_69",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_70 = 70
        self.register_variable(
            Real("button_70",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_71 = 71
        self.register_variable(
            Real("button_71",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_72 = 72
        self.register_variable(
            Real("button_72",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_73 = 73
        self.register_variable(
            Real("button_73",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_74 = 74
        self.register_variable(
            Real("button_74",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_75 = 75
        self.register_variable(
            Real("button_75",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_76 = 76
        self.register_variable(
            Real("button_76",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_77 = 77
        self.register_variable(
            Real("button_77",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_78 = 78
        self.register_variable(
            Real("button_78",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_79 = 79
        self.register_variable(
            Real("button_79",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_80 = 80
        self.register_variable(
            Real("button_80",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_81 = 81
        self.register_variable(
            Real("button_81",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_82 = 82
        self.register_variable(
            Real("button_82",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_83 = 83
        self.register_variable(
            Real("button_83",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_84 = 84
        self.register_variable(
            Real("button_84",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_85 = 85
        self.register_variable(
            Real("button_85",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_86 = 86
        self.register_variable(
            Real("button_86",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_87 = 87
        self.register_variable(
            Real("button_87",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=""))

        self.button_88 = 88
        self.register_variable(
            Real("button_88",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_89 = 89
        self.register_variable(
            Real("button_89",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_90 = 90
        self.register_variable(
            Real("button_90",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_91 = 91
        self.register_variable(
            Real("button_91",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_92 = 92
        self.register_variable(
            Real("button_92",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_93 = 93
        self.register_variable(
            Real("button_93",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_94 = 94
        self.register_variable(
            Real("button_94",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_95 = 95
        self.register_variable(
            Real("button_95",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_96 = 96
        self.register_variable(
            Real("button_96",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_97 = 97
        self.register_variable(
            Real("button_97",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_98 = 98
        self.register_variable(
            Real("button_98",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_99 = 99
        self.register_variable(
            Real("button_99",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        self.button_100 = 100
        self.register_variable(
            Real("button_100",
                 causality=Fmi2Causality.parameter,
                 variability=Fmi2Variability.tunable,
                 description=" "))

        # axis_ _value

        self.axis_0_value = 0
        self.register_variable(Real("axis_0_value", causality=Fmi2Causality.output))

        self.axis_1_value = 0
        self.register_variable(Real("axis_1_value", causality=Fmi2Causality.output))

        self.axis_2_value = 0
        self.register_variable(Real("axis_2_value", causality=Fmi2Causality.output))

        self.axis_3_value = 0
        self.register_variable(Real("axis_3_value", causality=Fmi2Causality.output))

        # button_ _value

        self.button_0_value = 0
        self.register_variable(Real("button_0_value", causality=Fmi2Causality.output))

        self.button_1_value = 0
        self.register_variable(Real("button_1_value", causality=Fmi2Causality.output))

        self.button_2_value = 0
        self.register_variable(Real("button_2_value", causality=Fmi2Causality.output))

        self.button_3_value = 0
        self.register_variable(Real("button_3_value", causality=Fmi2Causality.output))

        self.button_4_value = 0
        self.register_variable(Real("button_4_value", causality=Fmi2Causality.output))

        self.button_5_value = 0
        self.register_variable(Real("button_5_value", causality=Fmi2Causality.output))

        self.button_6_value = 0
        self.register_variable(Real("button_6_value", causality=Fmi2Causality.output))

        self.button_7_value = 0
        self.register_variable(Real("button_7_value", causality=Fmi2Causality.output))

        self.button_8_value = 0
        self.register_variable(Real("button_8_value", causality=Fmi2Causality.output))

        self.button_9_value = 0
        self.register_variable(Real("button_9_value", causality=Fmi2Causality.output))

        self.button_10_value = 0
        self.register_variable(Real("button_10_value", causality=Fmi2Causality.output))

        self.button_11_value = 0
        self.register_variable(Real("button_11_value", causality=Fmi2Causality.output))

        self.button_12_value = 0
        self.register_variable(Real("button_12_value", causality=Fmi2Causality.output))

        self.button_13_value = 0
        self.register_variable(Real("button_13_value", causality=Fmi2Causality.output))

        self.button_14_value = 0
        self.register_variable(Real("button_14_value", causality=Fmi2Causality.output))

        self.button_15_value = 0
        self.register_variable(Real("button_15_value", causality=Fmi2Causality.output))

        self.button_16_value = 0
        self.register_variable(Real("button_16_value", causality=Fmi2Causality.output))

        self.button_17_value = 0
        self.register_variable(Real("button_17_value", causality=Fmi2Causality.output))

        self.button_18_value = 0
        self.register_variable(Real("button_18_value", causality=Fmi2Causality.output))

        self.button_19_value = 0
        self.register_variable(Real("button_19_value", causality=Fmi2Causality.output))

        self.button_20_value = 0
        self.register_variable(Real("button_20_value", causality=Fmi2Causality.output))

        self.button_21_value = 0
        self.register_variable(Real("button_21_value", causality=Fmi2Causality.output))

        self.button_22_value = 0
        self.register_variable(Real("button_22_value", causality=Fmi2Causality.output))

        self.button_23_value = 0
        self.register_variable(Real("button_23_value", causality=Fmi2Causality.output))

        self.button_24_value = 0
        self.register_variable(Real("button_24_value", causality=Fmi2Causality.output))

        self.button_25_value = 0
        self.register_variable(Real("button_25_value", causality=Fmi2Causality.output))

        self.button_26_value = 0
        self.register_variable(Real("button_26_value", causality=Fmi2Causality.output))

        self.button_27_value = 0
        self.register_variable(Real("button_27_value", causality=Fmi2Causality.output))

        self.button_28_value = 0
        self.register_variable(Real("button_28_value", causality=Fmi2Causality.output))

        self.button_29_value = 0
        self.register_variable(Real("button_29_value", causality=Fmi2Causality.output))

        self.button_30_value = 0
        self.register_variable(Real("button_30_value", causality=Fmi2Causality.output))

        self.button_31_value = 0
        self.register_variable(Real("button_31_value", causality=Fmi2Causality.output))

        self.button_32_value = 0
        self.register_variable(Real("button_32_value", causality=Fmi2Causality.output))

        self.button_33_value = 0
        self.register_variable(Real("button_33_value", causality=Fmi2Causality.output))

        self.button_34_value = 0
        self.register_variable(Real("button_34_value", causality=Fmi2Causality.output))

        self.button_35_value = 0
        self.register_variable(Real("button_35_value", causality=Fmi2Causality.output))

        self.button_36_value = 0
        self.register_variable(Real("button_36_value", causality=Fmi2Causality.output))

        self.button_37_value = 0
        self.register_variable(Real("button_37_value", causality=Fmi2Causality.output))

        self.button_38_value = 0
        self.register_variable(Real("button_38_value", causality=Fmi2Causality.output))

        self.button_39_value = 0
        self.register_variable(Real("button_39_value", causality=Fmi2Causality.output))

        self.button_40_value = 0
        self.register_variable(Real("button_40_value", causality=Fmi2Causality.output))

        self.button_41_value = 0
        self.register_variable(Real("button_41_value", causality=Fmi2Causality.output))

        self.button_42_value = 0
        self.register_variable(Real("button_42_value", causality=Fmi2Causality.output))

        self.button_43_value = 0
        self.register_variable(Real("button_43_value", causality=Fmi2Causality.output))

        self.button_44_value = 0
        self.register_variable(Real("button_44_value", causality=Fmi2Causality.output))

        self.button_45_value = 0
        self.register_variable(Real("button_45_value", causality=Fmi2Causality.output))

        self.button_46_value = 0
        self.register_variable(Real("button_46_value", causality=Fmi2Causality.output))

        self.button_47_value = 0
        self.register_variable(Real("button_47_value", causality=Fmi2Causality.output))

        self.button_48_value = 0
        self.register_variable(Real("button_48_value", causality=Fmi2Causality.output))

        self.button_49_value = 0
        self.register_variable(Real("button_49_value", causality=Fmi2Causality.output))

        self.button_50_value = 0
        self.register_variable(Real("button_50_value", causality=Fmi2Causality.output))

        self.button_51_value = 0
        self.register_variable(Real("button_51_value", causality=Fmi2Causality.output))

        self.button_52_value = 0
        self.register_variable(Real("button_52_value", causality=Fmi2Causality.output))

        self.button_53_value = 0
        self.register_variable(Real("button_53_value", causality=Fmi2Causality.output))

        self.button_54_value = 0
        self.register_variable(Real("button_54_value", causality=Fmi2Causality.output))

        self.button_55_value = 0
        self.register_variable(Real("button_55_value", causality=Fmi2Causality.output))

        self.button_56_value = 0
        self.register_variable(Real("button_56_value", causality=Fmi2Causality.output))

        self.button_57_value = 0
        self.register_variable(Real("button_57_value", causality=Fmi2Causality.output))

        self.button_58_value = 0
        self.register_variable(Real("button_58_value", causality=Fmi2Causality.output))

        self.button_59_value = 0
        self.register_variable(Real("button_59_value", causality=Fmi2Causality.output))

        self.button_60_value = 0
        self.register_variable(Real("button_60_value", causality=Fmi2Causality.output))

        self.button_61_value = 0
        self.register_variable(Real("button_61_value", causality=Fmi2Causality.output))

        self.button_62_value = 0
        self.register_variable(Real("button_62_value", causality=Fmi2Causality.output))

        self.button_63_value = 0
        self.register_variable(Real("button_63_value", causality=Fmi2Causality.output))

        self.button_64_value = 0
        self.register_variable(Real("button_64_value", causality=Fmi2Causality.output))

        self.button_65_value = 0
        self.register_variable(Real("button_65_value", causality=Fmi2Causality.output))

        self.button_66_value = 0
        self.register_variable(Real("button_66_value", causality=Fmi2Causality.output))

        self.button_67_value = 0
        self.register_variable(Real("button_67_value", causality=Fmi2Causality.output))

        self.button_68_value = 0
        self.register_variable(Real("button_68_value", causality=Fmi2Causality.output))

        self.button_69_value = 0
        self.register_variable(Real("button_69_value", causality=Fmi2Causality.output))

        self.button_70_value = 0
        self.register_variable(Real("button_70_value", causality=Fmi2Causality.output))

        self.button_71_value = 0
        self.register_variable(Real("button_71_value", causality=Fmi2Causality.output))

        self.button_72_value = 0
        self.register_variable(Real("button_72_value", causality=Fmi2Causality.output))

        self.button_73_value = 0
        self.register_variable(Real("button_73_value", causality=Fmi2Causality.output))

        self.button_74_value = 0
        self.register_variable(Real("button_74_value", causality=Fmi2Causality.output))

        self.button_75_value = 0
        self.register_variable(Real("button_75_value", causality=Fmi2Causality.output))

        self.button_76_value = 0
        self.register_variable(Real("button_76_value", causality=Fmi2Causality.output))

        self.button_77_value = 0
        self.register_variable(Real("button_77_value", causality=Fmi2Causality.output))

        self.button_78_value = 0
        self.register_variable(Real("button_78_value", causality=Fmi2Causality.output))

        self.button_79_value = 0
        self.register_variable(Real("button_79_value", causality=Fmi2Causality.output))

        self.button_80_value = 0
        self.register_variable(Real("button_80_value", causality=Fmi2Causality.output))

        self.button_81_value = 0
        self.register_variable(Real("button_81_value", causality=Fmi2Causality.output))

        self.button_82_value = 0
        self.register_variable(Real("button_82_value", causality=Fmi2Causality.output))

        self.button_83_value = 0
        self.register_variable(Real("button_83_value", causality=Fmi2Causality.output))

        self.button_84_value = 0
        self.register_variable(Real("button_84_value", causality=Fmi2Causality.output))

        self.button_85_value = 0
        self.register_variable(Real("button_85_value", causality=Fmi2Causality.output))

        self.button_86_value = 0
        self.register_variable(Real("button_86_value", causality=Fmi2Causality.output))

        self.button_87_value = 0
        self.register_variable(Real("button_87_value", causality=Fmi2Causality.output))

        self.button_88_value = 0
        self.register_variable(Real("button_88_value", causality=Fmi2Causality.output))

        self.button_89_value = 0
        self.register_variable(Real("button_89_value", causality=Fmi2Causality.output))

        self.button_90_value = 0
        self.register_variable(Real("button_90_value", causality=Fmi2Causality.output))

        self.button_91_value = 0
        self.register_variable(Real("button_91_value", causality=Fmi2Causality.output))

        self.button_92_value = 0
        self.register_variable(Real("button_92_value", causality=Fmi2Causality.output))

        self.button_93_value = 0
        self.register_variable(Real("button_93_value", causality=Fmi2Causality.output))

        self.button_94_value = 0
        self.register_variable(Real("button_94_value", causality=Fmi2Causality.output))

        self.button_95_value = 0
        self.register_variable(Real("button_95_value", causality=Fmi2Causality.output))

        self.button_96_value = 0
        self.register_variable(Real("button_96_value", causality=Fmi2Causality.output))

        self.button_97_value = 0
        self.register_variable(Real("button_97_value", causality=Fmi2Causality.output))

        self.button_98_value = 0
        self.register_variable(Real("button_98_value", causality=Fmi2Causality.output))

        self.button_99_value = 0
        self.register_variable(Real("button_99_value", causality=Fmi2Causality.output))

        self.button_100_value = 0
        self.register_variable(Real("button_100_value", causality=Fmi2Causality.output))

        # latency check

        self.livesignal_in = 0
        self.register_variable(Real("livesignal_in", causality=Fmi2Causality.input))

        self.livesignal_out = 0
        self.register_variable(Real("livesignal_out", causality=Fmi2Causality.output))

        self.delta_time = 0
        self.register_variable(Real("delta_time", causality=Fmi2Causality.output))

        self.start_time = time.time()

        self.torque = 0
        self.register_variable(Real("torque", causality=Fmi2Causality.input))

        self.constant_level = 0
        self.register_variable(Real("constant_level", causality=Fmi2Causality.output))

        self.ff_enabled = True
        self.register_variable(Boolean("ff_enabled", causality=Fmi2Causality.output))

        self.steering_time_deactivated = 0
        self.register_variable(Real("steering_time_deactivated", causality=Fmi2Causality.output))

        self.gradient_steering_angle = 0
        self.gradient_steering_angle_out = 0
        self.register_variable(Real("gradient_steering_angle_out", causality=Fmi2Causality.output))

        # Carla output

        # self.position_in = 0
        # self.register_variable(Real("position_in", causality=Fmi2causality.input))

        # Initialization of steering wheel and haptic feedback

        sdl2.SDL_Init(sdl2.SDL_INIT_EVERYTHING)
        self.initialization = sdl2.SDL_Init(sdl2.SDL_INIT_JOYSTICK)
        self.haptic_id = 0
        self.a = -1
        self.b = -1

        if self.initialization < 0:  # Checking if there is a steeringwheel connected
            print("Warning: No steering wheel found! ")
        else:
            self.joystick = sdl2.SDL_JoystickOpen(        # First joystick to query the information
                id_finder(encoder(self.joystick_name)))
            self.w = sdl2.SDL_JoystickName(self.joystick)
            self.a = sdl2.SDL_JoystickNumAxes(self.joystick)
            self.b = sdl2.SDL_JoystickNumButtons(self.joystick)

            print("Steering Wheel name:", self.w)
            print("Number of available axis:", self.a, "\nNumber of buttons:", self.b)
            print("Hats:", sdl2.SDL_JoystickNumHats(self.joystick))
            print(self.joystick)

        # Checking recognized device if it has a force feedback

        if sdl2.SDL_NumHaptics() == 0:
            print("Warning: There is no Force Feedback for this device!")
            self.FF_joystick = sdl2.SDL_HapticOpen(self.haptic_id)
            sdl2.SDL_HapticSetGain(self.FF_joystick, 0)
            self.ff_c = 0
            self.c_force = 0

            self.create_force()

        else:
            print("Force Feedback device: ", sdl2.SDL_HapticName(self.haptic_id))
            self.FF_joystick = sdl2.SDL_HapticOpen(self.haptic_id)
            sdl2.SDL_HapticSetGain(self.FF_joystick, 0)

            # Force _value

            self.ff_c = 0
            self.c_force = 0

            self.create_force()

    # Ends the steering wheel feature

    def stop_steering_wheel(self):
        sdl2.SDL_JoystickClose(self.joystick)
        sdl2.SDL_HapticClose(self.FF_joystick)
        sdl2.SDL_Quit()

    # Defining methods for refreshing _values in axis_ and button_s

    def axis_value(self, axis_number):
        self.av = 0
        if axis_number >= 0:
            self.av = sdl2.SDL_JoystickGetAxis(self.joystick, axis_number)
        else:
            self.av = 0
        return self.av

    def button_value(self, button_number):
        self.bv = 0
        if button_number >= 0:
            self.bv = sdl2.SDL_JoystickGetButton(self.joystick, button_number)
        else:
            self.bv = 0
        return self.bv

    def create_force(self):

        # CONSTANT - set at the beginning of the simulation
        # act as the time of simulation goes (G-force, bumpy road etc)

        # CONSTANT force

        self.c_force = sdl2.SDL_HapticEffect()
        self.c_force.type = sdl2.SDL_HAPTIC_CONSTANT
        self.c_force.constant.direction.type = sdl2.SDL_HAPTIC_CARTESIAN  # Cartesian coordinates
        self.c_force.constant.level = 0
        self.c_force.constant.length = int(self.length_torque * self.time_step)  # Force length [ms]
        self.c_force.constant.attack_length = 0  # Set to 0 seconds because it will last until the effect is finished
        self.c_force.constant.fade_length = 0  # set to 0 seconds because it will last until the effect is finished

        self.ff_c = sdl2.SDL_HapticNewEffect(self.FF_joystick, self.c_force)
        sdl2.SDL_HapticRunEffect(self.FF_joystick, self.ff_c, sdl2.SDL_HAPTIC_INFINITY)

    def update_constant_force(self):

        self.torque_lst.insert(0, self.torque)
        self.torque_avg = sum(self.torque_lst) / len(self.torque_lst)
        if len(self.torque_lst) > 5:
            self.torque_lst.pop(-1)

        if self.torque_enabled:
            self.c_force.constant.level = int(self.torque_avg * self.gain_torque)
        else:
            self.c_force.constant.level = 0

        self.c_force.constant.length = int(self.length_torque * self.time_step)  # Force length [ms]

        sdl2.SDL_HapticUpdateEffect(self.FF_joystick, self.ff_c, self.c_force)

    # Updating _values

    def do_step(self, current_time, step_size):

        self.time_step = step_size

        sdl2.SDL_JoystickUpdate()

        self.axis_0_value = self.axis_value(int(self.axis_0))
        self.axis_1_value = self.axis_value(int(self.axis_1))
        self.axis_2_value = self.axis_value(int(self.axis_2))
        self.axis_3_value = self.axis_value(int(self.axis_3))

        self.button_0_value = self.button_value(int(self.button_0))
        self.button_1_value = self.button_value(int(self.button_1))
        self.button_2_value = self.button_value(int(self.button_2))
        self.button_3_value = self.button_value(int(self.button_3))
        self.button_4_value = self.button_value(int(self.button_4))
        self.button_5_value = self.button_value(int(self.button_5))
        self.button_6_value = self.button_value(int(self.button_6))
        self.button_7_value = self.button_value(int(self.button_7))
        self.button_8_value = self.button_value(int(self.button_8))
        self.button_9_value = self.button_value(int(self.button_9))
        self.button_10_value = self.button_value(int(self.button_10))
        self.button_11_value = self.button_value(int(self.button_11))
        self.button_12_value = self.button_value(int(self.button_12))
        self.button_13_value = self.button_value(int(self.button_13))
        self.button_14_value = self.button_value(int(self.button_14))
        self.button_15_value = self.button_value(int(self.button_15))
        self.button_16_value = self.button_value(int(self.button_16))
        self.button_17_value = self.button_value(int(self.button_17))
        self.button_18_value = self.button_value(int(self.button_18))
        self.button_19_value = self.button_value(int(self.button_19))
        self.button_20_value = self.button_value(int(self.button_20))
        self.button_21_value = self.button_value(int(self.button_21))
        self.button_22_value = self.button_value(int(self.button_22))
        self.button_23_value = self.button_value(int(self.button_23))
        self.button_24_value = self.button_value(int(self.button_24))
        self.button_25_value = self.button_value(int(self.button_25))
        self.button_26_value = self.button_value(int(self.button_26))
        self.button_27_value = self.button_value(int(self.button_27))
        self.button_28_value = self.button_value(int(self.button_28))
        self.button_29_value = self.button_value(int(self.button_29))
        self.button_30_value = self.button_value(int(self.button_30))
        self.button_31_value = self.button_value(int(self.button_31))
        self.button_32_value = self.button_value(int(self.button_32))
        self.button_33_value = self.button_value(int(self.button_33))
        self.button_34_value = self.button_value(int(self.button_34))
        self.button_35_value = self.button_value(int(self.button_35))
        self.button_36_value = self.button_value(int(self.button_36))
        self.button_37_value = self.button_value(int(self.button_37))
        self.button_38_value = self.button_value(int(self.button_38))
        self.button_39_value = self.button_value(int(self.button_39))
        self.button_40_value = self.button_value(int(self.button_40))
        self.button_41_value = self.button_value(int(self.button_41))
        self.button_42_value = self.button_value(int(self.button_42))
        self.button_43_value = self.button_value(int(self.button_43))
        self.button_44_value = self.button_value(int(self.button_44))
        self.button_45_value = self.button_value(int(self.button_45))
        self.button_46_value = self.button_value(int(self.button_46))
        self.button_47_value = self.button_value(int(self.button_47))
        self.button_48_value = self.button_value(int(self.button_48))
        self.button_49_value = self.button_value(int(self.button_49))
        self.button_50_value = self.button_value(int(self.button_50))
        self.button_51_value = self.button_value(int(self.button_51))
        self.button_52_value = self.button_value(int(self.button_52))
        self.button_53_value = self.button_value(int(self.button_53))
        self.button_54_value = self.button_value(int(self.button_54))
        self.button_55_value = self.button_value(int(self.button_55))
        self.button_56_value = self.button_value(int(self.button_56))
        self.button_57_value = self.button_value(int(self.button_57))
        self.button_58_value = self.button_value(int(self.button_58))
        self.button_59_value = self.button_value(int(self.button_59))
        self.button_60_value = self.button_value(int(self.button_60))
        self.button_61_value = self.button_value(int(self.button_61))
        self.button_62_value = self.button_value(int(self.button_62))
        self.button_63_value = self.button_value(int(self.button_63))
        self.button_64_value = self.button_value(int(self.button_64))
        self.button_65_value = self.button_value(int(self.button_65))
        self.button_66_value = self.button_value(int(self.button_66))
        self.button_67_value = self.button_value(int(self.button_67))
        self.button_68_value = self.button_value(int(self.button_68))
        self.button_69_value = self.button_value(int(self.button_69))
        self.button_70_value = self.button_value(int(self.button_70))
        self.button_71_value = self.button_value(int(self.button_71))
        self.button_72_value = self.button_value(int(self.button_72))
        self.button_73_value = self.button_value(int(self.button_73))
        self.button_74_value = self.button_value(int(self.button_74))
        self.button_75_value = self.button_value(int(self.button_75))
        self.button_76_value = self.button_value(int(self.button_76))
        self.button_77_value = self.button_value(int(self.button_77))
        self.button_78_value = self.button_value(int(self.button_78))
        self.button_79_value = self.button_value(int(self.button_79))
        self.button_80_value = self.button_value(int(self.button_80))
        self.button_81_value = self.button_value(int(self.button_81))
        self.button_82_value = self.button_value(int(self.button_82))
        self.button_83_value = self.button_value(int(self.button_83))
        self.button_84_value = self.button_value(int(self.button_84))
        self.button_85_value = self.button_value(int(self.button_85))
        self.button_86_value = self.button_value(int(self.button_86))
        self.button_87_value = self.button_value(int(self.button_87))
        self.button_88_value = self.button_value(int(self.button_88))
        self.button_89_value = self.button_value(int(self.button_89))
        self.button_90_value = self.button_value(int(self.button_90))
        self.button_91_value = self.button_value(int(self.button_91))
        self.button_92_value = self.button_value(int(self.button_92))
        self.button_93_value = self.button_value(int(self.button_93))
        self.button_94_value = self.button_value(int(self.button_94))
        self.button_95_value = self.button_value(int(self.button_95))
        self.button_96_value = self.button_value(int(self.button_96))
        self.button_97_value = self.button_value(int(self.button_97))
        self.button_98_value = self.button_value(int(self.button_98))
        self.button_99_value = self.button_value(int(self.button_99))
        self.button_100_value = self.button_value(int(self.button_100))

        self.livesignal_out = self.livesignal_in
        # self.position_in = self.position_in

        self.update_constant_force()
        self.constant_level = self.c_force.constant.level
        self.ff_enabled = self.torque_enabled

        # if self.position_in >= 1:
        #     self.stop_steering_wheel()
        #     quit()

        return True


#    def terminate(self):
#         if self.triangle == 1:
#              quit()
#          return

# Functionality test (Debugging)

# volan = SteeringWheel(instance_name="Wheel")
# time_ = 0
# time_step = 0.01
# running = True
# while running and volan.is_running:
#     volan.do_step(time_, time_step)
#
#     print(f"Current livesignal in is {volan.livesignal_in}")
#     print(f"Current time is {time_}\n")
#
#     time_ += time_step
#     if time_ > 60:
#         running = False
#
#     time.sleep(0.5)
