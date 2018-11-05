function [MapData,MicroscopeData,EBSD_DataInfo] = nReadHDF5(InputUser)
% nReadHDF5 Builds EBSD data from an HDF5 file
% 
% Same purpose as gen/bReadHDF5, only no MapData are read from the HDF5 file
% and MicroscopeData are read from a plain text file.
% 
% Assumes the HDF5 file is exported from HyperSpy
% (https://github.com/hyperspy/hyperspy/)
%
% Created by Håkon Wiik Ånes (hakon.w.anes@ntnu.no)
% 2018-11-05

% HDF5 file location
InputUser.HDF5FullFile = fullfile(InputUser.HDF5_folder,InputUser.EBSD_File);

% Read microscope data
MicroscopeData = readSettings(InputUser);

% Top Right Z Plus - standard for Bruker Coords - is used in EBSD_Map
% Top Left Z Minus - standard for EDAX TSL Coords
MicroscopeData.CoordSystems='TLZM';

MicroscopeData.TotalTilt = -((90 - MicroscopeData.SampleTilt) + ...
    MicroscopeData.CameraTilt)*pi/180; % Radians

% Set map data
MapData.DD = ones(MicroscopeData.NROWS*MicroscopeData.NCOLS,1)*0.5;
MapData.PCX = ones(MicroscopeData.NROWS*MicroscopeData.NCOLS,1)*0.5;
MapData.PCY = ones(MicroscopeData.NROWS*MicroscopeData.NCOLS,1)*0.5;
MapData.MAD = zeros(MicroscopeData.NROWS*MicroscopeData.NCOLS,1);
MapData.MADPhase = ones(MicroscopeData.NROWS*MicroscopeData.NCOLS,1);
MapData.NIndexedBands = zeros(MicroscopeData.NROWS*MicroscopeData.NCOLS,1);
MapData.phi1 = ones(MicroscopeData.NROWS*MicroscopeData.NCOLS,1);
MapData.PHI = ones(MicroscopeData.NROWS*MicroscopeData.NCOLS,1);
MapData.phi2 = ones(MicroscopeData.NROWS*MicroscopeData.NCOLS,1);
MapData.RadonQuality = zeros(MicroscopeData.NROWS*MicroscopeData.NCOLS,1);
MapData.XBeam = ones(MicroscopeData.NROWS*MicroscopeData.NCOLS,1);
MapData.YBeam = ones(MicroscopeData.NROWS*MicroscopeData.NCOLS,1);
MapData.XSample = ones(MicroscopeData.NROWS*MicroscopeData.NCOLS,1);
MapData.YSample = ones(MicroscopeData.NROWS*MicroscopeData.NCOLS,1);

% XBeam and XSample
XBeamVals = linspace(1,MicroscopeData.NCOLS,MicroscopeData.NCOLS);
XSampleVals = linspace(0,MicroscopeData.XSTEP*(MicroscopeData.NCOLS - 1),...
    MicroscopeData.NCOLS);
j = 0;
for i=1:MicroscopeData.NROWS
    start = j + 1;
    stop = j + MicroscopeData.NCOLS;
    MapData.XBeam(start:stop) = XBeamVals;
    MapData.XSample(start:stop) = XSampleVals;
    j = stop;
end

% YBeam and YSample
j = 0;
for i=1:MicroscopeData.NROWS
    YBeamVals = ones(1,MicroscopeData.NCOLS)*i;
    start = j + 1;
    stop = j + MicroscopeData.NCOLS;
    MapData.YBeam(start:stop) = YBeamVals;
    MapData.YSample(start:stop) = (YBeamVals - 1)*MicroscopeData.YSTEP;
    j = stop;
end

% Read HDF5 info
HDF5_info = h5info(fullfile(InputUser.HDF5_folder,InputUser.EBSD_File),...
    '/Experiments');

% Set up the EBSP reader
EBSD_DataInfo.PatternFile = [HDF5_info.Groups.Name '/data'];
EBSD_DataInfo.PW = double(MicroscopeData.PatternWidth);
EBSD_DataInfo.PH = double(MicroscopeData.PatternHeight);
EBSD_DataInfo.HDF5_loc = fullfile(InputUser.PatternLoc,InputUser.EBSD_File);

end