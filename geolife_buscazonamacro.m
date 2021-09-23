rootdir = "Geolife Trajectories 1.3/Data/";

D = dir(rootdir);

for (f = 3:size(D,1))
  filename = strcat(D(f).folder, "\\", D(f).name, "\\octave3.mat");
  if (exist(filename, "file"))
    disp(strcat("reading: ", filename));
    load(filename, "S", "preP");
    
    [partX, partY, blocks] = geolife_buscazonasimple(preP, 0.01);
    outliers = geolife_preproc_outliers(preP);
    aux = 1:numel(S);
    outliers = aux(outliers);
    for (i = outliers)
      n = size(S(i).traj, 1);
      remaining = true(n, 1);
      seqX = zeros(n, 1);
      for (j = 1:numel(partX))
        valid = (S(i).traj(:,2) < partX(j)) & remaining;
        seqX(valid) = j - 1;
        remaining(valid) = false;
      endfor
      seqX(remaining) = numel(partX);
      
      remaining = true(n, 1);
      seqY = zeros(n, 1);
      for (j = 1:numel(partY))
        valid = (S(i).traj(:,3) < partY(j)) & remaining;
        seqY(valid) = j - 1;
        remaining(valid) = false;
      endfor
      seqY(remaining) = numel(partY);
      
      S(i).seq = seqY * (numel(partX) + 1) + seqX;
    endfor
    
    preP.blocks = blocks;
    preP.partX = partX;
    preP.partY = partY;
    disp("Saving changes...");
    newfile = strcat(D(f).folder, "\\", D(f).name, "\\octave4.mat");
    save(newfile, "S", "preP");
  endif
endfor