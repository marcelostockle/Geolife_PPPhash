H = [];
for (c = 1:numel(S))
  if (preP.k_id(c) == 1)
    ind = cat(1, 1, find(diff(S(c).seq)));
    dT = S(c).traj(ind,1);
    H = cat(1, H, diff(dT));
  endif
endfor
H = H * 86400;

bin = 5;
xax = (0:bin:8000)+bin/2;
hist(H, xax);