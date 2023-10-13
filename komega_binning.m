function [kk,ff,h] = komega_binning(f,k,p,fbin,kbin)

% KOMEGA_HISTOGRAM Perform the binning for the komega diagram.
%   
%   [ff,kk,h] = KOMEGA_HISTOGRAM(f,k,v,fbin,kbin) creates a 2D histogram 
%       using one or more f,k,v triples. Given an array v of CSD values,
%       provide the original vectors of frequencies and wavenumbers f and k
%       alongside the bin arrays of frequency and wavenumber fbin and kbin 
%       according to which the binning assignment of f and k is desired.
%
% 
%   INPUTS
%
%   * f: array with vectors of frequencies.
%   * k: array with vectors of wavenumbers.
%   * v: array with vectors of the magnitude of the kf diagram.
%   * fbin: vector with the frequency bin edges.
%   * kbin: vector with the wavenumber bin edges.
% 
%   OUTPUTS
%   
%   * ff: meshgrid matrix of frequencies.
%   * kk: meshgrid matrix of wavenumbers.
%   * h: the 2D histogram.


    % Ensure column vectors
    fbin = fbin(:);
    kbin = kbin(:);
    if isrow(f)
        f = f(:);
    end
    if isrow(k)
        k = k(:);
    end
    if isrow(p) 
        p = p(:);
    end

    % Create the meshgrid
    [kk,ff] = meshgrid(kbin,fbin);

    % Compute area of each bin
    area = (fbin(2:end)-fbin(1:end-1))*(kbin(2:end)-kbin(1:end-1))';

    % Initialize the histogram
    h = zeros(size(ff));

    % Find the bin indices for the frequency
    fi = discretize(f,fbin);
    fi = fi(~isnan(fi));
    % Perform averaging of phase and power accordign to the statistics
    for i = fi(1):fi(end)
        k_f(i,:) = angle(mean(exp(1i*k(fi == i,:)),'all'));
        p_f(i,:) = 10^(mean(log10(abs(p(fi == i,:))),'all'));
    end
    % Find the bin indices for the wavenumber
    ki = discretize(k_f,kbin);
    
    for i = 1:length(ki(:,1))
        if ~isnan(ki(i)) && ~isnan(fi(i))
            % Take the sum here is unnecessary
            % h(i,ki(i,j)) = h(i,ki(i,j)) + sum(v_f(i,j))/area(i,ki(i,j));
            % The area is better not to include it so that the
            % magnitudes are comparable with the power statistics
            h(i,ki(i)) = h(i,ki(i)) + sum(p_f(i));
        end
    end