N = 1000;
len = 20000;
experiments = 30;

preP.k_id = 1;
preP.outlier = false;
preP.partX = 0;
preP.partY = zeros((N / 2) - 1, 1);
period = 5;
min_count_agg = 30:20:90;

max_pattern = randi(N, 1, period) - 1;

results_random = zeros(experiments * numel(min_count_agg), 1);
results_semi = zeros(size(results_random));
results_deter = zeros(size(results_random));
iter = 1;
iter_semi = 1;
iter_deter = 1;
for (x = 1:experiments)
  printf("\nExperimento #%d\n", x);
  S.cseq = randi(N, len, 1) - 1;
  for (min_count = min_count_agg)
    printf("-");
    results_random(iter, 1) = min_count;
    tic();
    [S, C, F] = geolife_protobppf_results(S, preP, period, min_count);
    results_random(iter, 2) = toc();
    
    printf("|");
    [F1, count] = geolife_maxsub_f1(S, preP, period, min_count, false);
    tic();
    tree = geolife_maxsub(S, preP, F1, period, min_count, false);
    results_random(iter, 3) = toc();
    iter++;
  endfor
  
  printf("\n - Semirandom:\n");
  for (p = 0:49)
    ind = p * period + (1:period);
    semirand = S.cseq(ind);
      for (i = 1:period)
        if (rand <= 0.5)
          semirand(i) = max_pattern(i);
        endif
      endfor
    S.cseq(ind) = max_pattern;
  endfor
  
  for (min_count = min_count_agg)
    printf("-");
    results_semi(iter_semi, 1) = min_count;
    tic();
    [S, C, F] = geolife_protobppf_results(S, preP, period, min_count);
    results_semi(iter_semi, 2) = toc();
    
    printf("|");
    [F1, count] = geolife_maxsub_f1(S, preP, period, min_count, false);
    tic();
    tree = geolife_maxsub(S, preP, F1, period, min_count, false);
    results_semi(iter_semi, 3) = toc();
    iter_semi++;
  endfor
  
  printf("\n - Deterministic:\n");
  for (p = 0:49)
    ind = p * period + (1:period);
    S.cseq(ind) = max_pattern;
  endfor
  
  for (min_count = min_count_agg)
    printf("-");
    results_deter(iter_deter, 1) = min_count;
    tic();
    [S, C, F] = geolife_protobppf_results(S, preP, period, min_count);
    results_deter(iter_deter, 2) = toc();
    
    printf("|");
    [F1, count] = geolife_maxsub_f1(S, preP, period, min_count, false);
    tic();
    tree = geolife_maxsub(S, preP, F1, period, min_count, false);
    results_deter(iter_deter, 3) = toc();
    iter_deter++;
  endfor
  
endfor

save("synth_resultsB.mat", "experiments", "len", "max_pattern", "min_count_agg", "period", "preP", "results_deter", "results_random", "results_semi")
