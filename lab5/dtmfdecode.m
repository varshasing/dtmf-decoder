function [Row,Col] = dtmfdecode(sKey,hRows,hCols,Fs)
% [Row,Col] = dtmfdecode(sKey,hRows,hCols,Fs)
%
% sKey  : Vector containing the time domain signal corresponding to a
%         single phone pad key. 
% hRows : N X 4 matrix containing the N point bandpass filters for the row
%         tones with center frequencies [697Hz 770Hz 852Hz 941Hz]. Each
%         column of hRows corresponds on one filter so that column k of
%         hRows corresponds to the filter for keypad row k. For example,
%         hRows(:,1) is the filter with center frequency 697Hz.  
% hCols : N X 3 matrix containing the N point bandpass filters for the
%         column tones with center frequencies [1209Hz 1336Hz 1477Hz
%         1633Hz]. Each column of hCols corresponds on one filter so that
%         column k of hCols corresponds to the filter for keypad column k.
%         For example, hCols(:,2) is the filter with center frequency
%         1336Hz.  
% Fs    : The sample rate in samples per second or Hertz. OPTIONAL
%         Default: Fs = 8192;
%
% Row   : Index of detected row (1,2,3, or 4). If no row or multiple rows
%         are detected, then Row=-1 to indicate an error condition.
% Col   : Index of detected column (1,2, or 3). If no column or multiple
%         columns are detected, then Col=-1 to indicate an error condition.
%
% This program takes an isolated key segment signal in sKey together with a
% set of bandpass filter impulse responses in hRows and hCols and detects
% and returns the row and column indes that the singal in sKey corresponds
% to. If no or more than one row or column is detected, then a -1 is
% returned.  

% W. C. Karl SC401 Fall06

% Set defaults
if nargin < 2
    Fs = 8192;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract row and column filters from the input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract individual row filters
hRow1 = hRows(:,1);
hRow2 = hRows(:,2);
hRow3 = hRows(:,3);
hRow4 = hRows(:,4);

% Extract individual column filters
hCol1 = hCols(:,1);
hCol2 = hCols(:,2);
hCol3 = hCols(:,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detect presence of tone in at each row frequency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Score sKey against each row frequency
scoreRow1 = dtmfdetect(sKey,hRow1,Fs);
scoreRow2 = dtmfdetect(sKey,hRow2,Fs);
scoreRow3 = dtmfdetect(sKey,hRow3,Fs);
scoreRow4 = dtmfdetect(sKey,hRow4,Fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detect presence of tone in at each column frequency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Score sKey against each Column
scoreCol1 = dtmfdetect(sKey,hCol1,Fs);
scoreCol2 = dtmfdetect(sKey,hCol2,Fs);
scoreCol3 = dtmfdetect(sKey,hCol3,Fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decode row detections into a row index
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Now convert row detection scores to a row index. If only one row score is
% 1, then job is simple. If more than one or none are 1, then we have an
% error and set a "-1" to indicate it. 
TotalRowDetections = scoreRow1 + scoreRow2 + scoreRow3 + scoreRow4;
if TotalRowDetections ~=1; 
    % Error state: Total number of detections is not = 1
    Row = -1;
else;
    % Normal case: set row index
    Row = find([...
        scoreRow1;
        scoreRow2;
        scoreRow3;
        scoreRow4]);
end;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decode column detections into a column index
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Now convert column detection scores to a column index. If only one column
% score is 1, then job is simple. If more than one or none are 1, then we
% have an error and set a "-1" to indicate it. 
TotalColDetections = scoreCol1 + scoreCol2 + scoreCol3;
if TotalColDetections ~=1;
     % Error state: Total number of detections is not = 1
     Col = -1;
else;
   % Normal case: set row index
    Col = find([...
        scoreCol1;
        scoreCol2;
        scoreCol3]);
end;
