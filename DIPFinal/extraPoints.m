function [points] = extraPoints(extras, yin, vpFinal, vp2Final)
vals = sort(max(extras));
thresh = vals(length(vals)-floor(length(vals)*.5));

extras(extras<thresh) = 0;
midDistance = 10000000000000;
%midx = vp2Final(1);
% for k = -3000:3000
%                
%     distLine = sqrt((k-vp2Final(1))^2 + (yin(k+3001)-vp2Final(2))^2);
%     if distLine<midDistance
%         midDistance = distLine;
%         midx = k;
%     end
% end


points= [0 0 0];
for a = 1:360
    for b = -90:90
        if extras(a, b+91)>0
           x = 800 * tand(a);
           y = 800 * tand(b)/cosd(a);
           
           
           collinear = false;
           
           for k = -3000:3000
               
               distLine = sqrt((k-x)^2 + (yin(k+3001)-y)^2);
               if distLine<50
                   collinear = true;           
               end   
           end
           distVP = sqrt((vpFinal(1)-x)^2 + (vpFinal(2)-y)^2);
               if distVP<300
                   collinear = false;           
               end 
               
%                if (midx-vpFinal(1))/(midx-x) >0
%                    collinear = false;           
%                end  
           if collinear == true
               
               ind = 0;
               closest = 100000000;
               if length(points(:, 1))>1
                   for k = 2:length(points(:, 1))
                       
                       dist = sqrt((points(k, 1)-x)^2 + (points(k, 2)-y)^2);
                       if dist<closest && dist<400
                           closest = dist;
                           ind = k;
                       end
                       
                   end
               end
               wt = extras(a, b+91)/vals(end);
               if ind>0
                   points(ind, 1) = (points(ind, 1)*points(ind, 3)+ x*wt)./(wt + points(ind, 3));
                   points(ind, 2) = (points(ind, 2)*points(ind, 3)+ y*wt)./(wt + points(ind, 3));
                   points(ind, 3) = (wt + points(ind, 3));
               else
                   points = [points; x, y, wt];
               end
               
           end
        end
    end
end 
end

