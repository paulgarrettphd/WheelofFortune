import pygame
from pygame.locals import *

def Screen(Full_or_Window='Full'):
    pygame.init()
    pygame.display.set_caption('Garrett, Cheng, Howard & Eidels. 2018')
    pygame.mouse.set_visible(False)
    infoObject = pygame.display.Info()
    (WINDOW_WIDTH, WINDOW_HEIGHT) = (infoObject.current_w, infoObject.current_h)
    if Full_or_Window == 'Full':
        DISPLAYSURF = pygame.display.set_mode((WINDOW_WIDTH,WINDOW_HEIGHT), pygame.FULLSCREEN)
    else:
        DISPLAYSURF = pygame.display.set_mode((WINDOW_WIDTH,WINDOW_HEIGHT))
    return (DISPLAYSURF, WINDOW_WIDTH, WINDOW_HEIGHT)


DISPLAYSURF, WINDOW_WIDTH, WINDOW_HEIGHT = Screen('Full')

