function EBSP = readEBSP(EBSPData, pattern_number, plugin)
% readEBSP Read an EBSP from a file
%
% This function has to read the EBSD in the correct coordinate system,
% specified by the plugin, or everything else will go wrong!

if strcmpi(plugin, 'nordif')
    EBSP = readEBSPNordif(EBSPData, pattern_number);
else % BCF/HDF5
    EBSP = bReadEBSP(EBSPData, pattern_number);
end

end