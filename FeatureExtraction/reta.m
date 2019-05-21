%entradas 
% theta = angulo de variação do sonar
% p = range do sonar para obstáculo
% x = distância para criar segmento no mapa


function [xr, yr] = reta(theta, p, x,xv,yv)

theta = theta + pi/2;
[xa,ya] = pol2cart(theta,p);

xa = xa + xv; %xv = x veiculo 
ya = ya + yv; %yv = y veiculo

x = xa + x;

%m = tan(theta);
m = pi/2 - theta;
y = (m*(x - xa)) + ya;

xr = [xa x];
yr = [ya y];

end

% 
%  x1 = cos(theta)*p;
%  y1 = sin(theta)*p;
% 
%  
%  x2 = 
%  y2 =
%  
%  % m = tan(theta);
% % 
% % (y-y1) = m*(x-x1)
% %p - adjacent
% 
% yup = cos(theta+deg2rad(10))/p; %hypothenuse
% xup = yup*sin(theta+deg2rad(10)); %oppositive
% 
% =     %hypothenuse
% 
% 
% 
% 
% 
% theta = theta+10
% [xb,yb] = pol2cart(theta,p);
















