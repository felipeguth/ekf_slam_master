function dataAssociation(z,R,gate1,gate2,timer)

global XX PX Vf

zf= []; zn= [];
idf= []; 
addFeat = 0;
assFeat = 0;
% p = 10; %teste
% theta =  deg2rad(45); %teste
for iln=1:size(z,2) % para o numero de landmarks observadas por medição
    rho = z(1,iln);
    theta = z(2,iln);
    
    %transform to the vehicle's coordinate frame
    [xs,ys] = pol2cart(theta,rho);
    xp = Vf(1,1) + xs*cos(Vf(1,3)) - ys*sin(Vf(1,3));
    yp = Vf(1,2) + xs*sin(Vf(1,3)) + ys*cos(Vf(1,3));
    
    [theta_iv,p_iv] = cart2pol(xp,yp);
    
    theta_iv =  pi_to_pi(theta_iv);
    
    ziv =[p_iv;theta_iv]; %actual line measurement in the vehicle's frame
    
    ziv = add_observation_noise(ziv,R); %add noise           
    %j = line feature of map
    %nF = number of features    
    %encontrar a hipótese correta é um processo envolvendo a análise da
    %discrepância entre a linha aferida atual e sua predição
    %essa predição é obtida pela função hj que relata a linha medida com o vetor
    %de estados x(k) contendo as localizações do robô e a feature j    
    jbest= 0;
    nbest= inf;
    outer= inf; 
    
    nf = (size(XX,1) - 8)/2; %nf = o número de features. Estado = 8. Cada feature tem 2 parametros
   % nf = 0; %TESTEEEEE Descomentar essa linha
    if nf > 0 %caso tenha feature
        i = 9;
        for j=1:nf   %para as landmarks do estado
            nd = 0;
            nis = 0;
            
            pj = XX(i);
            thetaj =XX(i+1);
            hj = h_j(XX(1), XX(2), XX(4),pj,thetaj);  %x,y,yaw,featureInState_p, featureInState_theta
            vij = ziv - hj;
            
            vij(2,1) = pi_to_pi(vij(2,1));
            
            %Hj representa a jacobiana que lineariza a função não linear hj sobre a melhor estimativa disponível do estado
            nFeaturesAfter = nf -j;
            nFeaturesBefore = nf - nFeaturesAfter - 1;
            
            Hj=[-cos(thetaj),-sin(thetaj),0,0,0,0,0,0,zeros(1,nFeaturesBefore*2),1,XX(1)*sin(thetaj)-XX(2)*cos(thetaj),zeros(1,nFeaturesAfter*2);
                0, 0, 0, -1, 0, 0, 0, 0, zeros(1,nFeaturesBefore*2),0, 1, zeros(1,nFeaturesAfter*2)];
            
            % e sua matrix de covariância Sij são obtidos como
            Sij = Hj * PX * Hj'+ R;%
            Si = pinv(Sij);
            %size(Si)
            nis = vij' * Si * vij;
            
            nis_aux = nis * nis; 
            nis = sqrt((nis_aux));
            nd = nis + log(det(Sij));
            
            if nis < gate1 & nd < nbest % if within gate, store nearest-neighbour
                nbest = nd;
                jbest = j;
                v = vij;
                H = Hj;  
                Sinv = Si;
                S = Sij;
            elseif nis < outer % else store best nis value
                outer= nis;
            end            
            i = i + 2;
        end
        
        % add nearest-neighbour to association list
        if jbest ~= 0
            assFeat = 1;
            zf= z(:,iln);
            idf= jbest;
        elseif outer > gate2 % z too far to associate, but far enough to be a new feature
            addFeat = 1;
            zn= z(:,iln);
        end
    else
        addNewFeature(XX(1),XX(2),XX(4),rho,theta,R,timer,0);
    end
    
    
    %Check for data association update or feature creation     
    if assFeat == 1 %data Association
        KF_cholesky_update(v,R,H,S,Sinv);
        addNewFeature(XX(1),XX(2),XX(4),rho,theta,R,timer,1);% gambiarra para imprimir - nao associa
    end    
    
    if addFeat == 1 %if there is new features
       % for af=1:size(zn,2)
            rho = zn(1,1);
            theta = pi_to_pi(zn(2,1));
            addNewFeature(XX(1),XX(2),XX(4),rho,theta,R,timer,0);
        %end
    end
    
    addFeat = 0;
    assFeat = 0;    
end

function zivk = h_j(x,y, yaw, pj, thetaj)
zivk = [pj - x * cos(thetaj) - y * sin(thetaj); pi_to_pi(thetaj - yaw)];
% function si = add_noise_ziv(R) noise observed before
% si = [randn(1)*sqrt(R(1,1));
%   %randn(1)*sqrt(R(1,2));
%   %randn(1)*sqrt(R(2,1));
%   randn(1)*sqrt(R(2,2))];


function addNewFeature(xv,yv,yawv,pln, thetaln,R,timer,flag)
global XX PX ft vetFeature
newfeature = [];
%state
angle = pi_to_pi(yawv+thetaln);
newfeature = [xv*cos(angle)+yv*sin(angle)+pln;angle];


%plot new feature
%figure(1);
[xs,ys] = pol2cart(thetaln,pln);
xp = xv + xs*cos(yawv) - ys*sin(yawv);
yp = yv + xs*sin(yawv) + ys*cos(yawv);


aft = [xp;yp;timer];

vetFeature = [vetFeature, aft];

if flag ==1
    hold on;
    plot(xp,yp,'r+');
end

d1 = [];
for ift=1:size(ft,1)
    xft = ft(ift,1);
    yft = ft(ift,2);
        
    d1 =[d1; sqrt((xp -xft)^2 + (yp - yft)^2)];
end

minDist = min(d1);

if minDist > 4 && flag ~= 1
    ft = [ft;xp,yp,timer];
    hold on;
    plot(xp,yp,'m+');
    
    len= length(XX);
    
    %augment XX
    XX = [XX;newfeature];
    
    %jacobians
    J1 = [cos(angle),sin(angle),yv*cos(angle)-xv*sin(angle); 0,0,1]; %(2x3)
    J2 = [1 -xv*sin(angle)+yv*cos(angle);
        0 1];
    
    %auxiliar matrix for multiplication
    PXaux(1:2,1:2) = PX(1:2,1:2);
    PXaux(3,1:2)   = PX(4,1:2);
    PXaux(1:2,3)   = PX(1:2,4);
    PXaux(3,3)     = PX(4,4);
    
    % augment PX
    rng= len+1:len+2;
    PX(rng,rng)= J1*PXaux*J1' + J2*R*J2'; % feature cov
    PX(rng,1:3)= J1*PXaux; % vehicle to feature xcorr
    PX(1:3,rng)= PX(rng,1:3)';
    
    %work around to adjust values
    PX(rng,4) = PX(rng,3);
    PX(rng,3) = 0;
    PX(4,rng) = PX(3,rng);
    PX(3,rng) = 0;
    
    if len>8
        rnm= 9:len;
        Pxaux(1:2,1:len-8) = PX(1:2,rnm);
        Pxaux(3,1:len-8) = PX(4,rnm);
        
        PX(rng,rnm)= J1*Pxaux; % map to feature xcorr
        PX(rnm,rng)= PX(rng,rnm)';
    end
    
    
end





% 
% 
% function [x,P]= add_one_z(x,P,z,R)
% 
% len= length(x);
% r= z(1); b= z(2);
% s= sin(x(3)+b); 
% c= cos(x(3)+b);
% 
% % augment x
% x= [x;
%     x(1) + r*c;
%     x(2) + r*s];
% 
% % jacobians
% Gv= [1 0 -r*s;
%      0 1  r*c];
% Gz= [c -r*s;
%      s  r*c];
%      
% % augment P
% rng= len+1:len+2;
% P(rng,rng)= Gv*P(1:3,1:3)*Gv' + Gz*R*Gz'; % feature cov
% P(rng,1:3)= Gv*P(1:3,1:3); % vehicle to feature xcorr
% P(1:3,rng)= P(rng,1:3)';
% if len>3
%     rnm= 4:len;
%     P(rng,rnm)= Gv*P(1:3,rnm); % map to feature xcorr
%     P(rnm,rng)= P(rng,rnm)';
% end
% 
% 
% 
% function aiu = update_ekf(H, Sij, vij)
% global XX PX
% K = PX * H' * pinv(Sij);
% XX = XX + K*vij;
% PX = (I - K*H) * PX;


%debug teste de inclusão de nova feature
% xv = XX(1);
% yv = XX(2);
% yawv = XX(4);
% pln = 15;
% thetaln = deg2rad(115);




