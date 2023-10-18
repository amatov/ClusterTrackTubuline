function batchParseGroup

% parseGroups('X:\AlexData11\786O\786Oparental\071018_786-Opar_01\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071018_786-Opar_02\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071018_786-Opar_03\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071018_786-Opar_04\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071018_786-Opar_05\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071018_786-Opar_06\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071018_786-Opar_07\images\');% good figure
% parseGroups('X:\AlexData11\786O\786Oparental\071018_786-Opar_08\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071018_786-Opar_09\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071018_786-Opar_10\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071018_786-Opar_11\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071018_786-Opar_12\images\');
% 
% parseGroups('X:\AlexData11\786O\786Oparental\071019_786-Opar_01\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071019_786-Opar_02\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071019_786-Opar_03\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071019_786-Opar_04\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071019_786-Opar_05\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071019_786-Opar_06\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071019_786-Opar_07\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071019_786-Opar_08\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071019_786-Opar_09\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071019_786-Opar_10\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071019_786-Opar_11\images\');
% parseGroups('X:\AlexData11\786O\786Oparental\071019_786-Opar_12\images\');
% 
% parseGroups('X:\AlexData11\786O\786OVHL\071018_786-OVHL30_01\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071018_786-OVHL30_02\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071018_786-OVHL30_03\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071018_786-OVHL30_04\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071018_786-OVHL30_05\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071018_786-OVHL30_06\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\786O\786OVHL\071018_786-OVHL30_07\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071018_786-OVHL30_08\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071018_786-OVHL30_09\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071018_786-OVHL30_10\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071018_786-OVHL30_11\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071018_786-OVHL30_12\images\');
% 
% parseGroups('X:\AlexData11\786O\786OVHL\071019_786-OVHL30_01\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071019_786-OVHL30_02\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\786O\786OVHL\071019_786-OVHL30_03\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071019_786-OVHL30_04\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071019_786-OVHL30_05\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071019_786-OVHL30_06\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071019_786-OVHL30_07\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071019_786-OVHL30_08\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071019_786-OVHL30_09\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\786O\786OVHL\071019_786-OVHL30_10\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071019_786-OVHL30_11\images\');
% parseGroups('X:\AlexData11\786O\786OVHL\071019_786-OVHL30_12\images\');
% -----------------------------------------------------------------------

% parseGroups('X:\AlexData11\RPE1\RPE1-ns\060922_RPE1-LMPns_01\images\');NOT
% parseGroups('X:\AlexData11\RPE1\RPE1-ns\060922_RPE1-LMPns_02\images\');NOT
%---
% parseGroups('X:\AlexData11\RPE1\RPE1-ns\060922_RPE1-LMPns_03\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns\060922_RPE1-LMPns_04\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns\060922_RPE1-LMPns_05\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns\060922_RPE1-LMPns_06\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RPE1\RPE1-ns\060922_RPE1-LMPns_07\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns\060922_RPE1-LMPns_08\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns\060922_RPE1-LMPns_09\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns\060922_RPE1-LMPns_11\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RPE1\RPE1-ns\060922_RPE1-LMPns_12\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RPE1\RPE1-ns\060922_RPE1-LMPns_13\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns\060922_RPE1-LMPns_14\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns\060922_RPE1-LMPns_15\images\');
% 
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_DMSO\RPE1-ns_SS_DMSO_01\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_DMSO\RPE1-ns_SS_DMSO_02\images\'); 
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_DMSO\RPE1-ns_SS_DMSO_03\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_DMSO\RPE1-ns_SS_DMSO_04\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_DMSO\RPE1-ns_SS_DMSO_05\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_DMSO\RPE1-ns_SS_DMSO_06\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_DMSO\RPE1-ns_SS_DMSO_07\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_DMSO\RPE1-ns_SS_DMSO_08\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_DMSO\RPE1-ns_SS_DMSO_09\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_DMSO\RPE1-ns_SS_DMSO_10\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_DMSO\RPE1-ns_SS_DMSO_11\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_DMSO\RPE1-ns_SS_DMSO_12\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_DMSO\RPE1-ns_SS_DMSO_13\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_DMSO\RPE1-ns_SS_DMSO_14\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_DMSO\RPE1-ns_SS_DMSO_15\images\');
% 
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_InhVIII\RPE1-ns_SS_InhVIII_01\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_InhVIII\RPE1-ns_SS_InhVIII_02\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_InhVIII\RPE1-ns_SS_InhVIII_03\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_InhVIII\RPE1-ns_SS_InhVIII_04\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_InhVIII\RPE1-ns_SS_InhVIII_05\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_InhVIII\RPE1-ns_SS_InhVIII_06\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_InhVIII\RPE1-ns_SS_InhVIII_07\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_InhVIII\RPE1-ns_SS_InhVIII_08\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_InhVIII\RPE1-ns_SS_InhVIII_09\images\');
% % parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_InhVIII\RPE1-ns_SS_InhVIII_10\images\');%no tracks
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_InhVIII\RPE1-ns_SS_InhVIII_11\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_InhVIII\RPE1-ns_SS_InhVIII_12\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_InhVIII\RPE1-ns_SS_InhVIII_13\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_InhVIII\RPE1-ns_SS_InhVIII_14\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-ns_SS_InhVIII\RPE1-ns_SS_InhVIII_15\images\');  
% 
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL\060922_RPE1-LMPshVHL_01\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL\060922_RPE1-LMPshVHL_02\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL\060922_RPE1-LMPshVHL_03\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL\060922_RPE1-LMPshVHL_04\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL\060922_RPE1-LMPshVHL_05\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL\060922_RPE1-LMPshVHL_08\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL\060922_RPE1-LMPshVHL_09\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL\060922_RPE1-LMPshVHL_10\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL\060922_RPE1-LMPshVHL_11\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL\060922_RPE1-LMPshVHL_12\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL\060922_RPE1-LMPshVHL_13\images\');  	
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL\060922_RPE1-LMPshVHL_14\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL\060922_RPE1-LMPshVHL_15\images\');
% 
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_DMSO\RPE1-shVHL_SS_DMSO_01\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_DMSO\RPE1-shVHL_SS_DMSO_02\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_DMSO\RPE1-shVHL_SS_DMSO_03\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_DMSO\RPE1-shVHL_SS_DMSO_04\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_DMSO\RPE1-shVHL_SS_DMSO_05\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_DMSO\RPE1-shVHL_SS_DMSO_06\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_DMSO\RPE1-shVHL_SS_DMSO_07\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_DMSO\RPE1-shVHL_SS_DMSO_08\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_DMSO\RPE1-shVHL_SS_DMSO_09\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_DMSO\RPE1-shVHL_SS_DMSO_10\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_DMSO\RPE1-shVHL_SS_DMSO_11\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_DMSO\RPE1-shVHL_SS_DMSO_12\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_DMSO\RPE1-shVHL_SS_DMSO_13\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_DMSO\RPE1-shVHL_SS_DMSO_14\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_DMSO\RPE1-shVHL_SS_DMSO_15\images\');
% 
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_InhVIII\RPE1-shVHL_SS_InhVIII_01\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_InhVIII\RPE1-shVHL_SS_InhVIII_02\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_InhVIII\RPE1-shVHL_SS_InhVIII_03\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_InhVIII\RPE1-shVHL_SS_InhVIII_04\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_InhVIII\RPE1-shVHL_SS_InhVIII_05\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_InhVIII\RPE1-shVHL_SS_InhVIII_06\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_InhVIII\RPE1-shVHL_SS_InhVIII_07\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_InhVIII\RPE1-shVHL_SS_InhVIII_08\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_InhVIII\RPE1-shVHL_SS_InhVIII_09\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_InhVIII\RPE1-shVHL_SS_InhVIII_10\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_InhVIII\RPE1-shVHL_SS_InhVIII_11\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_InhVIII\RPE1-shVHL_SS_InhVIII_12\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_InhVIII\RPE1-shVHL_SS_InhVIII_13\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_InhVIII\RPE1-shVHL_SS_InhVIII_14\images\');
% parseGroups('X:\AlexData11\RPE1\RPE1-shVHL_SS_InhVIII\RPE1-shVHL_SS_InhVIII_15\images\');
% 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_14\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_15\images\');
% 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060829_RCC4-CMV93-LMP_01\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060829_RCC4-CMV93-LMP_04\images\'); %BUG%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060829_RCC4-CMV93-LMP_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060829_RCC4-CMV93-LMP_07\images\'); % High Perc% of 3+tracks in group
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060829_RCC4-CMV93-LMP_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060829_RCC4-CMV93-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060831_RCC4-CMV93-LMP_12\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060831_RCC4-CMV93-LMP_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060831_RCC4-CMV93-LMP_14\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060831_RCC4-CMV93-LMP_15\images\');
% 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV94(VHL19)\060912_RCC4-CMV94-LMP_01\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV94(VHL19)\060912_RCC4-CMV94-LMP_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV94(VHL19)\060912_RCC4-CMV94-LMP_03\images\'); % Low Perc% of 3+ tracks in group
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV94(VHL19)\060912_RCC4-CMV94-LMP_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV94(VHL19)\060912_RCC4-CMV94-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV94(VHL19)\060912_RCC4-CMV94-LMP_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV94(VHL19)\060912_RCC4-CMV94-LMP_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV94(VHL19)\060912_RCC4-CMV94-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV94(VHL19)\060912_RCC4-CMV94-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV94(VHL19)\060912_RCC4-CMV94-LMP_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV94(VHL19)\060912_RCC4-CMV94-LMP_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV94(VHL19)\060912_RCC4-CMV94-LMP_15\images\');
% 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV97(Y98H)\060824_RCC4-CMV97-LMP_02\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV97(Y98H)\060824_RCC4-CMV97-LMP_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV97(Y98H)\060824_RCC4-CMV97-LMP_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV97(Y98H)\060824_RCC4-CMV97-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV97(Y98H)\060824_RCC4-CMV97-LMP_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV97(Y98H)\060824_RCC4-CMV97-LMP_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV97(Y98H)\060824_RCC4-CMV97-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV97(Y98H)\060824_RCC4-CMV97-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV97(Y98H)\060830_RCC4-CMV97-LMP_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV97(Y98H)\060830_RCC4-CMV97-LMP_14\images\');
% % 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV98(Y98N)\060830_RCC4-CMV98-LMP_01\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV98(Y98N)\060830_RCC4-CMV98-LMP_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV98(Y98N)\060830_RCC4-CMV98-LMP_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV98(Y98N)\060830_RCC4-CMV98-LMP_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV98(Y98N)\060830_RCC4-CMV98-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV98(Y98N)\060830_RCC4-CMV98-LMP_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV98(Y98N)\060830_RCC4-CMV98-LMP_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV98(Y98N)\060830_RCC4-CMV98-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV98(Y98N)\060830_RCC4-CMV98-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV98(Y98N)\060830_RCC4-CMV98-LMP_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV98(Y98N)\060830_RCC4-CMV98-LMP_12\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV98(Y98N)\060830_RCC4-CMV98-LMP_15\images\');
% 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp1\060831_RCC4-CMV99-LMP_01\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp1\060831_RCC4-CMV99-LMP_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp1\060831_RCC4-CMV99-LMP_03\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp1\060831_RCC4-CMV99-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp1\060831_RCC4-CMV99-LMP_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp1\060831_RCC4-CMV99-LMP_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp1\060831_RCC4-CMV99-LMP_08\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp1\060831_RCC4-CMV99-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp1\060831_RCC4-CMV99-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp1\060831_RCC4-CMV99-LMP_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp1\060831_RCC4-CMV99-LMP_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp1\060831_RCC4-CMV99-LMP_14\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp1\060831_RCC4-CMV99-LMP_15\images\');
% 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp2\070508_RCC4-CMV99-LMP_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp2\070508_RCC4-CMV99-LMP_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp2\070508_RCC4-CMV99-LMP_04\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp2\070508_RCC4-CMV99-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp2\070508_RCC4-CMV99-LMP_06\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp2\070508_RCC4-CMV99-LMP_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp2\070508_RCC4-CMV99-LMP_08\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp2\070508_RCC4-CMV99-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp2\070508_RCC4-CMV99-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp2\070508_RCC4-CMV99-LMP_12\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp2\070508_RCC4-CMV99-LMP_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp2\070508_RCC4-CMV99-LMP_14\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV99(Y112H)exp2\070508_RCC4-CMV99-LMP_15\images\');
% 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp1\060908_RCC4-CMV100-LMP_01\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp1\060908_RCC4-CMV100-LMP_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp1\060908_RCC4-CMV100-LMP_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp1\060908_RCC4-CMV100-LMP_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp1\060908_RCC4-CMV100-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp1\060908_RCC4-CMV100-LMP_06\images\'); %BUG%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp1\060908_RCC4-CMV100-LMP_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp1\060908_RCC4-CMV100-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp1\060908_RCC4-CMV100-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp1\060908_RCC4-CMV100-LMP_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp1\060908_RCC4-CMV100-LMP_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp1\060912_RCC4-CMV100-LMP_14\images\'); 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp1\060912_RCC4-CMV100-LMP_15\images\');
% 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp2\070508_RCC4-CMV100-LMP_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp2\070508_RCC4-CMV100-LMP_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp2\070508_RCC4-CMV100-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp2\070508_RCC4-CMV100-LMP_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp2\070508_RCC4-CMV100-LMP_07\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp2\070508_RCC4-CMV100-LMP_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp2\070508_RCC4-CMV100-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp2\070508_RCC4-CMV100-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp2\070508_RCC4-CMV100-LMP_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV100(Y112N)exp2\070508_RCC4-CMV100-LMP_15\images\');%BUG%GROUPING BUG
% 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV101(R161P)\061010_RCC4-CMV101-LMP_01\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV101(R161P)\061010_RCC4-CMV101-LMP_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV101(R161P)\061010_RCC4-CMV101-LMP_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV101(R161P)\061010_RCC4-CMV101-LMP_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV101(R161P)\061010_RCC4-CMV101-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV101(R161P)\061010_RCC4-CMV101-LMP_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV101(R161P)\061010_RCC4-CMV101-LMP_08\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV101(R161P)\061010_RCC4-CMV101-LMP_09\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV101(R161P)\061010_RCC4-CMV101-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV101(R161P)\061010_RCC4-CMV101-LMP_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV101(R161P)\061010_RCC4-CMV101-LMP_12\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV101(R161P)\061010_RCC4-CMV101-LMP_13\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV101(R161P)\061010_RCC4-CMV101-LMP_14\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV101(R161P)\061010_RCC4-CMV101-LMP_15\images\');
% % 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV102(R167W)\060912_RCC4-CMV102-LMP_01\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV102(R167W)\060912_RCC4-CMV102-LMP_02\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV102(R167W)\060912_RCC4-CMV102-LMP_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV102(R167W)\060912_RCC4-CMV102-LMP_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV102(R167W)\060912_RCC4-CMV102-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV102(R167W)\060912_RCC4-CMV102-LMP_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV102(R167W)\060912_RCC4-CMV102-LMP_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV102(R167W)\060912_RCC4-CMV102-LMP_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV102(R167W)\060912_RCC4-CMV102-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV102(R167W)\060912_RCC4-CMV102-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV102(R167W)\060912_RCC4-CMV102-LMP_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV102(R167W)\060912_RCC4-CMV102-LMP_12\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV102(R167W)\060912_RCC4-CMV102-LMP_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV102(R167W)\060912_RCC4-CMV102-LMP_14\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV102(R167W)\060912_RCC4-CMV102-LMP_15\images\');
% 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp1\060914_RCC4-CMV107-LMP_01\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp1\060914_RCC4-CMV107-LMP_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp1\060914_RCC4-CMV107-LMP_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp1\060914_RCC4-CMV107-LMP_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp1\060914_RCC4-CMV107-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp1\060914_RCC4-CMV107-LMP_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp1\060914_RCC4-CMV107-LMP_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp1\060914_RCC4-CMV107-LMP_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp1\060914_RCC4-CMV107-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp1\060914_RCC4-CMV107-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp1\060914_RCC4-CMV107-LMP_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp1\060914_RCC4-CMV107-LMP_12\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp1\060914_RCC4-CMV107-LMP_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp1\060914_RCC4-CMV107-LMP_14\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp1\060914_RCC4-CMV107-LMP_15\images\');
% 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp2\061108_RCC4-CMV107-LMP_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp2\061108_RCC4-CMV107-LMP_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp2\061108_RCC4-CMV107-LMP_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp2\061108_RCC4-CMV107-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp2\061108_RCC4-CMV107-LMP_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp2\061108_RCC4-CMV107-LMP_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp2\061108_RCC4-CMV107-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp2\061108_RCC4-CMV107-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp2\061108_RCC4-CMV107-LMP_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp2\061108_RCC4-CMV107-LMP_12\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp2\061108_RCC4-CMV107-LMP_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp2\061108_RCC4-CMV107-LMP_14\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV107(S68_72D)exp2\061108_RCC4-CMV107-LMP_15\images\');

% exp2 - NO
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp1\060908_RCC4-CMV108-LMP_01\images\');NO
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp1\060908_RCC4-CMV108-LMP_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp1\060908_RCC4-CMV108-LMP_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp1\060908_RCC4-CMV108-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp1\060908_RCC4-CMV108-LMP_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp1\060908_RCC4-CMV108-LMP_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp1\060908_RCC4-CMV108-LMP_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp1\060908_RCC4-CMV108-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp1\060908_RCC4-CMV108-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp1\060908_RCC4-CMV108-LMP_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp1\060908_RCC4-CMV108-LMP_12\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp1\060908_RCC4-CMV108-LMP_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp1\060908_RCC4-CMV108-LMP_14\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp1\060908_RCC4-CMV108-LMP_15\images\');

% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp2\061108_RCC4-CMV108-LMP_01\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp2\061108_RCC4-CMV108-LMP_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp2\061108_RCC4-CMV108-LMP_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp2\061108_RCC4-CMV108-LMP_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp2\061108_RCC4-CMV108-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp2\061108_RCC4-CMV108-LMP_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp2\061108_RCC4-CMV108-LMP_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp2\061108_RCC4-CMV108-LMP_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp2\061108_RCC4-CMV108-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp2\061108_RCC4-CMV108-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp2\061108_RCC4-CMV108-LMP_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp2\061108_RCC4-CMV108-LMP_12\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp2\061108_RCC4-CMV108-LMP_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp2\061108_RCC4-CMV108-LMP_14\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp2\061108_RCC4-CMV108-LMP_15\images\');
% 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp3\080112_RCC4_CMV108_01\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp3\080112_RCC4_CMV108_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp3\080112_RCC4_CMV108_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp3\080112_RCC4_CMV108_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp3\080112_RCC4_CMV108_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp3\080112_RCC4_CMV108_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp3\080112_RCC4_CMV108_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp3\080112_RCC4_CMV108_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp3\080112_RCC4_CMV108_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp3\080112_RCC4_CMV108_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp3\080112_RCC4_CMV108_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp3\080112_RCC4_CMV108_12\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp3\080112_RCC4_CMV108_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp3\080112_RCC4_CMV108_14\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV108(S68_72A)exp3\080112_RCC4_CMV108_15\images\');
% 
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_12\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_14\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_15\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_16\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_17\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_18\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_19\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_20\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_21\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_22\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_23\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-CMV109(d95-123)\080113_RCC4_CMV109_24\images\');

% exp1 - NO
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp1\070515_RCC4-pBabeneo-empty_01\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp1\070515_RCC4-pBabeneo-empty_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp1\070515_RCC4-pBabeneo-empty_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp1\070515_RCC4-pBabeneo-empty_04\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp1\070515_RCC4-pBabeneo-empty_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp1\070515_RCC4-pBabeneo-empty_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp1\070515_RCC4-pBabeneo-empty_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp1\070515_RCC4-pBabeneo-empty_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp1\070515_RCC4-pBabeneo-empty_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp1\070515_RCC4-pBabeneo-empty_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp1\070515_RCC4-pBabeneo-empty_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp1\070515_RCC4-pBabeneo-empty_12\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp1\070515_RCC4-pBabeneo-empty_13\images\');%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp1\070515_RCC4-pBabeneo-empty_15\images\');

% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe22(R64P)\070515_RCC4-pBabeneo22_01\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe22(R64P)\070515_RCC4-pBabeneo22_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe22(R64P)\070515_RCC4-pBabeneo22_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe22(R64P)\070515_RCC4-pBabeneo22_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe22(R64P)\070515_RCC4-pBabeneo22_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe22(R64P)\070515_RCC4-pBabeneo22_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe22(R64P)\070515_RCC4-pBabeneo22_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe22(R64P)\070515_RCC4-pBabeneo22_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe22(R64P)\070515_RCC4-pBabeneo22_12\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe22(R64P)\070515_RCC4-pBabeneo22_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe22(R64P)\070515_RCC4-pBabeneo22_15\images\');

% %exp2 - NO
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp2\070607_RCC4-pBabeempty-LMP_01\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp2\070607_RCC4-pBabeempty-LMP_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp2\070607_RCC4-pBabeempty-LMP_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp2\070607_RCC4-pBabeempty-LMP_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp2\070607_RCC4-pBabeempty-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp2\070607_RCC4-pBabeempty-LMP_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp2\070607_RCC4-pBabeempty-LMP_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp2\070607_RCC4-pBabeempty-LMP_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp2\070607_RCC4-pBabeempty-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp2\070607_RCC4-pBabeempty-LMP_10\images\');

% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp3\070607_RCC4-pBabeempty-LMPns_01\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp3\070607_RCC4-pBabeempty-LMPns_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp3\070607_RCC4-pBabeempty-LMPns_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp3\070607_RCC4-pBabeempty-LMPns_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp3\070607_RCC4-pBabeempty-LMPns_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp3\070607_RCC4-pBabeempty-LMPns_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp3\070607_RCC4-pBabeempty-LMPns_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp3\070607_RCC4-pBabeempty-LMPns_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp3\070607_RCC4-pBabeempty-LMPns_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe00(empty)exp3\070607_RCC4-pBabeempty-LMPns_10\images\');
% 
% 
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe24(N78S)\070515_RCC4-pBabeneo24_01\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe24(N78S)\070515_RCC4-pBabeneo24_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe24(N78S)\070515_RCC4-pBabeneo24_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe24(N78S)\070515_RCC4-pBabeneo24_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe24(N78S)\070515_RCC4-pBabeneo24_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe24(N78S)\070515_RCC4-pBabeneo24_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe24(N78S)\070515_RCC4-pBabeneo24_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe24(N78S)\070515_RCC4-pBabeneo24_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe24(N78S)\070515_RCC4-pBabeneo24_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe24(N78S)\070515_RCC4-pBabeneo24_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe24(N78S)\070515_RCC4-pBabeneo24_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe24(N78S)\070515_RCC4-pBabeneo24_12\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe24(N78S)\070515_RCC4-pBabeneo24_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe24(N78S)\070515_RCC4-pBabeneo24_14\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe24(N78S)\070515_RCC4-pBabeneo24_15\images\');
% 
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe36(G114S)\070516_RCC4-pBabeneo36-LMP_01\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe36(G114S)\070516_RCC4-pBabeneo36-LMP_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe36(G114S)\070516_RCC4-pBabeneo36-LMP_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe36(G114S)\070516_RCC4-pBabeneo36-LMP_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe36(G114S)\070516_RCC4-pBabeneo36-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe36(G114S)\070516_RCC4-pBabeneo36-LMP_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe36(G114S)\070516_RCC4-pBabeneo36-LMP_07\images\');%Bug%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe36(G114S)\070516_RCC4-pBabeneo36-LMP_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe36(G114S)\070516_RCC4-pBabeneo36-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe36(G114S)\070516_RCC4-pBabeneo36-LMP_10\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe36(G114S)\070516_RCC4-pBabeneo36-LMP_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe36(G114S)\070516_RCC4-pBabeneo36-LMP_12\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe36(G114S)\070516_RCC4-pBabeneo36-LMP_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe36(G114S)\070516_RCC4-pBabeneo36-LMP_14\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe36(G114S)\070516_RCC4-pBabeneo36-LMP_15\images\');
% % 
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe45(L188V)\070516_RCC4-pBabeneo45-LMP_01\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe45(L188V)\070516_RCC4-pBabeneo45-LMP_02\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe45(L188V)\070516_RCC4-pBabeneo45-LMP_03\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe45(L188V)\070516_RCC4-pBabeneo45-LMP_04\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe45(L188V)\070516_RCC4-pBabeneo45-LMP_05\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe45(L188V)\070516_RCC4-pBabeneo45-LMP_06\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe45(L188V)\070516_RCC4-pBabeneo45-LMP_07\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe45(L188V)\070516_RCC4-pBabeneo45-LMP_08\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe45(L188V)\070516_RCC4-pBabeneo45-LMP_09\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe45(L188V)\070516_RCC4-pBabeneo45-LMP_10\images\');%BUG%GROUPING BUG
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe45(L188V)\070516_RCC4-pBabeneo45-LMP_11\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe45(L188V)\070516_RCC4-pBabeneo45-LMP_13\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe45(L188V)\070516_RCC4-pBabeneo45-LMP_14\images\');
% parseGroups('X:\AlexData11\RCC4\RCC4-pBabe45(L188V)\070516_RCC4-pBabeneo45-LMP_15\images\');

% % ot tuk RAD 10
% % parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_0s_01\images\'); NO
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_0s_05\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_0s_09\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_0s_13\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_0s_17\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_0s_01\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_0s_05\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_0s_09\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_0s_13\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_0s_17\images\');
% parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_par_0s_01\images\'); 
% parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_par_0s_05\images\');
% parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_par_0s_09\images\');
% 
% % parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_20s_02\images\');NO
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_20s_06\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_20s_10\images\');
% % parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_20s_14\images\');NO
% % parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_20s_18\images\');NO
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_20s_02\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_20s_06\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_20s_10\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_20s_14\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_20s_18\images\');
% parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_par_20s_02\images\'); 
% parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_par_20s_06\images\');
% parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_par_20s_10\images\');
% 
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_300s_03\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_300s_07\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_300s_11\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_300s_15\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_300s_19\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_300s_03\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_300s_07\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_300s_11\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_300s_15\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_300s_19\images\');
% % parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_par_300s_03\images\'); NO
% parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_par_300s_07\images\');
% % parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_par_300s_11\images\');NO
% 
% % parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_600s_04\images\');NO
% % parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_600s_08\images\');ZERO GROUPS
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_600s_12\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_600s_16\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_par_600s_20\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_600s_04\images\');
% % parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_600s_08\images\');NO
% % parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_600s_12\images\');ONE GROUP
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_600s_16\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_par_600s_20\images\');
% parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_par_600s_04\images\'); 
% parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_par_600s_08\images\');
% % parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_par_600s_12\images\');NO
% 
% 
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_0s_01\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_0s_05\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_0s_09\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_0s_13\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_0s_17\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_0s_01\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_0s_05\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_0s_09\images\');
% % parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_0s_13\images\');NO
% % parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_0s_17\images\');NO
% % parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_VHL30_0s_01\images\'); NO
% % parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_VHL30_0s_05\images\');NO
% % parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_VHL30_0s_09\images\');NO
% 
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_20s_02\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_20s_06\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_20s_10\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_20s_14\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_20s_18\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_20s_02\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_20s_06\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_20s_10\images\');
% % parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_20s_14\images\');NO
% % parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_20s_18\images\');NO
% % parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_VHL30_20s_02\images\'); NO
% % parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_VHL30_20s_06\images\');NO
% % parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_VHL30_20s_10\images\');NO
% 
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_300s_03\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_300s_07\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_300s_11\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_300s_15\images\');
% % parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_300s_19\images\');THREE GROUPS
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_300s_03\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_300s_07\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_300s_11\images\');
% % parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_300s_15\images\');NO
% % parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_300s_19\images\');NO
% % parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_VHL30_300s_03\images\'); NO
% % parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_VHL30_300s_07\images\');NO
% % parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_VHL30_300s_11\images\');NO
% 
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_600s_04\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_600s_08\images\');
% % parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_600s_12\images\');THREE GROUPS
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_600s_16\images\');
% parseGroups('X:\AlexData11\NOCO\070816_RCC-4_Noco40nM_tiff\070816_RCC-4_VHL30_600s_20\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_600s_04\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_600s_08\images\');
% parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_600s_12\images\');
% % parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_600s_16\images\');NO
% % parseGroups('X:\AlexData11\NOCO\070818_RCC-4_Noco40nM_tiff\070818_RCC-4_VHL30_600s_20\images\');NO
% % parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_VHL30_600s_04\images\'); NO
% % parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_VHL30_600s_08\images\');NO
% % parseGroups('X:\AlexData11\NOCO\070819_RCC-4_Noco40nM_tiff\070819_RCC-4_VHL30_600s_12\images\');NO
% % RAD 10 do tuk
% 
% 
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_0s_08\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_0s_12\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_0s_16\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_0s_20\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_0s_25\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_0s_29\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_0s_33\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_0s_37\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_0s_41\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_0s_45\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_0s_49\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_0s_53\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_20s_09\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_20s_13\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_20s_17\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_20s_21\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_20s_26\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_20s_30\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_20s_34\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_20s_38\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_20s_42\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_20s_46\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_20s_50\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_20s_54\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_120s_10\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_120s_14\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_120s_18\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_120s_22\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_120s_27\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_120s_31\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_120s_35\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_120s_39\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_120s_43\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_120s_47\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_120s_51\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_120s_55\images\');
% % parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_360s_11\images\');% NO SHRINK
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_360s_15\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_360s_19\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_360s_23\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_360s_28\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_360s_32\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_360s_36\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_360s_40\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_360s_44\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_360s_48\images\');
% parseGroups('X:\AlexData11\080225_VHL30\080224_Noco40nM_RCC4VHL30_360s_52\images\');
% 
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_0s_01\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_0s_05\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_0s_09\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_0s_13\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_0s_17\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_0s_25\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_0s_29\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_0s_33\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_0s_37\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_0s_41\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_0s_45\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_20s_02\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_20s_06\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_20s_10\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_20s_14\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_20s_18\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_20s_22\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_20s_26\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_20s_30\images\');
% % parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_20s_34\images\'); % NO SHRINK
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_20s_38\images\');
% % parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_20s_42\images\'); % NO SHRINK
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_20s_46\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_120s_03\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_120s_07\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_120s_11\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_120s_15\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_120s_19\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_120s_23\images\');
% % parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_120s_27\images\');% NO SHRINK
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_120s_31\images\');
% % parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_120s_35\images\');% NO SHRINK
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_120s_39\images\');
% % parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_120s_43\images\');% NO SHRINK
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_120s_47\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_360s_04\images\');
% % parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_360s_08\images\');% NO SHRINK
% % parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_360s_12\images\');% NO SHRINK
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_360s_16\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_360s_20\images\');
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_360s_24\images\');
% % parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_360s_28\images\');% NO SHRINK
% parseGroups('X:\AlexData11\080225_CMVempty\080224_Noco40nM_RCC4par_360s_32\images\');

% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30_01\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30_02\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30_03\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30_04\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30_05\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30_06\images\');
% 
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872A_01\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872A_02\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872A_03\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872A_04\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872A_06\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872A_07\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872A_08\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872A_09\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872A_10\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872A_11\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872A_12\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872A_13\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872A_14\images\');
% 
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872D_01\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872D_03\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872D_04\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872D_05\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872D_06\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872D_07\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872D_08\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872D_09\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872D_10\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872D_11\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872D_12\images\');
% parseGroups('X:\AlexData11\080821_RCC4_starv_tiff\080821_RCC4_starv_Vhl30S6872D_13\images\');

% parseGroups('X:\AlexData11\Crop\080526RPE1-crops\060922_RPE1-LMPns_02_crop1\images\');
% parseGroups('X:\AlexData11\Crop\080526RPE1-crops\060922_RPE1-LMPns_02_crop2\images\');
% parseGroups('X:\AlexData11\Crop\080526RPE1-crops\060922_RPE1-LMPns_05_crop1\images\');
% parseGroups('X:\AlexData11\Crop\080526RPE1-crops\060922_RPE1-LMPns_05_crop2\images\');
% parseGroups('X:\AlexData11\Crop\080526RPE1-crops\060922_RPE1-LMPshVHL_05_crop1\images\');
% parseGroups('X:\AlexData11\Crop\080526RPE1-crops\060922_RPE1-LMPshVHL_05_crop2\images\');
% parseGroups('X:\AlexData11\Crop\080526RPE1-crops\060922_RPE1-LMPshVHL_10_crop1\images\');
% parseGroups('X:\AlexData11\Crop\080526RPE1-crops\060922_RPE1-LMPshVHL_10_crop2\images\');

% parseGroups('X:\AlexData\Torsten\GSK_paper\37degs\022608_#4\images\');
% parseGroups('X:\AlexData\Torsten\GSK_paper\37degs\022608_#7\images\');
% parseGroups('X:\AlexData\Torsten\GSK_paper\37degs\022608_#10\images\');
% parseGroups('X:\AlexData\Torsten\GSK_paper\37degs\030708_#11\images\');
% parseGroups('X:\AlexData\Torsten\GSK_paper\37degs\030708_#13\images\');
% parseGroups('X:\AlexData\Torsten\GSK_paper\37degs\030708_#14\images\');
% 
% parseGroups('X:\AlexData\Torsten\GSK_paper\gsk_100x\022208_#1\images\');
% parseGroups('X:\AlexData\Torsten\GSK_paper\gsk_100x\022208_#5\images\');
% parseGroups('X:\AlexData\Torsten\GSK_paper\gsk_100x\022608_#1\images\');
% parseGroups('X:\AlexData\Torsten\GSK_paper\gsk_100x\022608_#2\images\');
% parseGroups('X:\AlexData\Torsten\GSK_paper\gsk_100x\022608_#8\images\');
% parseGroups('X:\AlexData\Torsten\GSK_paper\gsk_100x\022608_#9\images\');