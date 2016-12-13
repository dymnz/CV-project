clear; close all;

WindowSize = 10;
MaxCornerCount = 100;

SampleImg = imread('./data/pattern.png');
SampleCorners = harrisCorner(SampleImg, WindowSize, MaxCornerCount);
SampleX = cat(2, SampleCorners, ones(size(SampleCorners(:,1))));

%


TestImg = imread('./data/s_left.jpg');
TestCorners = harrisCorner(TestImg, WindowSize, MaxCornerCount);
TestX = cat(2, TestCorners, ones(size(TestCorners(:,1))));
