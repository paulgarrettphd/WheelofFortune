 # -*- coding: utf-8 -*-
from Variables import *
from DisplayFunctions import *
from MouseResponse import *
from collections import OrderedDict
from JoystickResponse import *
from Instructions import *
import numpy as np
from PIL import Image

# CHINESE-TEXT VERSION OF WHEEL TASK

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

# This Command Runs the Full Experiment
RUN()



# Hi Yu-Tzu, Below is code for you to easily test the size and positions of the following displays:
#   - Stimulus Wheel
#   - Central Stimulus
#   - Mask
#   - Feedback Screen
#
# To run these, comment out the RUN() command (alt+3; this will stop the experiment from running)
# and uncomment (alt+4) one of the below sections of code.
# e.g., if you want to test the Wheel Position, uncomment from def TestWheelPosition(Lang=0: --> TestWheelPosition() and then run the script (F5)
# You can then measure the size of each display on your screen and modify the size of each object in the Variables.py file.
# If you match our physical measurements from Newcsatle, and seat participants roughly 60cm from the screen, we should
# mostly control for perceptual effects through a consistent visual angle.
#
# For future use, I've also included a Screen Shot Generator: ScreenshotAllStim()
# This will go through all the Experimental Session Types and will generate example Wheels, Stim, Masks and Feedback Screens
# saving them in a newly created directory called Figures (located in the parent directory, one directory above your current location)
# These screen shots will look Exactly like what is on your CRT display, so you can always send them to me to show me any problems that
# are occuring.
#
# Lastly, you might need to change the position of each stimulus in the Wheel. This was tricky when I originally did it. To make this easy
# I've added a TestAllWheelPositions() function. This will display all of the Stimuli within the wheel so you can make sure they are positioned
# between the spokes of the two inner and outter circles. I hope that makes sense. Email me with any issues.
#
# Paul

### Newcastle Dimensions: Outer Diameter: 27.6cm; Inner Diameter: 21.2cm; Spoke Length: 3.2cm
##def TestWheelPosition(Lang=0):
##    global WheelOrder   
##    WheelOrder = list(range(1,10))
##    StimList = LoadStim(Lang)
##    DrawWheel( LoadedStimList=StimList )
##    while True:
##        for event in pygame.event.get():
##            if event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE:
##                QUIT()
##TestWheelPosition()

### Newcastle Dimensions: Stimulus Noisy Box: 5.8cm x 5.8cm
##def TestStimSize(N=1,Lang=0):
##    blank()
##    DrawNoisyStim( N, LoadBaseStim(Lang), Signal=200, mu=NoiseMu, sigma=NoiseSigma, UPDATE=True )
##    while True:
##        for event in pygame.event.get():
##            if event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE:
##                QUIT()
##TestStimSize()
##
### Newcastle Dimensions: Mask Size: 12.2cm x 12.2cm
##def TestMaskSize():
##    blank()
##    DrawMask()
##    while True:
##        for event in pygame.event.get():
##            if event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE:
##                QUIT()
##TestMaskSize()
##
# Newcastle Dimensions: Accuracy Plot: 12.2cm x 12.2cm; Progress Bar: 24.6cm x 4.1cm
##def TestFeedbackScreen():
##    Feedback( 13, range(14), [75,60,65,60,55,60,60,65,70,70,60,50,55,65] )
##    QUIT()
##TestFeedbackScreen()
##
##
##
##def TestAllWheelPositions():
##    # Check all stim fit within the wheel spokes
##    for Exp in range(4):
##        StimList = LoadStim(Exp)
##        for randomwheel in range(10):
##            random.shuffle(WheelOrder)
##            DrawWheel( LoadedStimList=StimList )
##            wait_time(200)
##    QUIT()
##TestAllWheelPositions()




# The Below code will generate Screenshots of all the stimuli, wheels, masks and counters used
# during the experiment. They will be saved in the parent directory under 'Figures'. Uncomment
# Everything from the next line down to generate the screenshots. Make sure all previous functions have been commented off.

##import os
##def ScreenshotAllStim():
##    savefolder = os.path.abspath(os.path.join(os.path.dirname( __file__ ), os.pardir, 'Figures'))
##    if not os.path.exists( savefolder ):
##        os.mkdir( savefolder )
##    for Exp in range(4):
##        L = LoadBaseStim(Exp)
##        StimList = LoadStim(Exp)
##        for k in range(1,10):
##            blank(False)
##            t = pygame.time.get_ticks()
##            DrawNoisyStim( k, L, Signal=255, mu=0.47, sigma=0, UPDATE=True, BlackNumber=True )
##            update()
##            pygame.image.save(DISPLAYSURF, os.path.join(savefolder, 'Stim_Exp' + str(Exp) + 'Stim' + str(k) +'.jpg'))
##            blank(False)
##            DrawNoisyStim( k, L, Signal=SignalValue, mu=NoiseMu, sigma=NoiseSigma, UPDATE=True )
##            pygame.image.save(DISPLAYSURF, os.path.join(savefolder, 'Stim_Exp' + str(Exp) + 'NoisyStim' + str(k) +'.jpg'))
##        blank()
##        DrawWheel(LoadedStimList=StimList)
##        update()
##        pygame.image.save(DISPLAYSURF, os.path.join(savefolder, 'Wheel_Exp' + str(Exp) +'.jpg'))
##    for c in range(5):
##        blank()
##        CountdownTimer(5, c)
##        update()
##        pygame.image.save(DISPLAYSURF, os.path.join(savefolder, 'CountDown' + str(c) +'.jpg'))
##    blank()
##    fixation_cross()
##    pygame.image.save(DISPLAYSURF, os.path.join(savefolder, 'FixationCross.jpg'))
##    blank()
##    DrawMask()
##    pygame.image.save(DISPLAYSURF, os.path.join(savefolder, 'Wheel_Exp' + 'MASK' +'.jpg'))
##    wait_time(50)
##    blank()
##    PlotMean( [73,60,65,60,55,60,60,65,70,70,60,50,55,65], 13, False )
##    PlotBlockBar( 13 ) 
##    update()
##    pygame.image.save(DISPLAYSURF, os.path.join(savefolder, 'FeedbackExample.jpg'))
##    blank()
##    PlotMean( [73,60,65,60,55,60,60,65,70,70,60,50,55,65], 13, False )
##    PlotBlockBar( 13 ) 
##    CountdownTimer(30, 5, r=TimerTickLength, x=TimerXaxisPosition, y=TimerYaxisPosition, linewidth=TimerTickWidth)
##    pygame.image.save(DISPLAYSURF, os.path.join(savefolder, 'FeedbackExampleWithTimer.jpg'))
##    QUIT()
##ScreenshotAllStim()
