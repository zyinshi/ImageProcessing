 function cdf = getImageCDF(img)
 bins = 0:255;
 H = hist(img(:), bins);
 cdf = cumsum(H)/sum(H);