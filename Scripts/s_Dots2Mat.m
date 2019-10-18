% Paul Garrett
% 02/11/2018
% Short script: generate mat files containing images of the nine
% dot stimulus array for plotting on Figures

clear; close; clc;
cd('C:\Users\Paul\Dropbox\Study 4.1 - Spin_n_Win_Chineese_and_English_Characters\GreyNumberStimuli');

% Image Names
fn = {'Dots1.tif','Dots2.tif','Dots3.tif','Dots4.tif','Dots5.tif',...
      'Dots6.tif','Dots7.tif','Dots8.tif','Dots9.tif'};

% Set background (BG) and target (T) color
BG = 1;
T  = 0;

% Preallocate Array for speed
imgarray = num2cell(nan(1,9));
rawimgarray = imgarray;

% Read in image, 2D make gray scale & Store in array.
for img = 1:9
    RawImg = imread( fn{img} );
    Img = zeros(221,221,3);
    Img(1:size(RawImg,1), 1:size(RawImg,2), 1:3) = RawImg(:,:,1:3);
    Img = mat2gray(Img);                                                    % Change to Gray Scale (0--1)
    Img = Img(:,:,1);                                                       % Make 2D array for Xcorr analysis
    Img(Img~=0) = 99;                                                        % Fix Symbol Signal Color
    Img(Img==0) = BG;                                                       % Fix Background Color
    Img(Img==99) = T;
    imgarray{img} = Img;                                                    % Store Images in Cell Array
end

% Save
save('DotStim.mat', 'imgarray')
clear; close; clc;