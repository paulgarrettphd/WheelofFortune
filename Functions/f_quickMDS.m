function [ MDS ] = f_quickMDS( ConfusionMatrix, savedir, fname, plotiteration )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    if ~exist('ConfusionMatrix','var'),  error('Error in f_SaveLoadMDS. ConfusionMatrix must exist.'); end
    if ~exist('savedir','var'),  error('Error in f_SaveLoadMDS. savedir must exist.'); end
    if ~exist('fname','var'),  error('Error in f_SaveLoadMDS. fname must exist.'); end
    if ~exist('plotiteration','var'),  plotiteration = false; end
    
    if exist(savedir,'dir') ~= 7; mkdir( savedir ); end
    
    try
        MDS = load( fullfile( savedir, strcat(fname, '.mat') ) );
        MDS = MDS.MDS;
    catch
        fprintf(strcat('Generating New MDS for sub_', fname, '\n'));
        [MDS.bias_fit, MDS.sim_fit, MDS.sim2_fit, MDS.likelihood_fit] = f_DE_optim_Luce(ConfusionMatrix, 50, 500, 0.01, .0001, .0001, plotiteration);
        save( fullfile( savedir, strcat(fname, '.mat')), 'MDS');
    end
    
    
end

