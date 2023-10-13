function [wavemat] = buildwave(t,x,freq0,lambda0,Ar,Al,Hr,Hl)

% BUILDWAVE Build a dummy wave with the specified inputs.
% 
%   [wavemat] = BUILDWAVE(t,x,freq0,lambda0,Ar,Al,Hr,Hl) builds a wave 
%       matrix made of traveling waves with arbitrary frequency and 
%       wavenumber in possibly both directions and with several aribtrary 
%       harmonics.
% 
%   
%   INPUTS
%   
%   * t: time vector.
%   * x: space vector.
%   * freq0: main frequency (linear).
%   * lambda0: main wavelength (linear).  
%   * Ar: amplitude of right traveling harmonics.
%   * Al: amplitude of left traveling harmonics.
%   * Hr: number of right traveling harmonics.
%   * Hl: number of left traveling harmonics.
%      
%   OUTPUTS
%   
%   *wavemat: wave matrix with dimensions [space,time].

    waveright = zeros(length(x),length(t));
    waveleft = waveright;
    
    for i = 1:length(Hr)
        waveright = waveright + real(Ar*(exp(1i*2*Hr(i)*pi/lambda0*(x' - freq0*lambda0*t))));
    end
    for i = 1:length(Hl)
        waveleft = waveleft + real(Al*(exp(1i*2*Hl(i)*pi/lambda0*(x' + freq0*lambda0*t))));
    end
    
    wavemat = waveright + waveleft;
end