function ekfpredict(nX,Q,dt)

global XX PX

%jacobiana movimento
F = [ 1, 0, 0, - dt*XX(5)*sin(XX(4)) - dt*XX(6)*cos(XX(4)), dt*cos(XX(4)), -dt*sin(XX(4)), 0, 0;
      0, 1, 0,   dt*XX(5)*cos(XX(4)) - dt*XX(6)*sin(XX(4)), dt*sin(XX(4)),  dt*cos(XX(4)), 0, 0;
      0, 0, 1,                                           0,          0,           0, dt, 0;
      0, 0, 0,                                           1,          0,           0, 0, dt;
      0, 0, 0,                                           0,          1,           0, 0, 0;
      0, 0, 0,                                           0,          0,           1, 0, 0;
      0, 0, 0,                                           0,          0,           0, 1, 0;
      0, 0, 0,                                           0,          0,           0, 0, 1];


%jacobiana ruído
W =[dt^2*cos(XX(4))/2, -dt^2*sin(XX(4))/2,      0,      0;
    dt^2*sin(XX(4))/2,  dt^2*cos(XX(4))/2,      0,      0;
                    0,                  0, dt^2/2,      0;
                    0,                  0,      0, dt^2/2;
                   dt,                  0,      0,      0;
                    0,                 dt,      0,      0;
                    0,                  0,     dt,      0;
                    0,                  0,      0,      dt];
        
% predict covariance

sizeN = (size(XX,1) - 8)/2;%number of features - each feature is a theta rho pair

Faux = [F zeros(8,sizeN*2); 
        zeros(sizeN*2,8),eye(sizeN*2,sizeN*2)];
    
Waux = [W;
        zeros(sizeN*2,4)];    
    
PX = Faux*PX*Faux'+ Waux*Q*Waux';

%PX(1:8,1:8)= F*PX(1:8,1:8)*F'+W*Q*W';


%predict state
deltaX = ( (XX(5)* dt + nX(1)*dt^2/2)* cos(XX(4))) - ((XX(6) * dt + nX(2) *dt^2/2)* sin(XX(4)));   % (u.T + nu.T^2/2).cos(yaw) - (vT + nv.T^2/2)sin.(yaw)
deltaY = ( (XX(5)* dt + nX(1)*dt^2/2)* sin(XX(4))) + ((XX(6) * dt + nX(2) *dt^2/2)* cos(XX(4)));    %y + (u.T + nu.T^2/2).sin(yaw) + (vT + nv.T^2/2)cos.(yaw) 
deltaZ = 0;% XX(7) * dt + nX(3) * dt^2/2 ; %z + wT + nw.T^2/2
deltaYaw = XX(8) * dt + nX(4) * dt^2/2;    %yaw + rT + nr.T^2/2

XX(1:8)= [XX(1) + deltaX;  
          XX(2) + deltaY;
          XX(3) + deltaZ;
          pi_to_pi(XX(4) + deltaYaw);
          XX(5) + nX(1) * dt;   % u + nu.T
          XX(6) + nX(2) * dt;    % v + nv.T
          XX(7) + nX(3) * dt;   % w + nw.T
          XX(8) + nX(4) * dt];    % r + nr.T
      
      XX(3) = 0;