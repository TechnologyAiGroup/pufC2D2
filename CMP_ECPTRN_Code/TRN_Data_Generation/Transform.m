function [APhi] = Transform(AChallenge, nRows, ChalSize )
% The function transform the array of challenges of ChalSize-bit APUF to the
% corresponding array of feature vectors APhi of (ChalSize+1)-bit
%   Detailed explanation goes here
  
  APhi = ones(nRows,ChalSize+1);
  
  for i=1:nRows
      for j=1:ChalSize
          APhi(i,j) = 1; 
          for k=j:ChalSize
            APhi(i,j) = APhi(i,j)*(1-2*AChallenge(i,k));
          end
      end
  end



%   er  = 0 ; 
%   m = size(AChallenge,1);
%   for i=1:m
%       R = apuf.getResponse(AChallenge(i,:));
%       if(R ~= AResponse(i))
%          er = er+1;
%       end
%   end
% 
%    error = er/m; 
end

