function img = Preprocessing(oImg, EnableHEQ)
% Resize and apply Histogram Equalization acoording to setting
% INPT: oImgT: RGB image.
% OUPT: img: Processed RGB image.

% Resize
img = imresize(oImg, [NaN 1280]);

% RGB
if EnableHEQ
    img = rgb2hsv(img);
    img = cat(3, img(:, :, 1:2), histeq(img(:, :, 3)));
    img = uint8(hsv2rgb(img).*255);
end 

end
