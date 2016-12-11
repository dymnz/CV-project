function [corners] = harrisCorner(Img, WindowSize, MaxCornerCount)
% Harris Corner with Non-maximum Suppression

% Check if the image is grayscale image
% if not, turn it into grayscale image
grayimg = Img;
if size(Img, 3) ~= 1
    grayimg = double(rgb2gray(Img));
end
[H W] = size(grayimg);

% 1x3 derivative
v = [-1 0 1];
dx = conv2(grayimg, v,'same');
dy = conv2(grayimg, v','same');

% Square window
window = ones(WindowSize, WindowSize);
dx2 = conv2(dx.^2, window, 'same');
dy2 = conv2(dy.^2, window, 'same');
dxy = conv2(dx.*dy, window, 'same');

% Calculate the response
k = 0.04;
cim = (dx2.*dy2 - dxy.^2) - k*(dx2 + dy2).^2; 

% Find proper corners by Non-maximum Suppression
corners = zeros(MaxCornerCount, 2);
for i = 1 : MaxCornerCount
    [val ind] = max(cim(:));
    
    % If the response is <=0 stop iterating and truncate the corner array
    if val <= 0
        corners = corners(1:i-1, :);
        break;
    end
    
    [row, col] = ind2sub(size(cim), ind);
    corners(i, :) = [row col];
    for r = max(1, row - WindowSize) : min(row + WindowSize, H)
        for c = max(1, col - WindowSize) : min(col + WindowSize, W)
            cim(r, c) = 0;
        end
    end    
end

end
