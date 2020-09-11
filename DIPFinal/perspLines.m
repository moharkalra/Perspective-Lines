function [boundary] = perspLines(img)
%SEGMENT Summary of this function goes here
%   Detailed explanation goes here


bwImg = rgb2gray(img);
% 
% bwImg(bwImg>thresh(bwImg)) = 255;
% bwImg(bwImg<=thresh(bwImg)) = 0;     
bwImg = medfilt2(bwImg, [5 5]);

edges = edge(bwImg,'Canny');
figure;
imshow(edges);

[out] = houghfunc(edges);
boundary = out;


end

function [out] = thresh(img)
sum = ones(1,255);
mc = ones(1,255);
mg = 0;
bcv = 0;
out = 0;
vals = double(img(:));
vals = sort(vals);
total = length(vals);
start = 1;
for k = 1:255
    count = 0;
    done = false;
    while start<=total && done == false
        if vals(start) == k
            count = count + 1;
        else 
            if start>1 && vals(start-1)== k && vals(start) ~= k
                done = true;
            end
        end
        start = start+1;
    end
    if k>1
        sum(k) = sum(k-1)+count/total;
        mc(k) = mc(k-1)+k*count/total;
    else
        sum(k) = count/total;
        mc(k) = k*count/total;
    end
end
mg = mc(255);
for j = 1:255
   sigma = ((mg.*sum(j) - mc(j)).^2)./(sum(j).*(1-sum(j)));
   if sigma>bcv
      bcv = sigma;
      out = j;
   end
   
end
end

function [out] = houghfunc(img)
[x y] = size(img);
acc = ones(181, 2*sqrt(x^2 + y^2));

for o = -90:90
   for i = 1:x
       for j = 1:y
           if img(i, j) == 1
           p = i*cosd(o) + j*sind(o);
           val = p+ sqrt(x^2 + y^2)+1;
           acc(o+91, floor(val)) = acc(o+91, floor(val)) + 1; 
           end
       end
   end    
end

acc(acc<30) = 0;
for i = 1:181
    for j = 1:2*sqrt(x^2 + y^2)
        
        if acc(i, j)>0
            mask = false(x, y);
            xval = 1:x;
            yval = floor((-1*xval*cosd(i-91) + j-801)./sind(i-91));
            total = 0;
            startx = 0;
            starty = 0;
            darkcount = 0;
            currentTotal = 0;
            for xcount= 1:x
                
                if(yval(xcount)<y && yval(xcount)>0)
                    mask(xcount, yval(xcount)) = true;
                    if img(xcount, yval(xcount)) == true
                        if darkcount>5
                            currentTotal = 1;
                            startx = xcount;
                            starty = yval(xcount);
                        else
                            currentTotal = currentTotal + 1;
                            
                            total = max(currentTotal, total);
                        end
                        darkcount = 0;
                    elseif img(xcount, yval(xcount)) == false
                        darkcount = darkcount+1;
                        
                    end
                end
            end
            
%             %figure;
%             %imshow(mask);
%             line = img & mask;
%            
%             %figure;
%             %imshow(line);
%             mask2 = false(x,y);
%             for k = 2:x-1
%                 
%                 for l = 2:y-1
%                     val1 = false;
%                     if line(k, l)>0
%                         region = line(k-1:k+1, l-1:l+1);
%                         if sum(region(:))>2
%                             val1 = true;
%                         end
%                     end
%                     mask2(k, l) = val1;
%                 end
%                 
%             end
%             line = img & mask2;
%             
%             total = sum(line(:));
%             if total>30
%                 
%                  figure;
%                 imshow(img | mask);
%                 figure;
%                 imshow(line);
%                 total
%             end
            acc(i, j) = total;
            %close all;
        end
    end
end

out = acc;

end

