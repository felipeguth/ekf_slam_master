function point = sonarReadTeste(timer)
global IS Sf Vf bufferIS linhaBuffer

% timer
% Vf

THRESHOLD = 135;
vetorPoints = [];
point = [];
lastValue = 0;
for i=1:size(IS,1)
    if IS(i,1) == timer                  
        while IS(i,1) == timer
            bearing = pi_to_pi(IS(i,2) + pi/2);   %pi_to_pi(IS(i,2)+pi);%%%%%%%%%%%%%%%%%%%%%%%%%     
            Sf = [0,0,bearing];            
            for j=1:500 %bins                
                if (IS(i,j+2) > THRESHOLD) 
                   
                   range = (j-2) * 0.1;
%                    [xs,ys] = pol2cart(bearing, range);                   
%                    
%                    xp = Vf(1,1) + xs*cos(Vf(1,3)) - ys*sin(Vf(1,3));
%                    yp = Vf(1,2) + xs*sin(Vf(1,3)) + ys*cos(Vf(1,3));
%                    
                  % xp = xp * cos(-pi/2) - yp * sin(-pi/2);
                  % yp = xp * sin(-pi/2) + yp * cos(-pi/2);
                   
                   if IS(i,j+2) > lastValue  
                        lastValue = IS(i,j+2);
                        point = [range;bearing];
                   end
                   %vetorPoints = [vetorPoints; point];                    
                end                
            end 
            i = i+1;      
        end
    else
        break;
    end
    break;
end

vetorPoints;

for k=1:i-1
   IS(1,:) = []; 
end





                                  
%          %  segmentedBeam = excludeNearBins(segmentedBeam);
%             
%            if size(segmentedBeam,2) > 0
%                 [binsMaxima, segmentedBeam] = extractMaxima(segmentedBeam(1,:),NUM_BINS_MAXIMA,NUM_SEGMENTED_BINS);
%                 bufferIS(linhaBuffer,:) = [bearing, positionEKF, segmentedBeam, binsMaxima];            
% 
%                 if linhaBuffer == LINHAS_BUFFER
%                    linhaBuffer = 1; %
%                 else
%                     linhaBuffer = linhaBuffer + 1;
%                 end                
%            %else
%             %    1
%             %    break;
%            end
%             
%             binsMaxima = [];
%             segmentedBeam = [];
%             i = i+1;         
%         end        
%     else        
%         break;
%     end
%     break;
% end






