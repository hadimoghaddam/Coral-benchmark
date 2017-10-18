load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;************************************************************************
;	Vector Plot + Scalar Contour on Cubed Sphere Gemotry				 
;************************************************************************
;************************************************************************
;	Include NCL scripts libraries				 
;************************************************************************
;load "$NCARG_LIB/ncarg/nclscripts/csm/ccm_func.ncl"
;load "$NCARG_LIB/ncarg/nclscripts/csm/contributed.ncl"
;load "$NCARG_LIB/ncarg/nclscripts/csm/gsn_code.ncl"
;load "$NCARG_LIB/ncarg/nclscripts/csm/gsn_csm.ncl"
;load "$NCARG_LIB/ncarg/nclscripts/csm/popRemap.ncl"
;load "$NCARG_LIB/ncarg/nclscripts/csm/shea_util.ncl"
;load "$NCARG_LIB/ncarg/nclscripts/csm/sket_func.ncl"
;load "$NCARG_LIB/ncarg/nclscripts/csm/wind_rose.ncl"
;************************************************************************
; 	Main Program					 
;************************************************************************
begin
;************************************************************************ 
  fdat = "./ps.dat"
  xdat = "./csx.dat"
  ydat = "./csy.dat"
;************************************************************************
  m=65
  m2=33
  n=129
  k=21

  data = asciiread(fdat,(/m,n/),"float")

  tx = asciiread(xdat,(/6,k,k/),"float")
  ty = asciiread(ydat,(/6,k,k/),"float")

  r2d = 180.0/3.14159265

  tx(:,:,:) =tx(:,:,:)*r2d
  ty(:,:,:) =ty(:,:,:)*r2d

  xl     = new((/n/),float)
  yl     = new((/m/),float)
  y2     = new((/m2/),float)
  yp     = new((/n/),float)

  aa     = new((/k/),float)
  bb     = new((/k/),float)

    do i = 0, n-1
     xl(i) = i * (360./(n-1)) - 180.
     yp(i) = 0.0        
    end do

    do j = 0, m-1
     yl(j) = j * (180./(m-1)) - 90.
    end do

    do j = 0, m2-1
     y2(j) = j * (90./(m2-1))
    end do
;************************************************************************
  ff      = new((/m,n/),float)
  ff(:,:) = data(:,:) /100.0   - 1000.0
  
  f2      = new((/m2,n/),float)

    do i = 0, n-1
    do j = 0, m2-1
      f2(j,i) = data(32+j,i) 
    end do
    end do
;************************************************************************
; Create a workstation.
;************************************************************************
  NCGM=0
  X11 =1
  PS  =0
  PDF =0
  if (NCGM .eq. 1) then
    wks = gsn_open_wks("ncgm","primdg")
  end if
  if (X11 .eq. 1) then
    wks = gsn_open_wks("x11","primdg")
  end if
  if (PS .eq. 1) then
    wks = gsn_open_wks("ps","primdg")
  end if
  if (PDF .eq. 1) then
    wks = gsn_open_wks("pdf","primdg")
  end if

;************************************************************************
;  Define a color map.
;************************************************************************
; To see the various colormaps, go to:
;
; http://www.ncl.ucar.edu/Document/Graphics/color_table_gallery.shtml
;
;************************************************************************
;	LineColor = 0  => white
;	LineColor = 1  => black
;	LineColor = 2  => red
;	LineColor = 3  => green
;	LineColor = 4  => blue
;	LineColor = 5  => yellow
;	LineColor = 6  => light blue
;	LineColor = 7  => pink
;	LineColor = 8  => brown
;************************************************************************
  cmap = (/                      \
            (/ 0., 0., 0. /),    \
            (/ 1., 1., 1. /),    \
            (/ 0., 1., 1. /),    \
            (/ 1., 1., 0. /),    \
            (/ 1., 0., 0. /),    \
            (/ 0., 1., 0. /),    \
            (/ 0., .8, 0. /)     \
         /) 
; gsn_define_colormap(wks,cmap)
; gsn_define_colormap(wks,"BlAqGrYeOrRe")
; gsn_define_colormap(wks,"rainbow+white")
; gsn_define_colormap(wks,"WhViBlGrYeOrReWh")
; gsn_define_colormap(wks,"WhBlReWh")
; gsn_define_colormap(wks,"WhViBlGrYeOrRe")
; gsn_define_colormap(wks,"BlAqGrYeOrReVi200")
; gsn_define_colormap(wks,"hotres")
 gsn_define_colormap(wks,"rainbow")
; gsn_reverse_colormap(wks)
;************************************************************************
; To make background color to white
;************************************************************************
;    setvalues wks
;  "wkBackgroundColor" : (/ 0.0,0.0,0.0 /)
;    end setvalues
;************************************************************************
;  Define some resources and draw a globe as a background for 
;  the plot.
;************************************************************************
  map_resources = True
  map_resources@gsnFrame = False
  map_resources@gsnMaximize = True
  map_resources@gsnSpreadColors= True              ; Use full colormap, but start
  
  map_resources@cnFillOn            = True         ; Turn on contour fill
  map_resources@cnFillMode          = "AreaFill"   ; Style of fill. You can also
                                                   ; use "CellFill" and "RasterFill"
  map_resources@cnLinesOn           = True         ; Turn off contour lines
  map_resources@cnLineLabelsOn      = False        ; Turn off contour line labels

  map_resources@lbLabelAutoStride   = True         ; Clean up labelbar labels.
  map_resources@lbBoxLinesOn        = False        ; Turn of labelbar box lines.
;************************************************************************
  map_resources = True
  map_resources@gsnFrame = False
  map_resources@mpGridAndLimbOn= True
  map_resources@mpGridSpacingF = 45.0
  map_resources@mpGridLineDashPattern = 2
  map_resources@mpLimbLineColor = 6
  map_resources@mpGridLineColor = 1
  map_resources@mpGreatCircleLinesOn = True
  
;  map_resources@wkBackgroundColor = 0

;  map_resources@mpProjection  = "Orthographic"  ; Change the map projection.
   map_resources@mpCenterLonF  =  0.0            ; Rotate the projection.
   map_resources@mpGridSpacingF= 90.0            ; lat/long grids 
   map_resources@mpOutlineOn   = False           ; No continents
   map_resources@mpFillOn      = False           ; Turn on map fill
   map_resources@mpShapeMode          = "FreeAspect"
; resources@mpFillColors = (/0,-1,28,-1/) ; Fill land and leave oceans
                                          ; and inland water transparent.

; map_resources@vpXF      = 0.1    ; Change the size and location of the
; map_resources@vpYF      = 0.9    ; plot on the viewport.
; map_resources@vpWidthF  = 0.8
; map_resources@vpHeightF = 0.8

;************************************************************************
; Contour line features
;************************************************************************
;************************************************************************
;  mnlvl =  998.2                    ; Minimum contour level.
;  mxlvl =  1001.20                  ; Maximum contour level.
;  spcng = 0.20                      ; Contour level spacing.
;  ncn   = (mxlvl-mnlvl)/spcng + 1   ; Number of contour levels.
;************************************************************************
  mnlvl= min(ff(:,:))
  mxlvl= max(ff(:,:))
  spcng= (mxlvl-mnlvl)/16.
;************************************************************************
 map_resources@cnLevelSelectionMode = "ManualLevels" ; Define your own
 map_resources@cnMinLevelValF       = mnlvl          ; contour levels.
 map_resources@cnMaxLevelValF       = mxlvl
 map_resources@cnLevelSpacingF      = spcng
;************************************************************************
  map_resources@cnInfoLabelOn        = False    ;No c-label box at the bottom 
  map_resources@cnLineLabelsOn       = False    ;No cotour labels 
  map_resources@cnInfoLabelPerimOn   = False
;************************************************************************
  map_resources@cnFillOn        = True               ; color plot desired
  map_resources@gsnSpreadColors = True               ; use full color table
 
  map_resources@pmLabelBarDisplayMode   = "Always"
  map_resources@pmLabelBarSide          = "Bottom"
  map_resources@lbOrientation           = "horizontal"
  map_resources@lbPerimOn               =  False
;  map_resources@pmLabelBarParallelPosF   =  .5
;  map_resources@pmLabelBarOrthogonalPosF =  .0
;  map_resources@pmLabelBarWidthF  =  .525
;  map_resources@pmLabelBarHeightF =  .125  
  map_resources@pmTickMarkDisplayMode = "Always"
;************************************************************************
; getvalues plot@contour
; "cnLevels" : levels
; end getvalues
;************************************************************************
  map_resources@lbLabelAutoStride   = True         ; Clean up labelbar labels.
  map_resources@lbBoxLinesOn        = False        ; Turn of labelbar box lines.
;  map_resources@lbLabelStrings = sprintf("%5.2f",1000)
  map_resources@lbLabelStride        = 2 
  map_resources@lbTitleFontThicknessF=.5
  map_resources@lbAutoManage = True
  map_resources@lbLabelFontHeightF   = .012
  map_resources@lbLabelAlignment = "InteriorEdges"

  map_resources@cnLineDashPattern    = 0     ; Solid line contours     
  map_resources@cnLineThicknessF     = 1.0   ; Double the line thickness.
; map_resources@cnMonoLineColor      = False ; Multicolor
;  map_resources@cnMonoLineColor     = True
  map_resources@cnLineColors         = 1 

  map_resources@cnLevelFlag       = True
  map_resources@cnFillOn          = True
; map_resources@cnFillDrawOrder   = PostDraw 
; map_resources@cnMonoFillPattern  = False
; map_resources@cnFillcolor  = False
; map_resources@cnFillPattern      = True

;************************************************************************
; Sticking the cotour plots on the map
;************************************************************************
map_resources@sfXArray              = xl   ; X axes data points
map_resources@sfYArray              = yl   ; Y axes data points
;map_resources@sfYArray              = y2   ; Y axes data points

  map_resources@sfXCStartV = -180.0         ; Define where contour plot
  map_resources@sfXCEndV   = 180.0         ; should lie on the map plot.
  map_resources@sfYCStartV = -90.0
; map_resources@sfYCStartV = 0.0
  map_resources@sfYCEndV   =  90.0

; map_resources@mpMinLatF = 0.0 
; map_resources@mpMaxLatF = 90.0 
; map_resources@mpMinLonF = -180.0 
; map_resources@mpMaxLonF =  180.0 

 map = gsn_contour_map(wks,ff,map_resources) ; Draw contours over a map.
; map = gsn_contour_map(wks,f2,map_resources) ; Draw contours over a map.
; plot = gsn_csm_contour_map_ce(wks,f2,map_resources)

;************************************************************************
;  Cubed-sphere features 
;************************************************************************
   gsres = True
   gsres@gsLineThicknessF = 1.
   gsres@gsLineColor = 30

;  do l=0,3 
;   do j=0,k-1,5
;    aa(:) = tx(l,j,:)
;    bb(:) = ty(l,j,:)
;     ; if ( j.eq.(k-1)) then
;      ; gsres@gsLineColor = 4
;     ; end if 
;    gsn_polyline(wks,map,aa,bb,gsres)
;   end do

;   do j=0,k-1,5
;    aa(:) = tx(l,:,j)
;    bb(:) = ty(l,:,j)
;    gsn_polyline(wks,map,aa,bb,gsres)
;   end do
;  end do


;************************************************************************
;  Legend
;************************************************************************
; txres = True
; txres@txFontHeightF = 0.025
; txres@txFontColor = 1
; txres@txJust = "CenterLeft"
; draw_box(wks, 0.02, 0.945, 0.12, 0.955, 2, gsres)
; gsn_text_ndc(wks, ":F22:Delaunay triangles", 0.14, 0.95, txres)
; draw_box(wks, 0.02, 0.895, 0.12, 0.905, 3, gsres)
; gsn_text_ndc(wks, ":F22:Voronoi polygons", 0.14, 0.90, txres)
; draw_box(wks, 0.02, 0.845, 0.12, 0.855, 4, gsres)
; gsn_text_ndc(wks, ":F22:Circumcircles", 0.14, 0.85, txres)

;************************************************************************
;  Title
;************************************************************************
  txres = True
  txres@txFontHeightF= 0.020
  txres@txFontColor  = 1
  txres@txJust = "CenterCenter"
  gsn_text_ndc(wks, "DGAM Surface Pressure Ps deviation (ps-1000)",0.5,0.83,txres)

  frame(wks)

;************************************************************************
end
;************************************************************************

