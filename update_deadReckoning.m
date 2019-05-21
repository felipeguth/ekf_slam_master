function update_deadReckoning(VelXDVL,VelYDVL,VelZDVL,Yaw,VelYaw,sizeN,Rd,Rc)

%build H matrix

Hd = [zeros(4,4) eye(4) zeros(4,2*sizeN)];

%Hp;%not implemented pressure sensor

Hc = [0 0 0 1 0 0 0 0 zeros(1,2*sizeN)];


H =[Hd;
    Hc];

a = size(Rd,2);

R = [Rd zeros(4,1)
    zeros(1,a) Rc];

zx = [VelXDVL;VelYDVL;VelZDVL;VelYaw;Yaw];

KFLinearUpdate(zx,H,R);


function KFLinearUpdate(z,H,R)

global XX PX

v = z - H*XX;
K = PX*H'/(H*PX*H'+R);

%S = H*PX*H'+R;
%Sinv= inv(S);
%K = PX*H'*Sinv;

XX = XX + K*v;

I = eye(length(PX));
PX = (I-K*H)*PX;


%testar inversa e outra solucao para K