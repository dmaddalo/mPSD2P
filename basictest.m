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
function tests = basictest
%     clc;
%     close all;
    tests = functiontests(localfunctions); % See the help if you want more info
    
    global t Xp1 Xp2 freq0 lambda0 Ar Al Hr Hl s1 s2 tolerance
    
    t = 0:0.0005:0.1;  % time vector [s]
    x = 0:0.0005:10;  % space vector [m]
    
    % DEFINES ALL PARAMETERS FOR THE SIGNAL MATRIX AND BUILDS IT
    % The signal matrix has a size of [length(x),length(t)]. In order to
    % get a signal vector, it is required to specify a position within the
    % range of the above defined x vector.
    Xp1 = 5.0;
    Xp2 = 4.9;
    
    freq0 = 50;     % main frequency [Hz]
    lambda0 = 3;    % main wavelength [m]
    Ar = 1;      % amplitude of right traveling wave (a.u.)
    Al = 0;       % amplitude of left travelig wave (a.u.)
    
    noise = false;  % turn off or on noise superposition on the original signal
    
    % Noise tolerance versus the max value of the dispersion diagram
    tolerance = 500;
    
    % Integer array of right number of harmonics from 1 to n
	Hr = 1:5;   % from ... to ...
    
    % Integer array of left number of harmonics from 1 to n
    Hl = 1:1;   % from ... to ...
  
    
    % Builds signal matrix
    [WM] = test.buildwave(t,x,freq0,lambda0,Ar,Al,Hr,Hl);
          
    
    % Index of fictional probe position 1
    xs1 = abs(Xp1 - x) < (x(2)-x(1))/2;
    % Signal 1
    s1 = WM(xs1,:)';
    % Index of fictional probe position 2
    xs2 = abs(Xp2 - x) < (x(2)-x(1))/2;
    % Signal 2
    s2 = WM(xs2,:)';
    
    % Add noise if selection is true
    if noise == true
        % snr (Signal to noise ratio) = 10*log10(Psignal/Pnoise):
        % s = awgn(signal,snr);
        snr = 10;           % snr = 10 means Psignal/Pnoise = 10
        s1 = awgn(s1,snr);
        s2 = awgn(s2,snr);
    end
    
    % Plot the signals
    figure
    plot(t,s1); hold on;
    plot(t,s2); xlim([0 0.1])
    if Xp1 > Xp2
        legend('front probe','rear probe')
    elseif Xp2 > Xp1
        legend('rear probe','front probe')
    end
    
end


%% TEST 3
function test_new_CSD(~)
    global t Xp1 Xp2 freq0 lambda0 Ar Al Hr Hl s1 s2 tolerance
    
    [fqs,fs1] = ko.computefft(t,s1);
    [~,fs2] = ko.computefft(t,s2);
    
    [avg_CSD] = ko.CSD(fs1,fs2,fqs);
    
    [X,Y,SS] = ko.komega_binning(fqs,angle(avg_CSD),abs(avg_CSD),fqs,-pi:0.025:pi);
    
    figure
    surf(X,Y,SS,'edgecolor','none'); view(2); colormap([[1,1,1];jet]);
    axis([X(1) X(end) Y(1) Y(end)]); colorbar; caxis([1e-10 1]);
    set(gca,'ColorScale','log');
end