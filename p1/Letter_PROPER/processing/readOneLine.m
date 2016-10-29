function [class, cvLabel, data] = readOneLine(fid)
% Read one line/sample from file
% This function adds 1% noise to every sample
    ScaleData = 1;
    ScaleNoise = 0.01;
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
    
end