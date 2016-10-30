function [TrainSet, TestSet] = readSets(MAX_CLASS, TrainCount, TestCount, DATA_SIZE, Noise)
% Read the data for all classes
for i = 1 : MAX_CLASS
    fileName = sprintf('./data/%c.data', i - 1 + 'a');
    fid = fopen(fileName);
    R = 0;
    TrainMatrix = zeros(TrainCount(i), DATA_SIZE);
    TestMatrix = zeros(TestCount(i), DATA_SIZE);
    while R < TrainCount(i) + TestCount(i)
        
        R = R + 1;
        % Read a sample
        tempData = readOneLine(fid, Noise);
        if tempData == -1
            break;
        end
        
        % Store the first MAX_TRAIN_SIZE data as train set
        if R <= TrainCount(i)
            TrainMatrix(R, :) = tempData;
        else
            TestMatrix(R - TrainCount(i), :) = tempData;
        end
    end
    TrainSet{i} = TrainMatrix;
    TestSet{i} = TestMatrix;
    fclose(fid);
end
end

function data = readOneLine(fid, Noise)
% Read one line/sample from file  
    tline = fgets(fid);
    if tline == -1
        data = -1;
        return;
    end
    tline = regexprep(tline, ' ', '');
    data = tline - '0';
    data = data(1:end-1);
    data = data + Noise*randn(size(data));
    data(data>1) = 1;
    data(data<=0) = 0.001;
end
