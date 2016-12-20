%% Find Corresponding Points Using SURF Features 
% Use the SURF local feature detector function to find the corresponding points between two images that are rotated and
% scaled with respect to each other. 
%% 
% Read the two images.
Img1 = rgb2gray(imread('./data/i1.jpg'));
Img2 = rgb2gray(imread('./data/i2.jpg'));

Img1 = imresize(Img1, [480 640]);
Img2 = imresize(Img2, [480 640]);

%%
% Find the SURF features.
points1 = detectSURFFeatures(Img1);
points2 = detectSURFFeatures(Img2); 
%% 
% Extract the features.
[f1,vpts1] = extractFeatures(Img1,points1);
[f2,vpts2] = extractFeatures(Img2,points2);
%% 
% Retrieve the locations of matched points.
indexPairs = matchFeatures(f1,f2) ;
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));
%% 
% Display the matching points. The data still includes several outliers, but  you can see the effects of rotation and scaling on the display of matched features.
figure; showMatchedFeatures(Img1,Img2,matchedPoints1,matchedPoints2);
legend('matched points 1','matched points 2');
