load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl.test"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl.test"

begin
;  latlonsize = fbinrecread("movies.dry/aquaplanet.location",0,(/1/),"integer")

;  lat1d = fbinrecread("movies.dry/aquaplanet.location",1,(/latlonsize/),"double")
;  lon1d = fbinrecread("movies.dry/aquaplanet.location",2,(/latlonsize/),"double")

;  lat1d=lat1d*180.0/3.14
;  lon1d=lon1d*180.0/3.14

;  quad = fbinrecread("movies.dry/aquaplanet.Q.1.0",0,(/2/),"character")
;  intflds = fbinrecread("movies.dry/aquaplanet.Q.1.0",1,(/4/),"integer")

;  nlev = intflds(3)

;  fld = homme_read("movies.dry/aquaplanet.Q.1.0",latlonsize)
  

;  fld = new((/nlev,latlonsize/),double)

;  do n=0,nlev-1
;    print(n)
;    fld(n,:) = fbinrecread("movies.dry/aquaplanet.Q.1.0",n+2,(/latlonsize/),"double")
;  end do

;  ps1d=fld(10,:)

  fnames = systemfunc("ls movies/*.nc")
  f      = addfiles(fnames,"r")       ; Open netCDF files.	
  

  lat1d=f[:]->latP*180.0/3.14

  lon1d=f[:]->lonP*180.0/3.14
;  lattmp = ndtooned(f->lat2d)          ; Pull off lat/lon variable and
;  lontmp = ndtooned(f->lon2d)          ; convert both to 1D.

;  print ("minlat ="+min(lattmp)+" maxlat ="+max(lattmp))
;  print ("minlon ="+min(lontmp)+" maxlon ="+max(lontmp))

  print ("minlat ="+min(lat1d)+" maxlat ="+max(lat1d))	
  print ("minlon ="+min(lon1d)+" maxlon ="+max(lon1d))

  ps1d  = f[:]->Q(0,10,:)      ; Read some data; 

;
; Open a file to send output to. You can use "ps", "pdf", "x11",
; or "ncgm".
;
; It will also look for a "je-seam.res" file, where you can set 
; resources that you want set all the time, like the font, or
; the background/foreground colors.
;
  wks = gsn_open_wks("X11","je-seam")

;
; The first call below selects a colormap, and the second reverses it.
; The colors go from violet at the low valus to blue at the high
; values.
;
; To see the various colormaps, go to:
;
; http://ngwww.ucar.edu/ncl/coltable.html
;
  gsn_define_colormap(wks,"BlAqGrYeOrReVi200")
  gsn_reverse_colormap(wks)

;
; Set some plot resources.  Order doesn't matter here.
;
; Any time you don't want a plot drawn, just set the resources:
;
;  res@gsnDraw  = False
;  res@gsnFrame = False
;
; Of course, you'll have to remember to delete these resource
; settings or change them to True if you want later plots to
; be drawn.
;
  res                     = True
  res@gsnMaximize         = True         ; Maximize size of plot in frame
  res@gsnSpreadColors     = True         ; Use full colormap, but start
  res@gsnSpreadColorStart = 24           ; at color index 24.

  res@sfXArray            = lon1d        ; Required to tell NCL where to
  res@sfYArray            = lat1d        ; overlay data on globe.

  res@cnFillOn            = True         ; Turn on contour fill
  res@cnFillMode          = "AreaFill"   ; Style of fill. You can also
                                         ; use "CellFill" and "RasterFill"
  res@cnLinesOn           = False        ; Turn off contour lines
  res@cnLineLabelsOn      = False        ; Turn off contour line labels

  res@lbLabelAutoStride   = True         ; Clean up labelbar labels.
  res@lbBoxLinesOn        = False        ; Turn of labelbar box lines.

  res@tiMainString        = "SEAM grid surface pressure"    ; Title

  contour = gsn_csm_contour(wks,ps1d,res)     ; Draw a contour plot.

;
; Retrieve information from plot we just created so we can
; get ready to overlay on a map.  This part is not required
; for this example, because the plot covers the full globe. 
;
;  getvalues contour@data
;    "sfXCActualStartF" : xs
;    "sfXCActualEndF"   : xe
;    "sfYCActualStartF" : ys
;    "sfYCActualEndF"   : ye
;  end getvalues

  res@mpProjection          = "Orthographic"
  res@mpDataBaseVersion     = "MediumRes"      ; Improve the resolution
                                               ; of the map outlines 
                                               ; Default is "LowRes".
;
; For the same reason as above, these next 5 resources not required
; because we are covering the full globe.
;
;  res@mpLimitMode           = "LatLon"
;  res@mpMinLonF             = xs
;  res@mpMaxLonF             = xe
;  res@mpMinLatF             = ys
;  res@mpMaxLatF             = ye

  res@mpPerimOn             = False       ; Turn off map perimeter
  res@mpCenterLatF          =  40         ; Rotate map.
  res@mpCenterLonF          = -130

  res@pmTickMarkDisplayMode = "Always"    ; Turn on map tickmarks

  map = gsn_csm_contour_map(wks,ps1d,res)   ; Draw contours over a map.

;
; Try some other contour resource settings to show how the
; contour fill can be adjusted.
;
  res@cnFillMode      = "RasterFill"
  res@cnMaxLevelCount = 255 

  map = gsn_csm_contour_map(wks,ps1d,res)

;
; Change the map projection.
;
  res@mpProjection = "CylindricalEquidistant"
  res@mpCenterLatF = 0
  map = gsn_csm_contour_map_ce(wks,ps1d,res)

;
; Turn on smoothing.
;
  res@cnRasterSmoothingOn = True
  res@tiMainString        = "Surface pressure with smoothing on" 

  map = gsn_csm_contour_map_ce(wks,ps1d,res)

;
; Change the map projection again.
;
  res@mpProjection = "LambertEqualArea"
  res@mpCenterLatF = 40
  map = gsn_csm_contour_map(wks,ps1d,res)
end

