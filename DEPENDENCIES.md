# Dependencies

## `EB1projectCPP.zip` / `EB1projectCPP/`

The zip contains a Visual Studio C++ build folder producing several
standalone tracking executables (`FSMtrack.exe`, `ccLAPtrack_*.exe`,
`LAPtrack_*.exe`) -- not a MATLAB MEX-file. Building from source requires
a C++ compiler compatible with the included project files (`.sln`/
`.vcproj`/`.dsp`); the source itself is also available loose (without the
build artifacts) in `EB1projectCPP/src/` and `EB1projectCPP/include/` for
easier browsing.

`createSparseDistanceMatrix.c`, separately, is compiled via MATLAB's
`mex` compiler into a MEX-file for direct use by the MATLAB tracker
scripts.

## MATLAB scripts (`.m` files)

No specific MATLAB toolbox versions are recorded. Scripts throughout use
image processing and statistics functions that require MATLAB's Image
Processing Toolbox and Statistics and Machine Learning Toolbox.

## Hardcoded paths

Most `.m` files at the repository root contain hardcoded absolute paths
to the original author's local machine (e.g. `X:\AlexData11\...`). Active
(non-commented) instances are flagged with an `% EDIT:` comment directly
above them -- update these before running a script.
