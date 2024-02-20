function [corr_vxy] = CROSS_CORRELATION(vx,vy,tao_n)

point_n = length(vx);

ave_vx = mean(vx,1);
ave_vy = mean(vy,1);

var_vx = mean((vx-ave_vx).^2,1);
var_vy = mean((vy-ave_vy).^2,1);

corr_vxy = zeros(tao_n,1);
for i = 0:tao_n-1
    temp1 = 0;
    for j = 1:point_n-i
        temp1 = temp1+(vx(j)-ave_vx)*(vy(j+i)-ave_vy);
    end
    temp2 = temp1/(point_n-i);
    corr_vxy(i+1) = temp2/(var_vx^0.5*var_vy^0.5);
    
end

