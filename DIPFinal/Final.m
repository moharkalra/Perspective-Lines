img = imread("0023.jpg");

points = perspLines(img);
figure;
imshow(img);
axis on
hold on;
maxcount = sort(max(points));


[rows, cols] = size(points);
vals = sort(max(points));
thresh = vals(length(vals)-floor(length(vals)*.25));
points(points<thresh) = 0;
[stout, ind] = max(points');
yvals = 1:2000;
verts = 1:2000;
%weights = [];

for i = 20:rows-20
    %for j = 1:cols
        if points(i, ind(i))>0
            
                x = 1:2000;
                y = (-1*x*cosd(i-91) + ind(i)-801)./sind(i-91);
                yvals = [yvals; y];
                %weights = [weights, points(i, ind(i))];
                if points(i, ind(i))>vals(length(vals)-floor(length(vals)*.15))
                    plot(y, x); 
                end
        end
        
    %end
end
thresh = vals(length(vals)-floor(length(vals)*.15));
points(points<thresh) = 0;
for i = [1:10, rows-10:rows]
    
        if points(i, ind(i))>0
            
                x = 1:2000;
                y = (-1*x*cosd(i-91) + ind(i)-801)./sind(i-91);
                verts = [verts; y];
                %weights = [weights, points(i, ind(i))];
                verts = [verts; y];
            
        end
        
   
end
[vp, extras] = sphereMap(yvals);
[vp2, ~] = sphereMap(verts);

[~, m] = max(vp(:, 3));
vpFinal = [vp(m, 1), vp(m, 2)];
plot(vpFinal(1), vpFinal(2), "r*", 'LineWidth', 3);

[~, m] = max(vp2(:, 3));
plot(vp2(m, 1), vp2(m, 2), "g*");
vp2Final = [vp2(m, 1), vp2(m, 2)];
line = dual(vp2(m, 1), vp2(m, 2));





p = polyfit(line(20:80, 1),line(20:80, 2),1);
f = polyval(p,-3000:3000);

diff = vpFinal(2) - f(floor(vpFinal(1))+3000);
f = f + diff;
plot(-3000:3000, f, "b", "LineWidth", 2);

[vp3] = extraPoints(extras, f, vpFinal, vp2Final);

% for k = 2:length(vp3(:, 1))
%     plot(vp3(k, 1), vp3(k, 2), "b*");
% 
% end

[~, m] = max(vp3(:, 3));
if m>1
plot(vp3(m, 1), vp3(m, 2), "b*", "LineWidth", 3);
end


