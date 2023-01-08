clc;clear all;close all;


kernelSize = 3; %dont change this
image = imread("Peppers.tif");
I = im2double(image);
paddingI = zeros(size(I,1) + 2, size(I,2) + 2);
paddingI(2:size(paddingI,1) -1,2: size(paddingI,2) -1) = I;

P = zeros(10,2);
sum_med = 0; sum_s = 0;
noisePercentage = 0.10;

for i = 1 : 10
    if i == 10
        P(i,1) = sum_med / 9;
        P(i,2) = sum_s / 9;
        break
    end    
    J = imnoise(I,'salt & pepper',noisePercentage);
    paddingI(2:size(paddingI,1) -1,2: size(paddingI,2) -1) = J;
    medianFilteredImage = medfilt2(J, [kernelSize kernelSize]);
    for k = 2: size(paddingI,1) - 1
        for j = 2: size(paddingI,2)- 1
            if paddingI(k,j) == 0 || paddingI(k,j) == 1
                temp_vec = [];
                for a = k-1:k+1
                    for b = j-1:j+1
                        if paddingI(a,b) ~= 0 && paddingI(a,b) ~= 1
                            temp_vec = [paddingI(a,b) temp_vec];
                        end
                    end
                end
                if ~isempty(temp_vec)
                    temp_vec = sort(temp_vec);
                    paddingI(k,j) = temp_vec(floor(length(temp_vec)/2)+1);
                end
            end
        end
    end
    
    %figure;imshow(J);figure;imshow(paddingI);
    P(i,1) = psnr(medianFilteredImage,I);
    P(i,2) = psnr(paddingI(2:size(paddingI,1) -1,2: size(paddingI,2) -1),I);
    sum_med = sum_med + P(i,1);
    sum_s = sum_s + P(i,2);
    noisePercentage = noisePercentage + 0.10;    
end