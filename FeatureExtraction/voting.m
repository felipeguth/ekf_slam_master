function ln = voting(LINHAS_BUFFER,SIZE_BUFFER)

global bufferIS linhaBuffer


xV = bufferIS(linhaBuffer,2);
yV = bufferIS(linhaBuffer,3);
thetaV = bufferIS(linhaBuffer,4);


if bufferIS(LINHAS_BUFFER,1) == 999 
    ln = [];
    return;
else
    
    start_local_maxima = 105; %position where start the local maximas bins in buffer
    HS = zeros(210,510);
    
    %local maximas execute votes %two times the number of votes than normal bins
    for l=1:LINHAS_BUFFER
        for lm=start_local_maxima:SIZE_BUFFER
            if bufferIS(l,lm) > 0
                
                %undistorce
                deltaTheta = thetaV - bufferIS(l,4);
                deltaX = xV - bufferIS(l,2);
                deltaY = yV - bufferIS(l,3);
                
                angle = bufferIS(l,1);
                range = bufferIS(l,lm);
                bin = [];
                bin = [angle,range];
                HS = vote(bin,HS);
            else
                break;
            end            
        end
    end
    
    
    %bins over threshold execute votes    
    for l=1:LINHAS_BUFFER
        for lm=5:start_local_maxima
            if bufferIS(l,lm) > 0
                angle = bufferIS(l,1);
                range = bufferIS(l,lm);
                bin = [];
                bin = [angle,range];
                HS = vote(bin,HS);
            else
                break;
            end
        end
    end
    
    %find votes
    maxVot = max(HS(:));
    if maxVot > 18
        %[thetaMaxVotes,rhoMaxVotes] = find(HS>maxVot-1);
        [thetaMaxVotes,rhoMaxVotes] = find(HS>18);
        ln = [rhoMaxVotes*0.1,(thetaMaxVotes-101)*0.0314];
        ln = ln';
        %quando detecta uma feature limpa buffer
        bufferIS = zeros(LINHAS_BUFFER,SIZE_BUFFER); %testing
        bufferIS(:,1) = 999*ones(LINHAS_BUFFER,1);
        
    else
        ln = [];
    end
    
    % max(HS(:))
    %HS
    %ln = ln'; %adjust for data association
    
   % extractLine(ln);
end


function HS = vote(bin,HS) %otimizar
valBin = 4;
ValViz = 3;

limCol = 510;
limLin = 205;

var_angle_beam = 0.0314;
var_range = 0.1;

voteAngle = round(bin(1,1)/var_angle_beam) + 101;
voteRange = bin(1,2);%round(bin(1,2)/var_range);

HS(voteAngle,voteRange) = HS(voteAngle,voteRange) + valBin;

%8 neighbourhod
x = voteRange;
y = voteAngle;

%try tratar %limites vizi 8
if x+1 < limCol
    HS(y,x+1) = HS(y,x+1) + ValViz;
end
if x-1 > 0
    HS(y,x-1) = HS(y,x-1) + ValViz;
end

if y+1 < limLin
    HS(y+1,x) = HS(y+1,x) + ValViz;
end
if y-1 > 0
    HS(y-1,x) = HS(y-1,x) + ValViz;
end

if x+1 < limCol && y+1 < limLin
    HS(y+1,x+1) = HS(y+1,x+1) + ValViz;
end
if y-1 > 0 && x-1 > 0
    HS(y-1,x-1) = HS(y-1,x-1) + ValViz;
end

if x+1 < limCol && y-1 > 0
    HS(y-1,x+1) = HS(y-1,x+1) + ValViz;
end
if x-1 > 0 && y+1 < limLin
    HS(y+1,x-1) = HS(y+1,x-1) + ValViz;
end

%vizi4
    
% if x+1 < limCol
%     HS(y,x+1) = HS(y,x+1) + ValViz;
% end
% if x-1 > 0
%     HS(y,x-1) = HS(y,x-1) + ValViz;
% end
% 
% if y+1 < limLin
%     HS(y+1,x) = HS(y+1,x) + ValViz;
% end
% if y-1 > 0
%     HS(y-1,x) = HS(y-1,x) + ValViz;
% end




%catch err
    
%end

% % 
% function extractLine(ln,HS)
% 
% global Vf Sf bufferIS
% 
% 
% %if nao distorcido
% 
% for i=1:size(ln,1)
%     %angV = find(bufferIS,ln(i,1));
%     bheta = ln(i,2) + Vf(3); %angulo veiculo + sonar
%     thetaLn = pi/2 + bheta; %angulo linha paralela a bheta
% 
%     [xs,ys] = pol2cart(ln(i,2),ln(i,1));                   
%     xp = Vf(1,1) + xs*cos(Vf(1,3)) - ys*sin(Vf(1,3));
%     yp = Vf(1,2) + xs*sin(Vf(1,3)) + ys*cos(Vf(1,3));
%     
%     plot(xp,yp,'r+');
%     
%    %[x2,y2,m] = reta2(xp,yp,thetaLn);
%     
% %    [xs,ys] = pol2cart(thetaLn,ln(i,2));                   
% %     x2 = Vf(1,1) + xs*cos(Vf(1,3)) - ys*sin(Vf(1,3));
% %     y2 = Vf(1,2) + xs*sin(Vf(1,3)) + ys*cos(Vf(1,3));
% %     
% %     xl = [xp x2];
% %     yl = [yp y2];
% %     plot(xl,yl,'g')
%     hold on;
%     
% end














%function uncertaintyLine


%find first and last significant bins



