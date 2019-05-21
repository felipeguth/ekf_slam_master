function KF_cholesky_update(v,R,H,S,Sinv)
global XX PX associado naoassociado
associado = associado + 1;
%bayley
% PHt= PX*H';
% S= H*PHt + R;
% 
% S= (S+S')*0.5; % make symmetric
% SChol= chol(S);
% 
% SCholInv= inv(SChol); % triangular matrix
% W1= PHt * SCholInv;
% W= W1 * SCholInv';
% 
% XX= XX + W*v; % update 
% PX= PX - W1*W1';


%  PHt= (H*PX)'; % Matlab is column-major, so (H*PX)' is more efficient than PX*H' [Tim 2004]
%  S= H*PHt + R;
%  
%  S= (S+S')*0.5; % ensure is symmetric
%  try
%  SChol= chol(S);
%  catch err
%  end
% 
% SCholInv= inv(SChol); % triangular matrix
% W1= PHt * SCholInv;
% W= W1 * SCholInv';
% 
% XX= XX + W*v; % update 
% PX= PX - W1*W1';
% 
% 
% %GUTH naive
K = PX * H' * Sinv;
Kgain = K*v;
if Kgain(1,1) < 2.5 && Kgain(1,1) > -2.5
    XX = XX + Kgain;

    A = K * H;
    I = eye(size(A));
    %PX = (I - K*H) * PX;
    PX = (I-A)*PX;
    associado = associado + 1;
else
    naoassociado = naoassociado + 1; 
end
