function [output] = buildparams(input)

    %% Retrieve essential variables
    x = input.x;
    t = input.t;
    freq0 = input.freq0;
    lambda0 = input.lambda0;
    Ar = input.Ar;
    Al = input.Al;
    Hr = input.Hr;
    Hl = input.Hl;
    Xp1 = input.Xp1;
    Xp2 = input.Xp2;
    noise = input.noise;

    %%
    % Builds signal matrix
    [WM] = test.buildwave(t,x,freq0,lambda0,Ar,Al,Hr,Hl);
          
    
    % Index of fictional probe position 1
    xs1 = abs(Xp1 - x) < (x(2)-x(1))/2;
    % Signal 1
    s1 = WM(xs1,:)';
    % Index of fictional probe position 2
    xs2 = abs(Xp2 - x) < (x(2)-x(1))/2;
    % Signal 2
    s2 = WM(xs2,:)';
    
    % Add noise if selection is true
    if noise == true
        % snr (Signal to noise ratio) = 10*log10(Psignal/Pnoise):
        % s = awgn(signal,snr);
        snr = 10;           % snr = 10 means Psignal/Pnoise = 10
        s1 = awgn(s1,snr);
        s2 = awgn(s2,snr);
    end
    
    output = input;
    output.WM = WM;
    output.s1 = s1;
    output.s2 = s2;