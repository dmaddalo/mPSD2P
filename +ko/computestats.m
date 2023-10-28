function stats = computestats(csdij,psdi,psdj,f,df,flim)

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


fbin = f(1):df:flim;
fi = discretize(f,fbin);
fi = fi(~isnan(fi));

powerCSD = csdij.pow;
phaseCSD = csdij.ang;
origCSD = csdij.orig;


stats.meanphase = zeros(fi(end),1);
stats.stdphase = stats.meanphase;
stats.meanpow = stats.meanphase;
stats.stdpow = stats.meanphase;
stats.fRFTbin = fbin(1:end-1)';
for i = fi(1):fi(end)
    stats.meanphase(i) = angle(mean(exp(1i*phaseCSD(fi == i,:)),'all'));
    stats.stdphase(i) = mean(pi - abs(pi - abs(phaseCSD(fi == i,:) - stats.meanphase(i))),'all');

    % stats.meanpow(i) = mean(log10(abs(csd(fbin == i,:))),'all');
    stats.meanpow(i) = mean(log10(powerCSD(fi == i,:)),'all');
    stats.stdpow(i) = std(log10(powerCSD(fi == i,:)),0,'all');

    stats.coherence(i) = sum(origCSD(fi == i,:),'all') ./ ( sqrt( sum(psdi(fi == i,:),'all') )*sqrt( sum(psdj(fi == i,:),'all') ) );
end
stats.coherence = stats.coherence.';
