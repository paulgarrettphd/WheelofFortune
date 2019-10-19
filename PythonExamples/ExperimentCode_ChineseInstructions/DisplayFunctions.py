# -*- coding: utf-8 -*-
# Spin-&-Win:
# Chinese and English Confusion Matrix Number Task
# Garrett 28-02-2018. The Univerisity of Newcastle
# Update: 28-02-18
# Display Functions for Experiment

from SetScreen import *
from Colours import *
from Variables import *
import matplotlib
matplotlib.use("Agg")
import matplotlib.backends.backend_agg as agg, matplotlib.pyplot as plt
import math, sys, pygame, time, os, csv, pylab, numpy as np
from pygame import gfxdraw
from PlotMeans import *
from PIL import Image

def update():
    pygame.display.update()

def blank(UPDATE=True):
    DISPLAYSURF.fill(BG)
    if UPDATE:
        update()

def wait_time(x):
    pygame.time.delay(x)
    update()

def QUIT():
    pygame.quit()
    sys.exit()
    update()

def fixation_cross():
    blank()
    cross_size = 5
    pygame.draw.line(DISPLAYSURF, BLACK, ((WINDOW_WIDTH/2 + cross_size), WINDOW_HEIGHT/2 ), ((WINDOW_WIDTH/2 - cross_size), WINDOW_HEIGHT/2 ), 4)
    pygame.draw.line(DISPLAYSURF, BLACK, ((WINDOW_WIDTH/2), (WINDOW_HEIGHT/2 + cross_size)), ((WINDOW_WIDTH/2), (WINDOW_HEIGHT/2 - cross_size )), 4)
    update()

def pre_trial_screen():
    while True:
        blank()
        wait_time(250)
        fixation_cross()
        wait_time(500)
        blank()
        wait_time(250)
        break

def write(word, x=.5, y=.5, text_size = 32, UPDATE=True):
    fontObj = pygame.font.Font("Cyberbit.ttf", text_size)
    Text_surface = fontObj.render(word, True, BLACK, BG)
    Text_background_rectangle = Text_surface.get_rect()
    Text_background_rectangle.center = ((WINDOW_WIDTH*x), (WINDOW_HEIGHT*y))
    DISPLAYSURF.blit(Text_surface, Text_background_rectangle)
    if UPDATE == True:
        update()

def sq(x):
    return (x*x)

def sqrt(x):
    return (math.sqrt(x))

def distance( XY1, XY2 ):
    return (sqrt(sq(XY1[0] - XY2[0]) + sq(XY1[1] - XY2[1])))

def LineCoord(SpokeN, r, Nspokes = 9, x0=.5, y0=.5):
    Degree = 360 / Nspokes * SpokeN - 360 / Nspokes / 2
    Radian = math.radians(Degree)
    x = round( int(x0*WINDOW_WIDTH ) + r * math.cos(Radian) )
    y = round( int(y0*WINDOW_HEIGHT) + r * math.sin(Radian) )
    return(x,y)

def LineAngle(x1,y1,x0,y0):
    rad = math.atan2(y1-y0, x1-x0)
    deg = math.degrees(rad)
    if deg < 0:
        deg = 360 + deg
    return( deg )

def ResponseNum( NumStim, LineAngle ):
    Xangle = 360.0 / NumStim
    Kangle = Xangle
    Angles = [0]
    while Kangle < 360:
        Angles.append(Kangle)
        Kangle += Xangle
    Angles.append(360)
    for n in range(NumStim):
        if LineAngle >= Angles[n] and LineAngle <= Angles[n+1]:
            return (WheelOrder[n])

def DrawCircle(r = 50, x=.5, y=.5, rwidth = 2, UPDATE=True, LineColor=BLACK, FaceColor=BG):
    pygame.gfxdraw.filled_circle(DISPLAYSURF,  int(WINDOW_WIDTH*x), int(WINDOW_HEIGHT*y), r, LineColor)
    pygame.gfxdraw.filled_circle(DISPLAYSURF,  int(WINDOW_WIDTH*x), int(WINDOW_HEIGHT*y), r-rwidth, FaceColor)
    if UPDATE:
        update()

def DrawWheel(pushUpdate=True, rOuter = OuterRadius, rInner = InnerRadius, Nspokes = 9, x=.5 ,y=.5, LoadedStimList = [], SingleStim=False, Xminus=MinusPixelXaxis, Yminus=MinusPixelYaxis):
    blank()
    # Draw Outer Circle
    DrawCircle(r=rOuter, UPDATE=False)
    # Draw Spokes
    for k in range(1,Nspokes+1):
        Radian = math.radians( (360.0 / Nspokes) * k ) 
        IntX = round( int(WINDOW_WIDTH*x)  + rOuter * math.cos(Radian) )
        IntY = round( int(WINDOW_HEIGHT*y) + rOuter * math.sin(Radian) )
        pygame.draw.line(DISPLAYSURF, BLACK, (int(WINDOW_WIDTH*x), int(WINDOW_HEIGHT*y)), ( int(IntX), int(IntY) ), 2)
    # Draw Symbols
    for k, s in zip(range(1, Nspokes+1), WheelOrder):
        SymbolRadian = math.radians( (360.0 / Nspokes) * k ) - math.radians( (360.0 / Nspokes) ) / 2
        IntX = round( int(WINDOW_WIDTH*x)  + (rOuter+rInner)/2 * math.cos(SymbolRadian) )
        IntY = round( int(WINDOW_HEIGHT*y) + (rOuter+rInner)/2 * math.sin(SymbolRadian) )
        if len(LoadedStimList)>0 and SingleStim==False:
            DrawWheelStim( LoadedStimList, s, IntX, IntY, WheelStimSizes, Xminus[k-1], Yminus[k-1] )
        elif len(LoadedStimList)>0 and s==SingleStim:
            DrawWheelStim( LoadedStimList, s, IntX, IntY, WheelStimSizes, Xminus[k-1], Yminus[k-1] )
            
    # Draw Inner Circle
    DrawCircle(r=rInner,UPDATE=False)
    if pushUpdate:
        update()

def DrawWheelStim(LoadedStimusList, N, x, y, FigSize=WheelStimSizes, xMinus=0, yMinus=0):
    DISPLAYSURF.blit( pygame.transform.scale(LoadedStimusList[N-1], (FigSize, FigSize)), (x - xMinus ,y - yMinus))

def DrawStim(LoadedStimusList, N, x=.5, y=.5, FigSize=NonNoisyStimSize, UPDATE=False, NoiseIndex=1, FileTest=[]):
    trialid = N
    N = (NoiseIndex-1) * 9 + N-1
    #DISPLAYSURF.blit( LoadedStimusList[N], (WINDOW_WIDTH*x - FigSize*.5 ,WINDOW_HEIGHT*y - FigSize*.5))
    DISPLAYSURF.blit( LoadedStimusList[N], (WINDOW_WIDTH*x - FigSize * 1.5 ,WINDOW_HEIGHT*y - FigSize * 1.5))
    if UPDATE:
        update()

def LoadStim(Experiment):
    StimDir = os.path.join( os.path.split(os.getcwd())[0], 'NumberStimuli')
    String = ['English','Chinese','Thai','Dots'][Experiment]
    LoadedStimList = []
    for i in range(1,10):
        LoadedStimList.append( pygame.image.load( os.path.join( StimDir, String + str(i) + '.tif' ) ) )
    return( LoadedStimList )

def DrawMask(GenMask=False,masksize=MaskSizeModifier):
    gd = 40;
    pygame.draw.rect(DISPLAYSURF, BG, (0, WINDOW_HEIGHT*.25, WINDOW_WIDTH , WINDOW_HEIGHT*.55 ))
    matrix = np.random.uniform(50, 30, gd*gd).reshape((gd, gd))
    fig = pylab.figure(figsize=(masksize, masksize), dpi=100)
    ax=fig.gca()
    ax.set_axis_off()
    ax.matshow(matrix, cmap=plt.cm.binary)
    bg = BG[0]/255.
    fig.patch.set_facecolor(str(bg))
    canvas = agg.FigureCanvasAgg(fig)
    canvas.draw()
    renderer = canvas.get_renderer()
    raw_data = renderer.tostring_rgb()
    size = canvas.get_width_height() #* MaskSizeModifier
    surf = pygame.image.fromstring(raw_data, size, "RGB")
    screen = DISPLAYSURF
    if GenMask:
        plt.close('all')
        return(surf, masksize*50)
    screen.blit(surf, (WINDOW_WIDTH*.5 - masksize*50 ,WINDOW_HEIGHT*.5 -masksize*50))
    update()
    plt.close('all')


def LoadBaseStim( Experiment ):
    StimDir = os.path.join( os.path.split(os.getcwd())[0], 'GreyNumberStimuli')
    String = ['English','Chinese','Thai','Dots'][Experiment]
    LoadedStimArrays = []
    for i in range(1,10):
        filename = os.path.join( StimDir, String + str(i) + '.tif' )
        I = Image.open(filename)            # open image
        a = np.asarray(I)                   # make image an array
        a2 = a[:,:,:-1]                     # remove alpha value from 4th dimension
        a2.setflags(write=1)                # make array writable        
        a3 = a2.astype('float64')           # make float array
        LoadedStimArrays.append(a3)
    return(LoadedStimArrays)

def DrawNoisyStim( StimN, LoadedList, Signal=255, mu=0, sigma=0.0625, x=.5, y=.5, UPDATE=True, scale=PrimaryStimulusScale, BlackNumber=False ):

    if BlackNumber:
        Stim = np.copy(LoadedList[StimN-1])
        Stim[Stim==0] = BG[0]
        Stim[Stim!=BG[0]]  = 0 # Make symbol black
        
    if not BlackNumber:
        Stim = np.copy(LoadedList[StimN-1])
        Stim[Stim>0] = Signal#* 255.0           # make symbol uniform grey color
        Stim[Stim==0] = .5 * 255.0              # make grey background
        noise = np.random.normal(mu, sigma, Stim.shape[0]*Stim.shape[1]).reshape((Stim.shape[0],Stim.shape[1]))
        noise255 = noise * (255 * .5)           # make noise in 255 color space 
        Stim[:,:,0] += noise255                 # add equal noise to 1st...
        Stim[:,:,1] += noise255                 # 2nd ...
        Stim[:,:,2] += noise255                 # and 3rd dimension of image

    NoisyStim       = Stim.astype('uint8')        # convert back to uint8 for display
    surfaceimage    = pygame.surfarray.make_surface(NoisyStim) # Make image into pygame surface
    rotatedsurface  = pygame.transform.rotate( surfaceimage, 270 ) # rotate the image to be upright
    flipedsurface   = pygame.transform.flip(rotatedsurface,True,False) # flip the image    
    width, height   = flipedsurface.get_width(), flipedsurface.get_height()
    scaledsurface   = pygame.transform.scale(flipedsurface, (int(round(width*scale)), int(round(height*scale))) )
    width2, height2 = scaledsurface.get_width(), scaledsurface.get_height()
    DISPLAYSURF.blit( scaledsurface, (WINDOW_WIDTH*x - width2*.5, WINDOW_HEIGHT*y - height2*.5))
    
    if UPDATE:
        update()

def GenMasks(NMasks=20):
    MDict = {}
    MDict['M'] = []
    for M in range(NMasks):
        Surf, FigSize = DrawMask(GenMask=True)
        MDict['M'].append( Surf )
    return(MDict, FigSize)

def DisplayMask(MaskD, FigSize, x=.5, y=.5):
    DISPLAYSURF.blit(MaskD['M'][random.randint(0,len(MaskD['M'])-1)], (WINDOW_WIDTH*x - FigSize ,WINDOW_HEIGHT*y - FigSize))
    update()

def Feedback( block, mRT, mAcc ):
    #PlotMean( mAcc, block, False, xpos=.3, ypos=.35 ) # - if subploting RT and Acc
    #PlotMean( mRT,  block, xpos=.7, ypos=.35 ) # - if subploting RT and Acc
    blank()
    BlockNumScreen(block)
    blank()
    PlotMean( mAcc, block, False )
    PlotBlockBar( block ) 
    write(u'完成進度', y=.7, UPDATE=True)
    Toggle = pygame.USEREVENT + 1
    Timer  = pygame.USEREVENT + 2
    if block+1 < Blocks:
        pygame.time.set_timer(Toggle, 32000)
        pygame.time.set_timer(Timer, 10)
        DelayTime = 30
    else:
        pygame.time.set_timer(Toggle, 5)
    AcceptSpace = False
    count = 0
    while True:
        for event in pygame.event.get():
            if event.type == Timer and count <= DelayTime+1:
                CountdownTimer(DelayTime, count, r=TimerTickLength, x=TimerXaxisPosition, y=TimerYaxisPosition, linewidth=TimerTickWidth)
                count += 1
                pygame.time.set_timer(Timer, 1000)
            if event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE and Piloting == True:
                QUIT()
            if event.type == Toggle and block+1 < Blocks:
                write(u'按空白鍵繼續', y=.95, UPDATE=True)
                pygame.time.set_timer(Toggle, 0)
                pygame.time.set_timer(Timer, 0)
                AcceptSpace = True
            if event.type == Toggle and block+1 == Blocks:
                write(u'按空白鍵繼續', y=.95, UPDATE=True)
                pygame.time.set_timer(Toggle, 0)
                AcceptSpace = True
            if event.type == pygame.KEYDOWN and AcceptSpace and event.key == pygame.K_SPACE and block == 0:
                BlockOnePreamble()
                pygame.time.set_timer(Toggle, 0)
                timer(5, r=50, linewidth=8)
                return
            if event.type == pygame.KEYDOWN and AcceptSpace and event.key == pygame.K_SPACE and block+1 != Blocks:
                blank()
                pygame.time.set_timer(Toggle, 0)
                timer(5, r=50, linewidth=8)
                return
            if event.type == pygame.KEYDOWN and AcceptSpace and event.key == pygame.K_SPACE and block+1 == Blocks:
                ExitScreen()

def BlockOnePreamble():
    blank()
    write(u'您將準備開始進行正式題組', .5, .4, UPDATE=False)
    write(u'正式題開始，每個刺激與刺激之間，將不會給予任何回饋', .5, .45, UPDATE=False)
    write(u'這個實驗有點困難', .5, .55, UPDATE=False)
    write(u'如果你發現這些符號很難被辨識，不需要感到挫折', .5, .6, UPDATE=False)
    write(u'記得，如果你不確定剛剛所看到的，盡可能去猜您認為最符合的答案', .5, .65, UPDATE=False)
    write(u'按空白鍵開始實驗', .5, .85, UPDATE=True)
    while True:
        for event in pygame.event.get():
            if event.type == pygame.KEYDOWN and event.key == pygame.K_SPACE:
                blank()
                return
    

def Save(block, Dict):
    # Save off a single CSV file after each block is complete
    BlockName = 'Block' + str(block)
    ScriptPath = os.getcwd()
    savepath = os.path.join( os.path.dirname(os.getcwd()), 'Data' )
    if not os.path.exists( savepath ):
        os.mkdir( savepath )
    # Work from Save Dir for ease
    os.chdir(savepath)
    with open( str(ParticipantID) + '_' + timestructure + '_' + BlockName + '.csv', 'wb') as csv_file:
	writer = csv.writer( csv_file )
	writer.writerow( Dict.keys() )
	writer.writerows( zip(*Dict.values() ) )
    # Concatenate CSV files and delete individual block CSV files at the end of the experiment
    if block == Blocks - 1:
        SaveFile = open(str(ParticipantID) + '_' + timestructure + '.csv', 'a')
        for files in range(Blocks):
            BlockName = 'Block' + str(files)
            row = 0
            f = open( str(ParticipantID) + '_' +  timestructure + '_' + BlockName + '.csv' )
            for rows in f:
                if files == 0: SaveFile.write(rows)
                if files != 0:
                    if row > 0: SaveFile.write(rows)
                    row += 1
            f.close()
            os.remove( str(ParticipantID) + '_' + timestructure + '_' + BlockName + '.csv' )
        SaveFile.close()
        # Change back to Script/Function directory
        os.chdir(ScriptPath)
        return

def ExitScreen():
    blank()
    write(u'謝謝您全程參與本實驗', .5, .47, UPDATE=False)
    write(u'請找實驗者並領取參與者費用', .5, .53, UPDATE=True)
    wait_time(5000)
    QUIT()

def BlockNumScreen(block):
    if block > 0:
        #write('Block ' + str(block) + ' of ' + str(Blocks-1) + ' Complete!')
        write(u'請休息一下', .5, .50)
        wait_time(2000)
    if block == 0:
        write(u'練習題結束', .5, .4, UPDATE=False)
        write(u'接下來每當完成一回測試，', .5, .5, UPDATE=False)
        write(u'將會呈現您的作答正確率及平均反應時間， ', .5, .55, UPDATE=False)
        write(u'您可以隨時關注自己的表現', .5, .6, UPDATE=False)
        write(u'剩下來的題目，將不會再回饋作答是否正確', .5, .65, UPDATE=False)
        write(u'按空白鍵看您的進度', .5, .85, UPDATE=True)
        while True:
            for event in pygame.event.get():
                if event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_ESCAPE and Piloting == True:
                        QUIT()
                    if event.key == pygame.K_SPACE:
                        return

def BreakScreen(block):
    blank()
    if CounterBalance == 0: p1, p2 = .13, .86
    else: p1, p2 = .86, .13
    if block == 0:
        write(u'做的真好! 練習題到此結束', .5, .47, UPDATE=False)
        write(u'在正式實驗開始前請休息一下', .5, .53, UPDATE=True)
        wait_time(3000)
    else:
        BlockNumScreen(block)
        
    blank()
    write(u'在下一個題組開始前請稍帶休息', .5, .79, UPDATE=True)
        
    for i in range(30):
        pygame.draw.rect(DISPLAYSURF, BG, (WINDOW_WIDTH/2-32, WINDOW_HEIGHT*.85-32, 64, 64))
        write(str(30-i), y = .85)
        wait_time(1000)
    Draw = True
    pygame.event.clear(pygame.KEYDOWN)
    while True:
        if Draw == True:
            blank();
            write(u'按空白鍵開始下一個題組', .5, .9); Draw = False
        for event in pygame.event.get():
            if event.type == pygame.KEYDOWN and Piloting == True and event.key == pygame.K_ESCAPE: QUIT()
            if event.type == pygame.KEYDOWN and event.key == pygame.K_SPACE:
                #for i in list(reversed(range(1,6))):
                #    blank(); write(str(i)); wait_time(1000);
                blank()
                timer(5, r=50, linewidth=8)
                return

def EscapeButton():
    while True:
        for event in pygame.event.get():
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    QUIT()

def timer(seconds, r=25, x=.5, y=.5, linewidth=5):
    colorwheel = zip( np.linspace(RED[0], GREEN[0], seconds), np.linspace(RED[1], GREEN[1], seconds), np.linspace(RED[2], GREEN[2], seconds) )
    for t in range(1,seconds+2):
        pygame.gfxdraw.filled_circle(DISPLAYSURF,  int(WINDOW_WIDTH*x), int(WINDOW_HEIGHT*y), int(r*1.5), BG)
        for k in range(t,seconds+1):
            Radian = math.radians( (360.0 / seconds) * k )
            IntX = round( int(WINDOW_WIDTH*x)  + r * math.cos(Radian) )
            IntY = round( int(WINDOW_HEIGHT*y) + r * math.sin(Radian) )
            pygame.draw.line(DISPLAYSURF, colorwheel[t-1], (int(WINDOW_WIDTH*x), int(WINDOW_HEIGHT*y)), ( int(IntX), int(IntY) ), linewidth)
        pygame.gfxdraw.filled_circle(DISPLAYSURF,  int(WINDOW_WIDTH*x), int(WINDOW_HEIGHT*y), int(r*.25), BG)
        update()
        wait_time(1000)
    return

def CountdownTimer(TotalTime, Count, r=25, x=.5, y=.5, linewidth=5):
    colorwheel = zip( np.linspace(RED[0], GREEN[0], TotalTime), np.linspace(RED[1], GREEN[1], TotalTime), np.linspace(RED[2], GREEN[2], TotalTime) )
    pygame.gfxdraw.filled_circle(DISPLAYSURF,  int(WINDOW_WIDTH*x), int(WINDOW_HEIGHT*y), int(r*1.5), BG)
    if Count > 0:
        for k in range(Count,TotalTime+1):
            Radian = math.radians( (360.0 / TotalTime) * k )
            IntX = round( int(WINDOW_WIDTH*x)  + r * math.cos(Radian) )
            IntY = round( int(WINDOW_HEIGHT*y) + r * math.sin(Radian) )
            pygame.draw.line(DISPLAYSURF, colorwheel[Count-1], (int(WINDOW_WIDTH*x), int(WINDOW_HEIGHT*y)), ( int(IntX), int(IntY) ), linewidth)
            pygame.gfxdraw.filled_circle(DISPLAYSURF,  int(WINDOW_WIDTH*x), int(WINDOW_HEIGHT*y), int(r*.5), BG)
    update()

MaskD, FigSize = GenMasks()
