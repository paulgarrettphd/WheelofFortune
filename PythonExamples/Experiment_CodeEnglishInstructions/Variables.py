# Lampshades Task Variables
from GUI import *
import time, pygame, random, numpy as np
from Colours import *
from itertools import permutations as permute

NativeLanuage = 'English'
#NativeLanuage = 'Chinese'

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
Stim_Display_Time = 500 
Mask_Time         = 200
Max_Stim_Time     = 8000

# Stimulus Contrat Intensity - Changing will change the experimental stimulus
SignalStep        = 1 # range 0 - 255
SignalValue       = int(round( 255 * .6 ))
MinSignal         = int(round( 255 * .5  ))
MaxSignal         = int(round( 255 * 1   ))
NoiseMu           = 0
NoiseSigma        = 0.25 # Eidels 2018. Derived by Eidles & Gold (0.0625 x 4)

OuterRadius       = 500
InnerRadius       = 400
MouseStartRadius  = 50
NumTotalStimuli   = 9

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
