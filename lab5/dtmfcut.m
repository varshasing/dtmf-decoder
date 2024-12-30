function [nstart,nstop] = dtmfcut(sKeys,Fs)
% [nstart,nstop] = dtmfcut(sKeys,Fs)
%
% sKeys  : Vector containing a time domain signal corresponding to a
%          sequence of phone pad keys
% Fs     : The sample rate in samples per second or Hertz. OPTIONAL
%          Default: Fs = 8192;
%
% nstart : Vector containing the indices of the start points of each
%          distinct key signal
% nstop  : Vector containing the indices of the stop points of each
%          distinct key signal
%
% This function takes a time domain DTMF signal and finds the index
% locations within that overall signal of the separate, single key
% segmenents. These index locations are returned in the common length
% vectors nstart and nstop. If nstart (and nstop) are of length M, then M
% distinct key signals have been found. For example, the kth key signal
% contained in sKeys may be extracted from the original signal sKeys via:
%
% sKeys(nstart(k),nstop(k))
%
% The function assumes the tone regions are separated by silence regions of
% at least 10msec. Further, any tone regions less than 40msec in duration
% are ignored (per the ITU standard). 

% W. K. Karl SC401

% For ease of interpretation, we make new variables for each intermediate
% step, which is memory inefficient, but easier to read and understand. 

% Set defaults
if nargin < 2
    Fs = 8192;
end;    

% Preliminary setup
s_norm = sKeys(:)'/max(abs(sKeys)); % Normalize s to range [-1 1]
Ls = length(sKeys);                 % Get length of signal
Lf = round(0.01*Fs);                % Set length of boxcar smoothing filter: 10ms
THRESHOLD = 0.02;                   % Set Threshold at 2% of max signal value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Turn original tone-pair signal into binary waveform indicating tone
% locations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step 1: Smooth rectified raw signal with boxcar filter
s_filter = filter( ones(1,Lf)/Lf, 1, abs(s_norm) );

% Step 2: Threshold resulting smoothed, rectified signal to obtain binary
% waveform indicating regions of tone-pairs.
s_threshold = s_filter > THRESHOLD; 

% Step 3: Find edges of binary waveform, which indicate pulse transition 
% locations
s_diff = diff(s_threshold);   % Edges of binary wave indicate pulses

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Turn binary waveform into list of tone transition locations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step 1: Find indices of all points corresponding to a "transition" in 
% the binary waveform. These are locations of tone-pair start and stop
Itransitions = find(s_diff~=0)';

% Step 2: Deal with edge effect, which may cause us to miss the initial and
% final edges

% If the first transition found is not positive, we've missed the first
% leading edge due to edge effect and need to fix it.
if s_diff(Itransitions(1))<0, 
    Itransitions = [1;Itransitions];  
end

% If the last transition found is not negative, we've missed the final
% trailing edge due to edge effects and need to fix it.
if s_diff(Itransitions(end))>0, 
    Itransitions = [Itransitions;Ls]; 
end

% Step 3: Now create lists of the start and stop indices of each tone-pair. 
% This is now easy since these points are given by sequential pairs of the
% indices in Itransitions
nstart = Itransitions(1:2:end,1);
nstop = Itransitions(2:2:end,1);

% Finally, we have to remove any identified tone bursts of duration less
% than 40msec (the ITU standard). Note that 40msec corresponds to 0.04*Fs
% samples. 
Iremove = find(nstop-nstart< 0.04*Fs); % Find indices of pairs less than 40ms in length
nstart(Iremove) = [];   % Remove from start list
nstop(Iremove) = [];    % Remove from stop list
