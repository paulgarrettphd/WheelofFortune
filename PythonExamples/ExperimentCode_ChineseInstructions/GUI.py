import os, sys
if sys.version_info > (3,0):
    from tkinter import *
    import tkinter.ttk as ttk
elif sys.version_info < (3,0):
    from Tkinter import *
    import ttk as ttk

class GUI():

    def __init__(self, requestMessage):
        self.root = Tk()
        self.root.title('Spin n Win: Garrett, Howard, Yang & Eidels. 2018')
        self.root.geometry("400x60")
        self.mainframe = ttk.Frame(self.root, padding = "3 3 12 12")
        self.mainframe.grid(column = 0, row = 0, sticky = (N, W, E, S))
        self.mainframe.columnconfigure(0, weight = 1)
        self.mainframe.rowconfigure(0, weight = 1)
        self.acceptInput(requestMessage)

    def acceptInput(self, requestMessage):
        mf = self.mainframe
        k = Label(mf, text = 'Participant ID', font='bold 14')
        k.grid(column = 1, row = 1, sticky = (W))
        self.ID = Entry(mf, text = 'Name')
        self.ID.grid(column = 2, row = 1, sticky = (W))
        self.ID.focus_set()
               
        b = Button(mf, text = '    Enter    ', font = 'bold 12', command = self.gettext)
        b.grid(column = 3, row = 1, sticky = (W, E))

        self.root.bind('<Return>', self.parse)
        
        for child in mf.winfo_children(): child.grid_configure(padx = 5, pady = 5)

    def parse(self, event):
        self.gettext()

    def gettext(self):
        self.string1 = self.ID.get()
        self.root.destroy()
    
    def getString(self):
        return (self.string1)

    def waitForInput(self):
        self.root.mainloop()
        
def QueryParticipantID(requestMessage=''):
    msgBox = GUI(requestMessage)
    msgBox.waitForInput()
    return msgBox.getString()


#print(QueryParticipantID())
