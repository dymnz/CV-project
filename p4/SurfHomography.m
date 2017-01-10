%% Find the homography between two images with SURF and RANSAC
clear; close all;

%% Read and resize the images
disp('Read images...');

% Target
Img1 = rgb2gray(imread('./data/i1.jpg'));
Img1 = imresize(Img1, [NaN 640]);

% Photo
Img2 = rgb2gray(imread('./data/i2.jpg'));
Img2 = imresize(Img2, [NaN 640]);

%% Find matched SURF feature points
disp('Find SURF matching points...');
[T, W] = surfFindMatchPoints(Img1, Img2);

NumOfMPs = size(W, 1);

disp(sprintf('Num of MPs: %d', NumOfMPs));

%% RANSAC
disp('RANSAC...');
HomographyIterations = 300; % # of maximum iterations for non-linear optimization
RANSACiteration = min(max(500, NumOfMPs*10), 1000); % # of maximum iterations for RANSAC
InlierThreshold = 5.0;    % Thershold for projection error in pixels

maxInliers = zeros(1,1);    % Store the largest set of inliers
maxInlierCount = -1;

%% Normalize the coordinates
MaxValue = max(max(max(W)), max(max(T)));
W = W./MaxValue;
T = T./MaxValue;
InlierThreshold = InlierThreshold/MaxValue;

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
    
    if double(maxInlierCount)/NumOfMPs >= 0.7
        break;
    end
end

end

%% Use the best set of inliers to find homography
disp('Find the final homography...');
disp(sprintf('NumOfMPs: %d Inliers: %d', NumOfMPs, maxInlierCount));

WorldCoord = W(maxInleirs, :).*MaxValue;
TargetCoord = T(maxInleirs, :).*MaxValue;

phi = findHomography(WorldCoord, TargetCoord, HomographyIterations);

% Here it is 
H = double(reshape(phi, [3 3]));

%% Append the pattern onto the image
cImg1 = imread('./data/i1.jpg');
cImg1 = imresize(cImg1, [NaN 640]);
cImg2 = imread('./data/i2.jpg');
cImg2 = imresize(cImg2, [NaN 640]);
RNe = imref2d(size(cImg2));
t = projective2d(H);
[transformedImg2 RNex] = imwarp(cImg2, RNe, t);
alpha = imwarp(255*ones(size(Img2)), RNe, t);

% Fix Y-axis 
% Please fix X-axis

if floor(RNex.YWorldLimits(1)) < 0

x2 = uint8(zeros([-floor(RNex.YWorldLimits(1))+size(transformedImg2, 1)...
    floor(RNex.XWorldLimits(1))+size(transformedImg2, 2) 3]));
x2( 1:size(transformedImg2, 1),...
    floor(RNex.XWorldLimits(1)):floor(RNex.XWorldLimits(1)) + size(transformedImg2, 2) - 1, :)...
    = transformedImg2;

xAlpha = uint8(zeros([-floor(RNex.YWorldLimits(1))+size(transformedImg2, 1)...
    floor(RNex.XWorldLimits(1))+size(transformedImg2, 2) 1]));
xAlpha( 1:size(transformedImg2, 1),...
    floor(RNex.XWorldLimits(1)):floor(RNex.XWorldLimits(1)) + size(transformedImg2, 2) - 1, :)...
    = alpha;

x1 = uint8(zeros([-floor(RNex.YWorldLimits(1))+size(transformedImg2, 1)...
    floor(RNex.XWorldLimits(1))+size(transformedImg2, 2) 3]));
x1( -floor(RNex.YWorldLimits(1)):-floor(RNex.YWorldLimits(1))+size(cImg1, 1) - 1,...
    1:size(Img1, 2), :)...
    = cImg1;
end



% Append the pattern onto the image
figure1 = figure;

% Two images to put = Two axes to put on
ax1 = axes('Parent',figure1);
ax2 = axes('Parent',figure1);
set(ax1,'Visible','off');
set(ax2,'Visible','off');

imshow(x1, 'Parent',ax1);

% Draw the pattern and let it have a transparent background
I = imshow(x2, 'Parent',ax2);
set(I,'AlphaData',xAlpha);



