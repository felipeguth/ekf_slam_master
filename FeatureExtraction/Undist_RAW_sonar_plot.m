%function Undist_RAW_sonar_plot(timer)
function Undist_RAW_sonar_plot(initReading, endReading)
ir = initReading;

global IS Vf linhaBuffer bufferISAux

load('/home/guth/Desktop/SLAM/ekf_slam/StPereDataset/histTimePoseDR.mat');

    figure1 = figure;
    %figure2 = figure;
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
    % saveas(figure1,a)
    hold on;
        
    initTime = IS(ir,1); 
    endTime = IS(endReading,1);
    
    %deslocamento
    
    %index
    i = 1;   
    while histIt(i,1) ~= initTime        
        indexInit = i + 1;
        i = i +1;
    end
    
    i = 1;
    while histIt(i,1) ~= endTime        
        indexEnd = i + 1;
        i = i +1;
    end
    
    indexInit;
    indexEnd;
    
    dtx = histIt(indexEnd,2) - histIt(indexInit,2);
    dty = histIt(indexEnd,3) - histIt(indexInit,3);
    dttheta = histIt(indexEnd,4) - histIt(indexInit,4);
    
end

%monta nova imagem







%for in buffer
%for 

%bufferISAux 1 sonarAngle 2 robotX 3robotY 4robotYaw 5:504sonar returns

% %carrega Buffer TESTING
% for i=1:size(IS,1)
%     if IS(i,1) == timer
%         while IS(i,1) == timer
%             bearing = IS(i,2) + pi/2;
%             timer, bearing, Vf
%             bufferISAux(linhaBuffer,1) =  bearing;%sonarAngle
%             bufferISAux(linhaBuffer,2) = Vf(1);%xRobot
%             bufferISAux(linhaBuffer,3) = Vf(2);%yRobot
%             bufferISAux(linhaBuffer,4) = Vf(3);%YawRobot
%             
%             
%             bufferISAux(linhaBuffer,5:504) = IS(i,3:502);
%             
%             i = i+1;
%             lastIndex = linhaBuffer;
%             
%             if linhaBuffer == 100
%                 linhaBuffer = 1; %
%             else
%                 linhaBuffer = linhaBuffer + 1;
%             end
%         end
%     else
%         break;
%     end
%     break;
% end
% 
% if bufferISAux(100,1) ~= 999
%     undistorce(lastIndex,bufferISAux);
% end
% 
% for k=1:i-1
%     IS(1,:) = [];
% end
% 
% 
% 
% function printaBuffer
% %PRINTA BUFFER
%  xa = [];
%  ya = [];
%  za = [];
% 
%         for ja=1:100
%              thetaa = bufferISAux(ja,1);%angulo 
%              for ka=1:500
%                  rhoa = (ka*0.1);
%                  [xaa,yaa] = pol2cart(thetaa,rhoa);
%                  xa = [xa,xaa];
%                  ya = [ya,yaa];
%                  %z = [z,0]; %intensidade
%                  za = [za,bufferISAux(ja,ka+4)]; %intensidade
%              end             
%         end
% 
%         scatter(xa,ya,20,za)
%           hold on;
% %%%%%%%%%%%%%%%    end TESTING

% 
% 
% function undistorce(lastIndex,bufferISAux)
% 
% lastAngle = bufferISAux(lastIndex,1);% + bufferISAux(linhaBuffer,4);
% lastX = bufferISAux(lastIndex,2);
% lastY = bufferISAux(lastIndex,3);
% x = [];
% y = [];
% z = [];
% 
% for i=1:100
%     
%     if i ~= lastIndex
%     
%         deltaTheta = lastAngle - (bufferISAux(i,1));%+ bufferISAux(i,4));   
%         deltaXr = lastX - bufferISAux(i,2);
%         deltaYr = lastY - bufferISAux(i,3);
% 
%         for j=1:500
%             x = [x, (j*0.1) * cos(-deltaTheta) - deltaXr];
%             y = [y, (j*0.1) * sin(-deltaTheta) - deltaYr];
% 
%     %         x = [x, xp + deltaXr *cos(deltaTheta) - sin(deltaTheta)];
%     %         y = [y, yp + deltaYr *cos(deltaTheta) + sin(deltaTheta)];
%             z = [z, bufferISAux(i,j+4)];
% 
%             %          [xp,yp] = pol2cart(bufferISAux(i,1), j*0.1);
%     %         x = [x, xp + deltaXr];   
%     %         y = [y, yp + deltaYr];
%     %         z = [z, bufferISAux(i,j+4)];
%         end
%     else
%         for k=1:500
%             [a,b] = pol2cart(lastAngle,k*0.1);
%             x = [x,a];
%             y = [y,b];
%             z = [z,bufferISAux(lastIndex,k+4)];        
%         end
%     end    
%     % j x = ver multiplicar todos elementos - nao necessita o for
% end
% 
% figure(2) 
% scatter(x,y,20,z)
% 
% % %back to polar to voting
%  %for i=1:100
%   %   for j=1:500
%          [theta,rho] = cart2pol(x,y,z)
%         % encaixa no buffer
%       %end
%  %end
% % 
% 
% %vehicle
% veh= [0 0 1; 0.3 -0.3 0];
% vf = patch(veh(1,:),veh(2,:),'r')
% axis equal;
% xdir = [0 0 1];
% rotate(vf,xdir,90)
% 
% 
% %sonar
% %figure3 = figure
% sonar= [-0.3 -0.3 0.3; 0.2 -0.2 0];
% sf = patch(sonar(1,:),sonar(2,:),'r')
% axis equal
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



