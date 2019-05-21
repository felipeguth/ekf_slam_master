dgpsPlot()
hold on;

load('/home/guth/Desktop/SLAM/ekf_slam/Res/DR.mat');

plot(DR(:,1),DR(:,2),'r')
hold on;

load('/home/guth/Desktop/SLAM/ekf_slam/Res/finalSlam.mat');
plot(finalSlam(:,1), finalSlam(:,2),'g');

