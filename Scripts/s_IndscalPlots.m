% Paul Garrett
% 3/3/2019
% Script Purpose:
% - Load data using pre-saved script
% - Load Inscal MDS analysis (completed in R)
% - Generate MDS inscal plots with locations superimposed by stimulus
% images
% - Generate Cluster Frequency Heatmap of each MDS plot for 2--6 cluster
% centroids. 

clc; clear; close;
cd('C:\Users\c3130234\Desktop\MDS Analysis Paper\Analysis');
run('s_VariableDataLoad.m');

cd('C:\Users\c3130234\Desktop\MDS Analysis Paper\Analysis\Indscal Analysis')
D(:,:,1) = xlsread('Rdata_ENGindscal.csv');
D(:,:,2) = xlsread('Rdata_DOTindscal.csv');
D(:,:,3) = xlsread('Rdata_CHNindscal.csv');
D(:,:,4) = xlsread('Rdata_THIindscal.csv');
D(:,1,:) = [];

cd(v.path.fun);
%% Generate basic MDS plots to check data
Name = {'English', 'Dots', 'Chinese', 'Thai'};
Col  = [ v.c.ENG; v.c.DOT; v.c.CHN; v.c.THI ];
TxT  = [ v.ENG; v.DOT; v.CHN'; v.THI' ];
F    = [35, 35, 40, 45];

for lang = 1:4
    f_subplot_tight(1,1,1, [.08, .08])
    
    h = scatter(D(:,1,lang), D(:,2,lang), 8, 'ko', 'filled', 'markeredgecolor','k'); hold all
    text(D(:,1,lang)+.05, D(:,2,lang)+.0, TxT(lang,:), 'color', 'k', 'interpreter', 'latex', 'fontsize', F(lang), 'fontweight', 'bold');

    axis square
    set(gca, 'xticklabels',[],'yticklabels',[],'xlim',[-2,2],'ylim',[-2,2],'box','on', ...
        'ycolor','k','xcolor','k','ticklength',[0.00, 0.0], 'linewidth', 2);
    
    f_SaveFig(gcf, fullfile(v.path.fig, strcat('Indscal_', Name{lang}, '.jpg')), 1000, true, [0 0 15 15]);
end

%% Indscal KMeans Cluster Analysis
clc; clear; close;
cd('C:\Users\c3130234\Desktop\MDS Analysis Paper\Analysis');
run('s_VariableDataLoad.m');

cd('C:\Users\c3130234\Desktop\MDS Analysis Paper\Analysis\Indscal Analysis')
D(:,:,1) = xlsread('Rdata_ENGindscal.csv');
D(:,:,2) = xlsread('Rdata_DOTindscal.csv');
D(:,:,3) = xlsread('Rdata_CHNindscal.csv');
D(:,:,4) = xlsread('Rdata_THIindscal.csv');
D(:,1,:) = [];

% Perform KMean analysis on each bias-free MDS inscal solution
I = 1:9;
M = zeros(9,9,4);
for lang = 1:4
    for Kn = 2:6
        Kindex = kmeans(D(:,:,lang), Kn, 'Replicates',20);
        for Ki = 1:length(unique(Kindex))
            jk = I( Kindex(:,1)==Ki );
            for j = 1:length(jk)
                for k = 1:length(jk)
                    M(jk(j), jk(k), lang) = M(jk(j), jk(k), lang) + 1;
                end
            end
        end
    end
end

% Set Colors of cluster heatmaps
v.c.DOT = [.3 .9 0];
v.c.ENG = [0 .6 .85];
v.c.CHN = [1 .0 .10];
base = [.95,.95,.95];

cd(v.path.fun);
% Figure params
figure(1);
set(gcf, 'Position', get(0, 'Screensize'), 'color', 'w');

% Subplot params
p = [1:11; 12:22; 23:33; 34:44];
% Color gradient
cn = 500; 
Name = {'\bf Arabic', '\bf Dots', '\bf Chinese', '\bf Thai'};
% Colors
Col  = [ v.c.ENG; v.c.DOT; v.c.CHN; v.c.THI ];
% Stimuli
TxT  = [ v.ENG; v.DOT; v.CHN'; v.THI' ];
% Font size
F = [14,14,16,16];

% Calculate proportional Kmean cluster heatmap. Subplot by Language Type.
% Proportions are the number of times any two items cluster together at
% each iteration of K for K in range 2--6. Proportions must be strings when
% overlaid on the heatmap. Dots must be displayed as images on the x and y
% axis.
for lang = 1:4
    m = nansum(M(:,:,lang), 3);
    m = m / 5;
    m = round(m, 2);
    Str = {};
    for ii = 1:9
        for kk = 1:9
            Str{ii,kk} = num2str(m(ii,kk));
        end
    end
    f_subplot_tight(2,2,lang,[.1,.01])
    cm = [ linspace(base(1), Col(lang,1), cn)', linspace(base(2), Col(lang,2), cn)', linspace(base(3), Col(lang,3), cn)' ];
    h = f_heatmap( (m+m')/2 , TxT(lang,:), TxT(lang,:), strrep(Str,'0.','.'), 'Colormap', cm, 'ColorLevels', 64, ...
        'ShowAllTicks', 1, 'TickFontSize', 10, 'TickTexInterpreter', 'latex', ...
        'UseFigureColormap',false, 'FontSize', 12);
    title( Name(lang), 'interpreter','latex','fontsize',16);
    set(gca,'fontsize',F(lang),'TickLength',[0.0, 0.00],'linewidth',2,'fontweight','bold')
    axis square
    
end

% Change the Xlabel and Ylabel to the Symbols
% Make Dots a symbol of its own
% Xaxis
axes('pos',[.567, .51, .033, .033]);  imshow( v.img.dot{1} );
axes('pos',[.6085, .51, .033, .033]);  imshow( v.img.dot{2} );
axes('pos',[.65, .51, .033, .033]);  imshow( v.img.dot{3} );
axes('pos',[.691, .51, .033, .033]);  imshow( v.img.dot{4} );
axes('pos',[.7325, .51, .033, .033]);  imshow( v.img.dot{5} );
axes('pos',[.774, .51, .033, .033]);  imshow( v.img.dot{6} );
axes('pos',[.8155, .51, .033, .033]);  imshow( v.img.dot{7} );
axes('pos',[.856, .51, .033, .033]);  imshow( v.img.dot{8} );
axes('pos',[.898, .51, .033, .033]);  imshow( v.img.dot{9} );

% Yaxis
axes('pos',[.52, .5515, .033, .033]);  imshow( v.img.dot{9} );
axes('pos',[.52, .592, .033, .033]);  imshow( v.img.dot{8} );
axes('pos',[.52, .6325, .033, .033]);  imshow( v.img.dot{7} );
axes('pos',[.52, .670, .033, .033]);  imshow( v.img.dot{6} );
axes('pos',[.52, .705, .033, .033]);  imshow( v.img.dot{5} );
axes('pos',[.52, .745, .033, .033]);  imshow( v.img.dot{4} );
axes('pos',[.52, .785, .033, .033]);  imshow( v.img.dot{3} );
axes('pos',[.52, .825, .033, .033]);  imshow( v.img.dot{2} );
axes('pos',[.52, .865, .033, .033]);  imshow( v.img.dot{1} );
    
%f_SuperTitle('Group Indscal', 20)

f_SaveFig(gcf, fullfile(v.path.fig, 'IndscalHeatmap.jpg'), 1000, true, [0 0 19 20]);
