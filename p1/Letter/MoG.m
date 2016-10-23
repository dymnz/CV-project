% This is the Mixture of Gaussian Estimator
% Remeber to run 'Init_Read' beforehand

% For every step that involves probability, I process it in log-domain 
% so that it won't overflow/underflow

Orders = 3.*ones(MAX_CLASS, 1); % # of order for each class
params = cell(MAX_CLASS, 3);    % Weights/Means/Covs of each class

% Orders(5) = 7;
% Orders(1) = 12;

% Set Weights for each class
for i = 1 : MAX_CLASS
    params{i, 1} = ones(1, Orders(i))./Orders(i);	% Weight 1xK
    params{i, 2} = zeros(DATA_SIZE, Orders(i));     % Means DxK
    params{i, 3} = repmat(eye(DATA_SIZE, DATA_SIZE), 1, 1, Orders(i));	% Covs DxDxK
end

% Construct responsibility storage
responsibility = cell(MAX_CLASS, 1);   
for i = 1 : MAX_CLASS
    responsibility{i} = cell(MAX_TRAIN_SIZE, Orders(i));% Rik MAX_TRAIN_SIZExK
end

%% EM for MoG
for i = 1 : MAX_CLASS
% E-step



% M-step




end