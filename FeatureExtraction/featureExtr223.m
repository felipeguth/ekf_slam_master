function ln = featureExtr223(LINHAS_BUFFER, SIZE_BUFFER) %retorna landmarks: linhas
global bufferIS linhaBuffer maximum


if bufferIS(LINHAS_BUFFER,1) == 999 %if buffer is not full, return 
    ln = [];
    return
else
    start_local_maxima = 105; %position where start the local maximas bins in buffer
    HS = zeros(200,500);       

    alpha = deg2rad(3); %Beamwidth angle 3�
    bheta = deg2rad(65); %incidence angle 65�

    var_angle_beam = 0.0314;
    resolution_alpha = alpha/2; %- Faz 3 angulos de largura na horizontal. Um ponto 1,5� abaixo da origem, outro na origem, outro 1,5� acima da origem 
    resolution_bheta = var_angle_beam; 

    %atual position of base reference B. Sonar Head - Last Beam
    if linhaBuffer == 1 
        lastBeam = 1;
    else
        lastBeam = linhaBuffer - 1;
    end
    x_B = bufferIS(lastBeam,2);
    y_B = bufferIS(lastBeam,3);
    theta_B = pi_to_pi(bufferIS(lastBeam,4) + (bufferIS(lastBeam,1)));% + pi)); %Look at that motherfucker

    %undistorceOldBins();
    for l=1:LINHAS_BUFFER        
        if l ~= lastBeam %undistorce all bins except the last acquired        
            ang = pi_to_pi(bufferIS(l,4) + (bufferIS(l,1))); % + pi));
            theta_s_B = pi_to_pi(theta_B - ang); %undistorce theta
            x_s_B = (x_B - bufferIS(l,2)); %(x_B - bufferIS(l,2))*cos(theta_s_B); %undistorce x
            y_s_B = (y_B - bufferIS(l,3)); %(y_B - bufferIS(l,3))*sin(theta_s_B); %undistorce y            
        else
           theta_s_B = theta_B;
           x_s_B = x_B;
           y_s_B = y_B;
        end

        %log = [];

       for lm=start_local_maxima:SIZE_BUFFER %localMaximaBinsInBuffer    
           if bufferIS(l,lm) > 0
             p_s = bufferIS(l,lm);%DIVIDIR POR 10 LOOOK AT THISSSS
                for i=(theta_s_B - alpha/2):resolution_alpha:(theta_s_B + alpha/2)
                     theta_i_B = pi_to_pi(i);
                     for k=(theta_i_B - bheta): resolution_bheta: (theta_i_B + bheta)        
                         theta_ik_B = pi_to_pi(k);
                         theta_ik = pi_to_pi(theta_i_B - theta_ik_B);
                         p_ik_B = x_s_B * cos(theta_ik_B) + y_s_B * sin(theta_ik_B) + p_s * cos(theta_ik); 
                         HS = voting(theta_ik_B,p_ik_B,HS);
                         %log = [log;theta_B,theta_s_B,theta_i_B, theta_ik_B ];

                     end 
                end
           else
               break
           end
       end        
    end

           [thetaMaxVotes,rhoMaxVotes] = find(HS>=20); %find(HS>=max(HS(:))); %busca por mais votados %autor considera que 18 votos seja o parametro ideal para encontrar landmarks
           maximum = [maximum;max(HS(:))];
           if size(thetaMaxVotes,1) > 0
               ln = [];
               for ldmk=1:size(thetaMaxVotes,1)
                   theta_line = 0.0314 * (thetaMaxVotes(ldmk) - 100);
                   rho_line = rhoMaxVotes(ldmk)*0.1;
                   ln = [ln;rho_line,theta_line]; 
               end
           else
               ln = 0; %numero de votos insuficientes para caracterizar uma linha
           end
end

% %
% x_s_B = 2.450; %sensor x position with respect to B
% y_s_B = 1.84;%sensor y position with respect to B
% theta_s_B = beam(1,1);  %Beam direction =  angle of measured beam
% 
% p_s = 0; %range of the bin
% theta_i_B = 0; %angle taken within the assumed beam width 
% 
% p_ik_B = 0; %perpendicular distance of the candidate line feature placed within the limits set by the incidence angle
% theta_ik_B = 0; %angle of candidate line feature placed within the limits set by the incidence angle
% 
% theta_ik = 0; %angle between the candidate line and the angle taken within the beamwidht
% 
% %candidate line = p_ik_B, theta_ik_B
% 
% 
% %quantization of Hough Space - equal to the angular and linear resolutions
% %of sensor - sonar girona theta 1.8� rho 0.1m
%     for h=1:100 %100 leituras = 180�
%     %0.0314 %varia��o de �ngulo para cada leitura - beam - em rad
%         for s=1:500
%        %0.1m - variacao distancia       
%         end       
%     end    
    
% end
% 
% 

%GOD RIBAS  Recomenda 18 votos para detecção de linha
 function HS = voting(theta_cl,p_cl,HS) %recebe angulo e distancia linha candidata e vota no HS
     
     indiceTheta = 100 + theta_cl/0.0314;    
              
     indexTheta = round(indiceTheta); 
     indexRho = round(p_cl); %round(p_cl * 0.1);
     
     if (indexTheta >= 0 && indexTheta <= 100) && (indexRho >= 0 && indexRho <=500)
         if indexTheta == 0
             indexTheta = 1;
         end
         if indexRho == 0
            indexRho = 1;
         end         
         HS(indexTheta,indexRho) = HS(indexTheta,indexRho) + 1; %assign 1 vote to the candidate line
     end
 

     
%undistorce Bins
function undistorceOldBins(x_B, y_B, theta_B, bufferIS)

for i=1:LINHAS_BUFFER
     ang = pi_to_pi(bufferIS(i,4) + (bufferIS(i,1))); % + pi));
     bufferUndistorced(i,1) = pi_to_pi(theta_B - ang); %undistorce theta
    for j=5:104   
        bufferUndistorced(i,j-4) = (x_B - bufferIS(l,2)); %(x_B - bufferIS(l,2))*cos(theta_s_B); %undistorce x
    y_s_B = (y_B - bufferIS(l,3));
    end
    
    
end


