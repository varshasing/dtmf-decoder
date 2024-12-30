function sKeys = dtmfdial(Keys,Ttone,Fs)
% sKeys = dtmfdial(Keys,Ttone,Fs)
%
% Keys  : String containing the key sequence to generate the signal for.
%         For example, Keys='225-2356' would produce the signal to dial the
%         number. Note the quotes -- Keys=225-2356 will NOT produce the
%         desired result!
% Ttone : The duration in seconds of each key tone. OPTIONAL
%         Default: Ttone = 0.1; (i.e. 100 ms)
% Fs    : The sample rate in samples per second or Hertz. OPTIONAL
%         Default: Fs = 8192;
%
% sKeys : The time domain signal corresponding to the key sequence in the 
%         string Keys
% 
% This program creates the DTMF signal corresponding to the key sequence in
% the input string Keys. The phone pad characters 0 through 9, #, and * are
% recognized. Anything else (e.g. space and "-") are ignored.

% W. C. Karl SC401 F06

% Check for errors
if ~ischar(Keys)
    error(['Input variable ''Keys'' must be a string array'])
end;    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set program defaults
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set default sampling rate
if nargin<3
    Fs = 8192;
end;    

% Set default tone duration (seconds)
if nargin<2
    Ttone = 0.100; % 100ms duration
end;

% Duration of pause
Tpause = 0.05; % 0.05 sec pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set parameters in this block
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define row frequencies (Hertz)
fRows = [...
    697;
    770;
    852;
    941];

% Define column frequencies (Hertz)
fCols = [...
    1209;
    1336;
    1477];

% Make array of key names
% The row/column positions of these keys match the phone.
KeyMap = [...
    '1' '2' '3';
    '4' '5' '6';
    '7' '8' '9';
    '*' '0' '#'];

% Make time vector for tones based on specified tone length
N = round(Fs*Ttone);  % Number of samples in a key tone at rate Fs
t = (0:N-1)/Fs;       % Time vector: N samples separated by 1/Fs

% Make space signal
space = zeros(1,round(Fs*Tpause));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now decipher input string and translate into tone sequence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Nsymbols = length(Keys);    % Get total number of input symbols in Keys
sKeys = [];                 % Initialize output signal to empty array

% For each symbol in Keys, identify correct row, column, create signal
% pair, and append to overall signal...
for k = 1:Nsymbols

    % Get current key symbol
    CurrentKey = Keys(k);

    % Find current key in the KeyMap: Returns the row/col index 
    % containing the key
    [IRow,ICol] = find(CurrentKey == KeyMap);

    % If the current key symbol is found in the KeyMap, 
    % add corresponding tone. Otherwise, just ignore it
    if ~isempty(IRow)

        % Add signal for current key to overall signal and end with a space
        sKeys = [...
            sKeys,...
            0.5*cos(2*pi*fRows(IRow)*t) + 0.5*cos(2*pi*fCols(ICol)*t),...
            space];
    end

end;
