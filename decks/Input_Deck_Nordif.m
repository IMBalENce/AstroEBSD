%% Input_Deck_Nordif
% Read Kikuchi diffraction patterns from a binary NORDIF .dat file
%
% Same as decks/Input_Deck_Fe, only that a binary file is read.
%
% Created by Håkon Wiik Ånes (hakon.w.anes@ntnu.no)
% 2019-03-13

clear
home
close all

% Which file format patterns are to be read from. The idea is to have one
% plugin per vendor/file format.
InputUser.Plugin = 'nordif'; % Alternatives: {'nordif', 'bruker'}
InputUser.Settings_File = 'Setting.txt'; % Assumed to be in same directory as
% the EBSD file (Pattern.dat)

InputUser.Mode = 'Map_Single'; %modes = 
                             %Isolated = single file 
                             %Map_Single = single from map
                             %Map_All = full map, with area PC search
                             %Folder = blind folder

% Load key folders into the path
Astro_FP = '/home/hakon/kode/matlab/AstroEBSD';
data_FP = ['/home/hakon/phd/data/sem/def2_cr90_325c/1000s/2_200/nordif/'...
    'astro_demo/astro_crop2'];
InputUser.PatternLoc = data_FP;
InputUser.PatternPhase = 1; % phase number for this pattern
InputUser.PCSearch = 1; % find the pattern centre - for single patterns
InputUser.PatternFlip = 1; % flip the pattern loaded (single & folder)...
% - 1 = UD, 2 = LR, 3 = UD + LR

InputUser.OnePatternPosition=[10 10]; % (X, Y) positions, in beam coords...
% - for map running

% Input filename - for map related data (ignored if isolated is selected)
InputUser.EBSD_File = 'Pattern_crop2.dat';
% Input folder - note that pwd gives the current directory
InputUser.HDF5_folder = data_FP;
InputUser.BCF_folder = '';

% Build the phases
InputUser.Phase_Folder = fullfile(Astro_FP, 'phases');
InputUser.Phase_Input = {'Aluminium'};
% Chose the folder for output
InputUser.FileOut = 'AstroEBSD';
InputUser.FolderOut = fullfile(data_FP);
mkdir(InputUser.FolderOut);

% PC search ranges
Settings_PCin.start = [0.42 0.22 0.52]; % [PCx, PCy, PCz]
Settings_PCin.range = [0.05 0.05 0.05]; % +- these values
Settings_PCin.array = [5 5]; % [#X, #Y] points extracted from map - will...
% fit a PC to these points & then fit a plane

% Plotting filters - for map data
Settings_PlotFilters.MAE_Thresh = 3*pi/180; % Max ok MAE, in radians
Settings_PlotFilters.IQ_Thresh = 0; % Min ok IQ

%% EBSD pattern settings

% Dynamic background correction
Settings_Cor.gfilt = 1; % Whether to subtract a Gaussian blurred pattern or not
Settings_Cor.gfilt_s = 4; % Gaussian filter sigma

% Radius mask
Settings_Cor.radius = 1; % Whether to use a radius mask or not
Settings_Cor.radius_frac = 0.75; % Fraction of pattern width to use as mask

% Hot pixel
Settings_Cor.hotpixel = 0; % Whether to correct hot pixels or not
Settings_Cor.hot_thresh = 1000; % Hot pixel threshold

% Resize
Settings_Cor.resize = 0; % Whether to resize patterns or not
Settings_Cor.size = 160; % Pattern width

% Static background correction
Settings_Cor.RealBG = 1; % Whether to subtract a static background or not
bg_file = fullfile(data_FP, 'Background acquisition pattern.bmp');
Settings_Cor.EBSP_bg = ReadEBSDFile(bg_file, InputUser.PatternFlip);
Settings_Cor.EBSP_bgnum = 10; % Number of real patterns to create static...
% background from

%Settings_Cor.SplitBG = 1; % ?

%% Radon searching 

% Peak Finder
Settings_Rad.theta_range = [-10 180 1]; % theta [min, max, step] in degrees

% Peak hunt
Settings_Rad.max_peaks = 7; % Max number of peaks to return
Settings_Rad.num_peak = 7; % Number of peaks to search for - peaks will be...
% rejected
Settings_Rad.theta_search_pix = 15; % Search size in theta steps
Settings_Rad.rho_search_per = 0.14; % Radon search in fractions
Settings_Rad.min_peak_width = 0.01; % Seperation of the peak width, in pixels

%% Run the code

% Load key folders into the path
Init_currentdir = cd;
Init_astroloc = strfind(Init_currentdir, 'AstroEBSD');
Init_path = Init_currentdir(1:Init_astroloc + 8);
% Check that we are in a subfolder
addpath(Init_path);
clear Init*

InputUser.DeckPath = mfilename('fullpath'); % Obtain the deck path

% Run the analysis code
Astro_Run;

% Plot data
Astro_Plot;