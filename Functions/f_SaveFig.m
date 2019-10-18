function [ ] = f_SaveFig( fig, savepath, dpi, saveon, dimensions )
%Function to load CSV files and save them as .mat for quick recall

    if ~exist('fig', 'var'), error('Error in f_SaveFig. fig (Figure) handle must exist.'); end
    if ~exist('savepath', 'var'), error('Error in f_SaveFig. savepath must be specified.'); end
    if ~exist('dpi', 'var'), dpi = 400; end
    if ~exist('savepath', 'var'), saveon=true; end
    if ~exist('dimensions', 'var'), dimensions=[0 0 40 20]; end
    
    dir = fileparts(char(savepath));
    if exist(dir,'dir') ~= 7; mkdir( dir ); end
    
    dpi = ['-r', num2str(dpi)];
    if saveon
        set( fig, 'PaperUnits', 'centimeters', 'PaperPosition', dimensions);
        print( char(savepath) , '-dpng', dpi);
        close();
    else
        pause;
        close()
    end
end