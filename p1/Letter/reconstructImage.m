function pic = reconstructImage(data, tR, tC, tD)
% Reconstruct the image of a row vector

pic = reshape(data(1:tR*tC), [tR, tC]);

for i = 1:tD-1
temp = reshape(data(i*tR*tC+1:(i+1)*tR*tC), [tR, tC]);
pic = cat(3, pic, temp);
end

end
