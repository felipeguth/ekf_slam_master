function auv_sonar_plot(buffer,op)

if op == 1
    
%angle = lastBuffer(:,1);
X = 0.1:0.1:50; %range
Y = -pi:0.03142:0; %angle    
Z = buffer(:,2:501); %intensidade

xmin = 0;
xmax = 50;
ymin = -pi;
ymax = pi;
zmin = 1;
zmax = 159;


%axis([xmin xmax ymin ymax zmin zmax cmin cmax])% sets the x-, y-, and z-axis limits and the color scaling limits (see caxis) of the current axes.
axis([xmin xmax ymin ymax zmin zmax]);

colormap jet; 
contourf(X,Y,Z);
 
 %surf(X,Y,Z);
%scatter(X,Y,Z);

% cmin=1;
% cmax=130;
% axis([0 50 -pi pi]);
else

    X = 0.1:0.1:50;
    Y =  buffer(:,1); %angle 
    Z = zeros(100,500);
    for i = 1:100        
        for j = 1:100             
            val = buffer(i,j+4);
            if val > 0
                Z(i,val) = 1;            
            end
        end    
    end
    size(X)
    size(Y)
    size(Z)
    ymin = min(Y)
    ymax = max(Y)
    
    xmin = 0;
    xmax = 500;
    ymin = min(Y);
    ymax = max(Y);
    zmin = 0;
    zmax = 1;

    %axis([xmin xmax ymin ymax zmin zmax cmin cmax])% sets the x-, y-, and z-axis limits and the color scaling limits (see caxis) of the current axes.
    axis([xmin xmax ymin ymax zmin zmax]);
    colormap jet; 
    contourf(X,Y,Z);
end