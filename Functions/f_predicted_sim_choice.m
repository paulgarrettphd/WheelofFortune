function predicted = f_predicted_sim_choice(x, nstimuli)
% Written by Zach Howard, PhD Candidate at the University of Newcastle
% Adapted from code found on the University of Indiana website
%% Function to take in bias and similarity values, and give predicted probabilities
    % Takes a bias for each of n responses
    % Takes upper, off diagonals of nxn similarity matrix, assumes symmetric matrix
    %
    % returns predicted identification confusion probabilities
    % transform sim values in matrix
    bias = x(1:nstimuli); sim = x(nstimuli+1:end);
    sim2 = squareform(sim); % makes a symmetric matrix with zeros for diagonals
    sim2(logical(eye(size(sim2)))) = 1; % set diagonals to 1
    predicted = ones(nstimuli);
    for i=1:nstimuli % for each STIMULUS
        % calculate the denominator, which is each bias times the
        % similarity of item i to each response j
        sumdenom = sum(bias .* sim2(i,:));
        for j=1:nstimuli % for each RESPONSE
            predicted(i,j) = bias(j)*sim2(i,j)/sumdenom; % this is Luce's formula
        end
    end
    
end

