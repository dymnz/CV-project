function data = readOneLine(fid)
% Read one line/sample from file
% This function adds 1% noise to every sample
    tline = fgets(fid);
    if tline == -1
        data = -1;
        return;
    end
    tline = regexprep(tline, ' ', '');
    data = tline - '0';
    data = data(1:end-1);
end