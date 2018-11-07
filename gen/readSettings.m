function [MicroscopeData] = readSettings(InputUser)
% readSettings Read data from Settings.txt file

settingsFile = fullfile(InputUser.HDF5_folder,InputUser.Settings_File);
text = textread(settingsFile,'%s','delimiter','\n');

%% Specimen
specOccurence = regexp(text,'Specimen');
specRow = find(~cellfun(@isempty,specOccurence));
phaseString = textscan(text{specRow + 1},'%s');
MicroscopeData.Phase = phaseString{1}{2};

%% Microscope
micOccurence = regexp(text,'Microscope');
micRow = find(~cellfun(@isempty,micOccurence));

% Magnification
magString = textscan(text{micRow + 3},'%s');
MicroscopeData.Magnification = str2double(magString{1}{2});

% Acceleration voltage
vString = textscan(text{micRow + 5},'%s');
MicroscopeData.KV = str2double(vString{1}{3})*1e3;

% Working distance
wdString = textscan(text{micRow + 6},'%s');
MicroscopeData.WD = str2double(wdString{1}{3})*1e-3;

% SampleTilt
taString = textscan(text{micRow + 7},'%s');
MicroscopeData.SampleTilt = str2double(taString{1}{3});

% CameraTilt
MicroscopeData.CameraTilt = 0;

%% Acquisition settings
aqsOccurence = regexp(text,'Acquisition settings'); % Find expression
aqsRow = find(~cellfun(@isempty,aqsOccurence)); % Find line number

% Aq. frame rate
aqfrString = textscan(text{aqsRow + 1},'%s');
MicroscopeData.AquisitionFrameRate = str2double(aqfrString{1}{3});

% Pattern height and width (aq. resolution)
aqrString = textscan(text{aqsRow + 2},'%s'); % Read line
aqrString = strsplit(aqrString{1}{2},'x'); % Split relevant part of string
MicroscopeData.PatternWidth = str2double(aqrString{1});
MicroscopeData.PatternHeight = str2double(aqrString{2});

% Aq. exposure time
aqetString = textscan(text{aqsRow + 3},'%s');
MicroscopeData.AquisitionExposureTime = str2double(aqetString{1}{3})*1e-6;

% Aq. gain
aqgString = textscan(text{aqsRow + 4},'%s');
MicroscopeData.AquisitionGain = str2double(aqgString{1}{2});

%% Calibration settings
calsOccurence = regexp(text,'Calibration settings');
calsRow = find(~cellfun(@isempty,calsOccurence));

% Cal. frame rate
calfrString = textscan(text{calsRow + 1},'%s');
MicroscopeData.CalibrationFrameRate = str2double(calfrString{1}{3});

% Cal. resolution
calrString = textscan(text{calsRow + 2},'%s');
MicroscopeData.CalibrationResolution = str2double(calrString{1}{2}(1:3));

% Cal. exposure time
caletString = textscan(text{calsRow + 3},'%s');
MicroscopeData.CalibrationExposureTime = str2double(caletString{1}{3})*1e-6;

% Cal. gain
calgString = textscan(text{calsRow + 4},'%s');
MicroscopeData.CalibrationGain = str2double(calgString{1}{2});

%% Area
areaOccurence = regexp(text,'Area','match');
areaRow = find(~cellfun(@isempty,areaOccurence));

% Number of columns and rows
crString = textscan(text{areaRow + 6},'%s');
crStringInterest = strsplit(crString{1}{4},'x');
MicroscopeData.NCOLS = str2num(crStringInterest{1});
MicroscopeData.NROWS = str2num(crStringInterest{2});

% Number of patterns
MicroscopeData.NPoints = MicroscopeData.NROWS * MicroscopeData.NCOLS;

% XSTEP and YSTEP
stepString = textscan(text{areaRow + 5},'%s');
MicroscopeData.XSTEP = str2double(stepString{1}{3});
MicroscopeData.YSTEP = MicroscopeData.XSTEP;

end