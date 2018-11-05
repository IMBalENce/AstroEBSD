%% Input_Deck_HDF5
% Read HDF5 with Kikuchi diffraction patterns
%
% Same as decks/Input_Deck_Fe, only that an arbitrary HDF5 file is read.
%
% Created by Håkon Wiik Ånes (hakon.w.anes@ntnu.no)
% 2018-11-05

clear
home
close all

% Load key folders into the path
Astro_FP = '/path/to/AstroEBSD/';
data_FP = '/path/to/data/';

% Modes:
% * Isolated = single file 
% * Map_Single = single from map
% * Map_All = full map, with area PC search
% * Folder = blind folder
% * hdf5 = Kikuchi diffraction patterns in arbitrary HDF5 file
InputUser.Mode = 'hdf5';

InputUser.PatternLoc = data_FP;
InputUser.PatternPhase = 1; % Phase number for this pattern
InputUser.PCSearch = 1; % Find the pattern centre
InputUser.PatternFlip = 1; % Flip the pattern loaded (single & folder) -
                           % 1 = UD, 2 = LR, 3 = UD + LR

% X and Y positions, in beam coords - for map running
InputUser.OnePatternPosition = [10,10];

% Input folder - note that pwd gives the current directory
InputUser.HDF5_folder = data_FP;
InputUser.EBSD_folder = '';

% Input filename - for map related data (ignored if isolated is selected)
InputUser.EBSD_File = 'Pattern.hdf5';
InputUser.Settings_File = 'Setting.txt';

% Build the phases
InputUser.Phase_Folder = fullfile(Astro_FP,'phases');
InputUser.Phase_Input  = {'Aluminium'};

% Chose the folder for output
InputUser.FolderOut = fullfile(data_FP,'outputs');
InputUser.FileOut = 'astroebsd';
mkdir(InputUser.FolderOut)

% PC search ranges
Settings_PCin.start = [0.41 0.212 0.51];
Settings_PCin.range=[0.05 0.05 0.05]; %+- these values
Settings_PCin.array=[10 10]; % Do not make this array larger than your data!

% Plotting filters - for map data
Settings_PlotFilters.MAE_Thresh=3*pi/180; % Max ok MAE, in radians
Settings_PlotFilters.IQ_Thresh= 0; % Min ok IQ

%% EBSD pattern settings

% Background correction
Settings_Cor.gfilt = 1; % Whether to use Gaussian or not
Settings_Cor.gfilt_s = 7; % Sigma

% Radius mask
Settings_Cor.radius = 1; % Whether to use a radius mask or not
Settings_Cor.radius_frac = 0.65; % Fraction of pattern width to use as mask

% Hot pixel
Settings_Cor.hotpixel = 0; % Whether to use hot pixel correction or not
Settings_Cor.hot_thresh = 200; % Hot pixel threshold

% Resize
Settings_Cor.resize = 0; % Whether to resize patterns or not
Settings_Cor.size = 120; % Pattern width

% Background pattern
bg_file = fullfile(data_FP,'Background acquisition pattern.bmp');
Settings_Cor.RealBG = 1; % Use the one defined just above
Settings_Cor.EBSP_bgnum = 1; % Number of real pattern to use for BG
Settings_Cor.EBSP_bg = ReadEBSDFile(bg_file,InputUser.PatternFlip);

%% Radon searching 

% Peak Finder
Settings_Rad.theta_range = [-10 180 1]; % Theta min, theta max, theta step - in
                                        % degrees
% Peak hunt
Settings_Rad.max_peaks = 10; % Max number of peaks to return
Settings_Rad.num_peak = 15; % Number of peaks to search for - peaks will be
                            % rejected
Settings_Rad.theta_search_pix = 4; % Search size in theta steps
Settings_Rad.rho_search_per = 0.1; % Radon search in fractions
Settings_Rad.min_peak_width = 0.002; % Seperation of the peak width, in pixels

%% Run the code

% Run analysis
Astro_Run;

% Plot data
Astro_Plot;