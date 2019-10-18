function [ data, fname, txt ] = f_LoadSave( loadpath, savepath )
%Function to load CSV files and save them as .mat for quick recall

    if ~exist('savepath', 'var')
        savepath = fullfile( fileparts( fileparts((char(loadpath)) )), 'Mat');
    end
    if exist(savepath,'dir') ~= 7; mkdir( savepath ); end
    
    [~,fname] = fileparts( char(loadpath) );

    try
        data = load(char(strcat(savepath, filesep, fname, '.mat')));
        data = data.data;
        txt  = load(char(strcat(savepath, filesep, 'txt', fname, '.mat')));
        txt  = txt.txt;
        
    catch
        try
            [data,txt] = xlsread(char(loadpath));
        catch
            [data,txt] = xlsread(char(strcat(loadpath, filesep, fname)));
        end
        save(char(strcat(savepath, filesep, fname, '.mat')), 'data');
        save(char(strcat(savepath, filesep, 'txt', fname, '.mat')), 'txt');
    end

end