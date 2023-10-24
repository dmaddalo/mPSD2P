function [t,WaveData] = matload(directory,samples)

% MATLOAD Load the data.
% 
%   [t,WaveData] = MATLOAD(directory) loads the file WaveData.m from the
%       provided location of directory.
% 
%   [...] = MATLOAD(...,samples) specifies which samples to load.
% 
% 
%   INPUTS
%   
%   * directory: specifies the directory in which to look for the .mat
%       file.
%   * samples: optional. specifies which samples to use in the format of a 
%       vector such as [1,2,3]; the vector as is will select all three 
%       samples, while only the samples 1 and 3 will be chosen if the 
%       vector is [1,3].
% 
%   OUTPUTS
%   
%   * t: time vector; it is meant to be one for all the samples.
%   * WaveData: cell array with each cell corresponding to one single sample;
%       within each cell lays a matrix [n,m] = [number of time acquisitions,
%       number of traces].


% Loads from the .mat file
load(fullfile(directory,'WaveData.mat'),'t','WaveData');

if ~exist('samples','var')
    samples = 1:length(WaveData(1,1,:));
end

% Deletes the cells corresponding to the samples not selected by the user 
WaveData = WaveData(:,samples,:); 

