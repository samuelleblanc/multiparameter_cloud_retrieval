# Retrieving cloud properties using multiple spectral shape parameters
Scientific analysis codes dedicated to calculate cloud properties (cloud optical thickness, cloud particle effective radius, and cloud thermodynamic phase)
These clouds properties are retrieved using zenith spectral radiance measurements taken with the 4STAR instrument onboard airborne research platforms or SSFR ground-based radiance measurements
The various codes are used to build a ki-squared based multiparameter retrieval of cloud properties. 

  - The codes used to prepare, run, and read radiative transfer calculations from a computing cluster is located in the 'cluster' subdirectory, the mie_hi.out required file is located at: http://science.arm.gov/~sleblanc/mie_hi.out
  - The codes used for reading libradtran output, and preparing the atmosphere profile input files are located in the libradtran subdirectory
  - Various plotting programs are located in the plotting subdirectory
  - the ki squared multiparameter retrieval codes are located in the retrieval subdirectory
  - An adaptation of the idl codes to python is located in the python_codes subdirectory.

The following steps describe the general steps to use these codes for retrieving cloud properties:
  - 1.0 Prepare and run radiative transfer calculations 
     - 1.1 Create input atmospher profiles for libradtran and surface albedo files (using atmsophere.pro in libradtran for the profiles)
     - 1.2 Select the correct altitudes of the cloud, output altitude, and the sza: Change the values of the following variables in the program 'build_v2.pro' or 'build_arctic_nas.pro' (or other build_*.pro versions located in the 'cluster' subdirectory) 
       - cldbot, clddz (for cloud bottom and thickness in km)
       - zout (for output altitudes)
       - sza (solar zenith angle, or alternatively lat and lon)
     - 1.3 Run the build_*.pro on a cluster, this builds all the input files, and a list of file command to run, which is used as input to a PBS script for parrallel processing
     - 1.4 Run the libradtran commands with PBS scripts
     - 1.5 Modify the read_*.pro programs to match the sza, zout, and date values in build_*.pro
     - 1.6 Read the output of libradtran with read_*.pro, which then saves to idl out files

  - 2.0 Build a LUT, and check output
     - 2.1 You can build and plot the details of the paramters by using pars_lut.pro located in retrieval
     - 2.2 To build an LUT (Look-Up-Table), which has a value of each 15 parameter (the 16 is for double checking), at each optical thickness, effective radius, and thermodynamic phase use the program build_lut_par.pro (located in subdir retrieval)
     - 2.3 View output of build_lut_par using the plotting tools found in the dubsir plotting (you can start with plot_pars4.pro)
  
  - 3.0 Run retrieval process with ki squared
     - 3.1 Modify the retrieve_kisq_v2.pro (located in subdir retrieval) to match the lut save file and the SSFR save file.
     - 3.2 Run the retrieve_kisq_v2.pro with date = to the date string (yyyymmdd) of the measured data. only use model or save keyword if you need testing.
  
  - Alternatively with python:
  After completing the steps in 1.0, open and run the load_model_sp_params.ipynb (ipython notebook) which follows along the creation and usage of the LUT for retrieving cloud properties with 4STAR data. (find relevant python codes in the python_codes subdir)

***
*** Disclaimer ***

The codes contained herein are for science analysis. 
The very nature of this research promotes evolving programs, thus legacy codes may still be prominent, with some lack in documentation.
This code is published online in the spirit of the the Community Research and Academic Programming License. http://www.dcs.gla.ac.uk/~pat/extremal/distribution/CRAPL-LICENSE.txt
***


Collection of idl and python codes for analysis of data taken with 4STAR and SSFR
The python codes are to be used in the ipython notebook
