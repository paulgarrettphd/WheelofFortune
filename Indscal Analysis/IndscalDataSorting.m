clc; clear; close;
cd('C:\Users\c3130234\Desktop\MDS Analysis Paper\Analysis');
run('s_VariableDataLoad.m');
Parts = [23:33; 12:22; 1:11; 34:44]; % ENG, DOT, CHN, THI
N = {'ENG','DOT','CHN','THI'};
ThreeD = {[2, 8, 9]; []; [2, 6, 7, 8]; [1, 3, 6, 11]};

for ii = 1:4
    Cmatrix = [];
    C3matrix = [];
    c = 0; c3 = 0;
    for p = 1:11
        if ~ismember( p, ThreeD{ii} )
            c = c + 1;
            % Confusion Mat
            Cmat = confusionmat( Data.exp(:,6,Parts(ii,p)), Data.exp(:,7,Parts(ii,p)) );
            % Unbias MDS
            UnbiasMDSmatrix = f_quickMDS( Cmat, fullfile(v.path.home, 'MatMDS'), v.ID{Parts(ii,p)} );
            % Save off Unbias MDS
            Cmatrix(:,:,c) = 1 - UnbiasMDSmatrix.sim2_fit;
            
        else
            
            c3 = c3 + 1;
            % Confusion Mat
            Cmat = confusionmat( Data.exp(:,6,Parts(ii,p)), Data.exp(:,7,Parts(ii,p)) );
            % Unbias MDS
            UnbiasMDSmatrix = f_quickMDS( Cmat, fullfile(v.path.home, 'MatMDS'), v.ID{Parts(ii,p)} );
            % Save off Unbias MDS
            C3matrix(:,:,c3) = 1 - UnbiasMDSmatrix.sim2_fit;
        end
    end
    save( fullfile('C:\Users\c3130234\Desktop\MDS Analysis Paper\Analysis\Indscal Analysis', strcat('UnbiasMDS_', N{ii},'.mat')), 'Cmatrix');
    
    if ~isempty(C3matrix)
        save( fullfile('C:\Users\c3130234\Desktop\MDS Analysis Paper\Analysis\Indscal Analysis', strcat('UnbiasMDS_3D_', N{ii},'.mat')), 'Cmatrix');
    end
end

