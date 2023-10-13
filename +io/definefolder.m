function [directory] =  definefolder(mdot,d,alpha,varargin)
    

%% Checks on which machine you are working from
% ROOT FOLDER
if exist('G:\Il mio Drive','dir') == 0  && exist('G:\My Drive','dir') == 7
    root = ['G:\My Drive\me and myself\Università\PhD'];
elseif exist('G:\Il mio Drive','dir') == 7 && exist('G:\My Drive','dir') == 0
    root = ['G:\Il mio Drive\me and myself\Università\PhD'];
else
    root = [fullfile(pwd,'..')];
end

%% Define final directory
additional = ['datasets/prelim/',varargin{1}];

directory = fullfile(root,additional,[sprintf('%0.1f',mdot),'_',sprintf('%03d',d),'_',sprintf('%02d',alpha)]);
