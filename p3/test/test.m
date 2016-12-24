%% Detect SURF Interest Points in a Grayscale Image

% Copyright 2015 The MathWorks, Inc.


%% Read image and detect interest points.
    I = imresize(rgb2gray(imread('./data/b2.jpg')), 0.5);
    points = detectSURFFeatures(I);

%% Display locations of interest in image.
    imshow(I); hold on;
    plot(points.selectStrongest(50));
