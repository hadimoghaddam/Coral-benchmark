;************************************************************************
; DG/SW : Vorticity Field s for "Galewsky Test" (RDNair NCAR/IMAGe/2012) 
;************************************************************************
;	Include NCL scripts libraries				 
;************************************************************************
;************************************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
; 	Main Program					 
;************************************************************************
;************************************************************************
begin
  fnames =  systemfunc("ls swtc51.nc")
  fall      = addfiles(fnames,"r")       ; Open netCDF files.	

  ; change the name of the field to plot here
  ; current field names are Q, ps, ke, u, v, T, zeta, geop - names are case sensitive
  ; prec, accum
  ; "wind" or "stream" to get a graph of barbs or streamlines only (without contour overlay)
  
  field = "zeta"

  fcnt = dimsizes(fnames)
  f=fall[0];      file with dynamics

; PS = f->ps
  vorti = f->zeta
; omg850 = f->omega
; vorti = vorti/9.80616
  vorti = vorti *100000.0 

 output_format = "X11"

; plot streamlines over contours (choose this or wind)
;  stream = True
  stream = False

  ntimes = dimsizes(f->time)
; nlev = dimsizes(f->lev)
  nlev = 1 
  nlat = dimsizes(f->lat)
  nlon = dimsizes(f->lon)
  print ("ntimes="+ntimes+" nlev="+nlev+" nlat x nlon "+nlat+"x"+nlon)

; for HOMME dycore.
  if (isatt(f,"ne")) then
    NE=f@ne
    NPTS = f@np
    deg=360.0 / (4*NE*(NPTS-1))  ; average grid spacing at equator
    hdeg=sprintf("%4.1f", deg)
    print("NE="+NE+" NPTS="+NPTS+" deg="+hdeg)
  else
    deg=360.0/nlon
  end if

;;;;;;;;
; change the levels and or times to plot here
  firsttime=3
  lasttime=6 ; ntimes-1
  timeinc=1


  time = f->time
  wks = gsn_open_wks(output_format,"Barotropic_vort")
  print ("Writing file UV"+"."+output_format)

;;;;;
  do n=firsttime,lasttime,timeinc
    res                     = True

  res@mpProjection = "Orthographic" ; Change the map projection.
  res@mpPerimLineThicknessF   = 1.
  res@mpCenterLatF = 50.           ; Rotate latitude-wise.
; res@mpCenterLonF = 0.           ; Rotate longitude-wise.
  res@mpCenterLonF = 180

  res@mpGridAndLimbOn = True
  res@mpGridSpacingF = 45.0
  res@mpGridLineDashPattern = 2
  res@mpLimbLineColor = 1
; res@mpGridLineColor = 0
  res@mpGreatCircleLinesOn = True



    res@gsnMaximize         = True         ; Maximize size of plot in frame
    res@gsnSpreadColors     = True         ; Use full colormap, but start

    res@cnFillOn            = True         ; Turn on contour fill
    res@cnFillMode          = "AreaFill"   ; Style of fill. You can also
                                ; use "CellFill" and "RasterFill"
    res@cnLinesOn           = False        ; Turn off contour lines
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

;  res@sfXCStartV = -180.0
;  res@sfXCEndV   = 180.0

  
;   thick=4
;   res@tmXBMajorThicknessF = thick
;   res@tmYLMajorThicknessF = thick
;   res@tmXBMinorThicknessF = thick
;   res@tmYLMinorThicknessF = thick
;   res@tmBorderThicknessF = thick
   res@tmXBLabelFontHeightF = .015
;
    res@lbLabelBarOn = True

;   ps = PS(n,:,:)
;    if ( "Pa" .ne. ps@units) then
;      print("converting ps to Pascals")
;      ps=ps*100
;      ps@units="Pa"
;    end if

;   hyam = f->hyam
;   hybm = f->hybm
;   pnew = (/ 700 /)

;    ; type of interpolation: 1 = linear, 2 = log, 3 = loglog
;    interp = 2
;    ; is extrapolation desired if data is outside the range of PS
;    extrap = False
;    P0mb = 1000

;  gsn_define_colormap(wks,"WhViBlGrYeOrRe")
   gsn_define_colormap(wks,"BlRe")
;  res@gsnSpreadColorStart = 2
;  res@gsnSpreadColorEnd   = -4


; gsn_define_colormap(wks,"gui_default")
   res@tiMainString    = "DG: Galewsky_Vorticity, Res:"+hdeg+"deg, Day="+time(n)+"."
;  res@tiMainString    = "HOMME/DG-SW: Vorticity Fields"

    var = vorti(n,:,:,:)
    print ("Vor x 10^5 min/max = "+min(var(0,:,:))+", "+max(var(0,:,:)) )
    res@cnMinLevelValF = -11.0
    res@cnMaxLevelValF = 11.0
    res@cnLevelSpacingF = 2.0
;   var@long_name = "geopotential height at 700 hPa"
;   var@units = "m"
    contour = gsn_csm_contour_map(wks,var(0,:,:),res)     ; Draw a contour plot.  ;

end do


end

