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

%% Plot Staircase Example
close; 
figure(1);
set(gcf, 'Position', get(0, 'Screensize'), 'color','w');
x = 20; y = 10;
f_subplot_tight(x,y, 1:90, [.1, .07] );

% Example Participant
p = 23;

ContrastVect = Data.PracticeContrast(:,p);
k = length(ContrastVect);
MeanContrast = nanmean(ContrastVect(end-29:end,:));

plot( 1:k-29, ContrastVect(1:k-29)', 'k', 'linewidth', 2.5 ); hold all
Line(1) = plot( k-29:k, ContrastVect(k-29:k)', 'color', v.c.ENG, 'linewidth', 2.5 );
Line(2) = plot( 1:k, repmat( MeanContrast, [1, k]), 'r--', 'linewidth', 2 );
xticks([0,15,30,45,60,75,90,105,120,135]);
set(gca, 'linewidth', 2,'fontweight','bold','fontsize',18, 'box','off','TickLabelInterpreter','LaTeX');

ylabel('\bf Staircase Contrast ($RGB$)', 'FontWeight', 'bold', 'FontSize', 16,'Interpreter', 'LaTeX');
xlabel('\bf Trial Number', 'FontWeight', 'bold', 'FontSize', 16,'Interpreter', 'LaTeX');
title('\bf Staircase Example - Participant S1 Arabic Numerals', 'FontWeight', 'bold', 'FontSize', 20,'Interpreter', 'LaTeX' );

ylim([129,155]); xlim([1,k]);
rectangle('Position',[106,130.5,29,8], 'FaceColor', [1,1,0,.15], 'EdgeColor', [1,1,0,1], 'LineWidth',2,'LineStyle','-' );

legend(Line, {'\bf Assessment Trials (N = 30)', '\bf Assessment Mean Contrast'},'fontsize',16, 'NumColumns', 1, 'location', 'northeast','box','off','interpreter','latex')

% Violin Plots of n-30 Staircase Trials
%data
d = [Data.PracticeContrast(end-29:end,23:33), zeros(30,1), Data.PracticeContrast(end-29:end,1:11), ...
    zeros(30, 1), Data.PracticeContrast(end-29:end,34:44), zeros(30,1), Data.PracticeContrast(end-29:end,12:22)];
%colors
c = vertcat( repmat(v.c.ENG, [11, 1]), [0,0,0], repmat(v.c.CHN, [11, 1]), [0,0,0], repmat(v.c.THI, [11, 1]), [0,0,0], repmat(v.c.DOT, [11, 1]));

f_subplot_tight(x,y, 120:200, [.1, .07] );
%violin plot
[~,l] = violin(d, 'facecolor', c, 'edgecolor', [], 'bw', .9, 'mc', 'k', 'medc', []); set(l,'visible','off'); hold all;
%legend scatter plots
l(1) = scatter(1,1, 1, 's', 'MarkerFaceColor', v.c.ENG, 'MarkerEdgeColor', v.c.ENG, 'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5); 
l(2) = scatter(1,1, 1, 's', 'MarkerFaceColor', v.c.CHN, 'MarkerEdgeColor', v.c.CHN, 'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5); 
l(3) = scatter(1,1, 1, 's', 'MarkerFaceColor', v.c.THI, 'MarkerEdgeColor', v.c.THI, 'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5); 
l(4) = scatter(1,1, 1, 's', 'MarkerFaceColor', v.c.DOT, 'MarkerEdgeColor', v.c.DOT, 'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5); 

set(gca, 'linewidth', 2,'fontweight','bold','fontsize',18, 'box','off','TickLabelInterpreter','LaTeX','xTick',[1,11,13,23,25,35,37,47],'xTickLabels',{'S1','S11','S1','S11','S1','S11','S1','S11'});

ylabel('\bf Contrast ($RGB$)', 'FontWeight', 'bold', 'FontSize', 16,'Interpreter', 'LaTeX');
xlabel('\bf Participant by Lanuage-Type', 'FontWeight', 'bold', 'FontSize', 16,'Interpreter', 'LaTeX');
title('\bf Mean Assessment Contrast', 'FontWeight', 'bold', 'FontSize', 20,'Interpreter', 'LaTeX' );

%legend(l, {'\bf ARABIC', '\bf CHINESE', '\bf THAI', '\bf DOTS'},'fontsize',16, 'NumColumns', 4, 'location', 'northwest', 'interpreter', 'latex')
ylim([127.5,142.5]); xlim([0,48])

%highlight example subject
rectangle('Position',[0.6,129,.8,11], 'FaceColor', [1,1,0,.15], 'EdgeColor', [1,1,0,1], 'LineWidth',2,'LineStyle','-' );
%separate Lang Types
rectangle('Position',[12,128,.1,12], 'FaceColor', [.5 .5 .5], 'EdgeColor', [.5 .5 .5], 'LineWidth',.05,'LineStyle','-' );
rectangle('Position',[24,128,.1,12], 'FaceColor', [.5 .5 .5], 'EdgeColor', [.5 .5 .5], 'LineWidth',.05,'LineStyle','-' );
rectangle('Position',[36,128,.1,12], 'FaceColor', [.5 .5 .5], 'EdgeColor', [.5 .5 .5], 'LineWidth',.05,'LineStyle','-' );
%Add means to axis
M = [ mean(mean(d(:,1:11))), mean(mean(d(:,13:23))), mean(mean(d(:,25:35))), mean(mean(d(:,37:47))) ];
rectangle('Position',[0,M(1),.5,.4], 'FaceColor', v.c.a.ENG, 'EdgeColor', [0,0,0,0], 'LineWidth',.05,'LineStyle','-' );
rectangle('Position',[0,M(2),.5,.6], 'FaceColor', v.c.a.CHN, 'EdgeColor', [0,0,0,0], 'LineWidth',.05,'LineStyle','-' );
rectangle('Position',[0,M(3),.5,.4], 'FaceColor', v.c.a.THI, 'EdgeColor', [0,0,0,0], 'LineWidth',.05,'LineStyle','-' );
rectangle('Position',[0,M(4),.5,.4], 'FaceColor', v.c.DOT,   'EdgeColor', [0,0,0,0], 'LineWidth',.05,'LineStyle','-' );

annotation(gcf,'textbox',...
    [0.140824304538799 0.37068345323741 0.1780629575402635 0.0460431654676259],...
    'String','\bf ARABIC','interpreter','latex','fontsize',18,'color',v.c.ENG,'edgecolor','none');

annotation(gcf,'textbox',...
    [0.340824304538799 0.37068345323741 0.1780629575402635 0.0460431654676259],...
    'String','\bf CHINESE','interpreter','latex','fontsize',18,'color',v.c.CHN,'edgecolor','none');

annotation(gcf,'textbox',...
    [0.575824304538799 0.37068345323741 0.1380629575402635 0.0460431654676259],...
    'String','\bf THAI','interpreter','latex','fontsize',18,'color',v.c.THI,'edgecolor','none');

annotation(gcf,'textbox',...
    [0.790824304538799 0.37068345323741 0.1380629575402635 0.0460431654676259],...
    'String','\bf DOTS','interpreter','latex','fontsize',18,'color',v.c.DOT,'edgecolor','none');

f_SaveFig(gcf, fullfile(v.path.fig, 'Staircase.jpg'), 1000, true);
clearvars -except Data v

%% Accuracy x Contrast Level Analysis
clearvars -except Data v
close
Mx = .11; My = .08;

Cnt = permute( Data.exp(:,12,:), [1,3,2]);
cnt = nan(5,size(Cnt,2));
for ii = 1:size(Cnt,2)
    cnt(:,ii) = unique(Cnt(:,ii));
end

% Plot Figure Subplots
figure(1); set(gcf, 'Position', get(0, 'Screensize'), 'color','w');
x = 10; y = 10;

D = permute( nanmean(Data.ContrastLvl), [3,2,1]);
pos = 1:size(D,2);
ii = [1:11;12:22;23:33;34:44]';

for j = 1:4
    M(j,:) = nanmean(D(ii(:,j),:));
    SE(j,:) = nanstd(D(ii(:,j),:)) ./ sqrt( sum(~isnan( D(ii(:,j),:) )));
end

f_subplot_tight(x,y, [1:5,11:15,21:25,31:35], [Mx, My] );
Colors = [v.c.ENG; v.c.CHN; v.c.THI; v.c.DOT];
P = [-.15, -.05, .05, .15];

for j = 1:4
    errorbar( pos+P(j), M(j,:), SE(j,:), 'o', 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'w', 'color', Colors(j,:), 'linewidth', 2, 'markersize', 9); hold all;
    l(j) = scatter ( pos+P(j), M(j,:), 120, 'd', 'MarkerFaceColor', Colors(j,:), 'MarkerEdgeColor', Colors(j,:), 'MarkerFaceAlpha', .7, 'MarkerEdgeAlpha', .7, 'linewidth', 2);
end

ylim([0,1]); xlim([.5, 5.5]);
ylabel('\bf Accuracy', 'FontWeight', 'bold', 'FontSize', 16,'Interpreter', 'LaTeX');
xlabel('\bf Contrast Level', 'FontWeight', 'bold', 'FontSize', 16,'Interpreter', 'LaTeX');
title('\begin{tabular}{c} \bf Mean Accuracy by Contrast Level \\ \bf and Language-Type \end{tabular}', 'FontWeight', 'bold', 'FontSize', 18,'Interpreter', 'LaTeX' );
set(gca, 'linewidth', 2,'fontweight','bold','fontsize',16, 'box','off','TickLabelInterpreter','LaTeX', 'xticklabels', {'\bf 1','\bf Critical','\bf 3','\bf 4','\bf 5'} );
legend(l, {'\bf ARABIC', '\bf CHINESE', '\bf THAI', '\bf DOTS'},'fontsize',15, 'NumColumns', 2, 'location', 'southeast', 'interpreter', 'latex','box','off')
text( 0.5, 1.1, '\bf a)', 'fontsize', 24, 'interpreter', 'latex');
clearvars -except Data v Mx My x y Cnt cnt
% Block Accuracy Example

D = permute( nanmean(Data.BlockAcc(:,:,:)), [3,2,1]);
pos = 1:size(D,2);
ii = [1:11;12:22;23:33;34:44];
for j = 1:4
    M(j,:) = nanmean(D(ii(:,j),:));
    SE(j,:) = nanstd(D(ii(:,j),:)) ./ sqrt( sum(~isnan( D(ii(:,j),:) )));
end
f_subplot_tight(x,y, [6:10,16:20,26:30,36:40], [Mx, My] );
Colors = [v.c.ENG; v.c.CHN; v.c.THI; v.c.DOT];
P = [-.15, -.05, .05, .15];
for j = 1:4
    errorbar( pos+P(j), M(j,:), SE(j,:), 'o', 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'w', 'color', Colors(j,:), 'linewidth', 2, 'markersize', 9); hold all;
    l(j) = scatter ( pos+P(j), M(j,:), 120, 'd', 'MarkerFaceColor', Colors(j,:), 'MarkerEdgeColor', Colors(j,:), 'MarkerFaceAlpha', .7, 'MarkerEdgeAlpha', .7, 'linewidth', 2);
end

ylabel('\bf Accuracy', 'FontWeight', 'bold', 'FontSize', 16,'Interpreter', 'LaTeX');
xlabel('\bf Block', 'FontWeight', 'bold', 'FontSize', 16,'Interpreter', 'LaTeX');
title('\begin{tabular}{c} \bf Mean Accuracy by Block \\ \bf and Language-Type \end{tabular}', 'FontWeight', 'bold', 'FontSize', 18,'Interpreter', 'LaTeX' );

ylim([0,1]); xlim([.5, 13.5]);
set(gca, 'linewidth', 2,'fontweight','bold','fontsize',16, 'box','off','TickLabelInterpreter','LaTeX');
legend(l, {'\bf ARABIC', '\bf CHINESE', '\bf THAI', '\bf DOTS'},'fontsize',15, 'NumColumns', 2, 'location', 'southeast', 'interpreter', 'latex','box','off')
text( 0.5, 1.1, '\bf b)', 'fontsize', 24, 'interpreter', 'latex');
%
% Accuracy by Critical Contrast Level, Per Subject
f_subplot_tight(x,y, [51:55,61:65,71:75,81:85,91:95], [Mx, My] );
C = cnt(4,:);
M = mean(Data.Acc,2)';

R2 = corr(C', M') ^ 2; 
m = polyfit(C, M, 1);
equation = strcat( {'\begin{tabular}{l} \bf y = '}, num2str(round(m(1),3)), {' * x + '}, num2str(abs(round(m(2),3))), {'\\ \bf $r^2_{Linear}$ = '}, num2str(round(R2,3)), {' \end{tabular}'} );

scatter( C, M, 'markeredgecolor', 'w' ); hold all;
h = lsline(gca); h.Color = 'k'; h.LineWidth = 2;
MS = 150;
l(1) = scatter( C(23:33)-.15, M(23:33), MS, 'd', 'markerfacecolor', v.c.ENG, 'markeredgecolor', v.c.ENG, 'markerfacealpha', .7, 'markeredgealpha', 1.0);
l(2) = scatter( C( 1:11)+-.05, M( 1:11), MS, 'd', 'markerfacecolor', v.c.CHN, 'markeredgecolor', v.c.CHN, 'markerfacealpha', .7, 'markeredgealpha', 1.0);
l(3) = scatter( C(34:44)+.05, M(34:44), MS, 'd', 'markerfacecolor', v.c.THI, 'markeredgecolor', v.c.THI, 'markerfacealpha', .7, 'markeredgealpha', 1.0);
l(4) = scatter( C(12:22)+.15, M(12:22), MS, 'd', 'markerfacecolor', v.c.DOT, 'markeredgecolor', v.c.DOT, 'markerfacealpha', .7, 'markeredgealpha', 1.0);

text( 132.75, .85, equation, 'interpreter', 'latex', 'fontsize', 14);
ylim([0,1]); xlim([132.5, 137.5])
set(gca, 'linewidth', 2,'fontweight','bold','fontsize',16, 'box','off','TickLabelInterpreter','LaTeX');
legend(l, {'\bf ARABIC', '\bf CHINESE', '\bf THAI', '\bf DOTS'},'fontsize',15, 'NumColumns', 2, 'location', 'southeast', 'interpreter', 'latex','box','off')

title('\begin{tabular}{c} \bf Mean Accuracy by Critical Contrast, \\ \bf Participant and Language-Type \end{tabular}', 'FontWeight', 'bold', 'FontSize', 18,'Interpreter', 'LaTeX' );
ylabel('\bf Accuracy', 'FontWeight', 'bold', 'FontSize', 16,'Interpreter', 'LaTeX');
xlabel('\bf Target Contrast ($RGB$)', 'FontWeight', 'bold', 'FontSize', 16,'Interpreter', 'LaTeX');

text( 132.5, 1.1, '\bf c)', 'fontsize', 24, 'interpreter', 'latex');

% Accuracy Matched For Five Contrast Levels
f_subplot_tight(x,y, [56:60,66:70,76:80,86:90,96:100], [Mx, My] );
D = permute( nanmean(Data.ContrastLvl), [3,2,1]);
C = permute(cnt, [2,1]);
I = [23:33; 1:11; 34:44; 12:22]';
U = unique(C);
P = repmat(1:44,[4,1])';

MM = nan( 4, length(U) ); MMse = MM;

for Lang = 1:4
    for Contrasts = 1:length(U)
        d = D;
        d( C~=U(Contrasts) ) = nan;
        LangCont = d(I(:,Lang),:);
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

errorbar( U-.15, MM(1,:), MMse(1,:), 'd', 'color', v.c.ENG,'markerfacecolor','w', 'markeredgecolor', 'w', 'linewidth',2, 'markersize', 10 ); hold all;
errorbar( U-.05, MM(2,:), MMse(2,:), 'd', 'color', v.c.CHN,'markerfacecolor','w', 'markeredgecolor', 'w', 'linewidth',2, 'markersize', 10 );
errorbar( U+.05, MM(3,:), MMse(3,:), 'd', 'color', v.c.THI,'markerfacecolor','w', 'markeredgecolor', 'w', 'linewidth',2, 'markersize', 10 );
errorbar( U+.15, MM(4,:), MMse(4,:), 'd', 'color', v.c.DOT,'markerfacecolor','w', 'markeredgecolor', 'w', 'linewidth',2, 'markersize', 10 );

l(1) = scatter( U-.15, MM(1,:), MS, 'd', 'markerfacecolor', v.c.ENG, 'markeredgecolor', v.c.ENG, 'markerfacealpha', .7, 'markeredgealpha', 1.0);
l(2) = scatter( U-.05, MM(2,:), MS, 'd', 'markerfacecolor', v.c.CHN, 'markeredgecolor', v.c.CHN, 'markerfacealpha', .7, 'markeredgealpha', 1.0);
l(3) = scatter( U+.05, MM(3,:), MS, 'd', 'markerfacecolor', v.c.THI, 'markeredgecolor', v.c.THI, 'markerfacealpha', .7, 'markeredgealpha', 1.0);
l(4) = scatter( U+.15, MM(4,:), MS, 'd', 'markerfacecolor', v.c.DOT, 'markeredgecolor', v.c.DOT, 'markerfacealpha', .7, 'markeredgealpha', 1.0);

set(gca, 'linewidth', 2,'fontweight','bold','fontsize',16, 'box','off','TickLabelInterpreter','LaTeX');
ylim([0,1]); xlim([min(U)-.5, max(U)+.5])
legend(l, {'\bf ARABIC', '\bf CHINESE', '\bf THAI', '\bf DOTS'},'fontsize',15, 'NumColumns', 2, 'location', 'southeast', 'interpreter', 'latex','box','off')

title('\begin{tabular}{c} \bf Mean Accuracy Matched \\ \bf by Contrast Level \end{tabular}', 'FontWeight', 'bold', 'FontSize', 18,'Interpreter', 'LaTeX' );
ylabel('\bf Accuracy', 'FontWeight', 'bold', 'FontSize', 16,'Interpreter', 'LaTeX');
xlabel('\bf Target Contrast ($RGB$)', 'FontWeight', 'bold', 'FontSize', 16,'Interpreter', 'LaTeX');

text( 129.5, 1.1, '\bf d)', 'fontsize', 24, 'interpreter', 'latex');


% T-tests between Matched Means
%ttest(


f_SaveFig(gcf, fullfile(v.path.fig, 'AccuracyByContrast.jpg'), 1000, true);
clearvars -except Data v

%% Resp Acc x Resp Freq
cd('C:\Users\c3130234\Desktop\MDS Analysis Paper\Analysis');
run('s_VariableDataLoad.m');
%%
clearvars -except Data v
close 
p = 23; Mx = .1; My = .1;
figure(1); set(gcf, 'Position', get(0, 'Screensize'), 'color', 'w');

%f_subplot_tight(2,2,1, [My, Mx])
f_subplot_tight(100,2,[1:2:85], [My, Mx])
fq = nan(1,9);
for rsp = 1:9
    fq(rsp) = sum(sum(Data.Response(:,:,p)==rsp));
end
fq1 = fq / size(Data.Response,1);
[ax, p1, p2]=plotyy(1:9,fq1,1:9,nanmean(Data.RespAcc(:,:,p))); hold all;
scatter(ax(1),[1,2,3,4,5,6,7,8,9],fq1, 40, 'o', 'filled', 'MarkerEdgeColor', [0,.2,1],'MarkerFaceColor', [0,.2,1], 'linewidth', 1.5);
text([1.05,2.05,3.1,4.1,5.1,6.1,7.1,7.7,9.1] ,fq1, v.ENG, 'interpreter', 'latex','fontsize',20, 'color', [0,.2,1]);

set( p1, 'LineStyle', 'none' );
hold(ax(2),'on')
scatter(ax(2),[1.1,2,3,4,5,6,7,7.8,8.7] ,nanmean(Data.RespAcc(:,:,p)), 40, 'd', 'filled', 'MarkerEdgeColor', [ 0.91 0.41 0.17],'MarkerFaceColor', [ 0.91 0.41 0.17], 'linewidth', 1.5);
text(ax(2), [1.15, 2.05, 3.1, 4.1, 5.1, 5.7, 7.1, 7.9, 8.8], nanmean(Data.RespAcc(:,:,p)), v.ENG, 'interpreter', 'latex','fontsize',20, 'color', [ 0.91 0.41 0.17]);

set( p2, 'LineStyle', 'none' ); ylim(ax(2),[0  1]); ylim(ax(1), [0,2]);
set(ax(1),'Box','off', 'TickLabelInterpreter','LaTeX','fontsize', 16, 'ytick', [0,1,2]); set(ax(2),'Box','off', 'TickLabelInterpreter','LaTeX','fontsize', 14, 'ytick',[0,.5,1]);

ylabel(ax(1), '\bf Resp Frequency','interpreter','latex','fontsize',16);
ylabel(ax(2), '\bf Resp Accuray','interpreter','latex','fontsize',16);
xlabel('\bf Stimulus Number','interpreter','latex','fontsize',16);
title('\begin{tabular}{c} \bf Response Freq by Response Accuracy \\ \bf Participant S1 - Arabic \end{tabular}', 'interpreter','latex','fontsize',16);

xlim([0.3,9.5])
plot(ax(2),0:14, repmat(Data.TotalAcc(p), 15), '--', 'color', [ 0.91 0.41 0.17], 'linewidth',1.5);  
L(1) = plot([-1,-1],[-1,-1], '--', 'linewidth',1,'color',[ 0.91 0.41 0.17]);

% Caculate Rank Order Correlation and Add to Legend...
M = nanmean(Data.RespAcc(:,:,p));
[c, cp] = corr(fq', M', 'type', 'kendall');
corval = num2str(round(c,2));
if cp <= 0.001; corval = strcat(corval, '***');
elseif cp <= 0.01; corval = strcat(corval, '**');
elseif cp <= 0.05; corval = strcat(corval, '*');
end
L(2) = plot([-1,-1],[-1,-1], 'linestyle','none');
legend( L, { '\bf Mean Acc', char(strcat({'\bf $\rho$ = '}, corval)) }, 'NumColumns', 1, 'interpreter','latex','fontsize',13,'box','off','location','best')

text( 0.2, 2.3, '\bf a)', 'fontsize', 24, 'interpreter', 'latex');

clearvars -except Data v Mx My

% Accuracy by Response Frequency, by Subject by Stimulus Number
%f_subplot_tight(2, 2, 2, [My, Mx])
f_subplot_tight(100,2,[2:2:86], [My, Mx])

A = permute( nanmean(Data.RespAcc), [3,2,1]);
R = permute( nansum(Data.RespFq) / (1170/9), [3,2,1]);
Rows = [23:33; 1:11; 34:44; 12:22];
Colors = [v.c.ENG; v.c.CHN; v.c.THI; v.c.DOT];
for row = 1:4
    for col = 1:9
        l(row)= scatter(R(Rows(row,:),col), A(Rows(row,:),col), 50, 'o', 'MarkerFaceColor', Colors(row,:), 'MarkerEdgeColor', Colors(row,:), 'MarkerEdgeAlpha', .7, 'MarkerFaceAlpha',.7); hold all;
    end
end

[Cor, pval] = corr( reshape(A, [1, size(A,1)*size(A,2)])', reshape(R, [1, size(R,1)*size(R,2)])' );

ylabel('\bf Mean Accuracy','interpreter','latex','fontsize',14);
xlabel('\bf Response Freq','interpreter','latex','fontsize',14);
title('\begin{tabular}{c} \bf Mean Accuracy by Response Freq, \\ \bf Participant and Stimulus \end{tabular}', 'interpreter','latex','fontsize',16);
set(gca, 'Box','off', 'TickLabelInterpreter','LaTeX','fontsize', 16 );
legend(l, {'\bf ARABIC', '\bf CHINESE', '\bf THAI', '\bf DOTS'},'fontsize',12, 'NumColumns', 1, 'location', 'southeast', 'interpreter', 'latex','box','off')
text(.1, .9, strcat({'\bf $\rho$ = '}, num2str(round(Cor,2)),'***'), 'fontsize', 15, 'interpreter','latex');
xlim([0,2.7])
text( 0.001, 1.15, '\bf b)', 'fontsize', 24, 'interpreter', 'latex');

clearvars -except Data v Mx My

% Average Accuracy by Response Frequency for All Lanuage Types

A = permute( nanmean(Data.RespAcc), [3,2,1]);
R = permute( nansum(Data.RespFq) / (1170/9), [3,2,1]);
Rows = [23:33; 1:11; 34:44; 12:22];

Acc2 = [ nanmean( A(Rows(1,:), :) ), -1,  nanmean( A(Rows(2,:), :) ), -1, nanmean( A(Rows(3,:), :) ), -1, nanmean( A(Rows(4,:), :) ) ];
Fq2  = [ nanmean( R(Rows(1,:), :) ), -1,  nanmean( R(Rows(2,:), :) ), -1, nanmean( R(Rows(3,:), :) ), -1, nanmean( R(Rows(4,:), :) ) ];

Acc = [ nanmean( A(Rows(1,:), :) ); nanmean( A(Rows(2,:), :) ); nanmean( A(Rows(3,:), :) ); nanmean( A(Rows(4,:), :) ) ];
Fq  = [ nanmean( R(Rows(1,:), :) ); nanmean( R(Rows(2,:), :) ); nanmean( R(Rows(3,:), :) ); nanmean( R(Rows(4,:), :) ) ];

%f_subplot_tight(2,2,3:4, [My, Mx])
f_subplot_tight(100,2,[110:200], [My, Mx])
[ax, p1, p2] = plotyy(1:39,Fq2,1:39,Acc2); hold all;

Org = [ 0.91 0.41 0.17];
Idx = [1:9;11:19;21:29;31:39]; Colors = [v.c.ENG; v.c.CHN; v.c.THI; v.c.DOT]; Lang = [ v.ENG; v.CHN'; v.THI'; {'' '' '' '' '' '' '' '' ''} ];
M = nanmean(Acc, 2);
for ii = 1:4
    hold(ax(1),'on')
    scatter(ax(1),Idx(ii,:), Fq(ii,:), 120, 'o', 'filled', 'MarkerEdgeColor', Colors(ii,:)*.66,'MarkerFaceColor', Colors(ii,:)*.66, 'MarkerFaceAlpha', .7, 'MarkerEdgeAlpha', .7, 'linewidth', 1.5); hold all;
    text(ax(1),Idx(ii,:),repmat(.15,[1,9]), Lang(ii,:), 'interpreter', 'latex','fontsize',20, 'color', Colors(ii,:));
    hold(ax(2),'on')
    scatter(ax(2),Idx(ii,:),Acc(ii,:), 120, 'd', 'filled', 'MarkerEdgeColor', Colors(ii,:)/4,'MarkerFaceColor', Colors(ii,:), 'MarkerFaceAlpha', .7, 'MarkerEdgeAlpha', .7, 'linewidth', 1.5); hold all;
    %text(ax(2),Idx(ii,:),Acc(ii,:), Lang(ii,:), 'interpreter', 'latex','fontsize',20, 'color', 'y');
end

set( p1, 'LineStyle', 'none','color','k' );
set( p2, 'LineStyle', 'none' );

ylim(ax(2), [0 1]); 
ylim(ax(1), [0,2]);
xlim([0., 40])
set(ax,{'ycolor'},{'k';'k'})

set(ax(1),'Box','off', 'TickLabelInterpreter','LaTeX','fontsize', 16, 'ytick', [0,1,2],'TickLength',[0,0],'linewidth',2); 
set(ax(2),'Box','off', 'TickLabelInterpreter','LaTeX','fontsize', 14, 'ytick',[0,.5,1],'TickLength',[0,0],'linewidth',2);

set(gca, 'linewidth', 2,'fontweight','bold','fontsize',16, 'box','off','TickLabelInterpreter','LaTeX','TickLength',[0.000,0.0]);
set(gca, 'xTick', [5,15,25,35],'xticklabels',{'\bf Arabic','\bf Chinese','\bf Thai','\bf Dots'})

ylabel(ax(1), "\bf Resp Frequency",'interpreter','latex','fontsize',16,'color','k');
ylabel(ax(2), "\bf Resp Accuray",'interpreter','latex','fontsize',16);
xlabel('\bf Stimulus by Language-Type','interpreter','latex','fontsize',16);
title('\begin{tabular}{c} \bf Response Frequency and Mean Accuracy \\ \bf Across Stimuli and Language-Type \end{tabular}', 'interpreter','latex','fontsize',16);

rectangle('Position',[10,.1,.05,1.8], 'FaceColor', [.5,.5,.5], 'EdgeColor', [.5,.5,.5], 'LineWidth',.1,'LineStyle','-' );
rectangle('Position',[20.25,.1,.05,1.8], 'FaceColor', [.5,.5,.5], 'EdgeColor', [.5,.5,.5], 'LineWidth',.1,'LineStyle','-' );
rectangle('Position',[30.25,.1,.05,1.8], 'FaceColor', [.5,.5,.5], 'EdgeColor', [.5,.5,.5], 'LineWidth',.1,'LineStyle','-' );

L(1) = scatter(ax(2),-10,-10, 'o', 'MarkerFaceColor','k','MarkerEdgeColor','k');
L(3) = scatter(ax(2),-10,-10, 'd', 'MarkerFaceColor','k','MarkerEdgeColor','k');
L(2) = plot(ax(2), -1, -1, 'k--','linewidth',2);
legend(L, {'\bf Rsp Freq', '\bf Mean Acc','\bf Rsp Acc'},'fontsize',14, 'NumColumns', 2, 'location', 'northwest','box','off','interpreter','latex');

for ii = 1:4
    plot(ax(2), Idx(ii,:), repmat(M(ii), 9), 'linestyle', '--','color', Colors(ii,:), 'linewidth', 1.5);
end
text( 0.01, 2.2, '\bf c)', 'fontsize', 24, 'interpreter', 'latex');

[Ec, Ep] = corr(Fq(1,:)', Acc(1,:)', 'type', 'kendall');
[Cc, Cp] = corr(Fq(2,:)', Acc(2,:)', 'type', 'kendall');
[Tc, Tp] = corr(Fq(3,:)', Acc(3,:)', 'type', 'kendall');
[Dc, Dp] = corr(Fq(4,:)', Acc(4,:)', 'type', 'kendall');

text( 0.5,  .4, '\bf $\rho$ = .67*', 'fontsize', 15, 'interpreter', 'latex');
text( 10.5, .4, '\bf $\rho$ = .5', 'fontsize', 15, 'interpreter', 'latex');
text( 20.8, .4, '\bf $\rho$ = .33', 'fontsize', 15, 'interpreter', 'latex');
text( 30.8, .4, '\bf $\rho$ = .72**', 'fontsize', 15, 'interpreter', 'latex');

%
s = .705; d = .019;
G = repmat( reshape(v.c.DOT, [1,1,3]), [size(v.img.dot{1},1), size(v.img.dot{1},2), 1]); 

axes('pos',[.702, .11, .035, .035]); I = repmat(v.img.dot{1}, [1,1,3]); I(I==0) = G(I==0);  imshow( I );
axes('pos',[.722, .11, .035, .035]); I = repmat(v.img.dot{2}, [1,1,3]); I(I==0) = G(I==0);  imshow( I );
axes('pos',[.741, .11, .035, .035]); I = repmat(v.img.dot{3}, [1,1,3]); I(I==0) = G(I==0);  imshow( I );
axes('pos',[.760, .11, .035, .035]); I = repmat(v.img.dot{4}, [1,1,3]); I(I==0) = G(I==0);  imshow( I );
axes('pos',[.783, .11, .035, .035]); I = repmat(v.img.dot{5}, [1,1,3]); I(I==0) = G(I==0);  imshow( I );
axes('pos',[.804, .11, .035, .035]); I = repmat(v.img.dot{6}, [1,1,3]); I(I==0) = G(I==0);  imshow( I );
axes('pos',[.826, .11, .035, .035]); I = repmat(v.img.dot{7}, [1,1,3]); I(I==0) = G(I==0);  imshow( I );
axes('pos',[.847, .11, .035, .035]); I = repmat(v.img.dot{8}, [1,1,3]); I(I==0) = G(I==0);  imshow( I );
axes('pos',[.868, .11, .035, .035]); I = repmat(v.img.dot{9}, [1,1,3]); I(I==0) = G(I==0);  imshow( I );


%
f_SaveFig(gcf, fullfile(v.path.fig, 'AccuracyResponseFreq.jpg'), 1000, true);
clearvars -except Data v

%% Statistics - Calibration Contrast

%M = [134.136363636364,134.912121212121,135.496969696970,134.875757575758];
clearvars -except Data v
D = nanmean( Data.PracticeContrast(end-29:end,:))';
ii = [1:11;12:22;23:33;34:44];
for j = 1:4
    M(j,:) = nanmean(D(ii(j,:),:));
    SD(j,:) = nanstd(D(ii(j,:),:));
end


%% Statistics - Contrast Level
clearvars -except Data v
D = permute( nanmean(Data.ContrastLvl), [3,2,1]);
%Dm = nanmean(D, 2);
ii = [1:11;12:22;23:33;34:44];

for c = 1:5
    for j = 1:4
        M(j,c) = nanmean(D(ii(:,j),c));
        SD(j,c) = nanstd(D(ii(:,j),c));
    end
end

