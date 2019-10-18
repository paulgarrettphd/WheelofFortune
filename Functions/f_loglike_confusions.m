function [ loglike ] = f_loglike_confusions( confusions, predicted )
%% Function to compute the log liklihood between a 
% given confusion matrix and a predicted probability matrix
out = 0;
nrow = size(confusions,1);
for i = 1:nrow
    tmp = mnpdf(confusions(i, :), predicted(i, :));
    if tmp==0
        tmp=0.000000000001;
    end
    tmp2 = log(tmp);
    out = out+tmp2;
end
loglike = out;
