%% Indscal Analysis of Group MDS data
% Analysis for 2019 'Symbolic Wheel of Fortune' 
% JASP Data Analysis Files
% Author. Paul Garrett 
% Created. 05/03/2019
% Edited.  05/03/2019

clc; clear; close; 
v.save = false;

% Check OS
if ispc, userdir= getenv('USERPROFILE');
else, userdir= getenv('HOME');
end

% Make Folders if not existant
v.Cohort = 'English';
v.path.home = fullfile( userdir, 'Desktop', 'MDS Analysis Paper', 'Analysis' ); clear userdir; 
v.path.data = fullfile( v.path.home, 'Data' );
v.path.fig  = fullfile( v.path.home, 'Figures', v.Cohort );
v.path.fun  = fullfile( v.path.home, 'Functions' );
v.path.mat  = fullfile( v.path.home, 'Matfiles');

% Allocate Stimuli per Language Type
v.ENG = {'1','2','3','4','5','6','7','8','9'};
v.DOT = {'1','2','3','4','5','6','7','8','9'};
v.CHN = {[228,184,128];[228,186,140];[228,184,137];[229,155,155];[228,186,148];[229,133,173];[228,184,131];[229,133,171];[228,185,157]}; % UTF-8 Chinese Symbols
v.THI = {[224,185,145];[224,185,146];[224,185,147];[224,185,148];[224,185,149];[224,185,150];[224,185,151];[224,185,152];[224,185,153]}; % UTF-8 Thai Symbols

% Regenerate Unicode values 
for n = 1:9
    v.CHN{n} = native2unicode(v.CHN{n}, 'UTF-8');
    v.THI{n} = native2unicode(v.THI{n}, 'UTF-8');
end

% Set Default Lang Colors
v.c.ENG = [0,  .6,     1]; v.c.a.ENG = [v.c.ENG, .25];
v.c.CHN = [1,   0,   .25]; v.c.a.CHN = [v.c.CHN, .25];
v.c.THI = [.2,  .2,    1]; v.c.a.THI = [v.c.THI, .25];
v.c.DOT = [.2,  .8,   .0]; v.c.a.DOT = [v.c.DOT, .25];

% Set KMean Colors
v.KMcolors = [.8     .2     1;            ... % MAGENTA
             1.0000    0.4118    0.1608; ... % ORANGE
             0.0745    0.6235    1.0000; ... % BLUE
             0.0824    0.8588    0.0275; ... % GREEN
             .85, .85, .1;               ... % GOLD
             0         1         1     ; ... % CYAN
             .7     0.1     0.1;         ... % RED
             .3, .3, 1 ;                 ... % PURPLE
             .0, .5, .0;                 ... % WHITE-GREEN
             .0, .0, .0];                    % WHITE

clear n

% Load Dot Image Array
cd(v.path.home);
imgarray = load('DotStim.mat');
v.img.dot = imgarray.imgarray;

cd(v.path.data);
v.files = extractfield(dir('*csv'),'name');

%% Load Data
% Rows = Trials, Col = Output Columns, 3Dim = Session (English Cohort - 11 x 4)
cd(v.path.fun);
run('s_LoadDataScript');

% Separate Prac and Exp Blocks
PracRowEnd = find(Data.raw(:,4)==0,1,'last');
Data.exp = Data.raw(PracRowEnd+1:end,:,:);
Data.prac = Data.raw(1:PracRowEnd,:,:);
Data.txt = Data.txt(PracRowEnd+2:end,:,:);

% Make all Time Out (666) trials NaN
for p = 1:size(Data.exp,3)
    Data.exp(Data.exp(:,7,p)==666,7,p) = nan;
end
clear p PracRowEnd

% Extract Key Data 
run('s_DataOrganisation.m');
fprintf('Data Loaded \n');
