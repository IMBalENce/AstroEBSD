# AstroEBSD (modified)

Made it possible to read arbitrary HDF5 files with diffraction patterns. In my case, I have a file from [HyperSpy](https://github.com/hyperspy/hyperspy) with shape (x grid, y grid, x pattern, y pattern), e.g. (100, 100, 120, 120) if I have 100 x 100 patterns of 120 x 120 px.

## New files

#### decks/Input_Deck_HDF5.m

Added new input user mode (hdf5).

#### gen/nReadHDF5.m

Same purpose as `gen/bReadHDF5`, only no `MapData` are read from the HDF5 file and `MicroscopeData` are read from a plain text file. Assumes the HDF5 file is exported from HyperSpy or from Matlab (see my other repository [nordif2hdf5](https://github.com/hwagit/nordif2hdf5)).

#### gen/readSettings.m

Read microscope and pattern acquisition settings from plain text file, written to the `MicroscopeData` structure.

#### phases/Aluminium.pha

Changed name and lattice constants in `Austenite.pha`, otherwise used same values (is this correct?).

## Modified files

#### bin/Astro_EBSPset.m

Uncommented line 338 (`uiwait(f,300)`), so that the radon transform etc. waits for my inputs before executing.

#### bin/Astro_Plot.m

Set the CRange for the MAE plot to take upper value as the one set by the user in `Settings_PlotFilters.MAE_Thresh`.

#### bin/Astro_Run.m

Added mode `hdf5` as a 5th mode. Similar to 'Map_All', but functions for reading data from file are different. No static background subtraction is performed either.

#### bin/EBSP_StaticBG.m

Included `InputUser` structure in input, since `bReadEBSP` now needs it (see below).

#### bin/Map_Radon.m

Added necessary inputs to `bReadEBSP` (see below).

#### gen/bReadEBSP.m

Added functionality for reading patterns from an HDF5 file of shape as mentioned above (from HyperSpy or Matlab). The script then needs to check the mode (needs `InputUser` structure) and the get the pattern's location in the grid (needs `Data_InputMap`). Because of this, I have had to send these in wherever this function is called.

#### start_AstroEBSD.m

Matlab now checks which OS you are running and builds paths accordingly.
