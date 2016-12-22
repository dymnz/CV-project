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
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));

% Remove bad points
radius = 3;
p1BadIndices = zeros(size(matchedPoints1));
for i = 1 : size(matchedPoints1, 1)
    pts = matchedPoints1.Location(i, :);
    xDupe = abs(pts(1)-matchedPoints1.Location(:, 1)) < radius;
    yDupe = abs(pts(2)-matchedPoints1.Location(:, 2)) < radius;
    xDupe(i) = 0; yDupe(i) = 0;
    p1BadIndices = p1BadIndices | (xDupe&yDupe);
end

p2BadIndices = zeros(size(matchedPoints2));
for i = 1 : size(matchedPoints2, 1)
    pts = matchedPoints2.Location(i, :);
    xDupe = abs(pts(1)-matchedPoints2.Location(:, 1)) < radius;
    yDupe = abs(pts(2)-matchedPoints2.Location(:, 2)) < radius;
    xDupe(i) = 0; yDupe(i) = 0;
    p2BadIndices = p2BadIndices | (xDupe&yDupe);
end

GoodIndices = ~(p1BadIndices | p2BadIndices);
matchedPoints1 = matchedPoints1(GoodIndices);
matchedPoints2 = matchedPoints2(GoodIndices);

matchedPoints1 = matchedPoints1.Location;
matchedPoints2 = matchedPoints2.Location;

end