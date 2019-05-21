

% [x1, y1] = pol2cart(theta,rho);
% 
% slope = tan(theta);
% 
% x1 = x1 + xv;
% y1 = y1 + yv;
% 
% var = 2;
% 
% 
% a = cos(theta);
% b = sin(theta);
% 
% if a == 1 || -1 %varia apenas y
%     y2 = y1 + var;
%     x2 = x1;
% else if b == 1 || -1 %varia apenas x
%         x2 = x1 + var;
%         y2 = y1;
%     else %varia x e y
%         x2 = 
%         y2 =
%     end
% end

thetaL = pi/2 - theta;


syms x m b
m = tan(thetaL);

eq2 = m*x+b;

sol = solve(eq2,'m=1','x=4','x,b');

lot(x1,y1,'r+');
hold on
ezplot(eq2); title('the line');
plot(sol.x,sol.y,'ro');





% 
% clear all; close all;
% slope = 0;
% 
% %the point, whatever
% x1 = 4;
% y1 = 6.5;
% 
% %make equation of line
% syms x y
% eq1 = (y-y1)/(x-x1)-slope
% 
% %find where it cross the x-axis
% sol = solve(eq1,'y=0','x,y');
% 
% %make plot
% hold on
% plot(x1,y1,'r+');
% hold on
% ezplot(eq1); title('the line');
% plot(sol.x,sol.y,'ro');