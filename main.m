function [vetX, vetY, ft] = main

%adjustment of sensors time
global XX PX IS bufferIS linhaBuffer x_v y_v Vf Sf  vf vsf sf associado naoassociado vetX vetY xPath yPath ft bufferISAux vetFeature


load('/media/phd/SAMSUNG/Documents/Code/ekf_slam_v6/StPereDataset/IS.mat');
load('/media/phd/SAMSUNG/Documents/Code/ekf_slam_v6/StPereDataset/MTI.mat');
load('/media/phd/SAMSUNG/Documents/Code/ekf_slam_v6/StPereDataset/DVL.mat');

auv_configfile;

ft = [0,0,0];

associado = 0;
naoassociado = 0;
bufferIS = zeros(LINHAS_BUFFER,SIZE_BUFFER); 
bufferIS(:,1) = 999*ones(LINHAS_BUFFER,1); 
vetFeature = [0;0;0];
%teste 360
bufferISAux = zeros(200,504);
%bufferISAux 1 sonarAngle 2 robotX 3robotY 4robotYaw 5:504sonar returns


linhaBuffer =1; %controla a linha atual para inclusão de leituras do sonar

%readIS; %script for sonar reading
IS(1:2646,:) = []; %exclude data to sinc with dvl and mti
%IS(1:2546,:) = [];


%filter sonar - testing
 %imOrig = bufferISAux(:,5:504);
 h = fspecial('average', [5 5]);
 IS(:,3:502) = filter2(h,IS(:,3:502));


for t=1:5045
    DVLlogTime(t) = round(DVLlogTime(t) - 1093400000.000);
end

for t=1:33457
    MTiLogTime(t) = round(MTiLogTime(t) - 1093400000.000);
end


for t=1:43613
    IS(t,1) = round(IS(t,1) - 1093400000.000);
    %tratamento de dados do sonar, 2 primeiros bins sao retornos falsos (eu
    %acho)
    IS(t,3:15) = 0;%sombra do robô
    IS(t,400:502) = 0;        
end

%end sensor adjustment


format compact

%R =[Rd zeros(3,2);zeros(1,3) Rp 0;zeros(1,4) Rc];

Vf = [0,0,0]; %vehicle pose x,y,yaw 
Sf = [0,0,0]; %sonar frame x,y,theta

XX = zeros(8,1);
PX = zeros(8);

dt = 1;
initTimer = 55407;
%endTimer = 55407;
%endTimer = 58426;
endTimer = initTimer + 2688;

firstMTi = pi_to_pi(deg2rad(MTiYaw(1)));% -pi/2);

XX(4) = firstMTi; %initializes yaw
Yaw = XX(4);
%updateReferencesPlots(2,firstMTi);

i = 1;
contDVL = 1;
contMTi = 1;

figure(1);
plot(0,0)
hold on;
dgpsPlot();
hold on;
histIt = [0 0 0 0];

 firstRead = 1;
% [firstRead, matFeat] = sonar360(0,firstRead,[0,0,firstMTi]);

for timer= initTimer:dt:endTimer
    
    nX = auv_add_noise_movement(Q);    
    ekfpredict(nX,Q,dt);     
    plot(XX(1),XX(2),'g');
    hold on;
    
    
    %busca indices para leitura de acordo com tempo
    while DVLlogTime(contDVL) ~= timer  
        contDVL = contDVL + 1;
    end

    while MTiLogTime(contMTi) ~= timer            
        contMTi = contMTi + 1;
    end

    %lê dados DVL
    if DVLbottomStatus(contDVL) == 1    
            VelXDVL = (DVLbottomVelX(contDVL)/100) * cos(0.5236) - (DVLbottomVelY(contDVL)/100) * sin(0.5236); %m/s 30 graus
            VelYDVL = ((DVLbottomVelX(contDVL)/100) * sin(0.5236) + (DVLbottomVelY(contDVL)/100) * cos(0.5236)) *-1; %m/s 30 graus*-1;
            VelZDVL = DVLbottomVelZ(contDVL)/100;
    else if DVLwaterStatus(contDVL) == 1          
            VelXDVL = (DVLwaterVelX(contDVL)/100) * cos(0.5236) - (DVLwaterVelY(contDVL)/100) * sin(0.5236); %m/s 30 graus DVLwaterVelX(contDVL)/100; 
            VelYDVL = ((DVLwaterVelX(contDVL)/100) * sin(0.5236) + (DVLwaterVelY(contDVL)/100) * cos(0.5236)) *-1; %m/s 30 graus*-1; DVLwaterVelY(contDVL)/100*-1;
            VelZDVL = DVLwaterVelZ(contDVL)/100;       
        else
            VelXDVL = 0; 
            VelYDVL = 0;
            VelZDVL = 0;
        end
    end
    
 
    %lê dados MTi 
        Yaw     = pi_to_pi(deg2rad(MTiYaw(contMTi)));%-firstMTi)); %degrees   
        VelYaw  = MTiVelYaw(contMTi);  %radsec
   % end
    
    
    XX(4) = Yaw; %theta
    XX(5) = VelXDVL; %VelX
    XX(6) = VelYDVL; %VelY
    XX(7) = VelZDVL; %VelZ
    XX(8) = VelYaw; %VelYaw    
    
    sizeN = (size(XX,1) - 8)/2;%number of features - each feature is a theta rho pair
    update_deadReckoning(VelXDVL,VelYDVL,VelZDVL,Yaw,VelYaw,sizeN,Rd,Rc);
    
    Vf = [XX(1),XX(2),XX(4)];
    
    %Build 360 dg sonar image
%    [firstRead, z] = sonar360(timer,firstRead,Vf);    
%          
%      %sonar reading
      sonarRead(timer,THRESHOLD,LINHAS_BUFFER,NUM_SEGMENTED_BINS,NUM_BINS_MAXIMA, LIMIT_DISTANCE_BINS);                       
%          
%  %      %Undist_RAW_sonar_plot(timer); %VER como adaptar distorção no buffer e local maximas    
      z = voting(LINHAS_BUFFER,SIZE_BUFFER);   
      
      

     if size(z,1) > 0
          dataAssociation(z,Rs,GATE_REJECT,GATE_AUGMENT,timer);
     end
%      
    histIt = [histIt; timer, XX(1),XX(2),XX(4)];
    
    drawnow;
%      nz = size(z,2);
%      
%      
%      if nz > 0
%          for nzi=1:nz
%             rho = z(1,nzi);
%             theta = z(2,nzi);             
%              
%          end
%      end
% %      if size(z,1) > 0
% %          rho = z(1,1);
% %          theta = z(2,1);
% %          
% %          [xs,ys] = pol2cart(theta,rho);
% %          xp = Vf(1,1) + xs*cos(Vf(1,3)) - ys*sin(Vf(1,3));
% %          yp = Vf(1,2) + xs*sin(Vf(1,3)) + ys*cos(Vf(1,3));
% %          hold on;
% %          plot(xp,yp,'m+');
% %          
% %          dataAssociation(z,Rs,GATE_REJECT,GATE_AUGMENT,timer);
% %          %                  %data_associate(XX,PX,z,Rs,GATE_REJECT,GATE_AUGMENT);
% %      end
     %end    
     
     %timer
     i = i+1;
end

histIt;
% view(180,-90);
% 
% 
% for timer= initTimer:dt:endTimer    
%              
%     nX = auv_add_noise_movement(Q);    
%     ekfpredict(nX,Q,dt);    
%     
%   %ix = ix + 1;
%     %GPS
%     plot(xgps(ix),ygps(ix));
%     hold on;
%     %DR
%     plot(a(ix),b(ix),'g');
%     hold on;
% % %        
% % %     %busca indices para leitura de acordo com tempo
% % %     while DVLlogTime(contDVL) ~= timer  
% % %         contDVL = contDVL + 1;
% % %     end
% % % 
% % %     while MTiLogTime(contMTi) ~= timer            
% % %         contMTi = contMTi + 1;
% % %     end
% % % 
% % %     %lê dados DVL
% % %     if DVLbottomStatus(contDVL) == 1    
% % %             VelXDVL = (DVLbottomVelX(contDVL)/100) * cos(0.5236) - (DVLbottomVelY(contDVL)/100) * sin(0.5236); %m/s 30 graus
% % %             VelYDVL = ((DVLbottomVelX(contDVL)/100) * sin(0.5236) + (DVLbottomVelY(contDVL)/100) * cos(0.5236)) *-1; %m/s 30 graus*-1;
% % %             VelZDVL = DVLbottomVelZ(contDVL)/100;
% % %     else if DVLwaterStatus(contDVL) == 1          
% % %             VelXDVL = (DVLwaterVelX(contDVL)/100) * cos(0.5236) - (DVLwaterVelY(contDVL)/100) * sin(0.5236); %m/s 30 graus DVLwaterVelX(contDVL)/100; 
% % %             VelYDVL = ((DVLwaterVelX(contDVL)/100) * sin(0.5236) + (DVLwaterVelY(contDVL)/100) * cos(0.5236)) *-1; %m/s 30 graus*-1; DVLwaterVelY(contDVL)/100*-1;
% % %             VelZDVL = DVLwaterVelZ(contDVL)/100;       
% % %         else
% % %             VelXDVL = 0; 
% % %             VelYDVL = 0;
% % %             VelZDVL = 0;
% % %         end
% % %     end
% 
%     %lê dados MTi
%     Yaw     = pi_to_pi(deg2rad(MTiYaw(contMTi)));%-firstMTi)); %degrees
%     VelYaw  = MTiVelYaw(contMTi);  %radsec
%            
% %      if timer > 58231 && timer < 58253 
% %          Yaw = -0.05; 
% %      end
%      
%         
%     XX(4) = Yaw; %theta
%    % XX(5) = VelXDVL; %VelX
%   %  XX(6) = VelYDVL; %VelY
%  %   XX(7) = VelZDVL; %VelZ
%     XX(8) = VelYaw; %VelYaw
%        
%     
%      XX(1) = xgps(ix);   
%     XX(2) = ygps(ix);
%     %update - implement
%     sizeN = (size(XX,1) - 8)/2;%number of features - each feature is a theta rho pair
%     %update_deadReckoning(VelXDVL,VelYDVL,VelZDVL,Yaw,VelYaw,sizeN,Rd,Rc);
%     
%     
%  %   updateReferencesPlots(2,XX(4));
%     
%     %     
% %     
% %     vehicle plotting
% %      pose = [XX(1:2); XX(4)];
% %      xv= transformtoglobal(veh, pose);
% %      set(h.xv, 'xdata', xv(1,:), 'ydata', xv(2,:)) 
%      %figure(1)      
%                     
%      %sonarRead(timer,THRESHOLD,LINHAS_BUFFER,NUM_SEGMENTED_BINS,NUM_BINS_MAXIMA, LIMIT_DISTANCE_BINS);                    
% %     
% %     %Undist_RAW_sonar_plot(timer); %VER como adaptar distorção no buffer e local maximas    
%     % z = voting(LINHAS_BUFFER,SIZE_BUFFER);   
%     
%    %  timer     
%            
%      
%      z = sonarReadTeste(timer); %SALVEEEE
%      
%       %sonarRead(timer,THRESHOLD,LINHAS_BUFFER,NUM_SEGMENTED_BINS,NUM_BINS_MAXIMA, LIMIT_DISTANCE_BINS);
% % %     
% % %     %Undist_RAW_sonar_plot(timer); %VER como adaptar distorção no buffer e local maximas    
%    %  z = voting(LINHAS_BUFFER,SIZE_BUFFER);  
%      
%     
%     
%              if size(z,1) > 0
% %                  rho = z(1,1);
% %                  theta = z(2,1);
%                  
% %                  [xs,ys] = pol2cart(theta,rho);
% %                  xp = Vf(1,1) + xs*cos(Vf(1,3)) - ys*sin(Vf(1,3));
% %                  yp = Vf(1,2) + xs*sin(Vf(1,3)) + ys*cos(Vf(1,3));
% %                  hold on;
% %                  plot(xp,yp,'m+');
%                  
%                  dataAssociation(z,Rs,GATE_REJECT,GATE_AUGMENT,timer);
%                  %data_associate(XX,PX,z,Rs,GATE_REJECT,GATE_AUGMENT);
%              end
%          %end
%      
%           
%    Vf = [XX(1),XX(2),XX(4)];
%     
%     x_v = XX(1);
%     y_v = XX(2);
%     i=i+1;    
%     
%      plot(x_v,y_v,'r')
%      hold on
%      axis equal
%      drawnow;   
%     vetX = [vetX; x_v];
%     vetY = [vetY; y_v];
% 
%     %end
%     
%     
% %     
% % %     ln;
% %      a = size(z,1);
% %      for i=1:a     
% %          dataAssociation(z(a));         
% % %         [xs,ys] = pol2cart(ln(i,1),ln(i,2));                   
% % %         xp = Vf(1,1) + xs*cos(Vf(1,3)) - ys*sin(Vf(1,3));
% % %         yp = Vf(1,2) + xs*sin(Vf(1,3)) + ys*cos(Vf(1,3));
% % %     %    figure(1)
% % %         plot(xp,yp,'r+')
% % %         hold on
% % %         axis equal
% % %         drawnow;
% %      end
% %     
%            
% %       vetorPoints = [];
% %       vetorPoints = sonarReadTeste(timer);     
% %       p = size(vetorPoints,1);
% %      
% %       for ip=1:p
% %           xp = vetorPoints(ip,1); 
% %           yp = (vetorPoints(ip,2));%*(-1));
% %           plot(xp,yp,'r+');
% %           hold on;
% %       end
% %     
% % 
% % plot(x_v,y_v,'r');
% % hold on;
% % grid on;
% % axis;
% % h1 = figure;
% % dgpsPlot();
% % 
% % plot(x_v,y_v,'r');
% 
% end    
% 
% naoassociado %SALVAR VETORES DE X e Y
% associado
% size(XX)
% size(PX)
% 
% % h1 = figure;
% % dgpsPlot();
% % 
% % plot(x_v,y_v,'r');

    



