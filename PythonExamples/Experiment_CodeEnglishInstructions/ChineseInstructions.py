from Variables import *
from DisplayFunctions import *
from Colours import *
from PracticeExamples import *

## Hi Yu-Tzu,
## The below code is the same as in the 'Instructions.py'.
## If you make a Chinese version of this code, I can make two 'RUN.py' files
## one for English, and one for Tiwan. I think this would be the easiest way
## to get around any issues in the code/lanuage.

## Let me know if you need a hand with any of the code
## In the below code, each 'Screen' is called by a number.
## Screen Numbers start at 0. Consent Screen numbers go from 0 -- 1
## and Instruction Screen numbers go from 0 -- 27.
## At the end of each screen loop there are a series of possible events
## that will progress the participant to the next screen.
## These events could be a keyboard press e.g., spacebar
## or the presentation of a Timer.

## In general, if you just replace the text (strings) in Green Font with
## Chinese text, then everything should work the same

## If you find you need to add lines of text to the screen, use the write function.
## It works like this:
## write( string, xpos, ypos, update )
## where - string is the text you wish to write e.g., 'this is a string'
##       - xpos (defaults to 0.5) is the position of the text centered along the x-axis e.g., 0.5 (middle of display)
##       - ypos (defaults to 0.5) is the position of the text centered along the y-axis e.g., 0.1 is 10% of the screen from the top,
##          0.5 is the middle of the screen, and 0.9 is towards the bottom of the screen
##       - UPDATE (defaults to true) This makes the whole screen update. Call this once all of the text has been written
##          otherwise the text may appear to 'flash' when one line is updated before another.
##          For example, see in the ConsentScreen function, UPDATE=False in the first 'write' function, but is defaults to true in the second 'write' function.
##
## I can help with formatting after the text has been written so don't worry about this too much, just get the words down
## and I'll take it from there.
##
## Email me with any issues, I take alot for granted and I don't expect anyone to intuitively understand my code :)
## Paul.

def ConsentScreen(Screen):
    Draw = True
    blank()
    pygame.event.clear(pygame.KEYDOWN)

    while True:
        if Screen == 0 and Draw:
            write('Welcome to Spin n Win: A Symbolic Identification Task', UPDATE=False)
            write('Press Space To Continue', .5, .9)
            Draw = False
        elif Screen == 1 and Draw:
            write('The following is an experiment in which you will be asked to view and identify',y=.25,UPDATE=False)
            write('a briefly presented symbol. The task will take approximately 1 hour to Complete.',y=.3,UPDATE=False)
            
            write('You will be reimbursed $' + HalfHourPayment + ' per half-hour of testing.',y=.4,UPDATE=False)
            
            write('Your participation in this study is completely voluntary.',y=.5,UPDATE=False)
            write('You can leave at any time without penalty, receiving reimbursement per half-hour of the time taken.',y=.55,UPDATE=False)
            
            write("Press 'Y' if you have read the Study Information Statement",y=.65,UPDATE=False)
            write("and consent to participate in this study. Otherwise press 'Esc' to exit the study.",y=.7,UPDATE=False)

            write("Press 'Y' to consent and continue with this study, or 'Esc' to Exit the Study", y=.9)
            Draw = False

        for event in pygame.event.get():
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    QUIT()
                if event.key == pygame.K_y and Screen == 1:
                    return
                if event.key == pygame.K_SPACE and Screen == 0:
                    return

def Instructions(Screen, Exp=LanuageNumber):
    Draw = True
    blank()
    pygame.event.clear(pygame.KEYDOWN)
    LoadedStim = LoadStim(Exp)
    BaseStimList = LoadBaseStim(Exp)
    L1, L2, L3, L4, L5, L6, L7, L8, L9, L10, L11, L12, L13, L14 = .2, .25, .3, .35, .4, .45, .5, .55, .6, .65, .7, .75, .8, .85
    Toggle = pygame.USEREVENT + 1
    TrainingSet = [4, 5, 2, 9, 7, 3, 6, 1, 8]

    while True:
        if Screen == 0 and Draw:
            write('In the following task, you will be briefly presented with one of nine symbols.', .5, L1, UPDATE=False)
            write('Using the ' + Device.lower() + ', you will be asked to identify which symbol was presented.', .5, L2, UPDATE=False)
            dsporder = list(range(9))
            random.shuffle(dsporder)
            xco = [.27, .47, .67]; yco = [.3, .5, .7]; n = 0
            for iy in yco:
                for ix in xco:
                    DISPLAYSURF.blit( pygame.transform.scale(LoadedStim[dsporder[n]], (75, 75)), (WINDOW_WIDTH*ix ,WINDOW_HEIGHT*iy )); n+= 1
            write('Press space to continue.', .5, .85)
            Draw = False
        if Screen == 1 and Draw:
            DrawStim( LoadedStim, WheelOrder[3], UPDATE=False )
            write('On a trial, you will view a central', .5, L2, UPDATE=False)
            write('symbol followed by a stimulus wheel.', .5, L3, UPDATE=False)
            write('Press space to continue.', .5, L12)
            pygame.time.set_timer(Toggle, 1200)
            Intro1 = True; Draw = False
        if Screen == 2 and Draw:
            DrawWheel(False,LoadedStimList=LoadedStim, SingleStim=WheelOrder[3] )
            write('Using the ' + Device.lower() + ', identify the', .5, L2, UPDATE=False)
            write('presented symbol on the stimulus wheel.', .5, L3, UPDATE=False)
            write('A response is taken when the cursor passes', .5, L4, UPDATE=True)
            write('the center circle.', .5, L5, UPDATE=True)
            pygame.mouse.set_visible(True)
            mx, my = pygame.mouse.get_pos()
            MousePos = []
            FinalPos = LineCoord(4, 400)
            for i in range(1,401):
                MousePos.append( LineCoord(4, i) )
            n = 0
            pygame.time.set_timer(Toggle, 5)
            Draw = False
        if Screen == 3 and Draw:
            write('The following will be a quick practice round.', .5, L4, UPDATE=False)
            write('Move the cursor to identify the target symbol.', .5, L5, UPDATE=False)
            write('Correct responses will be highlighted by a green inner circle,', .5, L7, UPDATE=False)
            write('Incorrect responses will be highlighted by a red inner circle.', .5, L8, UPDATE=False)
            write('Incorrect responses will be repeated until a correct response is given.', .5, L10, UPDATE=False)
            write('Press space to begin the practice round.', .5, L12, UPDATE=True)
            Draw = False
        if Screen in range(4, 8) and Draw:
            EGstim = TrainingSet[Screen-4]
            Outcome = 0
            while Outcome == 0:
                Outcome = PracticeExamples( EGstim , LoadedStim, BaseStimList, 1000, DrawSingle=True, NoiseOn=False)
            return
        if Screen == 8 and Draw:
            write('Great work. Now lets use the full stimulus wheel.', .5, L4, UPDATE=False)
            write('Move the cursor to identify the target symbol.', .5, L5, UPDATE=False)
            write('Correct responses will be highlighted by a green inner circle,', .5, L7, UPDATE=False)
            write('Incorrect responses will be highlighted by a red inner circle.', .5, L8, UPDATE=False)
            write('Incorrect responses will be repeated until a correct response is given.', .5, L10, UPDATE=False)
            write('Press space to begin the practice round.', .5, L12, UPDATE=True)
            Draw = False
        if Screen in range(9, 13) and Draw:
            EGstim = TrainingSet[Screen-4]
            Outcome = 0
            while Outcome == 0:
                Outcome = PracticeExamples( EGstim , LoadedStim, BaseStimList, 1000, DrawSingle=False, NoiseOn=False)
            return
        if Screen == 13 and Draw:
            write('Excellent! Now lets add some noise to the symbols.', .5, L2, UPDATE=False)
            write('This experiment is designed to be difficult, sometimes you will not', .5, L3, UPDATE=False)
            write('know the right answer. If in doubt, always respond with your best guess.', .5, L4, UPDATE=False)
            write('Move the cursor to identify the target symbol.', .5, L5, UPDATE=False)
            write('Correct responses will be highlighted by a green inner circle,', .5, L7, UPDATE=False)
            write('Incorrect responses will be highlighted by a red inner circle.', .5, L8, UPDATE=False)
            write('Incorrect responses will be repeated until a correct response is given.', .5, L10, UPDATE=False)
            write('Press space to begin the practice round.', .5, L12, UPDATE=True)
            Draw = False
        if Screen in range(14, 17):
            EGstim = random.randint(1,9)
            Outcome = 0
            while Outcome == 0:
                Outcome = PracticeExamples( EGstim , LoadedStim, BaseStimList, 1000, DrawSingle=False)
            return
        if Screen == 17 and Draw:
            write('Awesome! Now we will speed up the symbol display time.', .5, L4, UPDATE=False)
            write('Remember, if in doubt always respond with your best guess.', .5, L5, UPDATE=False)
            write('Correct responses will be highlighted by a green inner circle,', .5, L7, UPDATE=False)
            write('Incorrect responses will be highlighted by a red inner circle.', .5, L8, UPDATE=False)
            write('Incorrect responses will be repeated until a correct response is given.', .5, L10, UPDATE=False)
            write('Press space to begin the practice round.', .5, L12, UPDATE=True)
        if Screen in range(18,22):
            EGstim = random.randint(1,9)
            Outcome = 0
            while Outcome == 0:
                Outcome = PracticeExamples( EGstim , LoadedStim, BaseStimList, Stim_Display_Time, DrawSingle=False)
            return
        if Screen == 22 and Draw:
            write('Brilliant! Finally we will add a mask after the symbol presentation.', .5, L3, UPDATE=False)
            write('This is how all trials will be presented for the rest of the experiment.', .5, L4, UPDATE=False)
            write('Remember, if in doubt always respond with your best guess.', .5, L5, UPDATE=False)
            write('Correct responses will be highlighted by a green inner circle,', .5, L7, UPDATE=False)
            write('Incorrect responses will be highlighted by a red inner circle.', .5, L8, UPDATE=False)
            write('Incorrect responses will be repeated until a correct response is given.', .5, L10, UPDATE=False)
            write('Press space to begin the practice round.', .5, L12, UPDATE=True)
        if Screen in range(23, 27):
            EGstim = random.randint(1,9)
            Outcome = 0
            while Outcome == 0:
                Outcome = PracticeExamples( EGstim , LoadedStim, BaseStimList, Stim_Display_Time, DrawSingle=False, Mask=True)
            return
        if Screen == 27 and Draw:
            write('Excellent! Now you will complete a full practice block. During the practice block,', .5, L1, UPDATE=False)
            write('the more accurate you are, the harder the central symbol will become to see.', .5, L2, UPDATE=False)

            write('On each trial you will have eight seconds to respond.', .5, L4, UPDATE=False)
            
            write('During the practice block you will receive feedback on every trial.', .5, L6, UPDATE=False)
            write('In future blocks, trial-by-trial feedback will not be provided.', .5, L7, UPDATE=False)

            write('Remember, if in doubt always respond with your best guess.', .5, L9, UPDATE=False)

            write('Correct responses will be highlighted by a green inner circle,', .5, L11, UPDATE=False)
            write('Incorrect responses will be highlighted by a red inner circle.', .5, L12, UPDATE=False)
            
            write('Press space to begin.', .5, L14, UPDATE=True)
            Draw = False


        for event in pygame.event.get():
            if event.type == Toggle:
                if Screen == 1:
                    if Intro1 == True:
                        blank()
                        DrawWheel(False,LoadedStimList=LoadedStim, SingleStim=WheelOrder[3] )
                        write('On a trial, you will view a central', .5, L2, UPDATE=False)
                        write('symbol followed by a stimulus wheel.', .5, L3, UPDATE=False)
                        write('Press space to continue.', .5, L12); Intro1 = False
                    else:
                        blank()
                        DrawStim( LoadedStim, WheelOrder[3], UPDATE=False )
                        write('On a trial, you will view a central', .5, L2, UPDATE=False)
                        write('symbol followed by a stimulus wheel.', .5, L3, UPDATE=False)
                        write('Press space to continue.', .5, L12); Intro1 = True
                if Screen == 2 and n < 400:
                    pygame.mouse.set_pos(MousePos[n]); n+= 1
                if Screen == 2 and n == 400:
                    write('Press space to continue.', .5, L12)
                


            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    QUIT()
                if event.key == pygame.K_SPACE:
                    if Screen in range(2):
                        pygame.time.set_timer(Toggle, 0)
                        return
                    if Screen == 2 and n == 400:
                        pygame.time.set_timer(Toggle, 0)
                        pygame.mouse.set_visible(False)
                        return
                    if Screen in [3,8,13,17,22,27]:
                        blank()
                        timer(5, r=50, linewidth=8)
                        return
