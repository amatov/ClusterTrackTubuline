### ClusterTrack

### C++ and Matlab code I wrote for the software modules of the ClusterTrack algorithm

#### Methods for personalizing medical treatment are the focal point of contemporary biomedical research. All degenerative diseases are associated with impairment in intracellular trafficking and manifest in changes in the morphology of cellular components. Complete characterization of treatment efficacy and evaluation of why some individuals respond to specific regimens, whereas others do not, requires additional approaches to genetic sequencing at single time points. 

#### Quantitative cell biological profiling of subcellular interactions in disease is required to understand the mechanisms of pathogenesis and elucidate the mechanisms of drug action. Successful analyses of the mechanism of drug action require statistical analysis of large-scale readouts of molecular interactions at nanometer-scale resolution by automating the extraction of unbiased information from time-lapse microscopy image series. 

#### Methods for the continuous analysis of changes in phenotype, such as morphology and motion tracking of cellular proteins and organelles over time frames spanning the minute-hour scales, can provide new evidence and essential insight into patient treatment options.

### ClusterTrack software allowed for the first time comprehensive measurements of microtubule behavior, encompassing all cellular areas, including the cell body, where the density of the cytoskeleton is high. 

#### Additionally, the ClusterTrack algorithm allowed for the characterization of the different stages of microtubule depolymerization, a process that cannot be visualized using existing molecular markers. 

#### Using this software, I directly measured two parameters of microtubule dynamics and computationally inferred another ten parameters to evaluate a microtubule dynamics signature. This computational approach could evaluate and compare the effects of both established and new microtubule-targeting agents on microtubule dynamics. 

### In the long run, dissecting the mechanisms of microtubule organization using this computing tool will allow better drugs to be designed by exploiting disease-specific aberrations and aid in the characterization of new therapies.

#### My user guide can be viewed here: http://dx.doi.org/10.13140/RG.2.2.16489.26721

#### Many other Matlab functions, from unrelated projects at my dissertation lab, can be downloaded here: https://www.nature.com/articles/nmeth.1493#Sec13

##### The linear Kalman filter is based on solving the Hungarian algorithm with an implementation by Roy Jonker in 1996 

##### The tracking functions are based on implementation by Cor Veenman in 2001

##### See their C++ code in folders HungarianAlgorithm_cCode_LAP and GOA_Veenman

#### I also wrote code and performed analysis for the publication:

#### Yukako Nishimura, Kat Applegate, Mike Davidson, Gaudy Danuser, Clare Waterman "Automated Screening of Microtubule Growth Dynamics Identifies MARK2 as a Regulator of Leading Edge Microtubules Downstream of Rac1 in Migrating Cells (2012)" https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0041413
