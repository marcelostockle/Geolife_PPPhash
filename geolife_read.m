function [traj, datedata] = geolife_read(filename, directory)
  if (nargin() == 1)
    directory = "./";
  endif
  
  fid = fopen(strcat(directory, filename));

  str = fgetl(fid);
  readready = 0;
  rawdata = [];
  while (str != -1)
    if (readready)
      row = strsplit(str, ",");
      rawdata = cat(1, rawdata, row);
      % printf(strcat(str, "\n"));
    endif
    if (strcmp(str, "0"))
      readready = 1;
    endif
    str = fgetl(fid);
  endwhile
  fclose(fid);

  traj = str2double(rawdata(1:end,[5 1 2]));
  % plot(traj(:,2), traj(:,3));

  datedata = datevec(rawdata(:,6));
  aux = datevec(rawdata(:,7));
  datedata(:,4:6) = aux(:,4:6);

endfunction