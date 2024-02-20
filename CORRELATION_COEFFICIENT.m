
y1=X(:,1);
y2=X(:,2);

[h1,p1]=lillietest(y1);
[h2,p2]=lillietest(y2);
% [h3,p3]=lillietest(y3);
% [h4,p4]=lillietest(y4);
% [h5,p5]=lillietest(y5);
% [h6,p6]=lillietest(y6);

% p_all = vartestn([y1;y2;y3;y4],[z1;z2;z3;z4],'off');


%bijective transformation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acos_y1=acos(y1);
acos_y2=acos(y2);
% acos_y3=acos(y3);
% acos_y4=acos(y4);

[acos_h1,acos_p1]=lillietest(acos_y1);
[acos_h2,acos_p2]=lillietest(acos_y2);
% [acos_h3,acos_p3]=lillietest(acos_y3);
% [acos_h4,acos_p4]=lillietest(acos_y4);

% [h4,p4]=lillietest(y4);
% [h5,p5]=lillietest(y5);
% [h6,p6]=lillietest(y6);
% acos_p_all = vartestn([acos_y1;acos_y2;acos_y3;acos_y4],[z1;z2;z3;z4],'off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if h1==0 && p1>0.05 && h2==0 && p2>0.05
    disp('Normality: YES')
    
    r=corr(y1,y2,'type','Pearson')
elseif acos_h1==0 && acos_p1>0.05 && acos_h2==0 && acos_p2>0.05
    disp('Normality: transformation YES')
    
    r=corr(y1,y2,'type','Pearson')
else
    disp('Normality: NO')
    r=corr(y1,y2,'type','Spearman')
end
    
% [c,m,h,nms] = multcompare(stats)

%% group number = 2
% clc
% clear 
% close all
% load x1.mat
% load x2.mat
% 
% 
% %colume
% y1=reshape(x1,[],1);
% y2=reshape(x2,[],1);
% 
% 
% %group
% z1=1*ones(length(y1),1);
% z2=2*ones(length(y2),1);
% 
% 
% 
% [h1,p1]=lillietest(y1);
% [h2,p2]=lillietest(y2);
% 
% 
% p_all = vartestn([y1;y2],[z1;z2],'off');
% 
% if h1==0 && p1>0.05 && h2==0 && p2>0.05 && p_all>0.05
%     disp('Normality and Variance: YES')
%     
%     [h,p,ci,stats] = ttest2(y1,y2)%h=0,p>0.05 accept original assumption
% else
%     disp('Normality and Variance: NO')
%     [p,h,stats] = ranksum(y1,y2)%Wilcoxon rank sum test equals to Mann-Whitney U
% end
    

