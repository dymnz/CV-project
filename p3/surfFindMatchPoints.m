function [matchedPoints1 matchedPoints2] = surfFindMatchPoints(Img1, Img2)
% Find Corresponding Points Using SURF Features 
% Functions used below are from Matlab

% Find the SURF features.
points1 = detectSURFFeatures(Img1);
points2 = detectSURFFeatures(Img2); 

% Extract the features.
[f1,vpts1] = extractFeatures(Img1,points1);
[f2,vpts2] = extractFeatures(Img2,points2);

% Retrieve the locations of matched points.
indexPairs = matchFeatures(f1,f2) ;
matchedPoints1 = vpts1(indexPairs(:,1)).Location;
matchedPoints2 = vpts2(indexPairs(:,2)).Location;

end