[Means, Covs] = gaussianMLFitting(TrainSet);
[Ks, Thetas] = gammaMLFitting(TrainSet);

for i = 1 : size(Ks, 2)    
        mat = Ks{i}.*(Thetas{i}.^2) - diag(Covs{i}).';
%         mat = Ks{i}.*(Thetas{i}) - Means{i};
        mat = abs(mat);
%         mat = uint8(mat./max(max(mat)).*255);
        figure;
        pic = reconstructImage(mat, DATA_COLUMN, DATA_ROW, 1)';
        imshow(pic, 'InitialMagnification','fit');     

        mat2 = Means{i};
%         mat2 = uint8(mat2./max(max(mat2)).*255);
        figure;
        pic = reconstructImage(mat2, DATA_COLUMN, DATA_ROW, 1)';
        imshow(pic, 'InitialMagnification','fit');                    
        
        rgbImage1 = cat(3, mat, zeros(size(mat)), zeros(size(mat)));
        rgbImage2 = cat(3, zeros(size(mat)), mat2, zeros(size(mat)));
        mat3 = rgbImage1 + rgbImage2;
        figure;
        
        pic = reconstructImage(mat3, DATA_COLUMN, DATA_ROW, 3);
        pic = permute(pic, [2 1 3]);
        imshow(pic, 'InitialMagnification','fit'); 
        
        k = waitforbuttonpress;
        close all;
end
