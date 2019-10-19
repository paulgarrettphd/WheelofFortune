from Variables import *
from DisplayFunctions import *
from MouseResponse import *

global RT, Acc, ResponseList, CndList, TrialList, InnerRadius, OuterRadius, MouseStartRadius, NumTotalStimuli, MouseList, Experiment
def PracticeExamples(StimN, StimListBlack, BaseStim, StimDelay, DrawSingle=False, Mask=False, NoiseOn=True):
    RT = []
    Acc = []
    RspList = []
    AngleList = []
    CndList = []
    MouseList = []
    while True:
        pre_trial_screen()
        if NoiseOn:
            DrawNoisyStim( StimN, BaseStim, Signal=SignalValue, mu=NoiseMu, sigma=NoiseSigma, UPDATE=True )
        else:
            DrawStim( StimListBlack, StimN, UPDATE=True )
        wait_time(StimDelay)
        if Mask:
            DisplayMask(MaskD, FigSize)
            wait_time(Mask_Time)
        if DrawSingle:
            DrawWheel(LoadedStimList=StimListBlack, SingleStim=StimN ) 
        else:
            DrawWheel(LoadedStimList=StimListBlack, pushUpdate=True)
        if JOYSTICK == []:
            MouseResponse( StimN, -1, InnerRadius, RT, Acc, RspList, AngleList, MouseList )
        else:
            JoystickResponse( StimN, -1, InnerRadius, RT, Acc, RspList, AngleList, MouseList )
        return(Acc[-1])
        
