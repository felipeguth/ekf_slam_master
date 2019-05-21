function updateReferencesPlots(op,angle)

% op =
% 0 draw all
% 1 update sonar
% 2 update vehicle
% 3 update Sonar+vehicle

switch op
    case 0
        
        %sonar and Vehicle
        figure(6)
        vsonar= [-0.3 -0.3 0.3; 0.2 -0.2 0];
        vsf = patch(vsonar(1,:),vsonar(2,:),'b')
        axis equal;
        
        
        %vehicle
        figure(4)
        veh= [0 0 1; 0.3 -0.3 0];
        vf = patch(veh(1,:),veh(2,:),'r')
        axis equal;
        
        %sonar
        figure(5)
        sonar= [-0.3 -0.3 0.3; 0.2 -0.2 0];
        sf = patch(sonar(1,:),sonar(2,:),'g')
        axis equal;        
        
        return
        
    case 1        
        deg = rad2deg(angle);
        delete(figure(5));
        figure(5)
        sonar= [-0.3 -0.3 0.3; 0.2 -0.2 0];
        sf = patch(sonar(1,:),sonar(2,:),'g')
        axis equal;        
        
        zdir = [0 0 1];
        rotate(sf,zdir,deg);        
        return
        
    case 2        
        deg = rad2deg(angle);
        delete(figure(4));
        figure(4)        
        veh= [0 0 1; 0.3 -0.3 0];
        vf = patch(veh(1,:),veh(2,:),'b')
        axis equal;
        
        zdir = [0 0 1];
        rotate(vf,zdir,deg);
        return
        
    case 3        
        deg = rad2deg(angle);
        delete(figure(6));
        figure(6)
        vsonar= [-0.3 -0.3 0.3; 0.2 -0.2 0];
        vsf = patch(vsonar(1,:),vsonar(2,:),'b')
        axis equal;
        
        zdir = [0 0 1];
        rotate(vsf,zdir,deg);
        return
end

% 
% 
% 
% 
% 
% xdir = [0 0 1];
% rotate(vf,xdir,90)
% 
% zdir = [0 0 1];
% rotate(sf,zdir,90)
% 
% 
% 
% %sonar and Vehicle
% 
% %vehicle
% veh= [0 0 1; 0.3 -0.3 0];
% vf = patch(veh(1,:),veh(2,:),'r')
% axis equal;
% xdir = [0 0 1];
% rotate(vf,xdir,90)