%[bufferIS] = sonarRead(bufferIS, timer, contBeams,positionEKF)  
function sonarRead(timer,THRESHOLD,LINHAS_BUFFER,NUM_SEGMENTED_BINS,NUM_BINS_MAXIMA,LIMIT_DISTANCE_BINS)

global IS bufferIS linhaBuffer Vf

t = 1;
segmentedBeam = [];
for i=1:size(IS,1)
    if IS(i,1) == timer                  
        while IS(i,1) == timer            
            bearing = pi_to_pi(IS(i,2) + pi/2);
            for j=1:500 %bins
                sizeSB = size(segmentedBeam,2);
                if (IS(i,j+2) > THRESHOLD) && sizeSB < NUM_SEGMENTED_BINS
                    auxBin = [j; IS(i,j+2)];                                        
                                        
                    if sizeSB == 0
                        segmentedBeam = [segmentedBeam, auxBin];                        
                    else
                            %exclude bins that do not satisfy a minimum distace
                            indexLast = sizeSB;
                            pos_bin_last = segmentedBeam(1,sizeSB);
                            val_bin_last = segmentedBeam(2,sizeSB);
                            pos_bin_now = auxBin(1,1);
                            val_bin_now = auxBin(2,1);
                        
                        if (pos_bin_now  - pos_bin_last) > LIMIT_DISTANCE_BINS                                  
                            segmentedBeam = [segmentedBeam, auxBin];
                        else                        
                            if val_bin_now > val_bin_last
                                segmentedBeam(1,indexLast) = pos_bin_now;
                                segmentedBeam(2,indexLast) = val_bin_now;
                            %else
                                %keep old value - do nothing
                            end
                        end
                    end
                end                
            end
                                  
         %  segmentedBeam = excludeNearBins(segmentedBeam);
            
           if size(segmentedBeam,2) > 0
                [binsMaxima, segmentedBeam] = extractMaxima(segmentedBeam(1,:),NUM_BINS_MAXIMA,NUM_SEGMENTED_BINS);
                bufferIS(linhaBuffer,:) = [bearing, Vf, segmentedBeam, binsMaxima];            

                if linhaBuffer == LINHAS_BUFFER
                   linhaBuffer = 1; %
                else
                    linhaBuffer = linhaBuffer + 1;
                end                
           %else
            %    1
            %    break;
           end
            
            binsMaxima = [];
            segmentedBeam = [];
            i = i+1;         
        end        
    else        
        break;
    end
    break;
end

for k=1:i-1
   IS(1,:) = []; 
end


function [binsMaxima, segmentedBeam] = extractMaxima(segmentedBeam,NUM_BINS_MAXIMA,NUM_SEGMENTED_BINS)
localMaxima = max(segmentedBeam);
binsMaxima = [];
sb = size(segmentedBeam,2);
for i=1:sb
    if segmentedBeam(i) >= localMaxima && size(binsMaxima,2) < NUM_BINS_MAXIMA
        binsMaxima = [binsMaxima, segmentedBeam(i)];
    end
end

sm = size(binsMaxima,2);

binsMaxima = [binsMaxima, zeros(1,NUM_BINS_MAXIMA-sm)];
segmentedBeam = [segmentedBeam, zeros(1,NUM_SEGMENTED_BINS-sb)];

 



    



