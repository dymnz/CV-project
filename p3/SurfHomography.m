% Find the homography between two images with SURF and RANSAC
clear; close all;

Img1 = rgb2gray(imread('./data/i2.jpg'));
Img2 = rgb2gray(imread('./data/i2.jpg'));

points1 = detectSURFFeatures(Img1);
points2 = detectSURFFeatures(Img2); 

% Find matched SURF feature points
[T, W] = surfFindMatchPoints(Img1, Img2);

% Find homography
NumOfMPs = size(W, 1);
NumOfIterations = 300;
phi = findHomography(W, T, NumOfMPs, NumOfIterations);

%%
exphi = double(reshape(phi, [3 3]));
t = projective2d(exphi);
img = imwarp(Img2, t);
figure; imshow(img);
figure; imshow(Img1);
figure; imshow(Img2);