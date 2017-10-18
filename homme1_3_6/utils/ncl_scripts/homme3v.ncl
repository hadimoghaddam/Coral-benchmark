
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;=======================================================
function def_resav(ncount)
begin
  resav  = True

  resav@cnMaxLevelCount          = ncount
  resav@lbLabelAutoStride        = True         ; Clean up labelbar labels.
  resav@lbLabelStride            = ceil(ncount/4)
  resav@lbBoxLinesOn             = True        ; Turn on/of labelbar box lines.
  resav@lbLabelOffsetF           = 0.05
  resav@lbBottomMarginF          = -0.2

  resav@trYReverse               = True

  resav@gsnDraw                  = False
  resav@gsnFrame                 = False
; resav@gsnMaximize              = True         ; Maximize size of plot in frame

  resav@gsnSpreadColors          = True         ; Use full colormap, but start
  resav@gsnSpreadColorStart      = 24           ; at color index 24.
; resav@gsnPaperOrientation      = "portrait"
; resav@gsnYAxisIrregular2Linear = True

  resav@txFontHeightF          = 0.015 
  resav@tiMainFontHeightF      = 0.015              ; font height
  resav@tiXAxisFontHeightF     = 0.012
  resav@tiYAxisFontHeightF     = 0.012
  resav@tiXAxisOffsetYF        = 0.098

; resav@lgPerimOn              = False ; legend and turn off
; resav@lgLabelFontHeightF     = 0.018
; resav@lgJustification        = "TopCenter"

; resav@pmLegendZone           = 0    ; Change the location
; resav@pmLegendWidthF         = 0.20 ; Change width and
; resav@pmLegendHeightF        = 0.15  ; height of legend.
; resav@pmLegendDisplayMode    = "Always" ; Turn on drawing legend.
; resav@pmLegendSide           = "Top" ; Change location of 
; resav@pmLegendOrthogonalPosF = -0.20 ; of the legend
; resav@pmLegendParallelPosF   = 0.10

; resav@gsnPanelTop            = 0.7
; resav@gsnPanelRight          = 0.7
; resav@gsnPanelLeft           = 0.3
; resav@gsnPanelBottom         = 0.3
; resav@gsnPanelCenter         = True
; resav@gsnPanelLabelBar       = True                          ; common label bar

  resav@cnFillOn               = True         ; Turn on contour fill
  resav@cnFillMode             = "AreaFill"   ; Style of fill "CellFill"/"RasterFill"
  resav@cnLinesOn              = True         ; Turn off contour lines
  resav@cnLineLabelsOn         = False        ; Turn off contour line labels
  resav@cnSmoothingOn          = True 
 ;resav@tiYAxisOffsetXF        = 0.012
 ;resav@cnLevelSpacingF        = 5

 ;resav@sfXArray               = lon1d        ; Required to tell NCL where to
 ;resav@sfYArray               = lat1d        ; overlay data on globe. 

 ;resav@mpOutlineOn            = False 
 ;resav@mpFillOn               = False 
 ;resav@mpCenterLonF           = 90.0 
 ;resav@mpShapeMode            = "FreeAspect"

  return(resav)
 end 

;======================================================= 

function def_res(lon1d,lat1d,docontour,wind,stream)
 begin
 res                     = True
;res@gsnMaximize         = True         ; Maximize size of plot in frame
 res@gsnSpreadColors     = True         ; Use full colormap, but start
 res@gsnSpreadColorStart = 24           ; at color index 24. 
 res@cnFillOn            = True         ; Turn on contour fill
 res@cnFillMode          = "AreaFill"   ; Style of fill. also use "CellFill" and "RasterFill"
 res@cnLinesOn           = False        ; Turn off contour lines
 res@cnLineLabelsOn      = False        ; Turn off contour line labels
 res@lbLabelAutoStride   = True         ; Clean up labelbar labels. 
 res@lbBoxLinesOn        = False        ; Turn of labelbar box lines.
 if(docontour) then 
   res@sfXArray            = lon1d        ; Required to tell NCL where to
   res@sfYArray            = lat1d        ; overlay data on globe. 
;  res@cnLevelSelectionMode = "ManualLevels" ;   
;  res@cnMinLevelValF = 999.5 ;   
;  res@cnMaxLevelValF = 1000.25 ;   
;  res@cnLevelSpacingF = (res@cnMaxLevelValF-res@cnMinLevelValF)/10.  ;   
;  res@cnLevelSpacingF = 0.25
   res@mpOutlineOn          = False
   res@mpFillOn             = False
   res@mpCenterLonF         = 90.0
   res@mpShapeMode          = "FreeAspect"
 end if
 if(wind) then
   res@gsnFrame=False    
   wmsetp("wdf", 1); barbs point toward wind direction
 end if
 if(stream) then
   if(docontour) then
   res@gsnDraw = False
   res@gsnFrame= False    
 end if
 end if
 return(res)
 end 

;======================================================= 

function def_res2(plon,plat,docontour,wind,stream) 
begin
 if(stream) then
 res2=True
 res2@gsnMaximize         = True
 res2@vfXArray = plon
 res2@vfYArray = plat
 if(docontour) then
 res2@gsnFrame=False    
 res2@gsnDraw = False
 else
 res2@mpOutlineOn          = False
 res2@mpFillOn             = False
 res2@mpCenterLonF         = 90.0
 res2@mpShapeMode          = "FreeAspect"
 end if
 end if
 return(res2)
 end

;=======================================================

 begin
 fnames =  systemfunc("ls aquaplanet.nc")
 if(ismissing(fnames)) then
 delete(fnames)
 fnames = systemfunc("ls aquaplanet.nc")
 else
 print("Reading combined data file "+fnames(0))
 end if
 f      = addfiles(fnames,"r")       ; Open netCDF files.	

; change the name of the field to plot here 
; current field names are Q, ps, ke, u, v, T, zeta - names are case sensitive 
; "wind" or "stream" to get a graph of barbs or streamlines only (without contour overlay) 

  field = "v" 
  model = "homme"
; 
  wind = True    
; JPE wind vectors not working yet.  
  wind = False 
  wscale = 100.  
; scale the wind speed by this factor wsample = 1    
; sample the winds by this factor 
; stream = True  
; plot streamlines over contours (choose this or wind)
  stream = False

if(field .eq. "S") then
  surface=True
  zonalav=False
  docontour=False
else
  surface=False
  zonalav=True
  docontour=True
end if

  timezonalav=False

 if(field.eq."wind") then
   wind=True
   docontour=False
 end if

 if(field.eq."stream") then
   stream=True
   docontour=False
 end if

 if(stream .and. wind) then
   print("Cannot specify both streamlines and wind barbs "+field)
   exit
 end if 

; 
; Open a file to send output to. You can use "ps", "pdf", "x11", or "ncgm".  
; output_format = "x11" 
  output_format = "ncgm"

   fcnt = dimsizes(fnames)
   vcnt=new((/fcnt,4/),"integer")
   do i=0,fcnt-1
   vcnt(i,:) = getfiledimsizes(f[i])
   end do	   

; ntimes = vcnt(0,2)
; nlev = vcnt(0,1)
; nxy = dim_sum(vcnt(:,0)) 

  ntimes = vcnt(0,0)
  nlev = vcnt(0,2)
  nxy = dim_sum(vcnt(:,1)) 

; change the levels and or times to plot here 
  firsttime=0 
  lasttime=ntimes-1 
  timeinc=7 
  firstlev0=1 
  lastlev0=19 
  levinc=9 

 if(wind .or. stream) then
  u = new((/ntimes,nlev,nxy/),"float")
  v = new((/ntimes,nlev,nxy/),"float")
 end if

;----------------------------------------------- 

 lat1d=doubletofloat(f[:]->latP)*180.0/3.146264371
 lon1d=doubletofloat(f[:]->lonP)*180.0/3.146264371

 if(model.eq."eulag") then
   nxzav = 32
   nyzav = 16
   nzav  = 51
   zhighav =  25.*fspan(0.,1.,nzav)
 end if
 if(model.eq."homme") then
   nxzav = 90
   nyzav = 45
 end if
 plonzav = 360.*fspan(0.,1.,nxzav)
 platzav =  90.*fspan(-1.,1.,nyzav)

 if(docontour) then
  varxy = new((/ntimes,nlev,nyzav,nxzav/),"float")
 end if 

 if(surface) then
  varxy6 = new((/ntimes,6,nyzav,nxzav/),"float")
 end if 

 if(zonalav) then
  varxy1 = new((/ntimes,1,nyzav,nxzav/),"float")
 end if 
 
 nxe=0 
 
;  hyam=doubletofloat(f[0]->hyam(firstlev0:lastlev0:levinc)) 
;  ps0 = doubletofloat(hyam@ps0) 
;  hybm=doubletofloat(f[0]->hybm(firstlev0:lastlev0:levinc))

;----------------------------------------------- 

do n=firsttime,lasttime,timeinc
 icheck=0
 if (zonalav) then
 if(field .eq.  "ps") then
   varxy1(n,0,:,:)= triple2grid(lon1d,lat1d,doubletofloat(f[:]->ps(n,:)),plonzav,platzav,False)
   firstlev=0
   lastlev=0
   icheck=1
 end if
 if(field .eq.  "udrg") then
   varxy1(n,0,:,:)= triple2grid(lon1d,lat1d,doubletofloat(f[:]->udrg(n,:)),plonzav,platzav,False)
   firstlev=0
   lastlev=0
   icheck=1
 end if
 if(field .eq.  "vdrg") then
   varxy1(n,0,:,:)= triple2grid(lon1d,lat1d,doubletofloat(f[:]->vdrg(n,:)),plonzav,platzav,False)
   firstlev=0
   lastlev=0
   icheck=1
 end if
 if(field .eq.  "tsfl") then
   varxy1(n,0,:,:)= triple2grid(lon1d,lat1d,doubletofloat(f[:]->tsfl(n,:)),plonzav,platzav,False)
   firstlev=0
   lastlev=0
   icheck=1
 end if
 if(field .eq.  "qslf") then
   varxy1(n,0,:,:)= triple2grid(lon1d,lat1d,doubletofloat(f[:]->qsfl(n,:)),plonzav,platzav,False)
   firstlev=0
   lastlev=0
   icheck=1
 end if
 if(field .eq.  "prec") then
   varxy1(n,0,:,:)= triple2grid(lon1d,lat1d,doubletofloat(f[:]->prec(n,:)),plonzav,platzav,False)
   firstlev=0
   lastlev=0
   icheck=1
 end if

 if(icheck .eq. 0) then
 if(docontour) then
   do k=firstlev0,lastlev0,levinc
     kk=nlev-1-k
     varxy(n,kk,:,:)=triple2grid(lon1d,lat1d,doubletofloat(f[:]->$field$(n,k,:)),plonzav,platzav,False)
   end do
   firstlev=firstlev0
    lastlev=lastlev0
 end if
 end if
 end if

 if(surface) then
   firstlev=0
   lastlev=0
   varxy6(n,0,:,:)= triple2grid(lon1d,lat1d,doubletofloat(f[:]->ps(  n,:)),plonzav,platzav,False)
   varxy6(n,1,:,:)= triple2grid(lon1d,lat1d,doubletofloat(f[:]->udrg(n,:)),plonzav,platzav,False)
   varxy6(n,2,:,:)= triple2grid(lon1d,lat1d,doubletofloat(f[:]->vdrg(n,:)),plonzav,platzav,False)
   varxy6(n,3,:,:)= triple2grid(lon1d,lat1d,doubletofloat(f[:]->tsfl(n,:)),plonzav,platzav,False)
   varxy6(n,4,:,:)= triple2grid(lon1d,lat1d,doubletofloat(f[:]->qsfl(n,:)),plonzav,platzav,False)
   varxy6(n,5,:,:)= triple2grid(lon1d,lat1d,doubletofloat(f[:]->prec(n,:)),plonzav,platzav,False)
 end if

 if(wind .or. stream) then
  do k=firstlev0,lastlev0,levinc
   kk=nlev-1-k
   u(n,kk,:)=wscale*doubletofloat(f[:]->u(n,k,:))
   v(n,kk,:)=wscale*doubletofloat(f[:]->v(n,k,:))
  end do
  firstlev=firstlev0
   lastlev=lastlev0
 end if

 end do
;-----------------------------------------------
 if(stream) then
    if(model.eq."eulag") then
      nx = 32
      ny = 16
    end if
    if(model.eq."homme") then
      nx = 90
      ny = 45
    end if
    plon = 360.*fspan(0.,1.,nx)
    plat =  90.*fspan(-1.,1.,ny)
 end if 
;  print(min(plat)+" "+max(plat)+" "+min(plon)+" "+max(plon))
;-----------------------------------------------
;-----------------------------------------------
;-----------------------------------------------
;-----------------------------------------------
 if(timezonalav) then
    if(model.eq."eulag") then
      nxzav = 32
      nyzav = 16
    end if
    if(model.eq."homme") then
      nxzav = 90
      nyzav = 45
    end if
    plonzav = 360.*fspan(0.,1.,nxzav)
    platzav =  90.*fspan(-1.,1.,nyzav)
    vav = new((/ntimes,nlev,nyzav,nxzav/),"float")
    tzavg = new((/nlev,nyzav/),"float")
    tav = new((/nlev,nyzav,ntimes/),"float")

    do n=0,lasttime,1
    print(n+" time lev")
     do k=0,nlev-1,1
     vav(n,k,:,:)=triple2grid(lon1d,lat1d,doubletofloat(f[:]->$field$(n,k,:)),plonzav,platzav,False)
     end do
    end do
    zavg = dim_avg(vav)

    tzavg(:,:)=0
    do n=0,lasttime,1
     tzavg(:,:)=tzavg(:,:)+zavg(n,:,:)
    end do
    tzavg(:,:)=tzavg(:,:)/(lasttime+1)

    resav=def_resav(10)
    resav@tiMainString   = field+" time zonal average up to "+time(lasttime)+" days"
    resav@vpXF                   = 0.55  ;left edge of the viewport bounding box
    resav@vpYF                   = 0.46  ;top edge of the viewport bounding box
    resav@vpWidthF               = 0.40  ;width of the viewport bounding box
    resav@vpHeightF              = 0.30  ;height of the viewport bounding box
    resav@tiYAxisString          = " "
    resav@sfXArray               = platzav 
    contour = gsn_csm_contour(wks,tzavg,resav)
    draw(contour)
    frame(wks)

 end if
;-----------------------------------------------
;-----------------------------------------------
;-----------------------------------------------
;-----------------------------------------------
 time = f[0]->Time
;
; It will also look for a "homme.res" file, where you can set 
; resources that you want set all the time, like the font, or
; the background/foreground colors.
;
 
  filename= field+".T"+time(lasttime)+".K"+firstlev0+"_"+lastlev0
  wks = gsn_open_wks(output_format,filename)
  print ("Writing file "+filename+"."+output_format)
;---------------------------------------------------------------------
; The first call below selects a colormap, and the second reverses it.
; The colors go from violet at the low valus to blue at the high
; values.
;
; To see the various colormaps, go to:
;
; http://ngwww.ucar.edu/ncl/coltable.html
;
; gsn_define_colormap(wks,"BlWhRe")                
; gsn_define_colormap(wks,"temp1")
  gsn_define_colormap(wks,"BlAqGrYeOrRe")
; gsn_define_colormap(wks,"BlAqGrYeOrReVi200")
; gsn_reverse_colormap(wks)

;---------------------------------------------------------------------
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
;---------------------------------------------------------------------

;-----------------------------------------------
;-----------------------------------------------
;-----------------------------------------------
;-----------------------------------------------
  if(zonalav) then

    plev= new((/20/),"float")
    zlev= new((/20/),"float")

   ;if(model.eq."homme") then

    plev(19-0 )=  25.0
    plev(19-1 )=  75.0
    plev(19-2 )= 125.0
    plev(19-3 )= 175.0
    plev(19-4 )= 225.0
    plev(19-5 )= 275.0
    plev(19-6 )= 325.0
    plev(19-7 )= 375.0
    plev(19-8 )= 425.0
    plev(19-9 )= 475.0
    plev(19-10)= 525.0
    plev(19-11)= 575.0
    plev(19-12)= 625.0
    plev(19-13)= 675.0
    plev(19-14)= 725.0
    plev(19-15)= 775.0
    plev(19-16)= 825.0
    plev(19-17)= 875.0
    plev(19-18)= 925.0
    plev(19-19)= 975.0

    zlev(19-0 )= 24094.707
    zlev(19-1 )= 17721.964
    zlev(19-2 )= 14758.805
    zlev(19-3 )= 12799.006
    zlev(19-4 )= 11241.229
    zlev(19-5 )=  9925.526
    zlev(19-6 )=  8777.678
    zlev(19-7 )=  7756.084
    zlev(19-8 )=  6834.952
    zlev(19-9 )=  5993.625
    zlev(19-10)=  5219.701
    zlev(19-11)=  4503.492
    zlev(19-12)=  3836.961
    zlev(19-13)=  3213.130
    zlev(19-14)=  2625.633
    zlev(19-15)=  2069.887
    zlev(19-16)=  1542.451
    zlev(19-17)=  1041.305
    zlev(19-18)=   564.194
    zlev(19-19)=   108.321
    zlev=zlev/1000.
   ;end if

    print(min(platzav)+" "+max(platzav)+" "+min(plonzav)+" "+max(plonzav))

    vav = new((/ntimes,nlev,nyzav,nxzav/),"float")
    vav0= new((/ntimes,nlev,nyzav,nxzav/),"float")
    vavpl = new((/nlev,nxzav/),"float")
    tzavg = new((/nlev,nyzav/),"float")
    tav = new((/nlev,nyzav,ntimes/),"float")

    do n=firsttime,lasttime,timeinc
    print(n+" time lev")
     if(icheck.eq.0) then
     do k=0,nlev-1,1
     kk=nlev-1-k
     vav0(n,k,:,:)=triple2grid(lon1d,lat1d,doubletofloat(f[:]->$field$(n,k,:)),plonzav,platzav,False)
     vav(n,kk,:,:)=vav0(n,k,:,:)
     end do
     else
     vav(n,0,:,:)=triple2grid(lon1d,lat1d,doubletofloat(f[:]->$field$(n,:)),plonzav,platzav,False)
     end if
    end do
    zavg = dim_avg(vav0)


    do k=firstlev,lastlev,levinc
    restmp  = True
    restmp@cnLevelSelectionMode = "ManualLevels"
    restmp@cnLevelSelectionMode = "AutomaticLevels"
    restmp@cnMinLevelValF = min(zavg(firsttime:lasttime:timeinc,:,:))
    restmp@cnMaxLevelValF = max(zavg(firsttime:lasttime:timeinc,:,:))

    do n=firsttime,lasttime,timeinc
    ilong=floattointeger(plonzav(floattointeger(nxzav/2)))
    resav1=def_resav(10)
    resav1@tiMainString = field+" Z/lat lon="+ilong+" time="+time(n)+" days"
    resav1@tiXAxisString          = "latitude [deg]"           ; x-axis label
    resav1@sfXArray               = platzav 
    if(model.eq."homme") then
      resav1@tiYAxisString          = "height-levels (pressure)" ; z-axis label
      resav1@sfYArray               = plev 
    end if
    if(model.eq."eulag") then
      resav1@tiYAxisString          = "height [km]" ; z-axis label
      resav1@sfYArray               = zhighav
    end if
    resav1@vpXF                   = 0.08  ;left edge of the viewport bounding box
    resav1@vpYF                   = 0.46  ;top edge of the viewport bounding box
    resav1@vpWidthF               = 0.40  ;width of the viewport bounding box
    resav1@vpHeightF              = 0.30  ;height of the viewport bounding box
;   resav1@trYReverse             = False
    resav1@cnLevelSelectionMode = restmp@cnLevelSelectionMode
    resav1@cnMinLevelValF =       restmp@cnMinLevelValF
    resav1@cnMaxLevelValF =       restmp@cnMaxLevelValF

    vavyz=vav(n,:,:,floattointeger(nxzav/2))
    contour1 = gsn_csm_contour(wks,vavyz,resav1)

    resav2=def_resav(10)
    resav2@tiMainString   = field+" zonal average at time="+time(n)+" days"
    resav2@tiXAxisString          = "latitude [deg]"           ; x-axis label
    if(model.eq."homme") then
      resav2@tiYAxisString          = " "
;     resav2@trYReverse             = False
;     resav2@sfYArray               = zlev 
    end if
    if(model.eq."eulag") then
      resav2@tiYAxisString          = "height [km]" ; z-axis label
      resav2@trYReverse             = False
      resav2@sfYArray               = zhighav
    end if
    resav2@vpXF                   = 0.55  ;left edge of the viewport bounding box
    resav2@vpYF                   = 0.46  ;top edge of the viewport bounding box
    resav2@vpWidthF               = 0.40  ;width of the viewport bounding box
    resav2@vpHeightF              = 0.30  ;height of the viewport bounding box
    resav2@sfXArray               = platzav 
    resav2@cnLevelSelectionMode = restmp@cnLevelSelectionMode
    resav2@cnMinLevelValF =       restmp@cnMinLevelValF
    resav2@cnMaxLevelValF =       restmp@cnMaxLevelValF


;   resav2@tmYROn                  =  True
;   resav2@tmYLOn                  =  True
;   resav2@tmYUseLeft              =  True
;   resav2@tmYLMajorLengthF        =  .01
;   resav2@tmYLMajorOutwardLengthF =  .01
;   resav2@tmYLMode                =  "Explicit"
;   resav2@tmYLValues              =  (/-90.,-80.,-70.,-60.,-50./)
;   resav2@tmYLLabels              =  (/"-90.","-80.","-70.","-60.","-50."/)
;   resav2@tmYLLabelsOn            =  True
;   resav2@tmYLLabelFontColor      = "blue"

    contour2 = gsn_csm_contour(wks,zavg(n,:,:),resav2)

    ilat=floattointeger(platzav(nyzav/2))
    resav3=def_resav(10)
    resav3@tiMainString = field+" Z/lon lat="+ilat+" time="+time(n)+" days"
    resav3@tiXAxisString          = "longitude [deg]"           ; x-axis label
    if(model.eq."homme") then
      resav3@tiYAxisString          = " "
      resav3@sfYArray               = zlev 
    end if
    if(model.eq."eulag") then
      resav3@tiYAxisString          = "height [km]" ; z-axis label
      resav3@sfYArray               = zhighav
    end if
    resav3@vpXF                   = 0.55  ;left edge of the viewport bounding box
    resav3@vpYF                   = 0.955  ;top edge of the viewport bounding box
    resav3@vpWidthF               = 0.40  ;width of the viewport bounding box
    resav3@vpHeightF              = 0.30  ;height of the viewport bounding box
    resav3@sfXArray               = plonzav 
    resav3@trYReverse             = False
    resav3@cnLevelSelectionMode = restmp@cnLevelSelectionMode
    resav3@cnMinLevelValF =       restmp@cnMinLevelValF
    resav3@cnMaxLevelValF =       restmp@cnMaxLevelValF
    vavxz=vav(n,:,floattointeger(nyzav/2),:)
    contour3 = gsn_csm_contour(wks,vavxz,resav3)

    kk=nlev-1-k
    resav4=def_resav(6)
    resav4@tiMainString           = field+" at level = "+k+" time="+time(n)+" days"    ;
    resav4@tiXAxisString          = "longitude [deg]"           ; x-axis label
    resav4@tiYAxisString          = "latitude [deg]"
    resav4@vpXF                   = 0.08  ;left edge of the viewport bounding box
    resav4@vpYF                   = 0.955  ;top edge of the viewport bounding box
    resav4@vpWidthF               = 0.40  ;width of the viewport bounding box
    resav4@vpHeightF              = 0.30  ;height of the viewport bounding box
    resav4@sfXArray               = plonzav 
    resav4@sfYArray               = platzav 
    resav4@trYReverse             = False
    resav4@cnLevelSelectionMode = restmp@cnLevelSelectionMode
    resav4@cnMinLevelValF =       restmp@cnMinLevelValF
    resav4@cnMaxLevelValF =       restmp@cnMaxLevelValF

    contour4 = gsn_csm_contour(wks,varxy(n,kk,:,:),resav4)
;   contour4 = gsn_csm_contour_map(wks,var(n,kk,:),resav4)     ; Draw a contour plot.

    draw(contour1)
    draw(contour2)
    draw(contour3)
    draw(contour4)

    frame(wks)
    end do
    end do

  end if

;-----------------------------------------------
  if(surface) then

    print(min(platzav)+" "+max(platzav)+" "+min(plonzav)+" "+max(plonzav))

    do n=firsttime,lasttime,timeinc
    ilong=floattointeger(plonzav(floattointeger(nxzav/2)))
    resav1=def_resav(5)
    resav1@tiMainString           = "U drag at surface time="+time(n)+" days"    ;
    resav1@tiXAxisString          = "longitude [deg]"           ; x-axis label
    resav1@tiYAxisString          = "latitude [deg]"
    resav1@sfXArray               = plonzav     ; Required to tell NCL where to
    resav1@sfYArray               = platzav     ; overlay data on globe. 
    resav1@vpXF                   = 0.08  ;left edge of the viewport bounding box
    resav1@vpYF                   = 0.46  ;top edge of the viewport bounding box
    resav1@vpWidthF               = 0.40  ;width of the viewport bounding box
    resav1@vpHeightF              = 0.30  ;height of the viewport bounding box
    resav1@trYReverse             = False

    contour1 = gsn_csm_contour(wks,varxy6(n,1,:,:),resav1)

    resav2=def_resav(5)
    resav2@tiMainString           = "Tsurf at surface time="+time(n)+" days"    ;
    resav2@tiXAxisString          = "longitude [deg]"           ; x-axis label
    resav2@tiYAxisString          = ""
    resav2@sfXArray               = plonzav     ; Required to tell NCL where to
    resav2@sfYArray               = platzav     ; overlay data on globe. 
    resav2@vpXF                   = 0.55  ;left edge of the viewport bounding box
    resav2@vpYF                   = 0.46  ;top edge of the viewport bounding box
    resav2@vpWidthF               = 0.40  ;width of the viewport bounding box
    resav2@vpHeightF              = 0.30  ;height of the viewport bounding box
    resav2@trYReverse             = False


;   resav2@tmYROn                  =  True
;   resav2@tmYLOn                  =  True
;   resav2@tmYUseLeft              =  True
;   resav2@tmYLMajorLengthF        =  .01
;   resav2@tmYLMajorOutwardLengthF =  .01
;   resav2@tmYLMode                =  "Explicit"
;   resav2@tmYLValues              =  (/-90.,-80.,-70.,-60.,-50./)
;   resav2@tmYLLabels              =  (/"-90.","-80.","-70.","-60.","-50."/)
;   resav2@tmYLLabelsOn            =  True
;   resav2@tmYLLabelFontColor      = "blue"

    contour2 = gsn_csm_contour(wks,varxy6(n,3,:,:),resav2)

    ilat=floattointeger(platzav(nyzav/2))
    resav3=def_resav(5)
    resav3@tiMainString           = "Qsurf at surface time="+time(n)+" days"    ;
    resav3@tiXAxisString          = "longitude [deg]"           ; x-axis label
    resav3@tiYAxisString          = ""
    resav3@sfXArray               = plonzav     ; Required to tell NCL where to
    resav3@sfYArray               = platzav     ; overlay data on globe. 
    resav3@vpXF                   = 0.55  ;left edge of the viewport bounding box
    resav3@vpYF                   = 0.955  ;top edge of the viewport bounding box
    resav3@vpWidthF               = 0.40  ;width of the viewport bounding box
    resav3@vpHeightF              = 0.30  ;height of the viewport bounding box
    resav3@trYReverse             = False
    contour3 = gsn_csm_contour(wks,varxy6(n,4,:,:),resav3)

    resav4=def_resav(5)
    resav4@tiMainString           = "Precip at surface time="+time(n)+" days"    ;
    resav4@tiXAxisString          = "longitude [deg]"           ; x-axis label
    resav4@tiYAxisString          = "latitude [deg]"
    resav4@sfXArray               = plonzav     ; Required to tell NCL where to
    resav4@sfYArray               = platzav     ; overlay data on globe. 
    resav4@vpXF                   = 0.08  ;left edge of the viewport bounding box
    resav4@vpYF                   = 0.955  ;top edge of the viewport bounding box
    resav4@vpWidthF               = 0.40  ;width of the viewport bounding box
    resav4@vpHeightF              = 0.30  ;height of the viewport bounding box
    resav4@trYReverse             = False

    contour4 = gsn_csm_contour(wks,varxy6(n,5,:,:),resav4)

    draw(contour1)
    draw(contour2)
    draw(contour3)
    draw(contour4)

    frame(wks)
    end do

  end if

; res =def_res(lon1d,lat1d,docontour,wind,stream)
; res =def_res(lon1d,lat1d,docontour,wind,stream)
; res@cnMinLevelValF = min(var(firsttime:lasttime:timeinc,firstlev:lastlev:levinc,:))
; res@cnMaxLevelValF = max(var(firsttime:lasttime:timeinc,firstlev:lastlev:levinc,:))
 
; if(docontour) then
; res=def_res(lon1d,lat1d,docontour,wind,stream)
; do k= firstlev,lastlev,levinc
;   do n = firsttime,lasttime,timeinc
;       res@vpXF                = 0.08  ;left edge of the viewport bounding box
;       res@vpYF                = 0.95  ;top edge of the viewport bounding box
;       res@vpWidthF            = 0.40  ;width of the viewport bounding box
;       res@vpHeightF           = 0.30  ;height of the viewport bounding box
;       res@tiYAxisString       = " "
;       res@tiMainString        = field+" at level = "+k+" time="+time(n)+" days"    ;
;
;       contour = gsn_csm_contour_map(wks,var(n,k,:),res)     ; Draw a contour plot.
;       draw(contour)
;   end do
; end do
; end if

; if(wind) then
; do k= firstlev,lastlev,levinc
;   do n = firsttime,lasttime,timeinc
;       wmbarbmap(wks,lat1d(::wsample), lon1d(::wsample), u(n,k,::wsample), v(n,k,::wsample))
;       frame(wks)
;   end do
; end do
; end if
;
; if (stream) then
; res2=def_res2(plat,plon,docontour,wind,stream)
; do k= firstlev,lastlev,levinc
;   do n = firsttime,lasttime,timeinc
;      	us = triple2grid(lon1d(::wsample),lat1d(::wsample),u(n,k,::wsample),plon,plat,False)
;       vs = triple2grid(lon1d(::wsample),lat1d(::wsample),v(n,k,::wsample),plon,plat,False)
;       if(docontour) then
;         strm = gsn_streamline(wks,us,vs,res2)
;         overlay(contour,strm)
;         draw(contour)
;         frame(wks)
;       else
;         strm = gsn_streamline_map(wks,us,vs,res2)
;       end if
;   end do
; end do
; end if

end
