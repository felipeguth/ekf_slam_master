function [ firstRead, matFeat ] = sonar360(timer, firstRead,pose)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%bufferISAux = 1 bearing 2 x 3 y 4 theta 5 - 504 bins 

global IS bufferISAux linhaBuffer
initIndex = 1;
endIndex = 1;

extractFeat = 0;
matFeat = [];

if firstRead == 1
    bufferISAux(1:91,1) = pi_to_pi(IS(1:91,2) + pi/2);   
    bufferISAux(1:91,2:3) = zeros(91,2);
    bufferISAux(1:91,4) = pose(3);
    bufferISAux(1:91,5:504) = IS(1:91,3:502);
    
    linhaBuffer = 92;
    IS(1:91,:) = [];
else
    
    for i=1:size(IS,1)
     while IS(i,1) == timer
        initIndex = i;
        i = i+1;
        break        
     end
     
     while IS(i,1) == timer
        endIndex = i;
        i = i+1;
     end
     
     if endIndex > 1
         break
     end       
    end
    
    numRead = linhaBuffer+endIndex-initIndex;
    
    %tratamento numRead max 200
    if numRead < 200
    
        bufferISAux(linhaBuffer:numRead,1) = pi_to_pi(IS(initIndex:endIndex,2) + pi/2);   %bearing
        bufferISAux(linhaBuffer:numRead,2) = pose(1);
        bufferISAux(linhaBuffer:numRead,3) = pose(2);
        bufferISAux(linhaBuffer:numRead,4) = pose(3); %x y theta robo    
        bufferISAux(linhaBuffer:numRead,5:504) = IS(initIndex:endIndex,3:502); %bins
        linhaBuffer = numRead+1;
    else
        
        b = initIndex;
        for a=linhaBuffer:200
            bufferISAux(a,1) = pi_to_pi(IS(b,2) + pi/2);
            bufferISAux(a,2) = pose(1);
            bufferISAux(a,3) = pose(2);
            bufferISAux(a,4) = pose(3); %x y theta robo
            bufferISAux(a,5:504) = IS(b,3:502);
            
            b = b+1;            
        end
        linhaBuffer = endIndex - initIndex - b +2;
        
        for a=1:linhaBuffer
            bufferISAux(a,1) = pi_to_pi(IS(b,2) + pi/2);
            bufferISAux(a,2) = pose(1);
            bufferISAux(a,3) = pose(2);
            bufferISAux(a,4) = pose(3); %x y theta robo
            bufferISAux(a,5:504) = IS(b,3:502);            
            b = b+1;            
        end
        
                
        %extract features when buffer is completed        
        filtering()
        matFeat= extractFeatures();                
        linhaBuffer = 1;
        bufferISAux = zeros(200,504);
    end
    
    IS(initIndex:endIndex,:) = [];    
    
        
%     for i=1:size(IS,1)
%         if IS(i,1) == timer                  
%             while IS(i,1) == timer            
%                 bearing = pi_to_pi(IS(i,2) + pi/2);
%                 for j=1:500 %bins
% 
%                     bufferISAux(linhaBuffer,
% 
%                 end
%             end
%         end
%     end
end

firstRead = 2; 

function matFeat = extractFeatures()
global bufferISAux linhaBuffer

maxValueReturn = max(bufferISAux(:));
%maxValueReturn = 133;
[thetaIndexFt, rhoIndexFt] = find(bufferISAux(:,5:504) >= maxValueReturn);

features = [];
features(:,1) = (bufferISAux(thetaIndexFt(:)));
features(:,2) = rhoIndexFt*0.1;
features(:,3) = bufferISAux(linhaBuffer,2) - bufferISAux(thetaIndexFt,2);% movimento x
features(:,4) = bufferISAux(linhaBuffer,3) - bufferISAux(thetaIndexFt,3);% movimento y
features(:,5) = bufferISAux(linhaBuffer,4) - bufferISAux(thetaIndexFt,4);% movimento theta

features(:,1) = pi_to_pi(features(:,1) + features(:,5)); %coorige o movimento angular do robô 


[xa,ya] = pol2cart(features(:,1),features(:,2));
xFt = [];
yFt = [];
xFt = xa + features(:,3); %corrige movimento em x
yFt = ya + features(:,4); %corrige movimento em y

thetaFt = features(:,1) + features(:,5);

[thetM, rhoM] = cart2pol(xFt,yFt);
matFeat = [rhoM,pi_to_pi(thetM+ pi/2)];

matFeat = matFeat';

% 

function filtering()
%average filtering
global bufferISAux


for i=1:200    
    for k=5:504
        if bufferISAux(i,k) < 100 %passa alta
           bufferISAux(i,k) = 0; 
        end        
    end
end

%% 
 imOrig = bufferISAux(:,5:504);
 h = fspecial('average', [5 5]);
% %h = fspecial('gaussian', [4 4]);
% 
 bufferISAux(:,5:504) = filter2(h,imOrig);
% K = rangefilt(bufferISAux(:,5:504));
% I2 = bufferISAux(:,5:504);  



% 
% % 
% % 
% % %%print images
% x=[];
% y=[];
% z=[];
% z2 = [];
% z3 = [];
% for i=1:200
%     theta = bufferISAux(i,1);
%     for k=5:504
%         rho = ((k-4)*0.1);
%         [xa,ya] = pol2cart(theta,rho);
%         x = [x,xa];
%         y = [y,ya];
%         %z = [z,0]; %intensidade
%         z = [z,bufferISAux(i,k)]; %intensidade 
%         z2 = [z2, I2(i,k-4)]; 
%        % z3 = [z3, K(i,k-4)]; 
%     end
% end
% 
% 
% figure2 = figure
% scatter(x,y,20,z);
% 
% figure3 = figure
% scatter(x,y,20,z2);
% % % 
%  figure4 = figure
%  scatter(x,y,20,z);

% figure5 = figure
% scatter(x,y,20,z2);

