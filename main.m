clearvars; clear all;

%% d = axial distance [mm]
d = 20;
%% alpha = angular displacement [deg]
alpha = 50;
%% SCCM
mdot = 2.4;
%%
rot = 25;
forced = 0;
not = 1;
day = '16.10';
%% Number of chunks in which to divide the waveform
chunks = 1;
%% Binning parameters (none of those depend on the dataset)
df = 200;       % Hz
dk = 2;         % deg
flim = 1e5;     % upper limit frequency

% oldnew = 1;

%% Define final directory path
% directory = io.definefolder(mdot,d,alpha,oldnew);
directory = io.definefolder(mdot,d,alpha,day);

if forced == true
    directory = [directory,'-forced'];
elseif not == true
   directory = [directory,' - Copie'];
end

%% Loading data
% Waveform to mat file
if ~exist(fullfile(directory,'WaveData.mat'),'file')
    [t,WaveData] = io.wvf2mat(directory);
end

% Load the mat waveform file
% [t,WaveData] = io.matload(directory,samples);

% Adjust
celldays = {'3.10','4.10','5.10','16.10'};
if any(cell2mat(cellfun(@(x) strcmp(day,x),celldays,'UniformOutput',false)))
    rho = 143.1;
    x = 130; y = 60;
    alphalang = rad2deg(atan(y/x));
else
    mu = atan(10/d); dr = d+10; dt = d/cos(mu);
    y = d*sin(deg2rad(alpha)); yt = y; yr = dr*sin(deg2rad(alpha));
end

params.mdot = mdot;
params.alpha = alpha;
params.d = d;
params.chunks = chunks;
params.y = y;
% params.oldnew = oldnew;

%% Divide the waveforms into the specified amount of chunks
% WARNING: the original time vector "t" gets overwritten (? not really)
[t_c,WaveData_c] = io.chunking(t,WaveData,chunks);

%
%% Computes the ffts and returns the single-sided complex transforms
WaveData_t = zeros(floor(size(WaveData_c,1)/2),size(WaveData_c,2),size(WaveData_c,3));
for i = 1:size(WaveData_c,2)
    [fRFT,WaveData_t(:,i,:)] = ko.computefft(t_c,...
        reshape(WaveData_c(:,i,:),size(WaveData_c,1),size(WaveData_c,3)));
end

%% Computes the k-omega dispersion diagram with the alternative CSD routine
% Cut frequencies above flim and define binned frequency vector
if df < fRFT(2)-fRFT(1)
    df = fRFT(2)-fRFT(1);
end

fRFTbin = fRFT(1):df:flim;
fRFTbin = fRFTbin(:);

%% CSD
% Computed on the non-binned frequency vector fRFT

% Azimuthal
% [csd_az,psd2,psd1] = ko.CSD(WaveData_t(:,:,2),WaveData_t(:,:,1),fRFT,flim);
[fRFTcut,csd32,psd3,psd2] = ko.CSD(WaveData_t(:,:,3),WaveData_t(:,:,2),fRFT,flim,chunks);
% [fRFTcut,csd32,psd2,psd3] = ko.CSD(WaveData_t(:,:,2),WaveData_t(:,:,3),fRFT,flim,chunks);

% Axial
% [csd_ax,psd1,psd3] = ko.CSD(WaveData_t(:,:,1),WaveData_t(:,:,3),fRFT,flim);
[~,csd24,~,psd4] = ko.CSD(WaveData_t(:,:,2),WaveData_t(:,:,4),fRFT,flim,chunks);
% [~,csd24,psd4,~] = ko.CSD(WaveData_t(:,:,4),WaveData_t(:,:,2),fRFT,flim,chunks);

% Radial
[~,csd12,psd1,~] = ko.CSD(WaveData_t(:,:,1),WaveData_t(:,:,2),fRFT,flim,chunks);
% [~,csd12,~,psd1] = ko.CSD(WaveData_t(:,:,2),WaveData_t(:,:,1),fRFT,flim,chunks);

%% Correct probe orientation
% Provisional, only accounts for counterclockwise rotation along the
% azimuthal direction

psd2p_az.orig = csd32;
psd2p_ax.orig = csd24;
psd2p_rd.orig = csd12;

psd2p_az.pow = abs(csd32);
psd2p_ax.pow = sqrt(abs(csd24).^2*cos(deg2rad(rot))^2 + abs(csd12).^2*sin(deg2rad(rot))^2);
psd2p_rd.pow = sqrt(abs(csd24).^2*sin(deg2rad(rot))^2 + abs(csd12).^2*cos(deg2rad(rot))^2);

psd2p_az.ang = angle(csd32);
psd2p_ax.ang = angle(csd24)*cos(deg2rad(rot)) - angle(csd12)*sin(deg2rad(rot));
psd2p_rd.ang = angle(csd24)*sin(deg2rad(rot)) + angle(csd12)*cos(deg2rad(rot));

%% PSD2P
% Computed on the binned frequency vector fRFTbin

% Azimuthal
[Kcsd_az,Fcsd_az,SScsd_az] = ko.komega_binning(fRFT,psd2p_az.ang,psd2p_az.pow,fRFTbin,-pi:deg2rad(dk):pi);

% Axial binned
[Kcsd_ax,Fcsd_ax,SScsd_ax] = ko.komega_binning(fRFT,psd2p_ax.ang,psd2p_ax.pow,fRFTbin,-pi:deg2rad(dk):pi);

% Radial binned
[Kcsd_rd,Fcsd_rd,SScsd_rd] = ko.komega_binning(fRFT,psd2p_rd.ang,psd2p_rd.pow,fRFTbin,-pi:deg2rad(dk):pi);

%% Statistics
% Computed on the binned frequency vector fRFTbin
% If rotation is required, the coherence computed here is not along the
% rotated axis but rather along the original one

% Azimuthal
% stats_az = ko.computestats(csd_az,psd2,psd3,fRFT,2*df,flim);
stats_az = ko.computestats(psd2p_az,psd2,psd3,fRFT,2*df,flim);

% Axial
% stats_ax = ko.computestats(csd_ax,psd2,psd4,fRFT,2*df,flim);
stats_ax = ko.computestats(psd2p_ax,psd2,psd4,fRFT,2*df,flim);

% Radial
% stats_rd = ko.computestats(csd_rd,psd2,psd1,fRFT,2*df,flim);
stats_rd = ko.computestats(psd2p_rd,psd2,psd1,fRFT,2*df,flim);


% Rotate coherence
msc_az = abs(stats_az.coherence).^2;
msc_ax = abs(stats_ax.coherence).^2*cos(deg2rad(rot))^2 + abs(stats_rd.coherence).^2*sin(deg2rad(rot))^2;
msc_rd = abs(stats_ax.coherence).^2*sin(deg2rad(rot))^2 + abs(stats_ax.coherence).^2*cos(deg2rad(rot))^2;

stats_az.coherence = msc_az;
stats_ax.coherence = msc_ax;
stats_rd.coherence = msc_rd;

%% Re-assign and plot
% Azimuthal
Kcsd.az = Kcsd_az;
Fcsd.az = Fcsd_az;
SScsd.az = SScsd_az;
stats.az = stats_az;

% Axial
Kcsd.ax = Kcsd_ax;
Fcsd.ax = Fcsd_ax;
SScsd.ax = SScsd_ax;
stats.ax = stats_ax;

% Radial
Kcsd.rd = Kcsd_rd;
Fcsd.rd = Fcsd_rd;
SScsd.rd = SScsd_rd;
stats.rd = stats_rd;

plot.separateplots(stats,Kcsd,Fcsd,SScsd,params)