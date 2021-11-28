

%sigmoid function
function [g] = sigmiod_fn(z)
    
     g = 1 ./ (1 + exp(-z));
end