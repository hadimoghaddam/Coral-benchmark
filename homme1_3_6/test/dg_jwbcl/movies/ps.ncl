;************************************************************************
; SW5: Height plots on the Cubed-Sphere (R.Nair/IMAGe/2009) 
;************************************************************************
;	Include NCL scripts libraries				 
;************************************************************************
;************************************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
; 	Main Program					 
;************************************************************************
;************************************************************************
begin
;  mergenc = systemfunc("cd movies; perl $HOMME_HOME/utils/mergenc.pl *.nc")
  fnames =  systemfunc("ls jw_bcl1.nc")
  ff      = addfiles(fnames,"r")       ; Open netCDF files.	

  ; change the name of the field to plot here
  ; current field names are Q, ps, ke, u, v, T, zeta, geop - names are case sensitive
  ; prec, accum
  ; "wind" or "stream" to get a graph of barbs or streamlines only (without contour overlay)
  
 ;field = "geop"
  field = "ps"

  fcnt = dimsizes(fnames)
  f=ff[0];      file with dynamics

  PS = f->ps
; z700 = f->geop
; t700 = f->T
; omg850 = f->omega
; z700 = z700/9.80616
; z700 = z700

 output_format = "X11"

; plot streamlines over contours (choose this or wind)
;  stream = True
  stream = False

  ntimes = dimsizes(f->time)
; nlev = dimsizes(f->lev)
  nlev = 26 
  nlat = dimsizes(f->lat)
  nlon = dimsizes(f->lon)
  print ("ntimes="+ntimes+" nlev="+nlev+" nlat x nlon "+nlat+"x"+nlon)

  var = new((/nlat,nlon/),"double")
;-----------------
; for HOMME dycore.
  if (isatt(f,"ne")) then
    NE=f@ne
    NPTS = f@np
    deg=360.0 / (4*NE*(NPTS-1))  ; average grid spacing at equator
    hdeg=sprintf("%4.1f", deg)
    print("NE="+NE+" NPTS="+NPTS+" degree="+hdeg)
  else
    deg=360.0/nlon
  end if

;;
;;;;;;;;
; change the levels and or times to plot here
  firsttime=1
 lasttime= ntimes-1
;  lasttime= 31       
  timeinc=1


  time = f->time
  wks = gsn_open_wks(output_format,"DG3d_JWbcl_Ps")
  print ("Writing file Ps"+"."+output_format)

;;;;;
  do n=firsttime,lasttime,timeinc

    res                     = True
;   res@gsnMaximize         = True         ; Maximize size of plot in frame
    res@gsnSpreadColors     = True         ; Use full colormap, but start
;   res@gsnSpreadColorStart =  35           ; at color index 24.
;   res@gsnSpreadColorEnd   = -35           ; at color index 24.

    res@cnFillOn            = True         ; Turn on contour fill
    res@cnFillMode          = "AreaFill"   ; Style of fill. You can also
                                ; use "CellFill" and "RasterFill"
    res@cnLinesOn           = True        ; Turn off contour lines
    res@cnLineLabelsOn      = False        ; Turn off contour line labels
    res@cnLevelSelectionMode = "ManualLevels"

    res@mpOutlineOn          = False
    res@mpFillOn             = False
    res@mpShapeMode          = "FreeAspect"

    res@tmYLLabelFont = 21    ;  21 = helvetica
    res@tmXBLabelFont = 21    ;  22 = helvetica-bold
    res@lbLabelFont = 21
    res@lbLabelBarOn = True
    res@lbLabelAutoStride = True

   res@sfXCStartV = -180.0
   res@sfXCEndV   = 180.0

  
;   thick=4
;   res@tmXBMajorThicknessF = thick
;   res@tmYLMajorThicknessF = thick
;   res@tmXBMinorThicknessF = thick
;   res@tmYLMinorThicknessF = thick
;   res@tmBorderThicknessF = thick
;  res@tmXBLabelFontHeightF = .015
;
    res@lbLabelBarOn = True
    res@mpCenterLonF         = 180

  gsn_define_colormap(wks,"gui_default")
  res@tiMainString    = "HOMME/DG3D JW_Ps, Res:"+hdeg+"deg, Day="+time(n)+"."

  var(:,:)= ff[0]->$field$(n,:,:)
  var(:,:)= var(:,:) / 100.0
  copyatt( var, ff[0]->$field$(n,:,:) )
    print ("Ps min,max = "+min(var(:,:))+", "+max(var(:,:)) )
;   res@cnMinLevelValF = 998.0
;   res@cnMaxLevelValF = 1001.0
    minv = min(var(:,:))
    maxv = max(var(:,:)) 
    res@cnMinLevelValF = minv           
    res@cnMaxLevelValF = maxv          
    res@cnLevelSpacingF = (maxv -minv)/11.0
;   var@long_name = "geopotential height at 700 hPa"
;   var@units = "m"
    contour = gsn_csm_contour_map(wks,var(:,:),res)     ; Draw a contour plot.  ;

end do


end

