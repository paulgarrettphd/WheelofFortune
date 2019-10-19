import pygame, math
from DisplayFunctions import *
from Variables import *

def JoystickResponse( trial, block, RespRadii, RT, Acc, ResponseList, AngleList, MouseList ):
    pygame.time.Clock().tick(FPS)
    t1 = pygame.time.get_ticks()
    pygame.event.clear(pygame.KEYDOWN)
    pygame.event.clear(pygame.JOYAXISMOTION)
    ConstantMotionEvent = pygame.USEREVENT + 1
    
    MaskToggle = False; PostMaskBlank = False

    pygame.mouse.set_visible(True)

    mx, my = [WINDOW_WIDTH*.5, WINDOW_HEIGHT*.5]
    pygame.mouse.set_pos( [mx, my] )
    started = False
    MousePosition = []
    
    while True:
        if pygame.time.get_ticks() - t1 > Max_Stim_Time:
            RT.append(-Max_Stim_Time);
            Acc.append(0);
            AngleList.append(666)
            ResponseList.append(666)
            MouseList.append( MousePosition )
            pygame.mouse.set_visible(False)
            pygame.time.set_timer(ConstantMotionEvent, 0)

            return
        
        for event in pygame.event.get():
            if event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE:
                pygame.mouse.set_visible(False)
                blank(); write('Good Bye!'); wait_time(500)
                pygame.mouse.set_visible(False)
                
                QUIT()

            if event.type == pygame.JOYAXISMOTION and started == False:
                pygame.time.set_timer(ConstantMotionEvent, 1)
                started = True

            if event.type == ConstantMotionEvent:

                CheckX = JOYSTICK.get_axis(0)
                CheckY = JOYSTICK.get_axis(1)

                print('GetAxis:', CheckX, CheckY)

                mx += (CheckX * JSmovementspeed)
                my += (CheckY * JSmovementspeed)

                pygame.mouse.set_pos( [mx, my] )

                Dist = distance( (WINDOW_WIDTH*.5, WINDOW_HEIGHT*.5), (mx, my) )
                MousePosition.append( (mx, my) )

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
                        Acc.append(0); RT.append(-pygame.time.get_ticks()-t1)
                    pygame.time.set_timer(ConstantMotionEvent, 0)

                    return
                
