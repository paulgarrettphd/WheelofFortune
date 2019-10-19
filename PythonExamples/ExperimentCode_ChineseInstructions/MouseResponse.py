import pygame, math
from DisplayFunctions import *
from Variables import *

def MouseResponse( trial, block, RespRadii, RT, Acc, ResponseList, AngleList, MouseList, Signal = SignalValue, MouseStart=[], MotionRT=[] ):
    
    pygame.time.Clock().tick(FPS)
    t1 = pygame.time.get_ticks()
    pygame.event.clear(pygame.KEYDOWN)
    pygame.event.clear(pygame.MOUSEMOTION)
    ConstantMotionEvent = pygame.USEREVENT + 1
    pygame.mouse.set_visible(True)
    MouseMoved = False
    

    MaskToggle = False; PostMaskBlank = False

    started = False
    MousePosition = []
    mx = my = 0
    while True:

        if not started:
            pygame.time.set_timer(ConstantMotionEvent, 1)
            started = True

        if pygame.time.get_ticks() - t1 > Max_Stim_Time and block > -1:
            RT.append(-Max_Stim_Time);
            Acc.append(0);
            MouseStart.append(Max_Stim_Time)
            MotionRT.append(abs(RT[-1]) - MouseStart[-1])
            AngleList.append(666)
            ResponseList.append(666)
            MouseList.append( MousePosition )
            pygame.mouse.set_visible(False)
            pygame.time.set_timer(ConstantMotionEvent, 0)

            if block == 0:
                Signal += SignalStep 
                if Signal > MaxSignal:
                    Signal = MaxSignal
            return (Signal)

        for event in pygame.event.get():

            if event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE:
                pygame.mouse.set_visible(False)
                blank(); write('Good Bye!'); wait_time(500)
                QUIT()

            if event.type == ConstantMotionEvent:
                mx, my = pygame.mouse.get_pos()
                Dist = distance( (WINDOW_WIDTH*.5, WINDOW_HEIGHT*.5), (mx, my) )
                MousePosition.append( (mx, my) )

                if len(set(MousePosition[-2:])) > 1 and not MouseMoved:
                    MouseStart.append( pygame.time.get_ticks()-t1 )
                    MouseMoved = True

                if Dist >= RespRadii:
                    
                    Angle = LineAngle(mx,my,WINDOW_WIDTH*.5,WINDOW_HEIGHT*.5)
                    Response = ResponseNum( NumTotalStimuli, Angle )
                    
                    AngleList.append( Angle )
                    ResponseList.append( Response )
                    MouseList.append( MousePosition )
                    pygame.mouse.set_visible(False)

                    if Response == trial:
                        Acc.append(1); RT.append(pygame.time.get_ticks()-t1)
                    else:
                        Acc.append(0); RT.append( (pygame.time.get_ticks()-t1) * -1 )
                    MotionRT.append(abs(RT[-1]) - MouseStart[-1])
                    pygame.time.set_timer(ConstantMotionEvent, 0)

                    if block in [-1,0]:
                        if Acc[-1] == 0:
                            DrawCircle(r=InnerRadius, UPDATE=False, LineColor=RED, rwidth=15)
                            if block == 0 and sum(Acc[-1:])==0: # nback = 1 
                                Signal += SignalStep 
                                if Signal > MaxSignal:
                                    Signal = MaxSignal
                        else:
                            DrawCircle(r=InnerRadius, UPDATE=False, LineColor=GREEN, rwidth=15)
                            if block == 0 and sum(Acc[-2:])==2: #nback = 2 
                                Signal -= SignalStep 
                                if Signal < MinSignal:
                                    Signal = MinSignal + SignalStep

                        update()
                        wait_time(500)
                    return (Signal)
                    
    
    
