function [line] = dual(xin, yin)
o = [0,0, 800];
sphere = zeros(360, 181);
p = [xin, yin, 0];

c = p-o;
mag = sqrt(c(1)^2 + c(2)^2 + c(3)^2);
n = c / mag;
for a = 1:360
    b = floor(atand(-1*(n(1)*sind(a) + n(3)*cosd(a))/n(2)));
    sphere(a, b+91) = sphere(a, b+91) + 1;
    
end


line= [0 0];
for a = 1:180
    for b = -90:90
        if sphere(a, b+91)>0
           x = 800 * tand(a);
           y = 800 * tand(b)/cosd(a);
           
           line = [line; x, y];
           
        end
    end
end 

end

