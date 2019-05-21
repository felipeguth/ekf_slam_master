function  add_new_feature(z_iv)
%add a new feature on the state and update covariance

%z_iv = [rho;theta] ralating feature with vehicle;

global XX PX 

%compounding the line feature with the current vehicle position

angVehFeat = XX(4) + z_iv(2,1);

newFeature = [XX(1)*cos(angVehFeat)+XX(2)*sin(angVehFeat)+z_iv(1,1);
              angVehFeat];
          
          
          
J1 = [cos(angVehFeat), sin(angVehFeat), -XX(1)*sin(angVehFeat)+XX(2)*cos(angVehFeat);
        0,0,1];
    
J2 = [1,-XX(1)*sin(angVehFeat)+XX(2)*cos(angVehFeat);
      0,1];
          
          

XX = [XX;
      newFeature];
  
  
  
  


end

