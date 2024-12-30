function [score,E] = dtmfdetect(sKey,h,Fs)
% score = dtmfdetect(sKey,h)
%
% sKey  : Vector containing the time domain signal corresponding to a
%         single phone pad key. 
% h     : Vector containing the impulse response of a bandpass filter
%         located at a single center frequency fCenter
% Fs    : The sample rate in samples per second or Hertz. OPTIONAL
%         Default: Fs = 8192;
%
% score : Output of detection process. If y is the filter output then:
%           score = 1 if sum y.^2 >= 0.6 
%           score = 0 if sum y.^2 <  0.6
%
% This program performs signal detection after performing filtering with
% the bandpass filter given in h.
%            _____
%   sKey --->| h |---> y
%            -----
%
% If the energy in the output signal y is greater than the threshold 0.6,
% then there is significant energy in sKey in that frequency band and a
% detection is declared (score =1). If the energy in the output signal y is
% below the threshold 0.6, then there is not significant energy in sKey in
% that frequency band and no detection is declared (score=0). 

% W. C. Karl SC401 Fall06

% Set defaults
if nargin < 2
    Fs = 8192;
end;    

% Threshold level
THRESHOLD = 0.6;

% First normalize the signal to make the threshold to duration and
% amplitude variation. This normalization assume there are a *pair* of
% tones in sKey, so scaling the maximum amplitude to 2 scales the
% individual cos terms to 1. Note: doing this when there is only a single
% tone present will increase the energy of that single tone relative to the
% two tone case.
% Following normalization sum(abs(y).^2)/Fs for a single tone should have
% unit energy
TsKey = length(sKey)/Fs;    % Time duration of sKey
sKey = 2*sKey/max(abs(sKey)); % Makes base cosines unit amplitude
sKey = sKey / sqrt(TsKey/2);      % Makes resulting individual cosines unit energy. 

% Now filter. 
% We scale the convolution by 1/Fs so the discrete convolution approximates
% the continuous convolution. Essentially 1/Fs = "dt"
y = conv(sKey,h)/Fs;

% Now find total energy E in output of the bandpass filte: int |y|^2 dt. 
% 1/Fs = "dt".
E = sum(abs(y).^2)/Fs;

% Finally threshold to produce binary output "score"
score = (E>=THRESHOLD);
