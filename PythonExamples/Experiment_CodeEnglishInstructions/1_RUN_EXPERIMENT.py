from Variables import *
from DisplayFunctions import *
from MouseResponse import *
from collections import OrderedDict
from JoystickResponse import *
from Instructions import *
import numpy as np
from PIL import Image

# In future, consider a difference calculation i.e., absolute deviance form the mean
# so for the last 30 trials, the participant must have an abs deviance <40 from the mean contrast level
# This should stop staircasing at the end of the practice round from influencing the mean calculation.

global RT, Acc, ResponseList, CndList, TrialList, InnerRadius, OuterRadius, MouseStartRadius, NumTotalStimuli, MouseList, Experiment, Stim_Display_Time, SignalValue
def RUN():
    global SignalValue
    FPSclock = pygame.time.Clock()
    FPSclock.tick(FPS)
    StimList = LoadStim(LanuageNumber)
    BaseStim = LoadBaseStim(LanuageNumber)
    mRT = []
    mAcc = []
    while True:
        [ConsentScreen(i) for i in range(2)]
        [Instructions(i) for i in range(28)]
        for block in range(Blocks):
            RT              = []
            Acc             = []
            RspList         = []
            AngleList       = []
            CndList         = []
            MouseList       = []
            SignalContrast  = []
            ContrastListN   = []
            MovementOnset   = []
            TimeInMotion    = []
            for trial, contrastN in cnd_list_contrasts(Trials,blockN=block):
                if trial == 111:
                    nRT = np.asarray(RT); nAcc = np.asarray(Acc)
                    mRT.append( np.mean( np.abs( nRT[nRT > -Max_Stim_Time] ) ) / 1000 ) # Mean RT excluding Timeouts
                    mAcc.append( np.mean( nAcc ) * 100 )
                    
                    SaveDict                            = OrderedDict()
                    SaveDict['NativeLangNumber']        = [NativeNumber] * len(RT)
                    SaveDict['LanuageNumber']           = [LanuageNumber] * len(RT)
                    SaveDict['SessionNumber']           = [SessionNumber] * len(RT)
                    SaveDict['Block']                   = [block]*len(RT)
                    SaveDict['TrialNum']                = list(range(1,len(RT)+1))
                    SaveDict['ConditionNumber']         = CndList
                    SaveDict['Response']                = RspList
                    SaveDict['Accuracy']                = Acc
                    SaveDict['RT']                      = RT
                    SaveDict['MovementOnsetTime']       = MovementOnset
                    SaveDict['TimeInMotion']            = TimeInMotion
                    SaveDict['SignalContrast']          = SignalContrast
                    SaveDict['SignalContrastNumber']    = ContrastListN

                    SaveDict['StimDisplayTime']         = [Stim_Display_Time] * len(RT)
                    SaveDict['MaskTime']                = [Mask_Time] * len(RT)
                    SaveDict['MaxResponseTime']         = [Max_Stim_Time] * len(RT)
                    
                    SaveDict['MousePositionXY']         = MouseList
                    SaveDict['MouseAngle']              = AngleList
                    SaveDict['WheelOrder']              = [WheelOrder] * len(RT)
                    SaveDict['NoiseMuSigma']            = zip([NoiseMu], [NoiseSigma]) * len(RT)
                    
                    SaveDict['ParticipantID']           = [ParticipantID]*len(RT)
                    SaveDict['LanuageTested']           = [PartPrefix] * len(RT)
                    SaveDict['SessionTested']           = [SessionLetter] * len(RT)
                    SaveDict['NativeLanuage']           = [NativeLanuage] * len(RT)
                    SaveDict['Date']                    = [Date] * len(RT)
                    SaveDict['ResponseDevice']          = [Device] * len(RT)
                    
                    Save(block, SaveDict)
                    Feedback( block, mRT, mAcc )

                    if block == 0:
                        SignalValue = int(round(np.mean(SignalContrast[-30:]))) # Changed to -30 rather than -20 during piloting
                        ConstantSignalValue = SignalValue
                    
                else:
                    if block > 0:
                        # 3-x-1 Design
                        SignalValue = range(ConstantSignalValue-NContrastLevels+2, ConstantSignalValue+2)[contrastN] 
                    else:
                        contrastN = 0
                    pre_trial_screen()
                    DrawNoisyStim( trial, BaseStim, Signal=SignalValue, mu=NoiseMu, sigma=NoiseSigma, UPDATE=True )
                    wait_time(Stim_Display_Time) # Non-Response Interval
                    DisplayMask(MaskD, FigSize)
                    wait_time(Mask_Time) # Mask Display
                    DrawWheel(LoadedStimList=StimList) # RTI begins
                    if JOYSTICK == []:
                        Signal = MouseResponse( trial, block, InnerRadius, RT, Acc, RspList, AngleList, MouseList, Signal=SignalValue, MouseStart=MovementOnset, MotionRT=TimeInMotion )
                    else:
                        JoystickResponse( trial, block, InnerRadius, RT, Acc, RspList, AngleList, MouseList )

                    CndList.append( trial )
                    SignalContrast.append(SignalValue)
                    ContrastListN.append( contrastN )
                    SignalValue = Signal

RUN()




# The Below code will generate Screenshots of all the stimuli, wheels, masks and counters used
# during the experiment. They will be saved in parent directory under 'Figures'
##import os
##def ScreenshotAllStim():
##    savefolder = os.path.abspath(os.path.join(os.path.dirname( __file__ ), os.pardir, 'Figures'))
##    for Exp in range(4):
##        L = LoadBaseStim(Exp)
##        StimList = LoadStim(Exp)
##        for k in range(1,10):
##            blank(False)
##            t = pygame.time.get_ticks()
##            ### Un-Comment to Display the Stimulus in Noise
##            DrawNoisyStim( k, L, Signal=SignalValue, mu=NoiseMu, sigma=NoiseSigma, UPDATE=True )
##            pygame.image.save(DISPLAYSURF, os.path.join(savefolder, 'Stim_Exp' + str(Exp) + 'Stim' + str(k) +'.jpg'))
##            ### Un-Comment to Display the Stimulus Wheel
##        blank()
##        DrawWheel(LoadedStimList=StimList) # RTI begins
##        update()
##        pygame.image.save(DISPLAYSURF, os.path.join(savefolder, 'Wheel_Exp' + str(Exp) +'.jpg'))
##        for c in range(5):
##            blank()
##            CountdownTimer(5, c)
##            update()
##            pygame.image.save(DISPLAYSURF, os.path.join(savefolder, 'CountDown' + str(c) +'.jpg'))
##        #print( pygame.time.get_ticks() - t)
##        blank()
##        DrawMask()
##        pygame.image.save(DISPLAYSURF, os.path.join(savefolder, 'Wheel_Exp' + 'MASK' +'.jpg'))
##        wait_time(100)
##            ##QUIT()
##    QUIT()
##ScreenshotAllStim()


##def TestWheelPositions():
##    global WheelOrder
##    #WheelOrder = list(range(1,10))
##    
##    for Exp in range(4):
##        StimList = LoadStim(Exp)
##        for randomwheel in range(10):
##            random.shuffle(WheelOrder)
##            DrawWheel( LoadedStimList=StimList )
##            wait_time(700)
##    QUIT()
##TestWheelPositions()




