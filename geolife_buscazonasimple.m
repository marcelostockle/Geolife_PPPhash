function [partitionX, partitionY, blocks] = geolife_buscazonasimple(preP, delta)
  
  ind = geolife_preproc_outliers(preP);

  min_coor = min(preP.min_I(ind,:));
  max_coor = max(preP.max_I(ind,:));

  dim = max_coor - min_coor;
  blocks = prod( ceil(dim / delta) ); % INCORRECTO
  
  % partition
  partitionX = min_coor(1):delta:max_coor(1);
  partitionX = partitionX + rem(max_coor(1) - min_coor(1), delta) / 2;
  partitionY = min_coor(2):delta:max_coor(2);
  partitionY = partitionY + rem(max_coor(2) - min_coor(2), delta) / 2;
endfunction