%%
rootdir = "Geolife Trajectories 1.3/Data/";

D = dir(rootdir);

filename = cat(2, D(65).folder, "\\", D(65).name, "\\octave3.mat"); 
load(filename, "S", "preP");

%%
outliers = geolife_preproc_outliers(preP);
accepted = 1:numel(outliers);
accepted = accepted(outliers);
axis_lim = cat(1, min(preP.min_I(accepted,:)), max(preP.max_I(accepted,:)));
for (i = accepted)
  ind = cat(1, 0, diff(S(i).seq));
  ind = find(ind != 0);
  [S(i).seq(ind) S(i).datedata(ind,4:6)]
  plot(S(i).traj(:,2), S(i).traj(:,3))
  xlim(axis_lim(:,1));
  ylim(axis_lim(:,2));
  hold on;
  plot(S(i).traj(1,2), S(i).traj(1,3), "*", "markersize", 10)
  grid on;
  hold off;
  waitforbuttonpress();
endfor