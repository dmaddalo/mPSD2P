function [f,transform] = computefft(t,s)

% COMPUTEFFT Compute the single-sided complex fft.
%   
%   [f,transform] = COMPUTEFFT(t,s) computes the fft of for the columns of 
%       signal matrix "s" and truncates it at the correct frequency.
% 
% 
%   INPUTS
%   
%   * t: time vector (m,1).  
%   * s: signal array (m,n) (each column is a different signal).
% 
%   OUTPUTS
%   
%   * f: linear frequency vector.
%   * transform: single-sided complex fft vector.


% Routine to detect if s is a single row vector and transpose it if so
if size(s,1) == 1 && size(s,2) ~= 1
   s = s';
end
% Routine to force the vector sizes to even values if odd. If the vector 
% lengths are odd, the fft algorithm computes wrong phase (with 
% discontinuities at the points where the power peaks) and the 
% magnitude-frequency assignment is not exact (empirically validated).
if rem(length(t),2) ~= 0
    t = t(1:end-1);
    s = s(1:end-1,:);
end

m = length(t);
n = length(s(1,:));

fs = 1/(t(2)-t(1));

transform(m,n) = 0; % Allocate
for i = 1:n
    % Normalize with length of t
    transform(:,i) = fftshift(fft(s(:,i))/length(t));
end

fres = fs/length(t);
f = fres*(-m/2:m/2-1);

truncation = m/2+1;

% Truncate the transform to keep only the positive frequency side
f = f(truncation:end)';
transform = transform(truncation:end,:);
 