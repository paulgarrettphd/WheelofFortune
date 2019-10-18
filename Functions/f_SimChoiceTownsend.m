function [ bias, sim ] = f_SimChoiceTownsend( data )
% This function applies Townsend's (1971) Estimation of Luce's Choice
% Model. This is essentially a formula that gives estimated parameters. We
% will then feed these parameters in to our DE-MCMC procedure to try and
% get a 'better' estimation of the parameters
data = data+.001; % avoid zeros
%% Transforms data into proportions if not already (ie if it is in counts)
if round(sum(sum(data))) ~= size(data, 1)
    for jj = 1:length(data)
        data(jj, :) = data(jj, :)/sum(data(jj, :));
    end
end
nstimuli = size(data, 2);
sim = zeros(nstimuli); bias = zeros(1, nstimuli); % preallocate variables
for i = 1:nstimuli % loop through stimuli
    for j = 1:nstimuli % loop through responses
        if i==j % set diagionals to 1 as per model assumptions
            sim(i, j) = 1;
        end
        %% Similarities
        sim(i, j) = ((data(i, j)*data(j, i))/(data(i, i)*data(j, j)))^(1/2);
        %% Bias (j)
        tmp = zeros(1, nstimuli);
        for k = 1:nstimuli
            tmp(k) = (1/nstimuli)*((data(j,j)*data(k, j))/(data(j, k)*data(k, k)))^(1/2);
        end
        bias(j) = (1/nstimuli)*sum(tmp);
        clear tmp
    end
end

end

