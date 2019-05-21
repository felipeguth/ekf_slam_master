%function [Q,R, Rc]= auv_configfile()

%DT_CONTROLS= 0.025; % seconds, time interval between control signals

%observations parameters
%DT_OBSERVE_SONAR
%DT_OBSERVE_DVL
%DT_OBSERVE_IMU

%sonar
THRESHOLD = 90;
LINHAS_BUFFER = 100;
NUM_SEGMENTED_BINS = 100;
NUM_BINS_MAXIMA = 20;
SIZE_BUFFER = 1+3+NUM_SEGMENTED_BINS+NUM_BINS_MAXIMA; %bearing = 1, positionEKF =3
LIMIT_DISTANCE_BINS = 2;

sigma_nv = 0.2;
sigma_nu = 0.2;
sigma_nw = 0.2;
sigma_nr = 0.2;

%sensors
sigma_pres = 0.1;
sigma_compass = 0.1;

sigmaDvl_du = 0.2;
sigmaDvl_duv = 0.2;
sigmaDvl_duw = 0.2;
sigmaDvl_dvu = 0.2;
sigmaDvl_dv = 0.2;
sigmaDvl_dvw = 0.2;
sigmaDvl_dwu = 0.2;
sigmaDvl_dwv = 0.2;
sigmaDvl_dw = 0.2;

sigmaMTi_velYaw  = 0.2;

Q = [sigma_nv^2 0 0 0;
     0 sigma_nu^2 0 0;
     0 0 sigma_nw^2 0;
     0 0 0 sigma_nr^2];
 
%  Rd = [sigmaDvl_du^2 sigmaDvl_duv sigmaDvl_duw 0 0;com bussola
%        sigmaDvl_dvu sigmaDvl_dv^2 sigmaDvl_dvw 0 0;
%        sigmaDvl_dwu sigmaDvl_dwv sigmaDvl_dw^2 0 0];
%    
  
Rd = [sigmaDvl_du^2 sigmaDvl_duv sigmaDvl_duw   0;
       sigmaDvl_dvu sigmaDvl_dv^2 sigmaDvl_dvw  0;
       sigmaDvl_dwu sigmaDvl_dwv sigmaDvl_dw^2  0
       0            0            0              sigmaMTi_velYaw^2];
 
Rp = sigma_pres^2;
  
Rc = sigma_compass^2;
  
  
  %Rdvl = [Rd; 0 0 0 Rp 0; 0 0 0 0 Rc]; com bussola
%Rdvl = [Rd zeros(3,1); 0 0 0 Rp];

%R = Rd;


% observation noises sonar features - naive methdod
sigmaRs= 0.10; % metres
sigmaBs= deg2rad(0.25); % radians
Rs= [sigmaRs^2 0; 0 sigmaBs^2];


% associação de dados
GATE_REJECT= 4.0; % maximum distance for association
GATE_AUGMENT= 25.0; % minimum distance for creation of new feature
% For 2-D observation: COPIEIE BAYLEY
%   - common gates are: 1-sigma (1.0), 2-sigma (4.0), 3-sigma (9.0), 4-sigma (16.0)
%   - percent probability mass is: 1-sigma bounds 40%, 2-sigma 86%, 3-sigma 99%, 4-sigma 99.9%.
