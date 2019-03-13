%% input_deck_hdf5
% Read HDF5 with Kikuchi diffraction patterns
%
% Same as decks/Input_Deck_Fe, only that an arbitrary HDF5 file is read.
%
% Created by Håkon Wiik Ånes (hakon.w.anes@ntnu.no)
% 2018-11-05

%clear
home
close all


% Load key folders into the path
Astro_FP = '/home/hakon/kode/matlab/AstroEBSD';
data_FP = ['/home/hakon/phd/data/sem/def2_cr90_325c/1000s/2_200/nordif/'...
    'astro_demo'];

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
InputUser.OnePatternPosition = [100, 100];

% Input folder - note that pwd gives the current directory
InputUser.HDF5_folder = data_FP;
InputUser.EBSD_folder = '';

% Input filename - for map related data (ignored if isolated is selected)
InputUser.EBSD_File = 'Pattern_crop_sde.hspy';
InputUser.Settings_File = 'Setting.txt';

% Build the phases
InputUser.Phase_Folder = fullfile(Astro_FP,'phases');
InputUser.Phase_Input  = {'Aluminium'};

% Chose the folder for output
InputUser.FileOut = 'astro_crop_sde_h5';
InputUser.FolderOut = fullfile(data_FP,InputUser.FileOut);
mkdir(InputUser.FolderOut)

% PC search ranges
Settings_PCin.start = [0.42, 0.24, 0.52]; % Initial guess at PC
Settings_PCin.range = [0.05 0.05 0.05]; % Range to search in
Settings_PCin.array = [10 10]; % Do not make this array larger than your data!

% Plotting filters - for map data
Settings_PlotFilters.MAE_Thresh = 3*pi/180; % Max ok MAE, in radians
Settings_PlotFilters.IQ_Thresh = 0; % Min ok IQ

%% EBSD pattern settings

% Background correction
Settings_Cor.gfilt = 0; % Whether to use Gaussian or not
Settings_Cor.gfilt_s = 4; % Sigma

% Radius mask
Settings_Cor.radius = 1; % Whether to use a radius mask or not
Settings_Cor.radius_frac = 0.75; % Fraction of pattern width to use as mask

% Hot pixel
Settings_Cor.hotpixel = 0; % Whether to use hot pixel correction or not
Settings_Cor.hot_thresh = 200; % Hot pixel threshold

% Resize
Settings_Cor.resize = 0; % Whether to resize patterns or not
Settings_Cor.size = 160; % Pattern width

% Background pattern
bg_file = fullfile(data_FP,'Background acquisition pattern.bmp');
Settings_Cor.EBSP_bg = ReadEBSDFile(bg_file,InputUser.PatternFlip);
Settings_Cor.RealBG = 0; % Use the one defined just above
Settings_Cor.EBSP_bgnum = 1; % Number of real pattern to use for BG

%% Radon searching 

% Peak Finder
Settings_Rad.theta_range = [-10 180 1]; % Theta min, theta max, theta step - in
                                        % degrees
% Peak hunt
Settings_Rad.max_peaks = 7; % Maximum number of peaks to return
Settings_Rad.num_peak = 7; % Number of peaks to search for - peaks will be
                            % rejected
Settings_Rad.theta_search_pix = 15; % Search size in theta steps
Settings_Rad.rho_search_per = 0.14; % Radon search in fractions
Settings_Rad.min_peak_width = 0.01; % Seperation of the peak width, in pixels

%% Run the code

% Run analysis
Astro_Run;

% Plot data
Astro_Plot;