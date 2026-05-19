# DPMA_lab_2

The purpose of the exercise is to study the properties of beamforming systems.

## Available functions:

a(PhiDeg,ArrayPattern,ArrayTaper=[]) - a function that generates the composite response of an antenna array (in the form of a signal vector of size corresponding to the size of the antenna).
PhiDeg - the angle from which/at which the signal is received [deg].
ArrayPattern - the arrangement of receiving elements in a linear array. Defined as the position of the elements on the axis, where the distance between them of 1 corresponds to d=0.5*lambda
Example: ArrayPattern=[0 1 2 3] means a 4-element linear antenna array with elements spaced at uniform d intervals.
ArrayTaper - (optional) vector of weights used for beamforming. Must be the same length as the ArrayPattern.

crandn(n) - a function that generates composite random variables with a Gaussian distribution (the default variance is sqrt(2)),
n - the size of the generated string

Required system functions (weighting windows):
- hamming
- hanning
- blackman
- nuttallwin


## Tasks to be carried out

1 Obtain the directional characteristics of the antenna.
Generate the vector a0 of the antenna response (composed of 8 equidistant elements) at any angle of your choice.
Using the equation y(phi)=a(phi)*a0'; obtain the directivity pattern of the antenna.
Draw a graph of the modulus of the above function, the x-axis should be scaled with degrees.
For proper accuracy, assume a resolution of 0.01 deg.
Plot the same graph when more than one object is present (sum of antenna response vectors from different angles).
The vertical axis should be scaled in dB.

2. sidelobe level and 3-db beamwidth.
Write your own functions that take the composite gain vector (beamPattern - y from the previous task) and the angles corresponding to the indices (angleVec).
The first function (get3dbBeamwidth(beamPattern, angleVec)) should return the 3db width of the characteristic (in degrees).
The second function (getSidelobeLevel(beamPattern, angleVec)) should take the same arguments as in the previous case, and return the maximum sidelobe level (in linear scale) and its distance from the beam center.

3. plot the characteristics and examine the sidelobe level for an antenna array consisting of M1=4; M2=8; M3=16; M4=128 receiving elements.
In this simulation, the object should be at an angle of phi_0=0 [deg] (to maintain symmetry).
List the beam widths and sidelobe levels in the table.
Comment on which antenna array will perform better for observing two objects with not much angular separation between them.

4 Examine the effect of weighting windows on the obtained characteristics.
In this simulation, the object should be at an angle of phi_0=0 [deg] (to preserve symmetry)
I one diagram put the drawings of antenna characteristics using windows:
- hamming (hamming)
- hanning (hanning)
- blackman (blackman)
- nuttal (nuttallwin)
Create a table with the widths of the main beam and the level of the side lobes.
