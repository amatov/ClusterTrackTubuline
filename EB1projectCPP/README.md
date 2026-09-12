This is the source for the `EB1track` Visual Studio solution
(`FSMtrack` project), packaged as a full build folder in
`EB1projectCPP.zip`. Building it (via the included `.sln`/`.vcproj`/
`.vcxproj` project files) produces nine standalone executables, all from
the same `FSMtrack` source with different build configurations:

- `FSMtrack.exe`
- `FSMtrack_unidir.exe`
- `ccLAPtrack_deg40.exe`
- `ccLAPtrack_long.exe`
- `ccLAPtrack_vesicle.exe`
- `LAPtrack_speckle.exe`
- `LAPtrack_speckle_long.exe`
- `LAPtrack_vesicle.exe`
- `LAPtrack_vesicle_long.exe`

(There is no single file literally named `EBtrack.exe` -- the solution
is named `EB1track`, but the built executables are the nine listed
above.)

`src/` and `include/` here are the `.cpp`/`.h` source from the zip,
extracted for browsing (the zip itself still has the full build folder,
including these compiled `.exe` files and the Visual Studio project
files needed to rebuild them). Some of these source files are identical
to the versions in `HungarianAlgorithm_cCode_LAP/`; others (e.g.
`main.cpp`) are modified for this project.
