rootdir = "Geolife Trajectories 1.3/Data/";

D = dir(rootdir);

for (i = 171:size(D,1))
  singledir = strcat(rootdir, D(i).name, "/Trajectory/");
  dataD = dir(singledir);
  outputfile = strcat(rootdir, D(i).name, "/octave.mat");
  disp(strcat("Current directory: ", singledir));
  
  numfiles = size(dataD,1)-2;
  S = struct("traj", cell(numfiles,1), "datedata", cell(numfiles,1));
  for (j = 1:numfiles)
    disp(strcat("Reading file: ", dataD(j+2).name));
    [S(j).traj, S(j).datedata] = geolife_read(dataD(j+2).name, singledir);
  endfor
  
  disp(strcat("Saving ", outputfile));
  save(outputfile, "S");
endfor