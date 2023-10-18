function distanceCellEdge

% USE imEdgeTracker

img2 = imread('H:\alex\AlexData\cell_mask\mask_EB1-GFP-5001.tif');
% img2 = imread('H:\alex\AlexData\Torsten\trichostatinA\1uM_TSA\cell1\cell_mask\mask_1um_tsa_#6_t01.tif');
% img2 = imread('D:\Dmitri\set1\cell_mask\mask_Nontg AstrocytesLysotracker-Red Hoesct-Image Export-01.tif');
% img2 = imread('D:\Dmitri\set2\cell_mask\mask_NontsAstrocytesLysotracker-RedHoesct-02-Image Export-01.tif');

% generate the distance map from the mask
distance_image = bwdist(~img2);

figure, imshow(distance_image,[])
%generate regions bands
res_image = zeros(size(distance_image));
% get the number of bands
nr_bands = floor(max(distance_image(:)) / band_width) - 3;
if nr_bands > nr_user_bands & nr_user_bands ~= 0
    nr_bands = nr_user_bands;
end