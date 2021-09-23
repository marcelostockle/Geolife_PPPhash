params = [4 5 6; 40 40 40];

for (params_i = 1:3)
  period = params(1, params_i)
  min_count = params(2, params_i)

  load("Geolife Trajectories 1.3/summary.mat");
  rootdir = "Geolife Trajectories 1.3/Data/";

  iter = find(summary == 1);
  iter += 2;
  D = dir(rootdir);
  D = D(iter);

  profileF1 = cell(size(D));
  profileTree = cell(size(D));
  profileHash = cell(size(D));
  roughF1 = zeros(size(D));
  roughTree = zeros(size(D));
  roughHash = zeros(size(D));
  totalPeriods = zeros(size(D));
  totalFPPP = zeros(numel(D), period);
  for (f = 1:numel(D))
    filename = strcat(D(f).folder, "\\", D(f).name, "\\octave4.mat");
    disp(strcat("reading: ", filename));
    load(filename, "S", "preP");
    
    % final preprocessing
    inliers = geolife_preproc_outliers(preP);
    accepted = 1:numel(inliers);
    accepted = accepted(inliers);
    for (i = accepted)
      ind = cat(1, 1, diff(S(i).seq));
      ind = find(ind != 0);
      S(i).cseq = S(i).seq(ind);
    endfor
    
    % max-subpattern
    printf("profiling F1... "); tic();
    profile clear; profile on;
    [F1, count] = geolife_maxsub_f1(S, preP, period, min_count, false);
    profile off; profileF1(f) = profile("info");
    roughF1(f) = toc();
    printf("%d seconds\n", roughF1(f));
    totalPeriods(f) = sum(count(:,1));
    totalFPPP(f, 1) = size(F1, 1);
    
    printf("profiling max-subpattern tree... "); tic();
    profile clear; profile on;
    tree = geolife_maxsub(S, preP, F1, period, min_count, false);
    profile off; profileTree(f) = profile("info");
    roughTree(f) = toc();
    printf("%d seconds\n", roughTree(f));
    
    % PPP-hash
    printf("profiling PPP-hash... "); tic();
    profile clear; profile on;
    [S, C, F] = geolife_protobppf_results(S, preP, period, min_count);
    profile off; profileHash(f) = profile("info");
    roughHash(f) = toc();
    printf("%d seconds\n", roughHash(f));
    for (p = 2:period)
      totalFPPP(f, p) = numel(F{p-1}.keys);
    endfor
  endfor

  fname = sprintf("tests/p%dsupp%d.mat", period, min_count);
  save(fname, "profileF1", "profileTree", "profileHash", 
   "roughF1", "roughTree", "roughHash", "D", "period", "min_count",
   "totalFPPP", "totalPeriods");
 endfor