% Test of Harris Corner with Non-maximum Suppression
clear; close all;

WindowSize = 5;
MaxCornerCount = 100;
% img = imread('./data/pattern.png');
Img = imread('./data/s_top.jpg');
[H W] = size(Img(:, :, 1));

corners = harrisCorner(Img, WindowSize, MaxCornerCount);

cim = zeros(size(Img));
for i = 1 : size(corners, 1)
    row = corners(i, 1); 
    col = corners(i, 2);
    for r = max(1, row - WindowSize) : min(row + WindowSize, H)
        for c = max(1, col - WindowSize) : min(col + WindowSize, W)
            Img(r, c, :) = [255 0 0];
        end
    end  
end
imshow(Img);


