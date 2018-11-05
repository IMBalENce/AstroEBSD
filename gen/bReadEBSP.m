function EBSDPat = bReadEBSP(EBSPData,pattern_number,InputUser,...
    Data_InputMap)
% bReadEBSP Read an EBSP from a HDF5 file
% EBSPData has:
% PatternFile: '/Si_1000x_10um_5_4s/EBSD/Data/RawPatterns'
% PW: 1600
% PH: 1152
% HDF5_loc: 'C:\Users\Benjamin\Documents\Writing\LargeEBSD\Algorithms\Bruker_HDF5\Si_1000x_10um_5_4s.h5'
%
% This function has to read the EBSD in the correct coordinate system (i.e.
% structure of HDF5 file), or everything else will go wrong!

if strcmp(InputUser.Mode,'hdf5')
    
    % Get correct pattern corresponding to pattern_number
    ncols = Data_InputMap.xpts;
    nrows = Data_InputMap.ypts;
    ind = linspace(1,ncols*nrows,ncols*nrows);
    ind = reshape(ind,ncols,nrows)';
    [col,row] = ind2sub(size(ind),find(ind==pattern_number));
    
    EBSDPat = flipud(double(h5read(EBSPData.HDF5_loc,EBSPData.PatternFile,...
        [1 1 row col],[EBSPData.PW EBSPData.PH 1 1]))');
else
    EBSDPat=flipud(double(h5read(EBSPData.HDF5_loc,EBSPData.PatternFile,...
        [1 1 pattern_number],[EBSPData.PW EBSPData.PH 1]))');
end

