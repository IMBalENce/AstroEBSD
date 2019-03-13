function EBSP = readEBSPNordif(EBSPData, pattern_number)
% readEBSPNordif Read an EBSP from a NORDIF binary .dat file
%
% This function has to read the EBSD in the correct coordinate system (i.e.
% structure of binary file), or everything else will go wrong!

% Set up reading parameters
pat_shape = [EBSPData.PW, EBSPData.PH];
nskip = (pattern_number - 1) * pat_shape(1) * pat_shape(2);
precision = 'uint8';
    
% Read pattern
fid = fopen(EBSPData.HDF5_loc, 'r');
fseek(fid, nskip, 'bof');
EBSP = fread(fid, pat_shape, precision);
EBSP = flipud(EBSP');
frewind(fid);
fclose(fid);

end