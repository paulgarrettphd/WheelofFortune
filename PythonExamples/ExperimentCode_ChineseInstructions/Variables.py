# Lampshades Task Variables
from GUI import *
import time, pygame, random, numpy as np
from Colours import *
from itertools import permutations as permute

# Yu-Tzu - These are the paramaters you can change

# Accuracy Plot Feedback Display Size and Positions
FeedbackAccuracyPlotSize        = 6   # Change to alter the size of the Accuracy Plot in the Feedback Display. See result with TestFeedbackScreen() in Run file
FeedbackAccuracyPlotXposition   = .5  # X-axis center of the Accuracy plot. 1 = Left. 0 = Right. .5 = Center of Screen
FeedbackAccuracyPlotYposition   = .35 # Y-axis center of the Accuracy plot. 0 = Top. 1 = Bottom. .5 = Center of Screen.

# Block Progress Bar Display Size and Positions
BlockProgressBarDimensions  = (1200, 200) # Change this to alter the size of the Block Progress Bar. Defailt (1200, 200)
ProgressBarTickLength       = 100 # Length of Progress Bar ticks. Default 100. Change if Ticks 
PlotBlockBarXposition       = .5  # Center of the Block Progress Bar, .5 is middle of screen
PlotBlockBarYposition       = .85 # Y Position of the Progress Bar. 0.85 is close to the bottom of the screen

# Feedback Timer Position - The big 30s timer that occurs with the Feedback. Typically to the left of the
# block progress bar. 
TimerXaxisPosition = .15
TimerYaxisPosition = .8
TimerTickLength    = 100
TimerTickWidth     = 8

BlockProgressBarSize        = 3 # Try not to change this from 3 if possible. You shouldn't need to.

# Wheel And Stim Sizes
OuterRadius       = 370             # Outer Wheel Circle Radius in Pixels. Newcastle Default 520. See result with TestWheelPosition() in Run file
InnerRadius       = 250             # Inner Wheel Circle Radius in Pixels. Newcastle Default 400. See result with TestWheelPosition() in Run file

WheelStimSizes    = 70             # Changes the size of response stimuli within the spokes of the Wheel. See result with TestWheelPosition() in Run file

MaskSizeModifier  = 4               # This multiplies the size of the mask. Newcastle Default 6. See result with TestMaskSize() in Run file
                                    # Note: Bigger number, bigger mask.

NonNoisyStimSize   = 65             ### Paul's Mistake, sorry Yu-Tzu. This was the size of the stimulus without noise as it appears during the instructions.
                                    # I've added the below variable PrimaryStimulusScale so you can use a multiplier to change the size of the noisy stimulus

PrimaryStimulusScale = 1           # Multiplier for the Noisy Stimulus Display. < 1, Smaller Box; > 1, Larger Box; = 1 Same Pixel size as Newcastle.

MinusPixelXaxis   = [40,35,35,35,30,35,30,30,35] # Use values these to finely adjust the stimuli within the wheel spokes
MinusPixelYaxis   = [30,35,40,35,30,30,25,25,30] # Positions align with the Position's Figure in the README file.
# For example, if position 1 is too far left, increase MinusPixelXaxis value 1 from 55 to 60.
# For example, if position 2 is too far down, increase MinusPixelYaxis value 2 from 60 to 70.
# Do this for all 9 wheel positions to make sure the response stimuli fit within the wheel. See result with TestWheelPosition() in Run file


# Lastly, all of the above values may not 'look' right when changed. This could be due to the position of the object on the screen
# Each functional call these variables are use in e.g., DrawWheel() for the wheel, has an x and y value you can specify which will change
# the position of the object on the screen. Let me know if this becomes an issue.
# If you run into trouble, run the ScreenshotAllStim() function in the RUN.py file. This will save off screenshots of the stimuli
# on the CRT monitor and give me an idea of what you need to change.

#NativeLanuage = 'English'
NativeLanuage = 'Chinese'

if NativeLanuage == 'English':
    NativeNumber = 1
else:
    NativeNumber = 2
        
Piloting = True 
HalfHourPayment = '5' # $5 per half hour testing

# Number of Contrast Levels Presented at Experimentation
NContrastLevels = 5
# Change to increase # Blocks or Trials per block
# Number of Experimental Blocks = Blocks-1 as the first block is a practice round
Blocks = 14 # 14
# Number of Trials
Nstim = 9
Trials = Nstim * NContrastLevels * 2

ParticipantID = QueryParticipantID()  # 'CHN001A' 'ENG001A'
if len(ParticipantID) is not 4 and len(ParticipantID) is not 7:
    raise(ValueError('Participant ID must be a string 4 letters long; 3 digits and 1 session letter. e.g., 001A; or 7 letters long with a session prefix, e.g., ENG001A, CHN001A, THI001A or DOT001A'))

SessionLetter = ParticipantID[-1]
PartNumber    = int(ParticipantID[-4:-1])
SessionNumber = ['A','B','C','D'].index(SessionLetter)+1

# Between Subjects Design
if len(ParticipantID) == 7:
    PartPrefix = ParticipantID[:3]
    if PartPrefix not in ['ENG', 'CHN', 'THI', 'DOT']:
        raise(ValueError('ID Lanuage Prefix must be either ENG, CHN, THI or DOT. Please change ID accordingly if you wish to proceed with a Between Subjects design.'))
    LanuageNumber = ['ENG', 'CHN', 'THI', 'DOT'].index(PartPrefix)
    
# Within Subjects Design
elif len(ParticipantID) == 4:
    TaskSet = list(permute(range(4)))
    # This is random order by which task set permutations may be presented, generated with below code.
    #RandomisedOrder = range(len(TaskSet))
    #random.shuffle(RandomisedOrder)
    RandomisedOrder = [20, 9, 13, 7, 15, 5, 8, 3, 17, 16, 19, 2, 11, 18, 22, 21, 1, 14, 6, 10, 23, 4, 12, 0]
    while len(RandomisedOrder) <= PartNumber: RandomisedOrder += RandomisedOrder
    TaskSet = TaskSet[RandomisedOrder[PartNumber]]
    LanuageNumber = TaskSet[SessionNumber-1]
    PartPrefix    = ['ENG', 'CHN', 'THI', 'DOT'][LanuageNumber]
    ParticipantID = PartPrefix + ParticipantID

# Timing of Stim, Mask and Time Out - Changing will change experiment timing
# Don't change these.
Stim_Display_Time = 500 
Mask_Time         = 200
Max_Stim_Time     = 8000

# Stimulus Contrat Intensity - Changing will change the experimental stimulus
# Don't change these.
SignalStep        = 1 # range 0 - 255
SignalValue       = int(round( 255 * .6 ))
MinSignal         = int(round( 255 * .5  ))
MaxSignal         = int(round( 255 * 1   ))
NoiseMu           = 0
NoiseSigma        = 0.25 # Eidels 2018. Derived by Eidles & Gold (0.0625 x 4)


MouseStartRadius  = OuterRadius/10  # Leave this one alone
NumTotalStimuli   = 9               # Leave this one alone    


# Don't change anything past here.


# Frames per second 
FPS = 60
JSmovementspeed = 15

WheelOrder = list(range(1,10))
random.shuffle(WheelOrder)

# Background Color
BG = GRAY_6 

pygame.joystick.init()
JOYSTICK = []
[JOYSTICK.append(pygame.joystick.Joystick(i)) for i in range(pygame.joystick.get_count())]
if len(JOYSTICK)>0:
    JOYSTICK = JOYSTICK[0]
    JOYSTICK.init()
    Device = 'Joystick'
else:
    JOYSTICK = []
    Device = 'Mouse'

# Get current date and string time structure
Date, timestructure = time.ctime(), time.strftime("%Y_%m_%d_%H.%M")

def Stim_Select(num, experiment):
    if experiment == 0: s = 'English'     # Arabic-English Integers
    elif experiment == 1: s = 'Chinese'   # Simple Chinese Characters
    elif experiment == 2: s = 'Thai'      # Simple Indian/Thai Numerals
    elif experiment == 3: s = 'Dots'      # Canonical Dot Patterns
    if num == 111: return(111)
    elif num in range(1,10):
        return( s + str(num) + '.png')

def cnd_list_contrasts(trials, cuttrials=0, contrasts=NContrastLevels, blockN=1):
    if blockN == 0:
        trials = Nstim * NContrastLevels * 3
        cuttrials = Nstim * NContrastLevels * 3
    t = []
    c = []
    for ii in range(1,Nstim+1):
        for iii in range(NContrastLevels):
            t.append(ii)
            c.append(iii)
    Repetitions = int(np.ceil(trials / float(len(t))))
    t *= Repetitions
    c *= Repetitions
    TrialList = zip(t,c)
    random.shuffle(TrialList)
    TrialList.append( (111,111) )
    if cuttrials > 0 and cuttrials < trials:
        index = list(range(cuttrials))
        index.append(-1)
        TrialList = [TrialList[j] for j in index]
    return(TrialList)
