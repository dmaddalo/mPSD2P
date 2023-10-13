function stats = computestats(psd2p,psd1,psd2,f,df,flim)

% COMPUTESTATS Compute the csd statistics.
% 
%   stats = COMPUTESTATS(csd,f,df,flim) computes the circular statistics of
%       the csd according to the original frequency vector upon which the
%       csd is originally computed. The resulting statistics will be
%       binned according to the desired frequency interval df and up until
%       the desired frequency flim. These two optios both allow to ease 
%       computational effort and aid data visualization when plotting.
%
%
%   INPUTS
%   
%   * csd: original array of the cross-correlation.
%   * f: original frequency array upon which csd has been computed.
%   * df: desired frequency interval of output statistics.
%   * flim: upper limit frequency until which the statistics will be
%       computed.
% 
%   OUTPUTS
%   
%   * stats: struct array containing:
%       * meanphase: mean value of the csd phase
%       * stdphase: standard deviation value of the csd phase
%       * meanpow: mean value of the csd power
%       * stdpow: standard deviation value of the csd power
%       * fRFTbin: final frequency array of the statistics, each frequency 
%           entry is df apart from each other.


dfbin = f(1):df:flim;
fbin = discretize(f,dfbin);
fbin = fbin(~isnan(fbin));

powerCSD = psd2p.pow;
phaseCSD = psd2p.ang;
origCSD = psd2p.orig;


stats.meanphase = zeros(fbin(end),1);
stats.stdphase = stats.meanphase;
stats.meanpow = stats.meanphase;
stats.stdpow = stats.meanphase;
stats.fRFTbin = dfbin(1:end-1)';
for i = fbin(1):fbin(end)
    stats.meanphase(i) = angle(mean(exp(1i*phaseCSD(fbin == i,:)),'all'));
    stats.stdphase(i) = mean(pi - abs(pi - abs(phaseCSD(fbin == i,:) - stats.meanphase(i))),'all');

    % stats.meanpow(i) = mean(log10(abs(csd(fbin == i,:))),'all');
    stats.meanpow(i) = mean(log10(powerCSD(fbin == i,:)),'all');
    stats.stdpow(i) = std(log10(powerCSD(fbin == i,:)),0,'all');

    stats.coherence(i) = sum(origCSD(fbin == i,:),'all') ./ ( sqrt( sum(psd1(fbin == i,:),'all') )*sqrt( sum(psd2(fbin == i,:),'all') ) );
end
stats.coherence = stats.coherence.';