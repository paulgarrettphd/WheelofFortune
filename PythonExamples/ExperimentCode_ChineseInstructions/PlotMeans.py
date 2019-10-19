#-*- coding: utf-8 -*-
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.backends.backend_agg as agg, matplotlib.pyplot as plt
from DisplayFunctions import *
from Variables import *


def PlotMean( List, BlockNumber, RTplot=True, FigSize=FeedbackAccuracyPlotSize, xpos=FeedbackAccuracyPlotXposition, ypos=FeedbackAccuracyPlotYposition, UPDATE=False ):
    prop = matplotlib.font_manager.FontProperties(fname='Cyberbit.ttf')
    matplotlib.rcParams.update({'font.size': 18})
    X = np.linspace(0,BlockNumber, BlockNumber+1)
    fig = pylab.figure(figsize=(FigSize, FigSize), dpi=100)
    ax=fig.gca()

    if RTplot == False:
        ax.plot(X, np.asarray(List), 'co-', linewidth=2.5, label='Acc', markeredgecolor='c', markeredgewidth=4)
        ax.set_ylim(0, 100)
        ax.set_yticks([0, 100])
        ax.tick_params(axis='y', length=0)
        ax.set_yticklabels([u'低', u'高'], rotation=45, fontproperties=prop)
        plt.title(u"平均正確率 (%)", fontsize=20, fontproperties=prop)
    else:
        ax.plot(X, np.asarray(List), 'bo-', linewidth=2.5, label='RT', markeredgecolor='b', markeredgewidth=4)
        plt.title("Avg Response Time (seconds)", fontsize=20)
        ax.set_ylim(0)
        ymax = max(ax.get_ylim()) * 1.5
        ax.set_ylim(0, ymax)
        ax.set_yticks([ ymax*.12, ymax*.88 ])
        ax.tick_params(axis='y', length=0)
        ax.set_yticklabels(['Fast RT', 'Slower RT'], rotation=90)

    plt.xticks(range(Blocks), rotation=90)
    labels = ['Prac']
    alphabet = ['0','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
    [labels.append( alphabet[i] ) for i in range(1,Blocks)]
    ax.set_xlim(-0.5, Blocks-.5)
    ax.set_xticklabels([])
    bg = str(BG[0]/255.)
    fig.patch.set_facecolor(bg)
    canvas = agg.FigureCanvasAgg(fig)
    canvas.draw()
    renderer = canvas.get_renderer()
    raw_data = renderer.tostring_rgb()
    size = canvas.get_width_height()
    surf = pygame.image.fromstring(raw_data, size, "RGB")
    screen = DISPLAYSURF
    screen.blit(surf, (int(WINDOW_WIDTH*xpos - FigSize*50) ,int(WINDOW_HEIGHT*ypos - FigSize*50) ) )

def PlotBlockBar( BlockNumber, FigSize=BlockProgressBarSize, xpos=PlotBlockBarXposition, ypos=PlotBlockBarYposition, UPDATE=False, TickLength=ProgressBarTickLength, Dimensions=BlockProgressBarDimensions ):
    matplotlib.rcParams.update({'font.size': 22})
    X = np.linspace(0,BlockNumber, BlockNumber+1)
    fig = pylab.figure(figsize=(FigSize*6, FigSize), dpi=100)
    ax=fig.gca()
    ax.barh(np.asarray([0]), np.asarray([BlockNumber+1]), align='center', color='green')
    plt.xticks(range(Blocks+1))
    ax.set_xlim(0, Blocks)
    labels = ['Prac']
    alphabet = ['0','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
    [labels.append( alphabet[i] ) for i in range(1,Blocks)]
    labels.append('End!')
    ax.set_xticklabels([])
    ax.set_ylim(-.005, .005)
    ax.get_yaxis().set_visible(False)
    ax.tick_params(axis='x', length=TickLength, width=2)
    bg = str(BG[0]/255.)
    fig.patch.set_facecolor(bg)
    canvas = agg.FigureCanvasAgg(fig)
    canvas.draw()
    renderer = canvas.get_renderer()
    raw_data = renderer.tostring_rgb()
    size = canvas.get_width_height()
    surf = pygame.image.fromstring(raw_data, size, "RGB")
    screen = DISPLAYSURF
    screen.blit( pygame.transform.scale( surf, Dimensions), (int(WINDOW_WIDTH*xpos - Dimensions[0] * .5 ) ,int(WINDOW_HEIGHT*ypos - Dimensions[1] * .5 ) ) )
    #screen.blit( pygame.transform.scale( surf, Dimensions), (int(WINDOW_WIDTH*xpos+150 ) ,int(WINDOW_HEIGHT*ypos-150 ) ) )


