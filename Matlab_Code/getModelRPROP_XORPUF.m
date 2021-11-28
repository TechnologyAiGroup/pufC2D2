
%--------------------------------------------------------------------------
% param.errorTol = ;  % Error tolerance
% param.optType = ;   % Optimization method
% param.mu_pos = ;    % Positive learning rate
% param.mu_neg = ;    % Negative learning rate
% param.delta_max = ; % Maximum update value
% param.delta_min = ; % Minimum update value
% param.method
%param.errorTol
%--------------------------------------------------------------------------
function [W grad] = getModelRPROP_XORPUF(X,Y,W0,delta,nXOR,param)
    
    W = W0;   % Weight vector to be discovered
    old_deltaW = zeros(1,length(W));
    
    for itr = 1:param.MaxIter
        
        grad = getGrad_XORPUF_model(W,X,Y,nXOR);
        if itr > 1
            gg = grad .* old_grad;
        else
            gg = grad;
        end
        deltaPos = min(delta*param.mu_pos,param.delta_max).*(gg > 0);
        deltaNeg = max(delta*param.mu_neg,param.delta_min).*(gg < 0);
        deltaEq = delta.*(gg == 0);
        delta = deltaPos + deltaNeg + deltaEq;

        switch param.method
            
            case 'Rprop-'
                    deltaW = -sign(grad).*delta;
                
            case 'Rprop+'
                    deltaW = -sign(grad).*delta.*(gg>=0) -...
                              old_deltaW.*(gg<0);
                    grad = grad.*(gg>=0);
                    old_deltaW = deltaW;
                
            case 'IRprop-'
                    grad = grad.*(gg>=0);
                    deltaW = -sign(grad).*delta;
                                 
            otherwise
                    error('Unknown method')
                
        end %End Switch

        W = W + deltaW;
        old_grad  = grad;
        
        if mod(itr,1000)==0
            fprintf('\nMax Grad = %g\n',max(abs(grad)));
        end
        
        if max(abs(grad)) < param.errorTol
            fprintf('\nRequire amount of Error is achieved\n');
            break;
        else
            
        end
        
    end 
end
