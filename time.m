initTimer = 1093455407.042;
endTimer =  1093458752.987;

for timer = initTimer:2:endTimer
    timer
    %[VelXDVL, VelYDVL, VelZDVL, VelYaw] = auv_getObservationsDVL(timer);
    
    % [yaw] = auv_getObservationsMRU(timer);
    %UPDATE KALMAN
end



initTimer = round(1093455407.042 - 1093400000.000);
endTimer =  round(1093458752.987 - 1093400000.000);

for timer = initTimer:2:endTimer
    for i=1:szD
        if ((round(DVL(i,1)- 1093400000.000) == timer))
            i 
        end
    end
end

ATTRIBUIÇÂO ERRONEA DUMBASS