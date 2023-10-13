function [t_chunked,WaveData_chunked] = chunking(t,WaveData,n_chunks)

% CHUNKING cut down the waveforms into smaller chunks.
%   
%   [t_chunked,WaveData_chunked] = CHUNKING(t,WaveData,n_chunks) divides 
%       the waveforms into the specified amount of n_chunks chosen by 
%       the user.
%  
%   INPUTS
%   
%   * t: original time vector.
%   * WaveData: cell array containing one sample per cell; each cell 
%       contains a different trace on each column.
%   * n_chunks: number of chunks.
% 
%   OUTPUTS
%   
%   * t_chunked: new time vector.
%   * WaveData_chunked: trace number n (from 1 to 4) in the format 
%       [m,n] = [time realizations,final samples].


% Initialize
chunk_length = floor(length(t)/n_chunks);
n_probe = length(WaveData(1,1,:));
n_realizations = length(WaveData(1,:,1)); 

t_chunked = t(1:chunk_length);

WaveData_chunked(chunk_length,n_realizations*n_chunks,n_probe) = 0; % Allocate

for i_chunk = 1:n_chunks 
    WaveData_chunked(:,1+n_realizations*(i_chunk-1):n_realizations*i_chunk,:) = ...
        WaveData(1+chunk_length*(i_chunk-1):chunk_length*i_chunk,:,:);
end 


