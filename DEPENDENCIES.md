# Dependencies

## `EB1projectCPP.zip`

Contains C source code that must be compiled with MATLAB's `mex`
compiler into a MEX-file before use by the tracker (the same pattern as
`createSparseDistanceMatrix.c`, which is included as loose source at the
repository root for the same purpose). Unzip and run `mex` on the
contained source to produce the compiled file your MATLAB scripts expect.

## MATLAB scripts (`.m` files)

No specific MATLAB toolbox versions are recorded. Scripts throughout use
image processing and statistics functions that require MATLAB's Image
Processing Toolbox and Statistics and Machine Learning Toolbox.

## Hardcoded paths

Most `.m` files at the repository root contain hardcoded absolute paths
to the original author's local machine (e.g. `X:\AlexData11\...`). Active
(non-commented) instances are flagged with an `% EDIT:` comment directly
above them -- update these before running a script.
