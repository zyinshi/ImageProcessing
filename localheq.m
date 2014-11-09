% input: image, window size(default: 10% of image size)
% output : enhanced image by local histogram equalization
function [ rst ] = localheq( img, s )
[row,col] = size(img); 
% default window size
if ( nargin < 2 )
    s = size(img,1) * 0.1;
end

rstimg = img;
for i = 1:row
    for j = 1:col
        if(i<=floor(s/2)) % special case for top corner
            if(j<=floor(s/2)) % special case for left corner
                block = img(1:i+floor(s/2),1:j+floor(s/2));
            elseif (j>col-floor(s/2)) % special case for right corner
                block = img(1:i+floor(s/2),j-floor(s/2)+1:col);
            else 
                block = img(1:i+floor(s/2),j-floor(s/2):j+floor(s/2));
            end
        elseif(i>row-floor(s/2)) %special case for top corner
            if(j<=floor(s/2))
                block = img(i-floor(s/2)+1:row,1:j+floor(s/2));
            elseif (j>col-floor(s/2))
                block = img(i-floor(s/2)+1:row,j-floor(s/2)+1:col);
            else 
                block = img(i-floor(s/2)+1:row,j-floor(s/2):j+floor(s/2));
            end
        else
            if(j<=floor(s/2))
                block = img(i-floor(s/2):i+floor(s/2),1:j+floor(s/2));
            elseif (j>col-floor(s/2))
                block = img(i-floor(s/2):i+floor(s/2),j-floor(s/2)+1:col);
            else 
                block = img(i-floor(s/2):i+floor(s/2),j-floor(s/2):j+floor(s/2));
            end
            
        end
        cdf = getImageCDF(block);  %compute cummulative distribution
        rstimg(i,j)=round(cdf(img(i,j)+1)*255);
    end
end

rst = rstimg;
end

