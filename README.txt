read_sm4_files
==============

Summary: A MATLAB code to read the proprietary files sm4 from RHK technology. 
--------

The general idea is to read all the information saved in a .sm4 file with MATLAB. 

The main code is contained in the file read_sm4.m and an example of how to call this function and plot the data is shown in read_files_sm4.m

In the folder devel_files there are some images and spectroscopy data to test the program (the files .SM4).
In addition there are some .txt files with raw data exported from the RHK proprietary software.

For writing the code I used some ideas from the Gwyddion project (http://gwyddion.net/) where I found rhk-sm4.c. 
The .log files where created by the Gwyddion program and were extremely helpful for writing the code.


----------------------
Created by Martín Caldarola (caldarola@df.uba.ar or caldarolamartin@gmail.com)
2012
----------------------


