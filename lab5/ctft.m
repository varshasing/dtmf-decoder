function [X,f] = ctft(x,Fs,Nsamp)
% [X,f] = ctft(x,Fs,Nsamp)
%
% x    : Vector of input samples
% Fs   : Sample rate in samples per second
% Nsamp: Number of CTFT samples to generate. Default: Nsamp = length(x) 
%
% X  : Samples of the CTFT of the signal in x
% f  : Corresponding frequencies of the samples in X in Hertz.
%
% This function finds samples of the CTFT of the CT signal whose samples   
% are contained in the vector x. It is assumed that the signal starts at
% t=0 and is sampled at the rate given by Fs. The function makes use of the
% relationship between the CTFT of x(t) and the DTFT of its samples x[n],
% as well as the relationship between the DTFT of x[n] and the DTFS of
% the finite signal x[n] -- that is the DFT of x[n].

% Because of the inherent sampling, only frequencies up to the Nyquest rate
% are calculated.

% W. C. Karl SC401 F06

% Get signal length
if nargin < 3
    Nsamp = length(x);
end;
    
% Find CTFT samples and scale appropriately
%X = fftshift(fft(x,Nsamp))*(2*pi/Nsamp);
X = fftshift(fft(x,Nsamp))/Fs;

% Find corresponding frequency values
if round(Nsamp/2)*2==Nsamp; % For even signals
    f =  linspace(-1,1-2/Nsamp,Nsamp)*Fs/2;
else % For odd signals
    f = [-(Nsamp-1)/2:(Nsamp-1)/2]*Fs/Nsamp;
end;

% Plot results if no output arguments
if nargout == 0
    I = find(f>=0);
    subplot(211)
    loglog(f(I),abs(X(I)).^20);
    xlabel('f (Hz)')
    ylabel('|X(f)| (dB)')
    subplot(212)
    semilogx(f(I),angle(X(I)));
    xlabel('f (Hz)')
    ylabel('Angle X(f)')
end;
  