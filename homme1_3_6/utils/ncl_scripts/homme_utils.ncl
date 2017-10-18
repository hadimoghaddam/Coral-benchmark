undef("homme_open_file")

function homme_open_file()
local mergenc, fnames
begin 
;  mergenc = systemfunc("cd movies; perl $HOMME_HOME/utils/mergenc.pl *.nc")
  fnames =  systemfunc("ls movies/*01.nc")
  if(ismissing(fnames)) then
    delete(fnames)
    fnames = systemfunc("ls movies/*.nc")
  else
    print("Reading combined data file "+fnames(0))
  end if
  
  return(addfiles(fnames,"r"))       ; Open netCDF files.
  
end
