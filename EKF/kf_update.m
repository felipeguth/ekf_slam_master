function kf_update(z,H,R)
global XX PX

v = z - H*XX;
S = H * PX * H' + R;
Si = pinv(S);
K = PX * H' * Si;

XX = XX + K * v;
A = K * H;
I = eye(size(A));
PX = (I - A ) * PX;
end


