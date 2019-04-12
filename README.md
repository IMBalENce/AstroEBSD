# AstroEBSD (modified)

Added a reader of electron backscatter patterns (EBSPs) from the Nordif binary .dat file. To make this work I changed all calls to `bReadEBSP` to a new function `readEBSP` which takes a plugin variable, making sure the correct reader is called. In my case this choice is between the default, BCF/HDF5, or Nordif.

## New files

#### decks/Input_Deck_Nordif.m

Added a new variable `Plugin` to the `InputUser` structure so that AstroEBSD can tell when patterns are to be read from a Nordif binary .dat file or from Bruker's BCF/HDF5 format (default).

#### gen/readEBSP.m

Decides which EBSP reader to call based on the plugin input variable.

#### gen/plugins/nordif/readNordif.m

Same purpose as `gen/bReadHDF5`, only no `MapData` is read from the binary file and `MicroscopeData` is read from the Nordif settings file, `Setting.txt`.

#### gen/plugins/nordif/readNordifSettings.m

Reads microscope and pattern acquisition settings from Nordif's settings file, `Setting.txt` and writes it to the `MicroscopeData` structure.

#### gen/plugins/nordif/readEBSPNordif.m

Reads an EBSP from a NORDIF binary .dat file.

#### phases/Aluminium.pha

Changed name and lattice constants in `Austenite.pha`, otherwise used same values.

## Modified files

#### bin/Astro_EBSPset.m

Removed `TIMEOUT` parameter (equal to 300) in call to `uiwait`, so that the radon transform etc. waits for my inputs before executing. Also fixed an error where the variable `h_check_radius` was set to `Settings_Cor.resize` instead of `Settings_Cor.radius`.

#### bin/Astro_Plot.m

Set the CRange for the MAE plot to take upper value as the one set by the user in `Settings_PlotFilters.MAE_Thresh`.

#### bin/Astro_Run.m

Added checks for plugin (`InputUser.Plugin`) in the `Map_All` cases. Options are `nordif` or `bcf/hdf5` (default). Changed calls from `bReadEBSP` to `readEBSP`. Added a check to see if a static background is to be generated from patterns or if it is already provided by the user from an image file.

#### bin/EBSP_StaticBG.m

Included `InputUser` structure in input parameters, since `readEBSP` needs it.

#### bin/Map_Radon.m

Added necessary inputs to `readEBSP`.

#### start_AstroEBSD.m

Use `fullfile` to create relative paths to different directories upon execution.
