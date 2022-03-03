function [ e ] = NLAEC(x,y,P,L )
% x is the reference signal.
% y is the mic signal
% P is the max. order of the nonlinear preprocessor
% L is the length of the adaptive FIR filters
% e is the residual signal after applying the NLAEC


% initialize

Total_Number_Of_Samples = length(x);
h_hat = zeros(L,1);
a_hat = [1;zeros(P-1,1)];
Threshold = 0.002;%????
deltau = 0.2;
alphah = 0.2;
alphaa = 0.02;
frame = zeros(L,1);
...
    % the NLAEC loop
for k = 1:Total_Number_Of_Samples
    % prepare current frame
    if k<L
        frame(1:k) = x(k:-1:1);
    else
        frame = x(k:-1:k-L+1);
    end
    % estimate nonlinear signal
    xp = (x(k).^(1:P))';
    Xp =  frame.^(1:P);
    s_hat = Xp * a_hat;%s_hat vector     
    ...
        
% predict the mic signal using current estimates of the adaptive
% filters h_hat
    u = Xp' * h_hat;
    y_hat = a_hat' * u;
        ...
    
% calculate error signal (residual)
    if k<L
        e(k) = y(k) - y_hat;
        % adapt after examining current energy (of the far-end)
        if var(frame)>Threshold % i.e., if the far-end has a very low energy, do not perform adaptation.
            a_hat = a_hat + alphaa ./ (norm(u).^2 + deltau) * u * e(k);
            h_hat = h_hat + alphah ./ norm(s_hat).^2 * s_hat * e(k);
            ... %Adapt
        end
    else
        e(k) = y(k) - y_hat;
        % adapt after examining current energy (of the far-end)
        if var(frame)>Threshold % i.e., if the far-end has a very low energy, do not perform adaptation.
            a_hat = a_hat + alphaa ./ (norm(u).^2 + deltau) * u * e(k);
            h_hat = h_hat + alphah ./ norm(s_hat).^2 * s_hat * e(k);
            ... %Adapt
        end
    end

end

end

