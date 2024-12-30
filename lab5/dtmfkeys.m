function Keys = dtmfkeys(sKeys,Tf,Fs)
% Keys = dtmfdecode(sKeys,Tf,Fs)
%
% sKeys   : The time domain signal corresponding to a sequence of phone pad
%           keys. 
% Tf      : Duration of the impulse response of the bandpass filters in seconds
% Fs      : The sample rate in samples per second or Hertz. OPTIONAL
%           Default: Fs = 8192;
%
% Keys    : A string containing the key sequence corresponding to the signal
%           contained in sKeys. For example, Keys='2252356' 
%
% This program is the executive shell that performs all the signal decoding
% steps. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set defaults
if nargin < 3
    Fs = 8192; % Default sample rate
end

% Define row frequencies (Hertz)
% Note order matches row numbers
fRows = [...
    697;
    770;
    852;
    941];

% Define column frequencies (Hertz)
% Note order matches column numbers
fCols = [...
    1209;
    1336;
    1477];

% Make array of key names for reverse mapping
% The row/column positions of these keys match the phone.
KeyMap = [...
    '1' '2' '3';
    '4' '5' '6';
    '7' '8' '9';
    '*' '0' '#'];

% Create row bandpass filters
hRows = dtmffilters(fRows,Tf,Fs);

% Create column bandpass filters
hCols = dtmffilters(fCols,Tf,Fs);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find component key segments from overall signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[nstart,nstop] = dtmfcut(sKeys,Fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop over individual component segments and process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Keys = [];
Nseg = length(nstart); % Number of segments to process
for k=1:Nseg

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Step 1: Extract current key segment from overall signal
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sKeyk = sKeys(nstart(k):nstop(k));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Step 2: Decode current key segment to corresponding Row,Col pair
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Row,Col] = dtmfdecode(sKeyk,hRows,hCols,Fs);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Step 3: Map Row,Col pair to corresponding key. Errors are indicated
    % with a '?'
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if Row==-1 | Col==-1
        Keyk = '?'; 
    else
        Keyk = KeyMap(Row,Col);
    end;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Step 4: Add current key to overall key list
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Keys = [Keys,Keyk];
        
end;
