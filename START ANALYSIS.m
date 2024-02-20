clc
clear 
close all;
tic

pic_set = 1:1:46;

SE_angle = [];
SE_r = [];

corr_angle = [];
corr_r = [];
corr_r_angle = [];

for i_ps = 1:length(pic_set)
imgname = ['C:\Users\Administrator\Desktop\CME\DATA\cell morphology\cell pair\cell pair 1\pic\down\ima_', sprintf('%d', pic_set(i_ps)), '.jpg'];  
I = imread(imgname);
gray_img = rgb2gray(I);
w = fspecial('gaussian',[5 5],2);
gray_img2 = imfilter(gray_img ,w);
T = graythresh(gray_img2);
BW = imbinarize(gray_img2,T);

BW1 = imfill(BW,'holes');
imLabel = bwlabel(BW1);  
stats = regionprops(imLabel,'Area');
all_area = cat(1,stats.Area);
index = find(all_area == max(all_area));       
BW2 = ismember(imLabel,index); 

imwrite(BW2,['C:\Users\Administrator\Desktop\CME\DATA\cell morphology\cell pair\cell pair 1\pic\down\', sprintf('%d', pic_set(i_ps)), '.jpg'])

stats_centroid = regionprops(BW2,'Centroid');
center = stats_centroid.Centroid;%x,y
Boundary = bwboundaries(BW2,'noholes');
boundary = Boundary{1};

pixel = 0.65;
stats_perimeter = regionprops(BW2,'Perimeter');
perimeter = stats_perimeter.Perimeter*pixel;

stats_area = regionprops(BW2,'Area');
area = stats_area.Area *pixel^2;

all_r0 = ((boundary(:,2) - center(1)).^2 + (boundary(:,1) - center(2)).^2).^0.5*pixel;
std_Allr = std(all_r0,0,1);
point_n = length(all_r0);

angle_x0 = zeros(point_n,1);  
angle_y0 = zeros(point_n,1);

for i = 1:length(all_r0)
    angle_x0(i) = acos(dot([boundary(i,2) - center(1),boundary(i,1) - center(2)],[1,0])...
            /(norm([boundary(i,2) - center(1),boundary(i,1) - center(2)])*norm([1,0])));
    angle_y0(i) = acos(dot([boundary(i,2) - center(1),boundary(i,1) - center(2)],[0,1])...
            /(norm([boundary(i,2) - center(1),boundary(i,1) - center(2)])*norm([0,1])));    
    if angle_y0(i) > 0.5*pi
            angle_x0(i) = 2*pi - angle_x0(i);
    end
end

temp_angle_x0 = angle_x0(1:end-1)-angle_x0(2:end);
locate = find(temp_angle_x0 == max(temp_angle_x0));

angle_x = [angle_x0(locate+1:end);angle_x0(1:locate)];
angle_y = [angle_y0(locate+1:end);angle_y0(1:locate)];
all_r = [all_r0(locate+1:end);all_r0(1:locate)];

r_n = length(all_r);
lag = 2;

d1_angle = [];
d1_r = [];
for i = 1:lag:r_n
    d1_angle = [d1_angle;angle_x(i)];
    d1_r = [d1_r;all_r(i)];
end

d2_angle = [];
d2_r = [];
d2_n = length(d1_angle)-1;
for i = 1:d2_n
    d2_angle = [d2_angle;d1_angle(i+1)-d1_angle(i)];
    d2_r = [d2_r;d1_r(i+1)-d1_r(i)];
end

d3_angle = [];
d3_r = [];
d3_n = length(d1_angle)-2;
for i = 1:d3_n
    d3_angle = [d3_angle;d2_angle(i+1)-d2_angle(i)];
    d3_r = [d3_r;d2_r(i+1)-d2_r(i)];
end

bin_n = 15;
[d2_angle_bin,~] = hist(d2_angle,linspace(-0.2,0.2,bin_n));
d2_angle_p = d2_angle_bin/length(d2_angle);

SE1_angle = 0;
for i=1:bin_n
    if d2_angle_p(i) ~= 0
        SE1_angle = SE1_angle+(-d2_angle_p(i)*log2(d2_angle_p(i)));
    else
        SE1_angle = SE1_angle+0;
    end
    
end
SE2_angle = SE1_angle/log2(bin_n);

[d2_r_bin,~] = hist(d2_r,linspace(-5,5,bin_n));
d2_r_p = d2_r_bin/length(d2_r);

SE1_r = 0;
for i=1:bin_n
    if d2_r_p(i) ~= 0
        SE1_r = SE1_r+(-d2_r_p(i)*log2(d2_r_p(i)));
    else
        SE1_r = SE1_r+0;
    end
    
end
SE2_r = SE1_r/log2(bin_n);

SE2 =(SE2_angle+SE2_r)/2;

SE_angle = [SE_angle;SE2_angle];
SE_r = [SE_r;SE2_r];

end
SE = [SE_angle SE_r (SE_angle+SE_r)/2];

figure()
plot(SE(:,1),'Or')
title('H ANGLE')
figure()
plot(SE(:,2),'Or')
title('H R')
figure()
plot(SE(:,3),'Or')
title('MEAN')
figure()
plot(SE(:,1),SE(:,2),'Or')
title('H ANGLE VS H R')

toc