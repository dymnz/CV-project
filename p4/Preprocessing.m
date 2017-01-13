function img = Preprocessing(oImg, EnableHSV)

% Resize
img = imresize(oImg, [NaN 1280]);

% RGB
if EnableHSV
    img = rgb2hsv(img);
    img = cat(3, img(:, :, 1:2), histeq(img(:, :, 3)));
    img = uint8(hsv2rgb(img).*255);
end 

end
