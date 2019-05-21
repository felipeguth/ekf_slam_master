function [x2,y2,m] = reta2(x1,y1,theta) %firstPoint LastPoint

%theta = deg2rad(30);
%rho = 2;
% 
% theta = pi_to_pi(theta);
% 
% [x1,y1] = pol2cart(theta,rho);
% 
% x1 = x1 + xv;
% y1 = y1 + yv;

var = 2; 

a = cos(theta);
b = sin(theta);

if a == 1 || a == -1 %varia apenas y    
    y2 = y1 + var;
    x2 = x1;
    m = (y2-y1)/(x2-x1);
else
    if b == 1 || b == -1 %varia apenas x        
         x2 = x1 + var;
         y2 = y1;
         m = (y2-y1)/(x2-x1);
    else %varia x e y
        
        an1 = pi_to_pi(deg2rad(315));
        an2 = pi_to_pi(deg2rad(45));
        an3 = pi_to_pi(deg2rad(135));
        an4 = pi_to_pi(deg2rad(225));

        alpha =pi_to_pi(pi/2 - theta);
        betha =pi_to_pi(pi/2 - alpha);
        
        x2 = x1 + ( y1*tan(betha));
        y2 = 0;
        m = (y2-y1)/(x2-x1);
        
        if (theta > an1 && theta <= an2) || (theta <= an4 && theta > -pi) || (theta > an3 && theta < pi)   %corta x
            y2 = 0;
            x2 = x2;            
        else
            if (theta > an2 && theta <= an3) || (theta > an4 && theta <= an1) %corta y
                x2 = 0;                   
                y2 = (m*x2)+(-m*x1)+y1;            
            else
                err = 6666
                theta
            end 
        end
    end
end
%         hold on
%         plot(x1,y1,'m+');
% %         plot(x2,y2,'g+');
% %         hold on
%          xl = [x1 x2];
%         yl = [y1 y2];
%         
        
%         hold on
%         plot(x1,y1,'r+')
%         hold on
%         plot(x2,y2,'r+')
%         hold on
%         plot(xl, yl,'g');




        
        
        
        
        
        
        
        
        
        
        
        
% theta = 0;
% theta = pi_to_pi(deg2rad(180)); 
% 
% theta = pi_to_pi(deg2rad(90));
% theta = pi_to_pi(deg2rad(270));


%theta = pi_to_pi(deg2rad(316)); %corta x
%theta = pi_to_pi(deg2rad(45)); 
%theta = pi_to_pi(deg2rad(350));
%theta = pi_to_pi(deg2rad(25));

%theta = pi_to_pi(deg2rad(136));
% theta = pi_to_pi(deg2rad(225));
% theta = pi_to_pi(deg2rad(175));
% theta = pi_to_pi(deg2rad(215));

% 
% theta = pi_to_pi(deg2rad(46)); %corta y
% theta = pi_to_pi(deg2rad(135)); 
% theta = pi_to_pi(deg2rad(89)); 
% theta = pi_to_pi(deg2rad(100));
% 
% theta = pi_to_pi(deg2rad(226));
% theta = pi_to_pi(deg2rad(315));
% theta = pi_to_pi(deg2rad(300));
% theta = pi_to_pi(deg2rad(280));



        
        
        
        
        
        
        
        

%a = x1;
%b = y1;
%b = sin(theta)*rho;
%c = x1 + ( y1*tan(betha));
%x2 = c;

% 
% xl3 = [x1 x2];
% yl3 = [y1 y2];
% hold on
% plot(xl3,yl3,'g');
% 




% 
% 
% 
% x2 = ((y2-y1)+ (x1*m))/m;
% 
% 
% 
% y3 = m * x3 + m * x1 + y1;
% 
% 
% xl = [x1 x2];
% yl = [y1 y2];
% 
% hold on
% plot(x1,y1,'r+')
% hold on
% plot(x2,y2,'r+')
% hold on
% plot(xl, yl,'g');
% hold on;
% axis equal


%se aumentar x deixar m negativo

%se diminuir x deixar m positivo