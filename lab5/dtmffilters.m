function hAll = dtmffilters(fCenter,Tf,Fs)
% hAll = dtmffilters(fCenter,Tfilter,Fs)
%
% fCenter   : Vector of Nf center frequencies of the filter passbands in Hertz
% Tf        : Duration of the impulse response of the bandpass filters in seconds
% Fs        : The sample rate in samples per second or Hertz. OPTIONAL
%             Default: Fs = 8192;
%
% hAll      : Matrix of all the bandpass filter impulse responses. Column k
%             contains the bandbass filter impulse response corresponding
%             to center frequency fCenter(k). Thus hAll is a
%             (Tfilter/Fs) X (Nf) matrix.
%
% This program creates a set of bandpass filters based on the input
% specification. A set of center frequencies are given in the Nf long
% vector fCenter. For each center frequency specified, the impulse response
% of a bandpass filter with that center frequency is produced. The
% "quality" of the bandpass filter is controlled through the duration of
% the impulse, as specified in Tfilter. Longer durations produce sharper
% filters. The filters are normalized to have unit passband height. 

% W. C. Karl SC401 Fall06

% Make time vector of duration Tfilter at sample rate Fs
t = 0:1/Fs:Tf;

% Find number of center frequencies in fCenter
Nf = length(fCenter);

% For each frequency, find filter and append it to the overall set.
hAll = [];
for k = 1:Nf
    
    % Extract current center frequency
    fk = fCenter(k);

    % Make base inpulse response
    hk = cos(2*pi*fk*t);

    % Normalize so filter has unit passband height
    hk = hk /(Tf/2);

    % Append to overall set of filters.
    hAll = [hAll, hk(:)];
    
end;