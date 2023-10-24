%{
Tests and examples
%}

%{ 
Visualize the "S" behavior of the dispersion diagram with:
Xp1 = 4.5
Xp2 = 4.6
freq0 = 50
lambda0 = 3
Ar = 1
Al = 0
Hr = 1:10
Hl irrelevant; Al is 0
%}

%% INITIALIZER
function tests = test_basic
%     clc;
%     close all;
    tests = functiontests(localfunctions); % See the help if you want more info

    global output %#ok<GVMIS>

    %% DEFINES ALL PARAMETERS FOR THE SIGNAL MATRIX AND BUILDS IT
    % This is done in the main test module in order to avoid opening the
    % "testparams.m" function every time you need to make parametric changes.

    % The signal matrix has a size of [length(x),length(t)]. In order to
    % get a signal vector, it is required to specify a position within the
    % range of the x vector.
    input.t = 0:0.0005:0.5;  % time vector [s]
    input.x = 0:0.0005:10;  % space vector [m]

    input.Xp1 = 5.0;
    input.Xp2 = 4.9;
    
    input.freq0 = 52;     % main frequency [Hz]
    input.lambda0 = 3;    % main wavelength [m]
    input.Ar = 1;      % amplitude of right traveling wave (a.u.)
    input.Al = 0;       % amplitude of left travelig wave (a.u.)
    
    input.noise = false;  % turn off or on noise superposition on the original signal
    
    % Noise tolerance versus the max value of the dispersion diagram
    input.tolerance = 500;
    
    % Integer array of right number of harmonics from 1 to n
	input.Hr = 1:5;   % from ... to ...
    
    % Integer array of left number of harmonics from 1 to n
    input.Hl = 1:1;   % from ... to ...

    output = test.buildparams(input);
    
end


%% TEST 3
function test_PSD2P(~)
    
    global output %#ok<GVMIS>

    Xp1 = output.Xp1;
    Xp2 = output.Xp2;
    s1 = output.s1;
    s2 = output.s2;
    t = output.t;

    % Plot the signals
    figure
    plot(t,s1); hold on;
    plot(t,s2); xlim([0 0.1])
    if Xp1 > Xp2
        legend('front probe','rear probe')
    elseif Xp2 > Xp1
        legend('rear probe','front probe')
    end

    [fqs,fs1] = ko.computefft(t,s1);
    [~,fs2] = ko.computefft(t,s2);
    
    [~,avg_CSD] = ko.CSD(fs1,fs2,fqs);
    
    [X,Y,SS] = ko.komega_binning(fqs,angle(avg_CSD),abs(avg_CSD),fqs,-pi:0.025:pi);
    
    figure
    surf(X,Y,SS,'edgecolor','none'); view(2); colormap([[1,1,1];jet]);
    axis([X(1) X(end) Y(1) Y(end)]); colorbar; caxis([1e-10 1]);
    set(gca,'ColorScale','log');
end
