% Organize Data by Condition

%% Contrast Acc

Contrast = nan( size(Data.exp,1) / numel(unique(Data.exp(:,13,1))), numel(unique(Data.exp(:,13,1))), size(Data.exp,3) );

for p = 1:size(Data.exp,3)
    data = sortrows(Data.exp(:,:,p), 13);
    acc  = data(:, 8);
    Contrast(:,:,p) = reshape(acc, [ length(acc)/numel(unique(Data.exp(:,13,1))), numel(unique(Data.exp(:,13,1)))]);
end
Data.ContrastLvl = Contrast;
clear Contrast p data acc 

%% Number Acc

Response = nan( size(Data.exp,1) / numel(unique(Data.exp(:,6,1))), numel(unique(Data.exp(:,6,1))), size(Data.exp,3) );
RespAcc  = Response;

for p = 1:size(Data.exp,3)
    data = sortrows(Data.exp(:,:,p), 6);
    acc  = data(:, 8);
    rsp  = data(:, 7);
    Response(:,:,p) = reshape(rsp, [ length(rsp)/numel(unique(Data.exp(:,6,1))), numel(unique(Data.exp(:,6,1)))]);
    RespAcc(:,:,p) = reshape(acc, [ length(acc)/numel(unique(Data.exp(:,6,1))), numel(unique(Data.exp(:,6,1)))]);
end
Data.Response = Response;
Data.RespAcc  = RespAcc; 
clear Response RespAcc p data acc rsp

%% Block Acc

BlockAcc = nan( size(Data.exp,1) / numel(unique(Data.exp(:,4,1))), numel(unique(Data.exp(:,4,1))), size(Data.exp,3) );
for p = 1:size(Data.exp,3)
    data = sortrows(Data.exp(:,:,p), 4);
    acc  = data(:, 8);
    BlockAcc(:,:,p) = reshape(acc, [ length(acc)/numel(unique(Data.exp(:,4,1))), numel(unique(Data.exp(:,4,1)))]);
end
Data.BlockAcc = BlockAcc;
Data.Acc = permute( nanmean(Data.BlockAcc), [3,2,1] );
Data.TotalAcc = nanmean( Data.Acc, 2);
clear p data acc BlockAcc

%% StimTrial x Block x Contrast Level x Subject = 4D array
Data.ContrastBlockAcc = nan( size(Data.exp,1) / ( numel(unique(Data.exp(:,4,1))) * numel(unique(Data.exp(:,13,1))) ), numel(unique(Data.exp(:,4,1))), numel(unique(Data.exp(:,13,1))), size(Data.exp,3) );
for p = 1:size(Data.exp,3)
    ExpData = sortrows(Data.exp(:,:,p), [13,4] );
    Data.ContrastBlockAcc(:,:,:,p) = reshape( ExpData(:,8), [size(ExpData,1)/numel(unique(ExpData(:,4)))/numel(unique(ExpData(:,13))), numel(unique(ExpData(:,4))), numel(unique(ExpData(:,13)))] );
end
clear p ExpData

Rsp = Data.exp(:,7,:);
Cnd = Data.exp(:,6,:);
Fq = nan(9,9,size(Data.exp,3));

for cnds = 1:9
    for rsps = 1:9
        Fq(cnds, rsps, :) = sum(Rsp == rsps & Cnd==cnds);
    end
end
Data.RespFq = Fq;
Data.RespPropFq = Data.RespFq ./ repmat( sum(Data.RespFq,2), [1,9,1]);
clear cnds rsps Fq Cnd Rsp


%% Staircase Contrast

Data.PracticeContrast = Data.prac(:,12,:);
Data.PracticeContrast = permute(Data.PracticeContrast, [1,3,2]);


% %% Table of Participant Data
% 
% t = num2cell( nan( 11, 10));
% 
% 
% switch v.Cohort
%     case 'English'
%         N = 11; L = 4;
%         
%         for p = 1:N, Ids{1,p} = ['S',num2str(p)]; end
%         
%         for l = 1:L
%             for p = 1:N
%                 
%             end
%         end
% end












