clear; close all;

img = imread('./pattern.png');
grayimg = rgb2gray(img);
[H W] = size(grayimg);

v = [-1 ; 1];
dy = conv2(v, 1, grayimg,'same');
dx = conv2(1, v, grayimg,'same');

WINDOW = 5;
window = ones(WINDOW, WINDOW);
dx2 = conv2(dx.^2, window, 'same'); % Smoothed squared image derivatives
dy2 = conv2(dy.^2, window, 'same');
dxy = conv2(dx.*dy, window, 'same');

k = 0.05;
% cim = (dx2.*dy2 - dxy.^2) - k*(dx2 + dy2).^2; 
cim = (dx2.*dy2 - dxy.^2)./(dx2 + dy2 + eps); % Harris corner measure

NUMEL = 100;

properCorners = zeros(NUMEL, 2);
for i = 1 : NUMEL
    [val ind] = max(cim(:));
    [row, col] = ind2sub(size(cim), ind);
    properCorners(i, :) = [row col];
    for r = max(0, row - WINDOW) : min(row + WINDOW, H)
        for c = max(0, col - WINDOW) : min(col + WINDOW, W)
            cim(r, c) = 0;
        end
    end    
end
cim = zeros(size(cim));
for i = 1 : NUMEL
    row = properCorners(i, 1); 
    col = properCorners(i, 2);
    for r = max(0, row - WINDOW) : min(row + WINDOW, H)
        for c = max(0, col - WINDOW) : min(col + WINDOW, W)
            cim(r, c) = 1;
        end
    end  
end
imshow(cim);

