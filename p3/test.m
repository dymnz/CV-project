% Test of Harris Corner with Non-maximum Suppression
% clear; close all;

WindowSize = 10;
MaxCornerCount = 18;
% Img = imread('./data/s_sample.jpg');
Img = imread('./data/s5.jpg');
[H W] = size(Img(:, :, 1));

Img = rgb2gray(Img);
Img = imgaussfilt(Img, 5);
corners = harrisCorner(Img, WindowSize, MaxCornerCount);

WindowSize = 8;
Metrics = zeros(1, size(corners, 1));
for i = 1 : size(corners, 1)
    r = corners(i, 1); 
    c = corners(i, 2);
    points = extractHOGFeatures( ...
        Img( max(1, r-WindowSize) : min(H, r+WindowSize), ...
            max(1, c-WindowSize) : min(W, c+WindowSize)), ...
            'NumOctaves', 1, ...
            'MetricThreshold', 0 ... 
        );
    disp(points.Count);
    disp(points.selectStrongest(1).Metric);
    Metrics(i) = points.selectStrongest(1).Metric;
end