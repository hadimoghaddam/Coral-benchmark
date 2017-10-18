
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
  fname =  systemfunc("ls movies/*1.nc")

  f      = addfile(fname,"r")       ; Open netCDF files.	

  ; change the name of the field to plot here
  ; current field names are Q, ps, ke, u, v, T, zeta - names are case sensitive
  ; prec, accum
  ; "wind" or "stream" to get a graph of barbs or streamlines only (without contour overlay)
  
  field = "T"
; JPE wind vectors not working yet.
;  wind = True
  wind = False
; scale the wind speed by this factor
  wscale = 100.
;  sample the winds by this factor
  wsample = 1

; plot streamlines over contours (choose this or wind)
;  stream = True
  stream = False

  docontour=True
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
; Open a file to send output to. You can use "ps", "pdf", "x11",
; or "ncgm".
;
  output_format = "ncgm"



  vcnt = getfiledimsizes(f)
  
  ntimes = vcnt(4)
  nlev = vcnt(2)
  nlon = vcnt(0)
  nlat = vcnt(1)

; change the levels and or times to plot here
  firsttime=0
  lasttime=ntimes-1
;  lasttime=6
  timeinc=1

 print ("ntimes="+ntimes+" nlev="+nlev+" nlon="+nlon+" nlat="+nlat)

  firstlev=nlev-1
  lastlev=nlev-1
  levinc=2
  if(wind .or. stream) then	
    u = new((/ntimes,nlev,nlat,nlon/),"float")
    v = new((/ntimes,nlev,nlat,nlon/),"float")
  end if
  if(docontour) then
    var = new((/ntimes,nlev,nlat,nlon/),"float")
  end if

  nxe=0

  fieldis2d = False
  if(field .eq. "ps" .or. field .eq. "prec" .or. field .eq. "accum") then
    fieldis2d = True
  end if
  if(field .eq. "udrag" .or. field .eq. "vdrag" .or. field .eq. "tsflx" .or. field .eq. "qsflx") then
    fieldis2d = True
  end if
  do n=firsttime,lasttime,timeinc
    if(fieldis2d) then
      varmin = 1.e9
      varmax = -1.
       var(n,0,:,:)= doubletofloat(f->$field$(n,:,:))
       copyatt(var,f->$field$)
       firstlev=0
       lastlev=0
;       do k=0,nxy-1
;         if(var(n,0,k) .lt. varmin) then
;           varmin = var(n,0,k)
;           kvarmin = k
;         end if
;         if(var(n,0,k) .gt. varmax) then
;           varmax = var(n,0,k)
;           kvarmax = k
;         end if
;        end do
;        print ("varmin("+kvarmin+")="+varmin+" lat,lon "+lat1d(kvarmin)+", "+lon1d(kvarmin))
;        print ("varmax("+kvarmax+")="+varmax+" lat,lon "+lat1d(kvarmax)+", "+lon1d(kvarmax))
    else
      if(docontour) then
        
        do k=firstlev,lastlev,levinc
	  var(n,k,:,:)=doubletofloat(f->$field$(n,k,:,:))
        end do
        copyatt( var, f->$field$ )
      end if
    end if
    if(wind.or.stream) then
      do k=firstlev,lastlev,levinc
	u(n,k,:,:)=wscale*doubletofloat(f->u(n,k,:,:))
	v(n,k,:,:)=wscale*doubletofloat(f->v(n,k,:,:))
      end do
    end if


  end do


 
  time = f->time
;
; It will also look for a "homme.res" file, where you can set 
; resources that you want set all the time, like the font, or
; the background/foreground colors.
;
 
  wks = gsn_open_wks(output_format,field)
  print ("Writing file "+field+"."+output_format)
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
;  gsn_reverse_colormap(wks)

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
;  res@gsnSpreadColorStart = 24           ; at color index 24.

  res@cnFillOn            = True         ; Turn on contour fill
;  res@cnFillMode          = "AreaFill"   ; Style of fill. You can also
                                         ; use "CellFill" and "RasterFill"
  res@cnLinesOn           = False        ; Turn off contour lines
  res@cnLineLabelsOn      = False        ; Turn off contour line labels

  res@lbLabelAutoStride   = True         ; Clean up labelbar labels.
  res@lbBoxLinesOn        = False        ; Turn of labelbar box lines.

  if(docontour) then  
;    res@sfXArray            = lon       ; Required to tell NCL where to
;    res@sfYArray            = lat        ; overlay data on globe.
;    res@sfXCStartV = min(lon)
;    res@sfXSEndV=max(lon)
;    res@sfYCStartV = min(lat)
;    res@sfYSEndV=max(lat)

    res@cnLevelSelectionMode = "ManualLevels"

;    res@cnMinLevelValF = 0.0025
;    res@cnMaxLevelValF = 0.0048 
;    res@cnLevelSpacingF = 0.25
  
    res@mpOutlineOn          = False
    res@mpFillOn             = False
    res@mpCenterLonF         = 0.0
;    res@mpShapeMode          = "FreeAspect"
  end if
  if(wind) then
    res@gsnFrame=False     
    wmsetp("wdf", 1); barbs point toward wind direction
  end if
  if(stream) then
    res2=True
    res2@gsnMaximize         = True 
    res2@vfXArray = plon
    res2@vfYArray = plat

    if(docontour) then
      res2@gsnFrame=False     
      res2@gsnDraw = False
      res@gsnDraw = False
      res@gsnFrame=False     
    else
      res2@mpOutlineOn          = False
      res2@mpFillOn             = False
      res2@mpCenterLonF         = 90.0
      res2@mpShapeMode          = "FreeAspect"
    end if
  end if

  do k= firstlev,lastlev,levinc
    res@cnMinLevelValF = min(var(firsttime:lasttime:timeinc,k,:,:))
    res@cnMaxLevelValF = max(var(firsttime:lasttime:timeinc,k,:,:))
    res@cnLevelSpacingF = (res@cnMaxLevelValF-res@cnMinLevelValF)/16.
    print(res@cnMinLevelValF+" "+res@cnMaxLevelValF) 
    do n = firsttime,lasttime,timeinc
 
;    res@cnMinLevelValF = min(var(n,k,:))
;    res@cnMaxLevelValF = max(var(n,k,:))
;    res@cnLevelSpacingF = (res@cnMaxLevelValF-res@cnMinLevelValF)/32.
;    print(res@cnMinLevelValF+" "+res@cnMaxLevelValF) 

     if(docontour) then
        res@tiMainString        = field+" at level = "+k+" time="+time(n)+" days"    ;
        contour = gsn_csm_contour_map(wks,var(n,k,:,:),res)     ; Draw a contour plot.
        print("Contour complete: "+res@tiMainString)
      end if
    end do
  end do





end

