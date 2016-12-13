% Test of Harris Corner with Non-maximum Suppression
% clear; close all;

WindowSize = 10;
MaxCornerCount = 18;
% Img = imread('./data/s_sample.jpg');
Img = imread('./data/s1.jpg');
[H W] = size(Img(:, :, 1));
Img = imgaussfilt(Img, 5);
corners = harrisCorner(Img, WindowSize, MaxCornerCount);

for i = 1 : size(corners, 1)
    row = corners(i, 1); 
    col = corners(i, 2);
    for r = max(1, row - WindowSize) : min(row + WindowSize, H)
        for c = max(1, col - WindowSize) : min(col + WindowSize, W)
            Img(r, c, :) = [255 0 0];
        end
    end  
end
figure; imshow(Img);


