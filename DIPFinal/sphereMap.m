function [points, extras] = sphereMap(lines)
[rows, cols] = size(lines);
o = [0,0, -800];
sphere = zeros(360, 181);
for i= 2:rows
    y = lines(i, :);
   p1 = [y(30), 30, 0];
   p2 = [y(300), 300, 0];
   c = cross(p1-o, p2-o);
   mag = sqrt(c(1)^2 + c(2)^2 + c(3)^2);
   n = c / mag;
   for a = 1:360
      b = floor(atand(-1*(n(1)*sind(a) + n(3)*cosd(a))/n(2)));
      sphere(a, b+91) = sphere(a, b+91) + 1;
      if(a>1 && a<360 && b<90 && b>-90)
        sphere(a+1, b+91) = sphere(a+1, b+91) + 1;
        sphere(a-1, b+91) = sphere(a-1, b+91) + 1;
        sphere(a, b+90) = sphere(a, b+90) + 1;
        sphere(a, b+92) = sphere(a, b+92) + 1;
      end
   end
end
vals = sort(max(sphere));
thresh = vals(length(vals)-4);
extras = sphere;
extras(extras>=thresh) = 0;
sphere(sphere<thresh) = 0;

points= [0 0 0];
for a = 1:360
    for b = -90:90
        if sphere(a, b+91)>0
           x = 800 * tand(a);
           y = 800 * tand(b)/cosd(a);
           ind = 0;
           closest = 100000000;
           if length(points(:, 1))>1
               for k = 2:length(points(:, 1))
                   
                   dist = sqrt((points(k, 1)-x)^2 + (points(k, 2)-y)^2);
                   if dist<closest && dist<100
                       closest = dist;
                       ind = k;
                   end
                   
               end
           end
           wt = sphere(a, b+91)/vals(end);
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
% xavg = sum((points(2:end, 1).*points(2:end, 3)))./sum(points(2:end, 3));
% yavg = sum((points(2:end, 2).*points(2:end, 3)))./sum(points(2:end, 3));
% points = [0,0; xavg, yavg];

end

