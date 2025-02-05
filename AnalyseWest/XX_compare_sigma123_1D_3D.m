clc; clear;

% Define file paths
files = {
    'West_Before_AllV2_Output.mat', 'West_Before_All3D_Output3D.mat';
    'West_During_AllV2_Output.mat', 'West_During_All3D_Output3D.mat';
    'West_After_AllV2_Output.mat', 'West_After_All3D_Output3D.mat'
};

% Base path
base_path = '/Users/mczhang/Documents/GitHub/stressinverse_1.1.3/Output/';

% Loop through each case
for i = 1:size(files, 1)
    % Load 1D and 3D data
    load(fullfile(base_path, files{i, 1})); % 1D file
    sigma_11D = sigma_1; clear sigma_1;
    sigma_2_1D = sigma_2;
    sigma_3_1D = sigma_3;
    shape_ratio_1D = shape_ratio;
    principal_mechanisms_1D = principal_mechanisms;
    
    load(fullfile(base_path, files{i, 2})); % 3D file
    sigma_13D = sigma_1;
    sigma_2_3D = sigma_2;
    sigma_3_3D = sigma_3;
    shape_ratio_3D = shape_ratio;
    principal_mechanisms_3D = principal_mechanisms;
    
    % Compute differences
    azimuth_diff = sigma_11D.azimuth - sigma_13D.azimuth;
    plunge_diff = sigma_11D.plunge - sigma_13D.plunge;

    sigma_2_azimuth_diff = sigma_2_1D.azimuth - sigma_2_3D.azimuth;
    sigma_2_plunge_diff = sigma_2_1D.plunge - sigma_2_3D.plunge;

    sigma_3_azimuth_diff = sigma_3_1D.azimuth - sigma_3_3D.azimuth;
    sigma_3_plunge_diff = sigma_3_1D.plunge - sigma_3_3D.plunge;

    shape_ratio_diff = shape_ratio_1D - shape_ratio_3D;
    [principal_mechanisms_diff,theta,phi]=kagan([principal_mechanisms_1D.strike(1),principal_mechanisms_1D.dip(1),principal_mechanisms_1D.rake(1)], ...
    [principal_mechanisms_3D.strike(1),principal_mechanisms_3D.dip(1),principal_mechanisms_3D.rake(1)]);


    % Display results for the current case
    fprintf('==== Comparison for %s and %s ====\n', files{i, 1}, files{i, 2});
    fprintf('Azimuth difference for sigma_1: %f\n', azimuth_diff);
    fprintf('Plunge difference for sigma_1: %f\n', plunge_diff);

    fprintf('Azimuth difference for sigma_2: %f\n', sigma_2_azimuth_diff);
    fprintf('Plunge difference for sigma_2: %f\n', sigma_2_plunge_diff);

    fprintf('Azimuth difference for sigma_3: %f\n', sigma_3_azimuth_diff);
    fprintf('Plunge difference for sigma_3: %f\n', sigma_3_plunge_diff);

    fprintf('Shape ratio difference: %f\n', shape_ratio_diff);
    disp('Principal mechanisms difference:');
    disp(principal_mechanisms_diff);
end