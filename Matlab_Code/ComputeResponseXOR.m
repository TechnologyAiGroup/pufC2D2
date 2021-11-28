

function [BResponse] = ComputeResponseXOR(XORw,nXOR,APhi,nRows,Size)
% The function computes the array of responses for a given array of feature
% vectors APhi and weight vector w
% The response = 0 if  w*APhi >0, otherwise = 1;
%   Detailed explanation goes here
  
  BResponse = ones(nRows,nXOR);

  for i=1:nRows
      %Outputs of each APUF instances 
      Sum = zeros(1,nXOR);
      
      %Compute the outputs of nXOR APUFs
      for j=1:Size
          for k = 1:nXOR
            Sum(k) = Sum(k) + XORw(k,j)*APhi(i,j);  
            if(Sum(k)>0)
                BResponse(i,k) = 0;
            else
                BResponse(i,k) = 1;
            end               
          end
      end     

  end

end

