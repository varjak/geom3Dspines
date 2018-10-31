%% MAIN
%  Main script for the spine collector
clear
% close all 
clc
tic
%% Set up constants and paths
Addpaths();
fname = 'ca1_10 apical2.tif';
voxel_measures = [0.0658941, 0.0658941, 0.1186];

% [xmin, xmax; ymin, ymax; zmin, zmax]
crop_matrix_meshcoords = [538, 632;
                          523, 722;
                            1,  25];

% crop_matrix_meshcoords = [538, 700;
%                           523, 722;
%                             1,  25];
                        
% crop_matrix_meshcoords = [1, 700;
%                           200, 600;
%                             1,  46];
                        
%% Preprocessing
% median_stack = Pre_Processing2(fname, voxel_measures);

median_stack_struct = load('total_median_stack.mat');
median_stack = median_stack_struct.median_stack;

% mip = max(median_stack, [], 3);
% figure
% imshow(mip, [])

%% Segmentation - Neurites
% [hessian_stack, vessel_stack] = Segmentation_Neurites(median_stack, voxel_measures);

total_smooth_mask_struct = load('total_smooth_mask.mat');
hessian_stack = total_smooth_mask_struct.total_smooth_mask;

% total_indeces_mask_struct = load('total_indeces_mask');
% hessian_stack = total_indeces_mask_struct.indeces_mask;

Supreme_Jermanness_seg_dil_struct = load('Supreme_Jermanness_seg_dil.mat');
vessel_stack = Supreme_Jermanness_seg_dil_struct.Supreme_Jermanness_seg_dil;

% Supreme_Jermanness= load('total_Supreme_Jermanness.mat');
% vessel2_stack = Supreme_Jermanness.Supreme_Jermanness;
%% Crop (optional)
[median_stack, hessian_stack, vessel_stack] = Crop_Stacks(median_stack, hessian_stack, vessel_stack, crop_matrix_meshcoords);

hessian_stack(200-29+1,51,14) = 0;
hessian_stack(200-29+1,51,15) = 0;

% [~, ~, vessel_stack2] = Crop_Stacks(vessel2_stack, vessel2_stack, vessel2_stack);

% mip = max(median_stack, [], 3);
% figure
% imshow(mip, [])
% 
% figure
% imshow(hessian_stack(:,:,9), [])
% 
% figure
% imshow(vessel_stack(:,:,9), [])
% 
% Auxiliar_Plot(hessian_stack, [1,1,1]);
%% Detection
spine_subs_cell = {};
for k = 1:1
%     spine_subs_cell{k} = Auto_Detection3(hessian_stack, vessel_stack, k);
    % CUIDADO:
%     spine_subs_cell{k} = Auto_Detection3(hessian_stack, vessel_stack, k, median_stack);

end
spine_subs_struct = load('spine_auto_subs_cycle3_pushed.mat');
spine_subs = spine_subs_struct.spine_subs;
%%
[spine_subs] = Crop_Coordinates(spine_subs, crop_matrix_meshcoords);

%%
% vermillion_rgb = [252, 74, 26]/255;
% mask_idxs = find(hessian_stack);
% [mask_rows, mask_cols, mask_zeds] = ind2sub(size(hessian_stack), mask_idxs);
% mask_subs = [mask_rows, mask_cols, mask_zeds];
% 
% z_show_spine = ones(size(spine_subs,1),1).*1;
% figure
% fig_axes3 = axes;
% % plot3(mask_cols2, size(partial_indeces_mask,1)- mask_rows2 +1, mask_zeds2, '.b','markers',5)
% scatter3(mask_cols, size(hessian_stack,1)- mask_rows +1, mask_zeds, 36,[0.60,0.60,0.60], 'filled') % , 'MarkerFaceAlpha',.05 
% hold on
% % Estava descomentado:
% % plot3(branch_subs(:,2), size(partial_indeces_mask,1)- branch_subs(:,1) +1, z_show_branch, 'x', 'Color',[0.3,0.3,0.3],'markers',10, 'LineWidth', 1.7)
% % hold on
% % % plot3(spine_subs_corrected(:,2), size(partial_indeces_mask,1)- spine_subs_corrected(:,1) +1, spine_subs_corrected(:,3), 'x', 'Color', [0    0.8078    0.8196],'markers',20, 'LineWidth', 2)
% % plot3(spine_subs_corrected(:,2), size(partial_indeces_mask,1)- spine_subs_corrected(:,1) +1, z_show_spine, 'x', 'Color', [0    0.8078    0.8196],'markers',10, 'LineWidth', 1.7) %dark turquoise
% % hold on
% 
% % plot3(spine_subs(:,2), size(hessian_stack,1)- spine_subs(:,1) +1, z_show_spine, 'x', 'Color', vermillion_rgb,'markers',10, 'LineWidth', 1.7) %vermillion
% % hold on
% xlabel('x [px.]')
% ylabel('y [px.]')
% zlabel('z [px.]')
% axis equal
% set(fig_axes3, 'Zdir', 'reverse')
% grid off

%% Evaluate Detection

% Evaluate_Detection(spine_subs, median_stack)
% 
% la = 0;

%% Segmentation - Spines
[spine_stack, spine_cell, neck_subs, fig_handle3] = Segmentation_Spines(median_stack, hessian_stack, spine_subs);

%% Evaluation
% Segmentation - Spines

% Evaluate_Segmentation_Spines(spine_stack)



%% Measurement
measurements_table = Measurement(spine_stack, neck_subs, fig_handle3);

disp(measurements_table)

%%
% vermillion_rgb = [252, 74, 26]/255;
% fresh_blue_rgb = [74,189,172]/255;
% sunshine_rgb = [247,183,51]/255;
% clean_gray = [223,220,227]/255;

toc