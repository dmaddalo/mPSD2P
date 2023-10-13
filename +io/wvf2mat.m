function [t,WaveData] = wvf2mat(directory)

% WVF2MAT Read a .wdf or .txt waveform file and save it in a .m file as specified.
%   
%   WVF2MAT(directory) reads all waveform files in the specified directory and
%       saves a matfile 'WaveData.mat' with the data in the same directory. 
%       The saved data consist of 't', the column time vector, and 'WaveData',
%       a 3-index array.
%       First index goes with time.
%       Second index goes with probes.
%       Third index goes with experimental realization.
%       Assumed: all realizations share the same 't' vector.
% 
%   
%   INPUTS
%   
%   * directory: struct with 2 fields.
%       directory.fullpath: string with the path of the directory.
%       directory.oldnew: dataset discriminant; 1 for older dataset, 2 for 
%           latest dataset.

% Data loading
realization = dir([directory,'/*.txt']);
if ~isempty(realization)
    for i = 1:size(realization,1)
    %         i_realization = 1:3
        temp = importdata(fullfile(directory,realization(i).name),'\t',24);
        WaveData(:,i,:) = temp.data;
    end
else
    error(['Undefined dataset.'])
end

tspan = str2double(temp.textdata{7,:}(22:32));
n_t = length(WaveData(:,1,1));

t = linspace(0,tspan,n_t);

% Data saving
% save(fullfile(directory,'WaveData'),'t','WaveData','-v7.3');
 
