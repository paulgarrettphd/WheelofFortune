function [ bias, sim, sim2, likelihood ] = f_DE_optim_Luce( data, nchains, niters, mutation, mutation2, mutation3, PlotCheck )
if ~exist('PlotCheck', 'var'), PlotCheck = true; end
%% Function to use Differential Evolution to fit the parameters of Luce's Similarity Choice
% Model (1963) to empirical data
% Outputs the bias and similarity parameters, with options for the full
% similairty matrix and the LogLikelihood values for the final parameters
% Written by Zach Howard, PhD Candidate at UoN with Input from Nathan Evans
%% This script will use an approximation of Differential Evolution MCMC to estimate parameters of Luce's Choice Model (1963)
% DE-MCMC involves a number of chains iterating parameter values. On each step, the current parameter values for each chain are put into...
% the likelihood function for the model. Then, the values of the chain are merged with the difference of two other chains (this is a 'jump')...
% The likelihood of these new parameters is compared to the first value. If the likelihood is better, the new values are kept. If not, the old values...
% are kept until the next iteration. This occurs for all chains at every iteration. At the end, the chain whose parameters give the best likelihood of all is taken...
% as the 'best parameters'.

%% Initialise some initial parameters
if nargin==1 % if no parameters set use default values
    nchains = 50; % This the 'population', or 'N' value
    niters = 500; % This is the max number of iterations or generations to run
    mutation = .000001; % small amount of variation to avoid stuck chains
    mutation2 = .0001;
end
if nargin>1 && nargin<6 % if not enough params specified revert to default
    disp('not enough inputs, reverting to defaults for all parameters!')
    nchains = 50; % This the 'population', or 'N' value
    niters = 500; % This is the max number of iterations or generations to run
    mutation = .000001; % small amount of variation to avoid stuck chains
    mutation2 = .0001;
end
%% use data to find number of stimuli (and thus free parameters to estimate)
nstimuli = size(data, 1); % number of stimuli equal to number of rows
nparams = ((nstimuli*nstimuli - nstimuli)/2) + nstimuli; % this is the number of free parameters, equal to half of the matrix minus the diagonal;

%% Estimate starting parameter values
% This applies Townsend's (1971) estimation procedure. We use the
% parameters from this as a starting point to further optimise with DE-MCMC
[ bias_estimate, sim2_estimate ] = f_SimChoiceTownsend( data );
bias_estimate = bias_estimate./(sum(bias_estimate)); % transform bias estimate into a proportion (not sure if this is required??)
%% @@@@@@@@@@
% Here we have a choice. We can use generic starting parameters (set all
% things equal with diagonals higher), or we can start by using approximate
% parameters from Townsend's (1971) approach. I prefer Townsend's starting
% point as it gets close and we can then improve with DE-MCMC
% @@@@@@@@@@@
%xx = zeros(26); xx(logical(eye(size(xx)))) = 0.5;
%xx(~logical(eye(size(xx)))) = .5/25; % set somewhat sensible starting
%params -- use if we don't want to use Townsend's approach for start
%tmp = xx; tmp = tmp+unifrnd(mutation2, mutation, nstimuli); tmp(logical(eye(size(tmp)))) = 0; tmp = (tmp+tmp') / 2;
%params(j, :, 1) = [(unifrnd(.01, .99, 1, size(data, 2))) squareform(tmp)]; ...
% Get estimated parameters likelihood so we can see our fit improving
predicted_Townsend = f_predicted_sim_choice_Townsend(bias_estimate, sim2_estimate, size(data, 2));
likelihood_estimate = f_loglike_confusions( data, predicted_Townsend );
sim2_estimate(logical(eye(size(sim2_estimate)))) = 0;
%% preallocate variables
loglike = -Inf(niters, nchains); % start all loglikes at -Inf so we can avoid getting stuck here later on
params = zeros(nchains, nparams, niters); % preallocate parameter array
%% Set initial loglikes
for j = 1:nchains % loop over each chain
        %% This section starts the chains at townsends estimated parameters then adds or subtracts some noise
%         params(j, :, 1) = [bias_estimate squareform(sim2_estimate)]; % start params at estimated values
%         tmp = unifrnd(mutation2, mutation, 1, nparams); tmp2 = randsample([-1 1], nparams, 'true'); tmp = tmp.*tmp2;
%         params(j, :, 1) = params(j, :, 1)+tmp; ...
            % use the estimated params plus some noise based on input mutation values)
    while loglike(1, j)==-Inf % if loglike is -Inf resample values or chain will get stuck
        % set starting parameters for each variable for each chain
            params(j, :, 1) = [bias_estimate squareform(sim2_estimate)]; % start params at estimated values
            tmp = unifrnd(mutation2, mutation, 1, nparams); tmp2 = randsample([-1 1], nparams, 'true'); tmp = tmp.*tmp2;
            params(j, :, 1) = params(j, :, 1)+tmp; ...
                % use the estimated params plus some noise based on input mutation values)
        %% Check if any parameter values fall outside range 0<x<1 and correct
        if any(params(j, :, 1)>1)
            tmp3 = find(params(j, :, 1)>1);
            params(j, tmp3, 1)=.999;
            clear tmp
        end
        if any(params(j, :, 1)<0)
            tmp3 = find(params(j, :, 1)<0);
            params(j, tmp3, 1)=.001;
        end
        tmp_predicted = f_predicted_sim_choice(params(j, :, 1), nstimuli); ...
            % sample the predicted probability matrix using the initial
        % parameters for this chain
        loglike(1, j) = f_loglike_confusions(data, tmp_predicted); ...
            % compute loglike of initial params for this chain
        clear tmp_predicted tmp; % clear variable to avoid contamination
    end
end
clear j
% We now have an initial parameter set and corresponding log likelihood for
% each chain
%% Start DE optimization loop
for i = 2:niters % loop all chains for niters
    %% This section will plot the likelihood to show it decreasing over iterations
    if PlotCheck
        fprintf(1, '%.f', i);
        fprintf(1, '\n');
        figure(1)
        hold on
        figure(1)
        hold on
        plot(i-1, max(loglike(i-1, :)), '.')
        title(sprintf('Min: %.3f, Max: %.3f', min(loglike(i-1, :)), max(loglike(i-1, :))))
        plot(ones(1, i-1)*likelihood_estimate, 'r--')
        if mod(i, 10) ==0
            drawnow
        end
    end
    %% For each chain, select two other chains to use for mutation, then perform the mutation
    for chain = 1:nchains
        % sample the two chains to use
        target = params(chain, :, i-1);  % initialise target vector (last iteration values)
        index = randsample(setdiff(1:nchains, chain), 2, false); ...
            % sample two chains that are not equal to each other or the current chain
        % sample a small amount of noise so we never get stuck in one place
        % if chains converge to same spot
        tmp1 = unifrnd(-mutation, mutation, 1,1);
        tmp2 = unifrnd(-mutation, mutation, 1,1);
        r = (tmp2-tmp1).*rand(1, nparams) + tmp1; % this samples the noise uniformly
        %r = normrnd(mutation, mutation3, 1, nparams);
        clear tmp1 tmp2
        F = 2.38 / sqrt(2*nparams); % This is a standard in the literature
        donor = target + F*(params(index(1), :, i-1)- params(index(2), :, i-1)) + r;...
            % donor parameters for chain equal the weighted difference of two
        % other chains + the current. F is the weight and is a constant. Also
        % adds a small amount of noise to avoid getting stuck
        % ## Donor vector is what we test against the target vector
        %% Bounded parameters
        % ## All parameters must be on the range 0<=x<=1 this code limits
        % all values to this range. If outside we simply reject the donor
        if any(donor>1)            
            donor=target;            
        end
        if any(donor<0)
            donor=target;
        end
        %% Log likelihood of trial and target vectors
        tmp_predicted1 = f_predicted_sim_choice(target, nstimuli); ...
            % sample the predicted probability matrix using the target
        % params
        tmp_predicted2 = f_predicted_sim_choice(donor, nstimuli); ...
            % sample the predicted probability matrix using the trial
        % params
        like1 = f_loglike_confusions(data, tmp_predicted1); ...
            % compute loglike of target params for this chain
        like2 = f_loglike_confusions(data, tmp_predicted2); ...
            % compute loglike of trial params for this chain
        %% Compare Likelihoods of Target and Donor Parameters
        if like1>=like2 % If old parameters are better, keep those for next iteration
            params(chain, :, i) = target;
            loglike(i, chain) = like1;
        elseif like2>like1 % If new parameters are better, keep those for next iteration
            params(chain, :, i) = donor;
            loglike(i, chain) = like2;
            %disp(sprintf('chain %.d updated', chain))
        end
        clear like1 like2 tmp_predicted1 tmp_predicted2 trial target donor p_comb Irand index r
        
    end
    % Now we have completed chain j for iteration i and successfully
    % updated the estimated parameters
    
end
%% Find best chain
bestindex = find(loglike(niters, :)==max(loglike(niters,:)));
likelihood = loglike(niters, bestindex);
best_params = params(bestindex, :, niters);
%% Create matrix of similarities
bias = best_params(1:nstimuli); sim = best_params(nstimuli+1:nparams);
bias = bias./sum(bias);
sim2 = squareform(sim); % makes a symmetric matrix with zeros for diagonals
sim2(logical(eye(size(sim2)))) = 1; % set diagonals to 1

end

