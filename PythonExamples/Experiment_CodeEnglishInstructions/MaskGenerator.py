# Code to Generate Masks for the Capacity Task
# MaskGenerator

from DisplayFunctions import *

def MaskGen(NMasks=20):
    MaskDir = os.path.join( os.getcwd(), 'Masks')
    if not os.path.exists(MaskDir):
        os.makedirs(MaskDir)

    for M in range(NMasks):
        blank()
        DrawMask()
        wait_time(8)
        pygame.image.save(DISPLAYSURF, os.path.join( MaskDir, ("Mask" + str(M+1) + ".jpeg") ) )

    MaskDict = {}
    MaskDict['Mask'] = []
    for M in range(NMasks):
        MaskDir = os.path.join( os.getcwd(), 'Masks', ('Mask' + str(random.randint(1,20)) + ".jpeg" ))
        MaskImg = pygame.image.load( MaskDir )
        MaskDict['Mask'].append(MaskImg)

    return(MaskDict)

#MaskGen()
#QUIT()
