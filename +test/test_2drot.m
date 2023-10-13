%% INITIALIZER
function tests = test_2drot
%     clc;
    close all;
    tests = functiontests(localfunctions); % See the help if you want more info
    
    global output

    %% DEFINES ALL PARAMETERS FOR THE SIGNAL MATRIX AND BUILDS IT
    % This is done in the main test module in order to avoid opening the
    % "testparams.m" function every time you need to make parametric changes.

    % The signal matrix has a size of [length(x),length(t)]. In order to
    % get a signal vector, it is required to specify a position within the
    % range of the x vector.
    input.t = 0:0.0005:0.1;  % time vector [s]
    input.x = 0:0.0005:10;  % space vector [m]

    input.Xp1 = 5.0;
    input.Xp2 = 4.9;
    
    input.freq0 = 50;     % main frequency [Hz]
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


%% TEST 2
function test_rotation(~)

    global output

    WM = output.WM;
    x = output.x;
    t = output.t;
    % Coordinates on original, non-rotated frame
    if output.Xp1 > output.Xp2
        Xp1 = output.Xp2;
        Xp2 = output.Xp1;
        s1 = output.s2;
        s2 = output.s1;
    else
        Xp1 = output.Xp1;
        Xp1 = output.Xp2;
        s1 = output.s1;
        s2 = output.s2;
    end
    Xp3 = Xp1;
    
    % This corresponds to a clockwise rotation of the probe frame x'-y' 
    % (along which the probes are measuring) with respect to the actual 
    % frame x-y (along whose direction - x - the dummy wave is traveling)
    rot = 25;      % deg
    
    Xp2r = Xp1 + (Xp2 - Xp1)*cos(deg2rad(rot));
    Xp3r = Xp1 - (Xp2 - Xp1)*sin(deg2rad(rot));

    %% Values along rotated axes

    % Index of fictional probe position 2 but rotated of "rot" degrees
    xs2r = abs(Xp2r - x) < (x(2)-x(1))/2;
    % Index of fictional probe position 3 but rotated of "rot" degrees
    xs3r = abs(Xp3r - x) < (x(2)-x(1))/2;
    % Signal 2
    s2r = WM(xs2r,:)';
    % Signal 3
    s3r = WM(xs3r,:)';

    % % Plot the signals
    % figure
    % plot(t,s1); hold on;
    % plot(t,s2); xlim([0 0.1])
    % if Xp1 > Xp2
    %     legend('front probe','rear probe')
    % elseif Xp2 > Xp1
    %     legend('rear probe','front probe')
    % end

    [fqs,fs1] = ko.computefft(t,s1);
    [~,fs2r] = ko.computefft(t,s2r);
    [~,fs3r] = ko.computefft(t,s3r);
    
    csd12r = ko.CSD(fs2r,fs1,fqs);
    csd13r = ko.CSD(fs1,fs3r,fqs);
    
    [X12r,Y12r,SS12r] = ko.komega_binning(fqs,angle(csd12r),abs(csd12r),fqs,-pi:0.025:pi);
    [X13r,Y13r,SS13r] = ko.komega_binning(fqs,angle(csd13r),abs(csd13r),fqs,-pi:0.025:pi);

    figure
    surf(X12r,Y12r,SS12r,'edgecolor','none'); view(2); colormap([[1,1,1];jet]);
    axis([X12r(1) X12r(end) Y12r(1) Y12r(end)]); colorbar; caxis([1e-10 1]);
    set(gca,'ColorScale','log')
    title('Rotated frame')
    xlabel('k_{x''}')
    figure
    surf(X13r,Y13r,SS13r,'edgecolor','none'); view(2); colormap([[1,1,1];jet]);
    axis([X13r(1) X13r(end) Y13r(1) Y13r(end)]); colorbar; caxis([1e-10 1]);
    set(gca,'ColorScale','log');
    title('Rotated frame')
    xlabel('k_{y''}')

    %% Values along original axes 

    % Index of fictional probe position 3 not rotated
    xs3 = abs(Xp3 - x) < (x(2)-x(1))/2;
    % Signal 3
    s3 = WM(xs3,:)';

    [~,fs2] = ko.computefft(t,s2);
    [~,fs3] = ko.computefft(t,s3);

    csd12 = ko.CSD(fs2,fs1,fqs);
    csd13 = ko.CSD(fs1,fs3,fqs);
    
    [X12o,Y12o,SS12o] = ko.komega_binning(fqs,angle(csd12),abs(csd12),fqs,-pi:0.025:pi);
    [X13o,Y13o,SS13o] = ko.komega_binning(fqs,angle(csd13),abs(csd13),fqs,-pi:0.025:pi);

    figure
    surf(X12o,Y12o,SS12o,'edgecolor','none'); view(2); colormap([[1,1,1];jet]);
    axis([X12o(1) X12o(end) Y12o(1) Y12o(end)]); colorbar; caxis([1e-10 1]);
    set(gca,'ColorScale','log')
    title('Original frame')
    xlabel('k_x')
    figure
    surf(X13o,Y13o,SS13o,'edgecolor','none'); view(2); colormap([[1,1,1];jet]);
    axis([X13o(1) X13o(end) Y13o(1) Y13o(end)]); colorbar; caxis([1e-10 1]);
    set(gca,'ColorScale','log');
    xlabel('k_y')
    title('Original frame')
    
    %% Rotate back to original axes
    
    pow12 = sqrt(abs(csd12r).^2*cos(deg2rad(rot))^2 + abs(csd13r).^2*sin(deg2rad(rot))^2);
    pow13 = sqrt(abs(csd12r).^2*sin(deg2rad(rot))^2 + abs(csd13r).^2*cos(deg2rad(rot))^2);

    ang12 = angle(csd12r)*cos(deg2rad(-rot)) - angle(csd13r)*sin(deg2rad(-rot));
    ang13 = angle(csd12r)*sin(deg2rad(-rot)) + angle(csd13r)*cos(deg2rad(-rot));

    [X12,Y12,SS12] = ko.komega_binning(fqs,ang12,pow12,fqs,-pi:0.025:pi);
    [X13,Y13,SS13] = ko.komega_binning(fqs,ang13,pow13,fqs,-pi:0.025:pi);

    figure
    surf(X12,Y12,SS12,'edgecolor','none'); view(2); colormap([[1,1,1];jet]);
    axis([X12(1) X12(end) Y12(1) Y12(end)]); colorbar; caxis([1e-10 1]);
    set(gca,'ColorScale','log')
    title('Rotated back to original frame')
    xlabel('k_x')
    figure
    surf(X13,Y13,SS13,'edgecolor','none'); view(2); colormap([[1,1,1];jet]);
    axis([X13(1) X13(end) Y13(1) Y13(end)]); colorbar; caxis([1e-10 1]);
    set(gca,'ColorScale','log');
    title('Rotated back to original frame')
    xlabel('k_y')

end