function z= add_observation_noise(z,R)
%function z= add_observation_noise(z,R, 

% Add random measurement noise. Assume R is diagonal.
len= size(z,2);
if len > 0
    z(1,:)= z(1,:) + randn(1,len)*sqrt(R(1,1));
    z(2,:)= z(2,:) + randn(1,len)*sqrt(R(2,2));
end