### **ClusterTrack**

##### Presentations, targeting strategies, and funding applications on this project are available here: https://researchgate.net/publication/374059796_Personalized_Therapy_for_Sensitization_of_Resistant_Tumors_and_Identification_of_Putative_Targets_within_the_Microtubule_Transcriptome_2007_-_2017

#### Methods for personalizing medical treatment are the focal point of contemporary biomedical research. All degenerative diseases are associated with impairment in intracellular trafficking and manifest in changes in the morphology of cellular components. Complete characterization of treatment efficacy and evaluation of why some individuals respond to specific regimens, whereas others do not, requires additional approaches to genetic sequencing at single time points. Quantitative cell biological profiling of subcellular interactions in disease is required to understand the mechanisms of pathogenesis and elucidate the mechanisms of drug action. Successful analyses of the mechanism of drug action require statistical analysis of large-scale readouts of molecular interactions at nanometer-scale resolution by automating the extraction of unbiased information from time-lapse microscopy image series. Methods for the continuous analysis of changes in phenotype, such as morphology and motion tracking of cellular proteins and organelles over time frames spanning the minute-hour scales, can provide new evidence and essential insight into patient treatment options.

#### **ClusterTrack** software allowed for the first time comprehensive measurements of microtubule behavior, encompassing all cellular areas, including the cell body, where the density of the cytoskeleton is high. Additionally, the ClusterTrack algorithm allowed for the characterization of the different stages of microtubule depolymerization, a process that cannot be visualized using existing molecular markers. Using this software, I directly measured two parameters of microtubule dynamics and computationally inferred another ten parameters to evaluate a microtubule dynamics signature. This computational approach could evaluate and compare the effects of both established and new microtubule-targeting agents on microtubule dynamics. In the long run, dissecting the mechanisms of microtubule organization using this computing tool will allow better drugs to be designed by exploiting disease-specific aberrations and aid in the characterization of new therapies.

##### I have described an application of ClusterTrack for the evaluation of oncolytic virus therapy here: https://researchgate.net/publication/374166817_Image_Analysis_of_Microtubules_Before_and_After_Treatment_with_Attenuated_Vaccinia_Virus_to_Evaluate_the_Infection_Efficacy_of_Oncolytic_Virus_Therapy_2011

##### I described a clinical application of ClusterTrack here: https://researchgate.net/publication/374059823_Quantitative_Video_Microscopy_Methods_in_Medicine_Perspective_2017

###### My user guide can be viewed here: https://www.researchgate.net/publication/256436111_ClusterTrack_software_user_guide

###### I wrote Matlab functions for detection, clustering, and statistics such as EB3a.m/scale-space detection (2002), trackCluster.m (2007), and the supporting functions 

###### All additional project Matlab functions can be downloaded here: https://www.nature.com/articles/nmeth.1493#Sec13

###### The linear Kalman filter is based on solving the Hungarian algorithm with an implementation by Roy Jonker in 1996 

###### The tracking functions are based on implementation by Cor Veenman in 2002
###### See their C++ code in folders HungarianAlgorithm_cCode_LAP and GOA_Veenman

