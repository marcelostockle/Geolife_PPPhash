rootdir = "Geolife Trajectories 1.3/Data/";

D = dir(rootdir);

for (i = 182:size(D,1))
  filename = strcat(D(i).folder, "\\", D(i).name, "\\octave.mat");
  if (exist(filename, "file"))
    disp(strcat("reading: ", filename));
    load(filename, "S");
    
    min_I = zeros(size(S,1), 2);
    max_I = zeros(size(S,1), 2);
    mean_I = zeros(size(S,1), 2);
    for (j = 1:size(S,1))
      min_I(j, 1) = min(S(j).traj(:,2));
      min_I(j, 2) = min(S(j).traj(:,3));
      max_I(j, 1) = max(S(j).traj(:,2));
      max_I(j, 2) = max(S(j).traj(:,3));
      mean_I(j, 1) = mean(S(j).traj(:,2));
      mean_I(j, 2) = mean(S(j).traj(:,3));
    endfor
    [k_id, centers] = kmeans(mean_I, 2);
    compare_min = min(min_I(k_id == 1, :));
    compare_max = max(max_I(k_id == 1, :));
    outlier = false;
    if (numel(compare_min) > 1)
      if (centers(2, 1) < compare_min(1) || centers(2, 2) < compare_min(2)
        || centers(2, 1) > compare_max(1) || centers(2, 2) < compare_max(2))
        printf("Outlier cluster, %d out of %d trajectories\n", sum(k_id == 2), size(S, 1));
        outlier = true;
      endif
    endif
    disp("Saving changes...");
    preP.min_I = min_I;
    preP.max_I = max_I;
    preP.k_id = k_id;
    preP.outlier = outlier;
    preP.id = D(i).name;
    newfile = strcat(D(i).folder, "\\", D(i).name, "\\octave2.mat");
    save(newfile, "S", "preP");
  endif
endfor