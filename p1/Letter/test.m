MAX_LETTERS = 26;
DATA_ROW = 16;
DATA_COLUMN = 8;

% fid = fopen('letter.data');
% [class, cvLabel, data] = readOneLine(fid);
% 
% 
% pic = reconstructImage(data, DATA_COLUMN, DATA_ROW, 1)';
% k = sprintf('%c', class+'a'-1);
% figure('Name', k, 'NumberTitle', 'off')
% imshow(pic, 'InitialMagnification','fit');
% fclose(fid);

% for i = 1:MAX_LETTERS
%     mat = trainMeans(i, :);
%     mat = uint8(mat./max(max(mat)).*255);
%     pic = reconstructImage(mat, DATA_COLUMN, DATA_ROW, 1)';
%     imshow(pic, 'InitialMagnification','fit');
%     k = waitforbuttonpress;
% end

% for i = 1:MAX_LETTERS
%     mat = trainMeans(i, :);
%     mat = uint8(mat./max(max(mat)).*255);
%     pic = reconstructImage(mat, DATA_COLUMN, DATA_ROW, 1)';
%     imshow(pic, 'InitialMagnification','fit');
%     k = waitforbuttonpress;
% end

% for m = 1 : size(testSetData, 1)
%     for n = 1 : size(testSetData, 2)
%         mat = testSetData(m, n, :);
%         mat = uint8(mat./max(max(mat)).*255);
%         pic = reconstructImage(mat, DATA_COLUMN, DATA_ROW, 1)';
%         imshow(pic, 'InitialMagnification','fit');       
%         k = waitforbuttonpress; 
%     end
% end

for m = 1 : size(trainSetData, 1)
    for n = 1 : size(trainSetData, 2)
        mat = trainSetData(m, n, :);
        mat = uint8(mat./max(max(mat)).*255);
        pic = reconstructImage(mat, DATA_COLUMN, DATA_ROW, 1)';
        imshow(pic, 'InitialMagnification','fit');       
        k = waitforbuttonpress; 
    end
end

% for i = 1:MAX_LETTERS
%     mat = diag(squeeze(trainCovs(i, :, :))).';
%     mat = uint8(mat./max(max(mat)).*255);
%     pic = reconstructImage(uint8(mat), DATA_COLUMN, DATA_ROW, 1)';
%     imshow(pic, 'InitialMagnification','fit');
%     k = waitforbuttonpress;
% end
% 



