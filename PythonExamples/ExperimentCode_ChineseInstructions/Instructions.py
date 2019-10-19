# -*- coding: utf-8 -*-
from Variables import *
from DisplayFunctions import *
from Colours import *
from PracticeExamples import *

def ConsentScreen(Screen):
    Draw = True
    blank()
    pygame.event.clear(pygame.KEYDOWN)

    while True:
        if Screen == 0 and Draw:
            write(u'歡迎參與符號辨識實驗', UPDATE=False)
            write(u'按空白鍵繼續', .5, .7)
            Draw = False
        elif Screen == 1 and Draw:
            write(u'這是一個符號辨識的實驗',y=.25,UPDATE=False)
            write(u'接下來這個實驗會請你看以及辨識一些快速呈現在螢幕上的符號',y=.3,UPDATE=False)
            
            write(u'這個實驗大約需要花一個小時來完成',y=.4,UPDATE=False)
            
            write(u'在過程中若有感到身體不適可以中止實驗，',y=.5,UPDATE=False)
            write(u'但仍請盡可能快速且正確的完成此測試',y=.55,UPDATE=False)
            
            write(u"閱讀完畢並同意以上資訊請按Y，或按Esc離開此實驗",y=.75,UPDATE=True)

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
            write(u'接下來的實驗，螢幕將會短暫的呈現一個壹到玖的刺激符號', .5, L1, UPDATE=False)
            write(u'並請您移動滑鼠去確認呈現的符號', .5, L2, UPDATE=False)
            dsporder = list(range(9))
            random.shuffle(dsporder)
            xco = [.27, .47, .67]; yco = [.3, .5, .7]; n = 0
            for iy in yco:
                for ix in xco:
                    DISPLAYSURF.blit( pygame.transform.scale(LoadedStim[dsporder[n]], (75, 75)), (WINDOW_WIDTH*ix ,WINDOW_HEIGHT*iy )); n+= 1
            write(u'按空白鍵繼續', .5, .85)
            Draw = False
        if Screen == 1 and Draw:
            DrawNoisyStim( WheelOrder[3], BaseStimList, UPDATE=False, BlackNumber=True )
            write(u'在每一次測試,', .5, L3, UPDATE=False)
            write(u'您會先在畫面中央', .5, L4, UPDATE=False)
            write(u'看到刺激符號，再看到圓環', .5, L5, UPDATE=False)
            write(u'按空白鍵繼續', .5, L12)
            pygame.time.set_timer(Toggle, 1200)
            Intro1 = True; Draw = False
        if Screen == 2 and Draw:
            DrawWheel(False,LoadedStimList=LoadedStim, SingleStim=WheelOrder[3] )
            write(u'用滑鼠確認呈現',  .5, L3, UPDATE=False)
            write(u'在圓環中的符號',  .5, L4, UPDATE=False)
            write(u'當游標從螢幕中央',.5, L5, UPDATE=False)
            write(u'滑過圓環的內圈',  .5, L6, UPDATE=False)
            write(u'即為您的反應時間',.5, L7, UPDATE=True)
            pygame.mouse.set_visible(True)
            mx, my = pygame.mouse.get_pos()
            MousePos = []
            FinalPos = LineCoord(4, InnerRadius)
            for i in range(1,InnerRadius+1):
                MousePos.append( LineCoord(4, i) )
            n = 0
            pygame.time.set_timer(Toggle, 5)
            Draw = False
        if Screen == 3 and Draw:
            write(u'接下來的練習將會加快速度', .5, L4, UPDATE=False)
            write(u'請移動滑鼠去確認呈現的符號', .5, L5, UPDATE=False)
            write(u'如果正確回應，內圓圈會顯示綠色', .5, L7, UPDATE=False)
            write(u'如果錯誤回應，內圓圈會顯示紅色', .5, L8, UPDATE=False)
            write(u'若一直錯誤回應，練習題將會持續直到正確回應為止', .5, L10, UPDATE=False)
            write(u'按空白鍵開始練習', .5, L12, UPDATE=True)
            Draw = False
        if Screen in range(4, 8) and Draw:
            EGstim = TrainingSet[Screen-4]
            Outcome = 0
            while Outcome == 0:
                Outcome = PracticeExamples( EGstim , LoadedStim, BaseStimList, 1000, DrawSingle=True, NoiseOn=False)
            return
        if Screen == 8 and Draw:
            write(u'您做得很好!接下來會呈現完整的圓環', .5, L4, UPDATE=False)
            write(u'請移動滑鼠去確認呈現的符號', .5, L5, UPDATE=False)
            write(u'如果正確回應，內圓圈會顯示綠色', .5, L7, UPDATE=False)
            write(u'如果錯誤回應，內圓圈會顯示紅色', .5, L8, UPDATE=False)
            write(u'若一直錯誤回應，練習題將會持續直到正確回應為止', .5, L10, UPDATE=False)
            write(u'按空白鍵開始練習', .5, L12, UPDATE=True)
            Draw = False
        if Screen in range(9, 13) and Draw:
            EGstim = TrainingSet[Screen-4]
            Outcome = 0
            while Outcome == 0:
                Outcome = PracticeExamples( EGstim , LoadedStim, BaseStimList, 1000, DrawSingle=False, NoiseOn=False)
            return
        if Screen == 13 and Draw:
            write(u'太棒了!接下來會將符號的圖片加入雜訊', .5, L2, UPDATE=False)
            write(u'這個實驗有點困難，有時候您會不知道正確的答案', .5, L3, UPDATE=False)
            write(u'假如不確定您所看到的，永遠記得盡可能的去猜您認為最符合的答案.', .5, L4, UPDATE=False)
            write(u'請移動滑鼠去確認呈現的符號', .5, L5, UPDATE=False)
            write(u'如果正確回應，內圓圈會顯示綠色', .5, L7, UPDATE=False)
            write(u'如果錯誤回應，內圓圈會顯示紅色', .5, L8, UPDATE=False)
            write(u'若一直錯誤回應，練習題將會持續直到正確回應為止', .5, L10, UPDATE=False)
            write(u'按空白鍵開始練習', .5, L12, UPDATE=True)
            Draw = False
        if Screen in range(14, 17):
            EGstim = random.randint(1,9)
            Outcome = 0
            while Outcome == 0:
                Outcome = PracticeExamples( EGstim , LoadedStim, BaseStimList, 1000, DrawSingle=False)
            return
        if Screen == 17 and Draw:
            write(u'太好了!那麼現在我們會加速符號呈現時間', .5, L4, UPDATE=False)
            write(u'記得，如果你不確定剛剛所看到的，盡可能去猜您認為最符合的答案', .5, L5, UPDATE=False)
            write(u'如果正確回應，內圓圈會顯示綠色', .5, L7, UPDATE=False)
            write(u'如果錯誤回應，內圓圈會顯示紅色', .5, L8, UPDATE=False)
            write(u'若一直錯誤回應，練習題將會持續直到正確回應為止', .5, L10, UPDATE=False)
            write(u'按空白鍵開始練習', .5, L12, UPDATE=True)
        if Screen in range(18,22):
            EGstim = random.randint(1,9)
            Outcome = 0
            while Outcome == 0:
                Outcome = PracticeExamples( EGstim , LoadedStim, BaseStimList, Stim_Display_Time, DrawSingle=False)
            return
        if Screen == 22 and Draw:
            write(u'棒極了!最後我們將在符號呈現後增加一個遮蔽畫面', .5, L3, UPDATE=False)
            write(u'這將是整個實驗所呈現的樣子', .5, L4, UPDATE=False)
            write(u'記得，如果您不確定剛剛所看到的，盡可能去猜您認為最符合的答案', .5, L5, UPDATE=False)
            write(u'如果正確回應，內圓圈會顯示綠色', .5, L7, UPDATE=False)
            write(u'如果錯誤回應，內圓圈會顯示紅色', .5, L8, UPDATE=False)
            write(u'若一直錯誤回應，練習題將會持續直到正確回應為止', .5, L10, UPDATE=False)
            write(u'按空白鍵開始練習', .5, L12, UPDATE=True)
        if Screen in range(23, 27):
            EGstim = random.randint(1,9)
            Outcome = 0
            while Outcome == 0:
                Outcome = PracticeExamples( EGstim , LoadedStim, BaseStimList, Stim_Display_Time, DrawSingle=False, Mask=True)
            return
        if Screen == 27 and Draw:
            write(u'真的太棒了!您快要完成整個練習題組了', .5, L1, UPDATE=False)
            write(u'在整個練習的過程中，您的答對率越高,接下來題目的難度會越來越困難', .5, L2, UPDATE=False)
            
            write(u'每次刺激您將會有8秒的時間去做反應', .5, L4, UPDATE=False)
            
            write(u'在練習的過程中，會回饋作答是否正確.', .5, L6, UPDATE=False)
            write(u'但在未來的正式題目，不再會提供回饋', .5, L7, UPDATE=False)

            write(u'記得，如果你不確定剛剛所看到的，盡可能去猜您認為最符合的答案', .5, L9, UPDATE=False)

            write(u'如果正確回應，內圓圈會顯示綠色', .5, L11, UPDATE=False)
            write(u'如果錯誤回應，內圓圈會顯示紅色', .5, L12, UPDATE=False)
            
            write(u'按空白鍵開始', .5, L13, UPDATE=True)
            Draw = False


        for event in pygame.event.get():
            if event.type == Toggle:
                if Screen == 1:
                    if Intro1 == True:
                        blank()
                        DrawWheel(False,LoadedStimList=LoadedStim, SingleStim=WheelOrder[3] )
                        write(u'在每一次測試,', .5, L3, UPDATE=False)
                        write(u'您會先在畫面中央', .5, L4, UPDATE=False)
                        write(u'看到刺激符號，再看到圓環', .5, L5, UPDATE=False)
                        write(u'按空白鍵繼續', .5, L12); Intro1 = False
                    else:
                        blank()
                        DrawNoisyStim( WheelOrder[3], BaseStimList, UPDATE=False, BlackNumber=True )
                        write(u'在每一次測試,', .5, L3, UPDATE=False)
                        write(u'您會先在畫面中央', .5, L4, UPDATE=False)
                        write(u'看到刺激符號，再看到圓環', .5, L5, UPDATE=False)
                        write(u'按空白鍵繼續', .5, L12); Intro1 = True
                if Screen == 2 and n < InnerRadius:
                    pygame.mouse.set_pos(MousePos[n]); n+= 1
                if Screen == 2 and n == InnerRadius:
                    write(u'按空白鍵繼續', .5, L12)
                


            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    QUIT()
                if event.key == pygame.K_SPACE:
                    if Screen in range(2):
                        pygame.time.set_timer(Toggle, 0)
                        return
                    if Screen == 2 and n == InnerRadius:
                        pygame.time.set_timer(Toggle, 0)
                        pygame.mouse.set_visible(False)
                        return
                    if Screen in [3,8,13,17,22,27]:
                        blank()
                        timer(5, r=50, linewidth=8)
                        return
