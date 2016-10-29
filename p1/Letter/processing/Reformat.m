clear; close all; 
% Reformat the data
fid = fopen('letter.data');

MAX_CLASS = 26;         % # of classes

storage = cell(MAX_CLASS, 1);
count = zeros(MAX_CLASS, 1);
while true

    [class, cvLabel, data] = readOneLine(fid); 

    % Check if EOL
    if class == -1
        disp('EOL');
        break;
    end
    
    count(class) = count(class) + 1;
    storage{class, count(class)} = data;
    lastData = data;
    lastClass = class;
end




fclose(fid);