% SIFT
clear; close all;

Octave = 4; Scale = 5; Sigma = sqrt(2);

scaleBlurImages = cell(Octave, Scale);
DOGs = cell(Octave, Scale - 1);

Img = imread('./data/s_sample.jpg');
Img = imresize(Img, 0.5);
% Calculate DoG images
% TODO: scaleImages do not need to be saved
for i = 1 : Octave
    scaledImg = imresize(Img, 1.0/(2^(i-1)) );
    for r = 1 : Scale        
        blurredImg = imgaussfilt(scaledImg, r*Sigma);       
        scaleBlurImages{i, r} = blurredImg;
    end
    
    for r = 2 : Scale
        puppy = scaleBlurImages{i, r} - scaleBlurImages{i, r-1}; 
        DOGs{i, r - 1} = puppy;
    end    
end
% Tempfix for that TODO
clear scaleBlurImages;

Neighbor = 1;
keyPoints = cell(Octave, Scale - 3);
for i = 1 : Octave
    [H, W] = size(DOGs{i, 1});
    
    for r = 2 : Scale - 2
        disp(sprintf('i:%d r:%d', i, r));
        for x = 1 + Neighbor : W - Neighbor
            for y = 1 + Neighbor : H - Neighbor
                point = DOGs{i, r}(y, x);
                topBotNeighbors = ...
                    [DOGs{i, r-1}(y-Neighbor:y+Neighbor, ...
                        x-Neighbor:x+Neighbor);
                     DOGs{i, r+1}(y-Neighbor:y+Neighbor, ...
                        x-Neighbor:x+Neighbor)];
                currentNeighbors = ...
                    [DOGs{i, r}(y-1, x-Neighbor:x+Neighbor), ...
                     DOGs{i, r}(y, x-Neighbor : x-1), ...
                     DOGs{i, r}(y, x+1 : x+Neighbor), ...
                     DOGs{i, r}(y+1, x-Neighbor:x+Neighbor)];
                neighbors = [topBotNeighbors(:)' currentNeighbors(:)'];
                     
                if max(neighbors(:)) < point || ...
                        min(neighbors(:)) > point
                    keyPoints{i, r-1} = cat(1, keyPoints{i, r-1}, [y x]);
                end
            end
        end
    end
end


