% Preallocate
Data.raw = nan( 1305, 18, length(v.files) );
v.ID = num2cell( nan( length(v.files), 1) );
% Set count
fn = 1;
% Start loop
for f = v.files
    [NumData, fname, StrData] = f_LoadSave( fullfile(v.path.data, f), v.path.mat );
    
    if sum(~isnan(NumData(:,1))) < 1305
        NSize = size(NumData,1);
        NumData(NSize+1 : 1305, :) = nan( 1305-NSize, 18 );
        StrData(NSize+2 : 1306, :) = num2cell(nan( 1305-NSize, 26 ));
        TrialVect = [1:135, repmat(1:90, [1,13])]';
        while any(TrialVect~=NumData(:,5))
            % Add NaN Space Between Missing Data Locations - Chinese Data
            % Set only. Missing 1--3 trials in two subjects
            P1 = find( TrialVect == NumData(:,5) == 0, 1, 'first');
            P2 = find( TrialVect(P1:end) == NumData(P1,5), 1, 'first')-1; 
            if isempty(P2), P2 = 1; end
            tmp = NumData(1:P1-1,:); tmpstr = StrData(1:P1,:);
            tmp(P1:P1+P2-1,:) = nan(P2,size(tmp,2)); tmpstr(P1+1:P1+1+P2-1,:) = num2cell(nan(P2,size(tmpstr,2)));
            tmp(P1+P2:size(NumData,1),:) = NumData(P1:end-P2,:); tmpstr(P1+1+P2:size(StrData,1),:) = StrData(P1+1:end-P2,:);
            tmpstr( P1+1:P1+P2, 17 ) = {'[]'};
            % Replace Trial Numbers
            tmp(P1:P1+P2-1,5) = TrialVect(P1:P1+P2-1);
            % Replace Trials with Innaccurate Non-Responses
            tmp(P1:P1+P2-1, [1:3, 7:11,14:16,18]) = repmat([ NumData( 1, 1:3), 666, 0, -8000, 8000, 8000, 500, 200, 8000, 0], [P2,1] );
            if 90-P2 == sum(tmp(:,4)==tmp(P1-1,4))
                tmp(P1:P1+P2-1,4) = repmat(tmp(P1-1,4), [P2,1]); 
            else
                error('missing trials exist over multiple blocks');
            end 
            NumData = tmp;
            StrData = tmpstr;
            %StrData(2:end,19:26) = repmat(StrData(:,19:26), [size(StrData,1)-1,1]);
        end
        for Block = 1:13
            % CntLvls = 0--4, Cnds = 1--9
            for Cnds = 1:9
                for CntLvl = 0:4
                    Idx = length(find( NumData(:,4)==Block & NumData(:,6)==Cnds & NumData(:,13)==CntLvl ));
                    Idx = 2 - Idx;
                    if Idx > 0
                        Fill = find( NumData(:,4)==Block & isnan(NumData(:,6))==1, 1, 'first');
                        NumData(Fill:Fill+Idx-1,[6,13]) = repmat([Cnds,CntLvl], [Idx,1]);
                    end
                end
            end
        end
        B1 = find( NumData(:,4)==1,1,'first');
        CntLvls = unique( NumData(B1:end,12) ); CntLvls(isnan(CntLvls))=[];
        for CntLvl = 0:4
            NumData( NumData(:,4)>0 & NumData(:,13)==CntLvl, 12) = CntLvls(CntLvl+1);
        end
    end
    
    % Sort Data by English and Chinese Speaking Cohorts
    switch v.Cohort
        case 'English'
            if NumData(1,1) == 1
                Data.raw(1:size(NumData,1),1:size(NumData,2),fn) = NumData; 
                Data.txt(1:size(StrData,1),1:size(StrData,2),fn) = StrData;
                v.ID{fn,1} = fname(1:7);
                fn = fn + 1;
            end
        case 'Chinese'
            if NumData(1,1) == 2
                Data.raw(1:size(NumData,1),1:size(NumData,2),fn) = NumData; 
                Data.txt(1:size(StrData,1),1:size(StrData,2),fn) = StrData;
                v.ID{fn,1} = fname(1:7);
                fn = fn + 1;
            end
    end
end
Data.raw = Data.raw(:,:,1:size(Data.txt,3));
v.ID = v.ID(1:size(Data.txt,3));
clearvars -except Data v