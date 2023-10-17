function [f,csd,varargout] = CSD(fs1,fs2,f,varargin)
% CSD Compute the Cross-Spectral Density of two Fourier-transformed
% signals.
%   
%   avgCSD = CSD(fs1,fs2) computes the cross spectral density (CSD) of the 
%       Fourier transforms of two synchronized signals (probes). If more than 
%       one realization of each fft is given, the average CSD is returned.
% 
%   
%   INPUTS
%   
%   * fs1: fft of signal 1 array (m,n) (each column is a different realization)
%   * fs2: fft of signal 2 array (m,n) (each column is a different realization)
% 
%   OUTPUTS
%   
%   * avg_CSD: (realization-averaged) complex cross spectral density array
%       (m).

if nargin > 3 && ~isempty(varargin{1})
    flim = varargin{1};
else
    flim = f(end);
end
if nargin > 4
    chunks = varargin{2};
else
    chunks = 1;
end

m = find(abs(f-flim) <= f(2)-f(1),1,'last'); % fft length
n = length(fs1(1,:)); % number of realizations

fs1 = fs1(1:m,:); % Cut arrays
fs2 = fs2(1:m,:);
f = f(1:m,:); 
csd(m,n) = 0; % Allocate
psd1(m,n) = 0;
psd2(m,n) = 0;
for i = 1:n
    csd(:,i) = fs1(:,i).*conj(fs2(:,i));
    psd1(:,i) = fs1(:,i).*conj(fs1(:,i));
    psd2(:,i) = fs2(:,i).*conj(fs2(:,i));
end

csd = csd/chunks;
psd1 = psd1/chunks;
psd2 = psd2/chunks;

varargout{1} = psd1;
varargout{2} = psd2;