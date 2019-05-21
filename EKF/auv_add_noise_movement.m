function [nX] = auv_add_noise_movement(Q)
  nX(1:4) = [randn(1)*sqrt(Q(1,1));
  randn(1)*sqrt(Q(2,2));   
  randn(1)*sqrt(Q(3,3));
  randn(1)*sqrt(Q(4,4))];