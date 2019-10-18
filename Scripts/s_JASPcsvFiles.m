%% Analysis for 2019 'Symbolic Wheel of Fortune' 
% JASP Data Analysis Files For Murray.
% Author. Paul Garrett 
% Created. 05/03/2019
% Edited.  05/03/2019

clc; clear; close; 
v.save = false;

if ispc, userdir= getenv('USERPROFILE');
else, userdir= getenv('HOME');
end

v.Cohort = 'English';
v.path.home = fullfile( userdir, 'Desktop', 'MDS Analysis Paper', 'Analysis' ); clear userdir; 
v.path.data = fullfile( v.path.home, 'Data' );
v.path.fig  = fullfile( v.path.home, 'Figures', v.Cohort );
v.path.fun  = fullfile( v.path.home, 'Functions' );
v.path.mat  = fullfile( v.path.home, 'Matfiles');

v.ENG = {'1','2','3','4','5','6','7','8','9'};
v.DOT = {'1','2','3','4','5','6','7','8','9'};
v.CHN = {[228,184,128];[228,186,140];[228,184,137];[229,155,155];[228,186,148];[229,133,173];[228,184,131];[229,133,171];[228,185,157]}; % UTF-8 Chinese Symbols
v.THI = {[224,185,145];[224,185,146];[224,185,147];[224,185,148];[224,185,149];[224,185,150];[224,185,151];[224,185,152];[224,185,153]}; % UTF-8 Thai Symbols

for n = 1:9
    v.CHN{n} = native2unicode(v.CHN{n}, 'UTF-8');
    v.THI{n} = native2unicode(v.THI{n}, 'UTF-8');
end

% Set Default Lang Colors
v.c.ENG = [0,  .6,     1]; v.c.a.ENG = [v.c.ENG, .7];
v.c.CHN = [1,   0,   .25]; v.c.a.CHN = [v.c.CHN, .7];
v.c.THI = [.2,  .2,    1]; v.c.a.THI = [v.c.THI, .7];
v.c.DOT = [.2,  .8,   .0]; v.c.a.DOT = [v.c.DOT, .7];

clear n

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

%% Subject Mean Acc by Lang and 5 Contrast Levels
clearvars -except Data v

Acc = permute( nanmean(Data.ContrastLvl), [3,2,1]);
T(:,1) = [1:11]';
T(:,2:6) = Acc(23:33, :);
T(:,7:11) = Acc(1:11, :);
T(:,12:16) = Acc(34:44, :);
T(:,17:21) = Acc(12:22, :);

T = array2table( T, 'VariableNames', ...
    {'Sub', 'ENG_C1','ENG_C2','ENG_C3','ENG_C4','ENG_C5', ...
    'CHN_C1','CHN_C2','CHN_C3','CHN_C4','CHN_C5', ...
    'THI_C1','THI_C2','THI_C3','THI_C4','THI_C5', ...
    'DOT_C1','DOT_C2','DOT_C3','DOT_C4','DOT_C5'}); 

writetable(T, 'C:\Users\Paul\Desktop\MDS Analysis Paper\Analysis\JASPcsv\FiveContrastAcc.csv');

%% Block Mean Accuracy by Lang
clearvars -except Data v

Acc = permute( nanmean(Data.BlockAcc(:,:,:)), [3,2,1]);
T(:,1) = [1:11]';
T(:,2:14) = Acc(23:33, :);
T(:,15:27) = Acc(1:11, :);
T(:,28:40) = Acc(34:44, :);
T(:,41:53) = Acc(12:22, :);

Names = {'Sub'}; c = 1;
for l = {'ENG_','CHN_','THI_','DOT_'}
    for b = 1:13
        c = c + 1;
        Names{c} = char(strcat(l, num2str(b)));
    end
end
T = array2table( T, 'VariableNames', Names );
writetable(T, 'C:\Users\Paul\Desktop\MDS Analysis Paper\Analysis\JASPcsv\BlockAcc.csv');

%% Matched Accuracy - By Subject
clearvars -except Data v

Cnt = permute( Data.exp(:,12,:), [1,3,2]);
cnt = nan(5,size(Cnt,2));
for ii = 1:size(Cnt,2)
    cnt(:,ii) = unique(Cnt(:,ii));
end
Acc  = permute( nanmean(Data.ContrastLvl), [3,2,1]);
Cont = permute(cnt, [2,1]);
Idx  = [23:33; 1:11; 34:44; 12:22]';
U    = unique(Cont);
P    = repmat(1:44,[4,1])';

T(:,1) = vertcat( Acc(:,1), Acc(:,2), Acc(:,3), Acc(:,4), Acc(:,5)); 
T(:,2) = vertcat( Cont(:,1), Cont(:,2), Cont(:,3), Cont(:,4), Cont(:,5)); 
T(:,3) = vertcat( repmat( vertcat( ones(11,1), ones(11,1)*2, ones(11,1)*3, ones(11,1)*4), [5,1]));
T(:,4) = repmat( (1:11)', [20,1]);

RemoveU = U([1,end]);
T( T(:,2) == RemoveU(1) | T(:,2) == RemoveU(2), : ) = [];

T = array2table( T, 'VariableNames', {'MatchedAcc','Contrast','Lang','Sub'});
writetable(T, 'C:\Users\Paul\Desktop\MDS Analysis Paper\Analysis\JASPcsv\MatchedAccBSanova.csv');

%% Matched Accuracy - By Mean
clearvars -except Data v

Cnt = permute( Data.exp(:,12,:), [1,3,2]);
cnt = nan(5,size(Cnt,2));
for ii = 1:size(Cnt,2)
    cnt(:,ii) = unique(Cnt(:,ii));
end
Acc  = permute( nanmean(Data.ContrastLvl), [3,2,1]);
Cont = permute(cnt, [2,1]);
Idx  = [23:33; 1:11; 34:44; 12:22]';
U    = unique(Cont);
P    = repmat(1:44,[4,1])';

MM = nan( 4, length(U) ); MMse = MM;

for Lang = 1:4
    for Contrasts = 1:length(U)
        d = Acc;
        d( Cont~=U(Contrasts) ) = nan;
        LangCont = d(Idx(:,Lang),:);
        LangCont(isnan(LangCont)) = [];
        
        if ~isempty(LangCont)
            MM(Lang, Contrasts) = nanmean(LangCont);
            MMse(Lang, Contrasts) = nanstd(LangCont) / sqrt(length(LangCont));
        else
            MM(Lang, Contrasts) = nan;
            MMse(Lang, Contrasts) = nan;
        end
    end
end

close all; plot( 2:8, MM(1,2:8) ); hold on; plot( 2:8, MM(2,2:8) );plot( 2:8, MM(3,2:8) );plot( 2:8, MM(4,2:8) ); legend('E','C','T','D');
Mcnd = nanmean(MM(:, 2:8), 2)'; McndSD = nanstd(MM(:,2:8)');

T(:,1) = vertcat(MM(1,2:end-1)',MM(2,2:end-1)',MM(3,2:end-1)',MM(4,2:end-1)');
T(:,2) = vertcat( ones(7,1), ones(7,1)*2, ones(7,1)*3, ones(7,1)*4 );
T(:,3) = repmat( (1:7)', [4,1]) ;

T = array2table( T, 'VariableNames', {'MatchedAcc','Lang','Contrast'});
writetable(T, 'C:\Users\Paul\Desktop\MDS Analysis Paper\Analysis\JASPcsv\MatchedMeanAccBSanova.csv');
