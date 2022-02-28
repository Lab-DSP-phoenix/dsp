function [ e ] = NLAEC(x,y,P,L )
% x is the reference signal.
% y is the mic signal
% P is the max. order of the nonlinear preprocessor
% L is the length of the adaptive FIR filters
% e is the residual signal after applying the NLAEC


% initialize

...
    % the NLAEC loop
for k=1:Total_Number_Of_Samples
    % prepare current frame
    frame = ...
        % estimate nonlinear signal
    ...
        
% predict the mic signal using current estimates of the adaptive
% filters h_hat
...
    
% calculate error signal (residual)
...
    
% adapt after examining current energy (of the far-end)
if var(frame)>Threshold % i.e., if the far-end has a very low energy, do not perform adaptation. 
    ... %Adapt
end

end



end

