function RAW_sonar_plot(initReading,endReading)

    global IS

    readIS; %script de leitura dos dados do sonar

    figure1 = figure;
    figure2 = figure;
    %rawPLOT

    %initReading = 2647;
    %endReading  = 2847;

    %for a=1:100
      %  initReading = a;
      %  endReading  = a;

        x = [];
        y = [];
        z = [];

        for j=initReading:endReading
             theta = IS(initReading,2) + pi/2;%angulo 
             for k=3:502
                 rho = ((k-2)*0.1);
                 [xa,ya] = pol2cart(theta,rho);
                 x = [x,xa];
                 y = [y,ya];
                 %z = [z,0]; %intensidade
                 z = [z,IS(initReading,k)]; %intensidade
             end
             initReading = initReading + 1;
        end
        
        figure1
        scatter(x,y,20,z)
        saveas(figure1,a)
        hold on;
        
        fgure2
        image(zraw)
        hold on;
        
        
       
        
        ;
                
    end
%end


%cria imagem acustica zerada para debug
% for a=pi:2*pi
%     for i=-50:50
%        x = [x;x] 
%        y =
%        z = 1;
%     end    
% end






% 
% xmin = -50;
% xmax = 50;
% ymin = 50;
% ymax = -50;
% zmin = 1;
% zmax = 159;
% 
% 
% %axis([xmin xmax ymin ymax zmin zmax cmin cmax])% sets the x-, y-, and z-axis limits and the color scaling limits (see caxis) of the current axes.
% axis([xmin xmax ymin ymax zmin zmax]);
% 
% colormap jet; 
% contourf(x,y,z);
%  















% 
% threshold = 50;
% 
% initReading = 1;
% 
% buffer = zeros(100,501);
% 
% theta = [];
% rho = [];
% c=1;
% fig = figure;
% polar(0,0)
% hold on;
% 
% for j=1:100
%     buffer(j,1) = IS(initReading,2);%angulo 
%     
%     for k=3:502
%         buffer(j,k-1) = IS(initReading,k);
%         
%         if IS(initReading,k) > threshold
%             theta(c) = buffer(j,1);
%             rho(c) = ((k-2)*0.1);
%             polar(theta(c),rho(c),'r+')
%             hold on;
%             c = c+1;
%         end
%     end
%     initReading = initReading + 1;
% end
% 
% sonar_plot(buffer)

% 
% 
% function sonar_plot(buffer)
% 
% %angle = lastBuffer(:,1);
% X = 0.1:0.1:50; %range
% Y = -pi:0.03142:0; %angle    
% Z = buffer(:,2:501); %intensidade
% 
% xmin = 0;
% xmax = 50;
% ymin = -pi;
% ymax = pi;
% zmin = 1;
% zmax = 159;
% 
% 
% %axis([xmin xmax ymin ymax zmin zmax cmin cmax])% sets the x-, y-, and z-axis limits and the color scaling limits (see caxis) of the current axes.
% axis([xmin xmax ymin ymax zmin zmax]);
% 
% colormap jet; 
% contourf(X,Y,Z);
%  
% 
% theta = []
% rho = [];
% 
% 
% theta(l,c)
% rho(l,c)
% 
% 
% theta = 
%  %surf(X,Y,Z);
% %scatter(X,Y,Z);

% cmin=1;
% cmax=130;
% axis([0 50 -pi pi]);


