function [XORw] = XORPUFgeneration(nXOR,chalSize,mu,sigma)
% The function transform the array of challenges of ChalSize-bit APUF to the
% corresponding array of feature vectors APhi of (ChalSize+1)-bit
%   Detailed explanation goes here
  
  XORw = normrnd(mu,sigma,nXOR,chalSize+1);

end

