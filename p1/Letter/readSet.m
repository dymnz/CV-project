function [setData, setCount] = readSet (MAX_CLASS, MAX_SIZE, acceptedCVLabel, DATA_ROW, DATA_COLUMN)
% Read training set

fid = fopen('letter.data');
setCount = uint16(zeros(1, MAX_CLASS));
setData = zeros(MAX_CLASS, MAX_SIZE, DATA_ROW*DATA_COLUMN);

totalCount = 0;
skipped = 0;

% Read training set from file
while totalCount < MAX_SIZE*MAX_CLASS
    
    % Read a sample from file
    [class, cvLabel, data] = readOneLine(fid); 
    
    % Check if EOL
    if class == -1
        error('Not enough data');
        break;
    end
    
    % Check if the data has a cvLabel that is accepted
    % Check if the data set for a given class has enough data    
    if ismember(cvLabel, acceptedCVLabel) && (setCount(class) < MAX_SIZE)        
        setData(class, setCount(class)+1, :) = data;
        totalCount = totalCount + 1;
        setCount(class) = setCount(class) + 1;
    else
        skipped = skipped + 1;
    end
end

fclose(fid);
end


function [class, cvLabel, data] = readOneLine(fid)
% Read one line/sample from file
    ScaleData = 100;
    ScaleNoise = 1;
    tline = fgets(fid);
    if tline == -1
        class = -1;
        cvLabel = -1;
        data = -1;
        return;
    end
    tline = regexprep(tline, '\t', '');
    num = tline - '0';
    class = num(1)+'0'-'a'+1;
    cvLabel = num(2);
    data = num(3:end-2);
    
    data = ScaleData.*data + ScaleNoise.*rand(size(data));
end
