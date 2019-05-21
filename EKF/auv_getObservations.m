function [VelXDVL, VelYDVL, VelZDVL, VelYaw] = auv_getObservations(timer,contDVL,contMTi)

%busca indices para leitura de acordo com tempo
while(round(DVLlogTime(contDVL)- 1093400000.000) ~= timer)            
    contDVL = contDVL + 1;
end

while(round(MTiLogTime(contMTi)- 1093400000.000) ~= timer)            
    contMTi = contMTi + 1;
end

%lê dados DVL
if DVLbottomStatus(contDVL) == 1    
        VelXDVL = DVLbottomVelX(contDVL)/100; %m/s
        VelYDVL = DVLbottomVelY(contDVL)/100;
        VelZDVL = DVLbottomVelZ(contDVL)/100;
else if DVLwaterStatus(contDVL) == 1
        VelXDVL = DVLwaterVelX(contDVL)/100; 
        VelYDVL = DVLwaterVelY(contDVL)/100;
        VelZDVL = DVLwaterVelZ(contDVL)/100;       
    else
        VelXDVL = 0; 
        VelYDVL = 0;
        VelZDVL = 0;
    end
end

%lê dados MTi
Yaw     = MTiYaw(contMTi); %degrees
VelYaw  = MTiVelYaw(contMTi);  %radsec

%deleta registros não usados
for j=contDVL:-1:1
    DVLlogTime(j)       = [];
    DVLbottomStatus(j)  = [];
    DVLwaterStatus(j)   = [];
    DVLbottomVelX(j)    = []; 
    DVLbottomVelY(j)    = [];
    DVLbottomVelZ(j)    = [];    
    DVLwaterVelX(j)     = [];
    DVLwaterVelY(j)     = [];
    DVLwaterVelZ(j)     = [];
end

for k=contMTi:-1:1
    MTiLogTime(k) = []; 
    MTiVelYaw(k)  = [];
    MTiYaw(k)     = [];    
end


% 
% 
% 
% 
% 
% while(round(DVLlogTime(contDVL)- 1093400000.000) ~= timer)
%     
%     contDVL = contDVL+1;
% end
% 
% 
% 
% j = 1
% 
% 
% 
% 
%     dvl_current_time = dvl_data(k,1);
%     dvl_velxw = dvl_data(k,2)/100; %cm/s x faz divis�o para converter em metros
%     dvl_velyw = dvl_data(k,3)/100; %cm/s y
%     dvl_velzw = dvl_data(k,4)/100; %cm/s z
%     
%     dvl_velxb = dvl_data(k,6)/100; %cm/s x faz divis�o para converter em metros
%     dvl_velyb = dvl_data(k,7)/100; %cm/s y
%     dvl_velzb = dvl_data(k,8)/100; %cm/s z
%     
%     dvl_heading = pi_to_pi(auv_convertToRadians(dvl_data(k,10))); %degrees
%     dvl_pressure = ((0.00377225 *(dvl_data(k,11)) - 4.43146) * 0.1 / 1.11377); %convert data to decibar * 0.1 to bar divided by pressure (bar) of 1m = deep
%     
%     dt_dvl = dvl_current_time - lastTime_dvl;  
%     lastTime_dvl = dvl_current_time;    
%         
% %     Xdvl(1:7)=[dvl_velxb;
% %           dvl_velyb;
% %           dvl_velzb; 
% %           dvl_velxw;
% %           dvl_velyw;
% %           dvl_velzw;
% %           dvl_pressure];
% 
% %dt_dvl = lastTime_dvl -
% %lastime = dvl_data(i,1)
% 
% 
% 
% Xdvl(1:9,:)=[0;0;dvl_pressure;0; dvl_velxb; dvl_velyb; dvl_velzb;0;0];
%   
% % Hd = [ zeros(2,9);     %x,y
% %     0 0 1 0 zeros(1,3) zeros(1,2);
% %     zeros(1,9);%heading    
% %     zeros(3,3) zeros(3,1) eye(3,3) zeros(3,2);
% %     zeros(2,9)];
% 
% Hd = [ zeros(3,4) eye(3) zeros(3,2);
%           0 0 1 zeros(1,6)];
% 
% m = auv_add_noise_DVL(R);
% 
% Zd = Hd * Xdvl + m; 
% 
% y = Zd - Hd * Xv;
% 
% warning('Vai chamar update KF DVL');
% auv_KF_update(y,R,Hd);


  