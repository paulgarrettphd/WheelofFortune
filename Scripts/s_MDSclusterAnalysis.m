%% Analysis for 2019 'Symbolic Wheel of Fortune' 
% Author. Paul Garrett 
% Created. 27/02/2019
% Edited.  4/03/2019

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

v.b.ENG = {'\bf 1','\bf 2','\bf 3','\bf 4','\bf 5','\bf 6','\bf 7','\bf 8','\bf 9'};
v.b.DOT = v.b.ENG; v.b.CHN = v.CHN; v.b.THI = v.THI;

v.b.f.CHN = 18; v.b.f.ENG = 14; v.b.f.DOT = 14; v.b.f.THI = 18;

% Set Default Lang Colors
v.c.ENG = [0,  .6,     1]; v.c.a.ENG = [v.c.ENG, .3];
v.c.CHN = [1,   0,   .25]; v.c.a.CHN = [v.c.CHN, .15];
v.c.THI = [.2,  .2,    1]; v.c.a.THI = [v.c.THI, .25];
v.c.DOT = [.2,  .8,   .0]; v.c.a.DOT = [v.c.DOT, .3];

v.KMcolors = [0.0745    0.6235    1.0000; ... % BLUE
             1.0000    0.4118    0.1608; ... % ORANGE
             .8     .2     1;            ... % MAGENTA
             0.0824    0.8588    0.0275; ... % GREEN
             .85, .85, .1;               ... % GOLD
             .7     0.1     0.1;         ... % RED
             .3, .3, 1 ;                 ... % PURPLE
             .0, .5, .0;                 ... % WHITE-GREEN
             .0, .0, .0];                    % WHITE

clear n

cd(v.path.data);
v.files = extractfield(dir('*csv'),'name');

% Load Data
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

%% Generate MDS w/ Clusters
clearvars -except Data v
clc

Q=.8;
q=Q; w=q*3; e=q*5; r=q*7; t=q*9;
ix = [q,w,e,r,t,q,w,e,r,t,q,...
      t,q,w,e,r,t,q,w,e,r,t];

iy = [t,t,t,t,t,r,r,r,r,r,e,...
      e,w,w,w,w,w,q,q,q,q,q];

X1 = -.7 : 0.01 : .7;
X2 = -.7 : 0.01 : .7;
[X1G, X2G] = meshgrid(X1, X2);
XGrid = [X1G(:),X2G(:)];
  
opts = statset('MaxIter', 500);
Part = [23:33,12:22; 1:11,34:44]; % ENG, DOT, CHN, THI
MaxCentroids = 8; 

Num = { {v.b.ENG; v.b.DOT}, {v.b.CHN;  v.b.THI}};
Colors = {[v.c.a.ENG; v.c.a.DOT], [v.c.a.CHN; v.c.a.THI]};
LangTxt = { {'English', 'Dots'}, {'Chinese','Thai'} };
FontSizes = { {11, 11}, {12,16} };

for Ps = 1:2
    count = 0;
    for p = Part(Ps,:)
        count = count + 1;
        
        % Make Unbias Confusion Matrix
        Cmat = confusionmat( Data.exp(:,6,p), Data.exp(:,7,p) );
        UnbiasMDSmatrix = f_quickMDS( Cmat, fullfile(v.path.home, 'MatMDS'), v.ID{p} );
        UnbiasMDS = mdscale(UnbiasMDSmatrix.sim2_fit, 2, 'Criterion', 'sstress', 'Replicates', '100', 'Options', opts);
        
        % Assess KM Centers
        for Centers = 1:MaxCentroids
            Idx(:,Centers) = kmeans(UnbiasMDS, Centers, 'replicates', 20);
        end
        BestCenterFit = evalclusters(UnbiasMDS,Idx,'CalinskiHarabasz');
        [KMindex, KMcenters] = kmeans(UnbiasMDS, BestCenterFit.OptimalK, 'Replicates',20);
        
        % Setup Figure Background
        if count == 1
            figure(1);
            set(gcf, 'Position', get(0, 'Screensize'), 'color', 'w');
            f_subplot_tight(1,1,1,[0.005,0.005])
            rectangle('Position',[0,3.2,3.3,1.6], 'FaceColor', Colors{Ps}(1,:), 'EdgeColor', 'none','LineWidth',2,'LineStyle','-' ); hold all
            rectangle('Position',[0,4.8,8.2,3.2], 'FaceColor', Colors{Ps}(1,:), 'EdgeColor', 'none','LineWidth',2,'LineStyle','-' ); 
            rectangle('Position',[4.9,3.2,3.3,1.6], 'FaceColor', Colors{Ps}(2,:), 'EdgeColor', 'none','LineWidth',2,'LineStyle','-' );
            rectangle('Position',[0,0,8.2,3.2], 'FaceColor', Colors{Ps}(2,:), 'EdgeColor', 'none','LineWidth',2,'LineStyle','-' ); 
            text(2.0,4.05,LangTxt{Ps}{1},'fontsize',20,'interpreter','latex');
            text(5.45,4.05,LangTxt{Ps}{2},'fontsize',20,'interpreter','latex');
        end
        
        if count < 12
            Numerals = Num{Ps}{1};
            F = FontSizes{Ps}{1};
        else
            Numerals = Num{Ps}{2};
            F = FontSizes{Ps}{2};
        end
        
        % Plot KM Regions 
        idx2Region = kmeans(XGrid, BestCenterFit.OptimalK, 'MaxIter',20,'Start',KMcenters); hold all;
        gscatter(XGrid(:,1)+ix(count)-.0,XGrid(:,2)+iy(count)-.0,idx2Region, v.KMcolors(1:BestCenterFit.OptimalK,:),'..',5); 
        legend(gca, 'off'); 
        
        % Plot unbias MDS Symbols
        scatter(UnbiasMDS(:,1)+ix(count), UnbiasMDS(:,2)+iy(count), 3, 'ko', 'filled', 'markeredgecolor','k');
        text(UnbiasMDS(:,1)+ix(count)+.03, UnbiasMDS(:,2)+iy(count), Numerals, 'interpreter', 'latex','fontsize',F, 'fontweight', 'bold');
        
    end
    axis square
    set(gca, 'TickLength', [0,0],'visible','off','ylim',[0,8], 'xlim', [0,8]);
    f_SaveFig(gcf, fullfile(v.path.fig, strcat('MDSunbias_', LangTxt{Ps}{1}, '_', LangTxt{Ps}{2}  ,'_Clusters.jpg')), 800, true, [0 0 20 20]);
end
    
    
%% Generate MDS w/ Clusters
clearvars -except Data v
clc

Q=.8;
q=Q; w=q*3; e=q*5; r=q*7; t=q*9;
ix = [q,w,e,r,t,q,w,e,r,t,q,...
      t,q,w,e,r,t,q,w,e,r,t];

iy = [t,t,t,t,t,r,r,r,r,r,e,...
      e,w,w,w,w,w,q,q,q,q,q];

X1 = -.7 : 0.01 : .7;
X2 = -.7 : 0.01 : .7;
[X1G, X2G] = meshgrid(X1, X2);
XGrid = [X1G(:),X2G(:)];
  
opts = statset('MaxIter', 500);
Part = [23:33,12:22; 1:11,34:44]; % ENG, DOT, CHN, THI
MaxCentroids = 8; 

Num = { {v.b.ENG; v.b.DOT}, {v.b.CHN;  v.b.THI}};
Colors = {[v.c.a.ENG; v.c.a.DOT], [v.c.a.CHN; v.c.a.THI]};
LangTxt = { {'English', 'Dots'}, {'Chinese','Thai'} };
FontSizes = { {11, 11}, {12,16} };

for Ps = 1:2
    count = 0;
    for p = Part(Ps,:)
        count = count + 1;
        
        % Make Unbias Confusion Matrix
        Cmat = confusionmat( Data.exp(:,6,p), Data.exp(:,7,p) );
        UnbiasMDSmatrix = f_quickMDS( Cmat, fullfile(v.path.home, 'MatMDS'), v.ID{p} );
        UnbiasMDS = mdscale(UnbiasMDSmatrix.sim2_fit, 2, 'Criterion', 'sstress', 'Replicates', '100', 'Options', opts);
        
        % Setup Figure Background
        if count == 1
            figure(1);
            set(gcf, 'Position', get(0, 'Screensize'), 'color', 'w');
            f_subplot_tight(1,1,1,[0.005,0.005])
            rectangle('Position',[0,3.2,3.3,1.6], 'FaceColor', Colors{Ps}(1,:), 'EdgeColor', 'none','LineWidth',2,'LineStyle','-' ); hold all
            rectangle('Position',[0,4.8,8.2,3.2], 'FaceColor', Colors{Ps}(1,:), 'EdgeColor', 'none','LineWidth',2,'LineStyle','-' ); 
            rectangle('Position',[4.9,3.2,3.3,1.6], 'FaceColor', Colors{Ps}(2,:), 'EdgeColor', 'none','LineWidth',2,'LineStyle','-' );
            rectangle('Position',[0,0,8.2,3.2], 'FaceColor', Colors{Ps}(2,:), 'EdgeColor', 'none','LineWidth',2,'LineStyle','-' ); 
            text(2.0,4.05,LangTxt{Ps}{1},'fontsize',20,'interpreter','latex');
            text(5.45,4.05,LangTxt{Ps}{2},'fontsize',20,'interpreter','latex');
        end
        
        if count < 12
            Numerals = Num{Ps}{1};
            F = FontSizes{Ps}{1};
        else
            Numerals = Num{Ps}{2};
            F = FontSizes{Ps}{2};
        end
        
        % Plot unbias MDS Symbols
        scatter(UnbiasMDS(:,1)+ix(count), UnbiasMDS(:,2)+iy(count), 3, 'ko', 'filled', 'markeredgecolor','k'); hold all
        text(UnbiasMDS(:,1)+ix(count)+.03, UnbiasMDS(:,2)+iy(count), Numerals, 'interpreter', 'latex','fontsize',F, 'fontweight', 'bold');
        
    end
    axis square
    set(gca, 'TickLength', [0,0],'visible','on','ylim',[0,8], 'xlim', [0,8]);
    f_SaveFig(gcf, fullfile(v.path.fig, strcat('MDSunbias_', LangTxt{Ps}{1}, '_', LangTxt{Ps}{2}  ,'.jpg')), 800, true, [0 0 20 20]);
end
    