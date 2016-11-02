function pic = reconstructImage(data, tR, tC, tD)
% RECONSTRUCTIMAGE　Reconstruct an image of a row vector
% INPT: data: A row vector with the length of tR*tC*tD
%		tR: The dimension of row of the image
%		tC: The dimension of column of the image
%		tD: The dimension of depth of the image
% OUPT: pic: A matrix of tRxtCxtD representing an image

pic = reshape(data(1:tR*tC), [tR, tC]);

for i = 1:tD-1
temp = reshape(data(i*tR*tC+1:(i+1)*tR*tC), [tR, tC]);
pic = cat(3, pic, temp);
end

end
