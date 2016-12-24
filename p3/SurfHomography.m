%% Find the homography between two images with SURF and RANSAC
clear; close all;

%% Read and resize the images
disp('Read images...');

% Target
Img1 = rgb2gray(imread('./data/cover.jpg'));
Img1 = imresize(Img1, 0.5);

% Photo
Img2 = rgb2gray(imread('./data/b2.jpg'));
Img2 = imresize(Img2, 0.5);

% Pattern: pattern contains the image;
%   alpha contains the transparent information (a mask)
[pattern,map,alpha] = imread('./data/s2.png');
[pattern map] = imresize(pattern, 0.5);
alpha = imresize(alpha, 0.5);

%% Find matched SURF feature points
disp('Find SURF matching points...');
[T, W] = surfFindMatchPoints(Img1, Img2);

NumOfMPs = size(W, 1);

disp(sprintf('Num of MPs: %d', NumOfMPs));

%% RANSAC
disp('RANSAC...');
HomographyIterations = 300; % # of maximum iterations for non-linear optimization
RANSACiteration = min(max(500, NumOfMPs*10), 1000); % # of maximum iterations for RANSAC
InlierThreshold = 5;    % Thershold for projection error in pixels

maxInliers = zeros(1,1);    % Store the largest set of inliers
maxInlierCount = -1;

for i = 1 : RANSACiteration
% Randomly pick four points
Indices = randperm(NumOfMPs, 4);
WorldCoord = W(Indices, :);
TargetCoord = T(Indices, :);

% Find homography using the four points
phi = findHomography(WorldCoord, TargetCoord, HomographyIterations);
H = double(reshape(phi, [3 3]));

% Find point-wise error - psi
exW = [W ones(NumOfMPs, 1)];
H = [phi(1:8);1];
denom = exW*H(7:9);
x = exW*H(1:3)./denom;
y = exW*H(4:6)./denom;
X = [x y];
psi = T - X;

% Find squared root error for each point
sqE = sqrt(psi(:, 1).^2 + psi(:, 2).^2);

% Count the number of inliers
Inliers = find(sqE<InlierThreshold);
InlierCount = numel(Inliers);

% If a better set of inliers is found, store it
if InlierCount > maxInlierCount
	maxInleirs = Inliers;
    maxInlierCount = InlierCount;
    disp(sprintf('Itr: %d InlierCount: %d', i, maxInlierCount));
    
    if double(maxInlierCount)/NumOfMPs >= 0.8
        break;
    end
end

end

%% Use the best set of inliers to find homography
disp('Find the final homography...');
disp(sprintf('NumOfMPs: %d Inliers: %d', NumOfMPs, maxInlierCount));

WorldCoord = W(maxInleirs, :);
TargetCoord = T(maxInleirs, :);

phi = findHomography(WorldCoord, TargetCoord, HomographyIterations);

% Here it is 
H = double(reshape(phi, [3 3]));

%% Append the pattern onto the image
figure1 = figure;

% Two images to put = Two axes to put on
ax1 = axes('Parent',figure1);
ax2 = axes('Parent',figure1);
set(ax1,'Visible','off');
set(ax2,'Visible','off');

% Project the pattern onto the photo using H^-1
% -Since some pixel will be projected out of the region of original image,
% Matlab projects that image and added translation to contain the result.
% RNex stores the translation on X and Y
RNe = imref2d(size(pattern));
t = projective2d(inv(H));
[pattern RNex] = imwarp(pattern, RNe, t);
alpha = imwarp(alpha, RNe, t);

% Use the translation parameter X and Y stored in RNex to make sure
% that pattern and photo is in the same coordinate system
xa = uint8(zeros([size(Img2) 3]));
xa( floor(RNex.YWorldLimits(1)):floor(RNex.YWorldLimits(1)) + size(pattern, 1) - 1,...
    floor(RNex.XWorldLimits(1)):floor(RNex.XWorldLimits(1)) + size(pattern, 2) - 1, :)...
    = pattern;
Rxa = imref2d(size(xa));

% The transparent mask requires the same treatment
xalpha = uint8(zeros(size(Img2)));
xalpha( floor(RNex.YWorldLimits(1)):floor(RNex.YWorldLimits(1)) + size(pattern, 1) - 1,...
    floor(RNex.XWorldLimits(1)):floor(RNex.XWorldLimits(1)) + size(pattern, 2) - 1)...
    = alpha;

% Draw the photo
imshow(Img2, 'Parent',ax1);

% Draw the pattern and let it have a transparent background
I = imshow(xa, 'Parent',ax2);
set(I,'AlphaData',xalpha);


