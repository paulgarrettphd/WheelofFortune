function [ ] = f_PlotStaircase( ContrastVect, Title, Ylimits, DisplayFigure, SaveFilePath )

    if ~exist('ContrastVect', 'var'), error('Error in f_PlotStaircase. ContrastVect must exist.'); end
    if exist('Ylimits', 'var') && isempty(Ylimits), Ylimits = [127,155]; end
    if ~exist('Ylimits', 'var'), Ylimits = [127,155]; end
    if ~exist('Title', 'var'), Title = ''; end
    if ~exist('DisplayFigure', 'var'), DisplayFigure = true; end
    if ~exist('SaveFilePath', 'var'), SaveFilePath = ''; end
    
    IsFigure = findobj('type','figure');
    SubplotCheck = 0;
    try SubplotCheck = ~isempty(get(IsFigure(1), 'children')); end
    if isempty(IsFigure)
        if ~DisplayFigure
            h = figure(1);
            set(h, 'visible','off');
        else
            figure(1);
        end
        set(gcf, 'Position', get(0, 'Screensize'));
    else
        if SubplotCheck
            h = gcf;
            set(gcf, 'Position', get(0, 'Screensize'));
        end
    end
    set(gcf, 'color','w' );
    
    plot( 1:length(ContrastVect), ContrastVect', 'k', 'linewidth', 1.5 )
    
    ylim( Ylimits );
    xlim([1, length(ContrastVect)]);
    set(gca, 'linewidth', 1,'fontweight','bold','fontsize',14, 'box','off','TickLabelInterpreter','LaTeX');
    
    ylabel('\bf Contrast ($RGB$)', 'FontWeight', 'bold', 'FontSize', 16,'Interpreter', 'LaTeX');
    xlabel('\bf Trial Number', 'FontWeight', 'bold', 'FontSize', 16,'Interpreter', 'LaTeX');
    
    if ~isempty(Title)
        title(['\bf ', Title ], 'FontWeight', 'bold', 'FontSize', 16,'Interpreter', 'LaTeX' );
    end
    
    if ~isempty(SaveFilePath)
        set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 40 20]);
        print( SaveFilePath , '-dpng', '-r400');
    end
    
    if ~DisplayFigure && SubplotCheck == 0
        try
            close(h);
        catch
            %Do Nothing
        end
    end
    
end