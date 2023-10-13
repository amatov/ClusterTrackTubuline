
******************************************************************************

This directory contains the source files of both the GOA tracker and the
IPAN tracker. These trackers can be build in a unix environment in which
the g++ compiler has been installed. I did not test other operating
systems or compilers, but I do not expect real difficulties.

Both trackers can be configured with the file 'track.ini'. All options
that can be set in this file can, however, be overruled with command
line options.

The programs read the feature positions from a text file. In this file
the position information is stored a text line per frame. Each line contains
a list of positions in the following format:

    (x0 y0) (x1 y1) (x2 y2) .. (xn yn).

The tracking results are written to a output file in PGM image format, 8
bit per pixel.

******************************************************************************

I implemented these and other trackers to test our own GOA tracker
and to do a proper performance comparison with other trackers. For a
description of the GOA tracker and the results of the performance
evaluation I refer to:

    C.J. Veenman, M.J.T. Reinders, and E. Backer, 'Resolving Motion
    Correspondence for Densely Moving Points'. IEEE Transactions on
    Pattern Analysis and Machine Intelligence, vol. 23, no. 1, pp.
    54-72, Januari 2001

The IPAN tracker is implemented as described in:

    D. Chetverikov and J. Veresto'y, 'Feature Point Tracking for
    Incomplete Trajectories'. Computing, Devoted Issue on Digital
    Image Processing', 62:321-338, 1999.

******************************************************************************


As an example I included the points file 'rotdish80.pts' which contains the
position information of the seeds on a rotating dish as used in the
abovementioned PAMI paper.

Then the programs can track the points from the file as follows:

    goa -max-phi=0.1 -max-speed=100 rotdish80.pts rotdish80.goa.pgm

    ipan -max-phi=0.1 -max-speed=42 rotdish80.pts rotdish80.ipan42.pgm
    ipan -max-phi=0.1 -max-speed=50 rotdish80.pts rotdish80.ipan50.pgm


Good luck,

Cor J. Veenman

Department of Mediamatics
Faculty of Information Technology and Systems
Delft University of Technology
Delft
The Netherlands

email:  C.J.Veenman@its.tudelft.nl
