% SIFT
clear; close all;

Octave = 4; BlurLevel = 5; Sigma = sqrt(2);

scaleBlurImages = cell(Octave, BlurLevel);
DOGs = cell(Octave, BlurLevel - 1);

Img = imread('./data/s_sample.jpg');


% TODO: scaleImages do not need to be saved
for i = 1 : Octave
    scaledImg = imresize(Img, 1.0/(2^(i-1)) );
    for r = 1 : BlurLevel        
        blurredImg = imgaussfilt(scaledImg, r*Sigma);       
        scaleBlurImages{i, r} = blurredImg;
    end
    
    for r = 2 : BlurLevel
        DOGImg = scaleBlurImages{i, r} - scaleBlurImages{i, r-1}; 
        DOGs{i, r - 1} = DOGImg;
        imshow(DOGImg);
    end
    
end




