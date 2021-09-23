function [partitionX, partitionY, delta, blocks] = geolife_buscazona(preP, max_blocks)
  
  ind = geolife_preproc_outliers(preP);

  min_coor = min(preP.min_I(ind,:));
  max_coor = max(preP.max_I(ind,:));

  dim = max_coor - min_coor;

  % initialization
  delta = min(dim / 2);
  delta_readjust = .9;
  blocks = prod( ceil(dim / delta) );

  % optimization
  while (blocks < max_blocks)
    delta = delta_readjust * delta;
    blocks = prod( ceil(dim / delta) );
  endwhile

  % revert
  delta = delta / delta_readjust;
  blocks = prod( ceil(dim / delta) );
  
  % partition
  partitionX = min_coor(1):delta:max_coor(1);
  partitionX = partitionX + rem(max_coor(1) - min_coor(1), delta) / 2;
  partitionY = min_coor(2):delta:max_coor(2);
  partitionY = partitionY + rem(max_coor(2) - min_coor(2), delta) / 2;
endfunction