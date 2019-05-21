function [contDVL,contMTi] = readInertial(timer, contDVL, contMTi)

global XX

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
    
    XX(4) = Yaw; %theta
    XX(5) = VelXDVL; %VelX
    XX(6) = VelYDVL; %VelY
    XX(7) = VelZDVL; %VelZ
    XX(8) = VelYaw; %VelYaw