for i = 1 : MAX_CLASS
    fName = sprintf('%c.data', 'a' + i - 1);
    fileID = fopen(fName,'w');
    for r = 1 : count(i)
        
        for p = 1 : 128
            if p ~= 128
                fprintf(fileID, '%d ', storage{i, r}(1, p));
            else
                fprintf(fileID, '%d', storage{i, r}(1, p));
            end
        end
        fprintf(fileID, '\n');  
    end
    fclose(fileID);
end