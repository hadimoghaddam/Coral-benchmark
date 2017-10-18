; on bluesky NCARG_ROOT=/contrib and ncl is /contrib/bin/ncl.new
; on thunder NCARG_ROOT=/ptmp/grubin/ncarg and ncl is /ptmp/grubin/ncarg/bin/ncl.new
; 

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
  ; This script is for latitude vs vertical zonal average contour plots 
  ; nlat is the number of latitude bins to average into
  nlat = 50
  fnames = systemfunc("ls movies/*1.nc")
  f = addfiles(fnames,"r")
	

  ; change the name of the field to plot here, 
  ; current field names for vertical crosssections are Q, ke, u, v, T, zeta - names are case sensitive
  
  field = "u" 

;
; Open a file to send output to. You can use "ps", "pdf", "x11",
; or "ncgm".
;
  output_format = "ncgm"

  lat1d=doubletofloat(f[:]->latP)*180.0/3.14

  lon1d=doubletofloat(f[:]->lonP)*180.0/3.14

  fcnt = dimsizes(f)
 
  vcnt=new((/fcnt,4/),"integer")
  do i=0,fcnt-1
    vcnt(i,:) = getfiledimsizes(f[i])
  end do	   	 
  
  ntimes = vcnt(0,0)
  nlev = vcnt(0,2)
  nxy = dim_sum(vcnt(:,1))

; change the levels and or times to plot here
  firsttime=0
  lasttime=ntimes-1  
;  lasttime=0
  timeinc=1
  firstlev=0
  lastlev=nlev-1
  levinc=1

  nxe=0

;  hyam=doubletofloat(f[0]->hyam(firstlev:lastlev:levinc))
;  ps0 = doubletofloat(hyam@ps0)
;  hybm=doubletofloat(f[0]->hybm(firstlev:lastlev:levinc))

   

  nx = nlat
  plon = 360.*fspan(0.,1.,nx)
  plat =  90.*fspan(-1.,1.,nlat)

  varlatlon = new((/ntimes,nlev,nlat,nx/),"float")

;  print(min(plat)+" "+max(plat)+" "+min(plon)+" "+max(plon))

  do n=firsttime,lasttime,timeinc
    do k=firstlev,lastlev,levinc
       	varlatlon(n,k,:,:) = triple2grid(lon1d,lat1d,doubletofloat(f[:]->$field$(n,k,:)),plon,plat,False)
    end do
  end do
  zavg = dim_avg(varlatlon)
 
  time = f[0]->Time
;
; It will also look for a "homme.res" file, where you can set 
; resources that you want set all the time, like the font, or
; the background/foreground colors.
;
 
  wks = gsn_open_wks(output_format,field+"_zonal")
  print ("Output to: "+field+"_zonal."+output_format)
;
; The first call below selects a colormap, and the second reverses it.
; The colors go from violet at the low valus to blue at the high
; values.
;
; To see the various colormaps, go to:
;
; http://ngwww.ucar.edu/ncl/coltable.html
;
;  gsn_define_colormap(wks,"BlAqGrYeOrReVi200")
;  gsn_reverse_colormap(wks)
   gsn_define_colormap(wks,"wh-bl-gr-ye-re")
;
; Set some plot resources.  Order doesn't matter here.
;

    res   = True

  res@lbLabelStride        = 3

  res@trYReverse           = True
;  res@trXReverse           = True

  res@gsnDraw              = False
  res@gsnFrame             = False
  res@gsnSpreadColors      = True
  res@gsnMaximize          = True
  res@gsnPaperOrientation  = "portrait"
  res@gsnYAxisIrregular2Linear = True

  res@cnFillOn             = True
  res@cnSmoothingOn        = True
;  res@cnLevelSpacingF      = 5
  res@sfXArray             = plat



  do n = firsttime,lasttime,timeinc
    res@tiMainString        = field+"zonal average at  time="+time(n)+" days"    ;

    contour = gsn_csm_contour(wks,zavg(n,:,:),res)
;    contour = NegDashLineContour(contour)
    draw(contour)
    frame(wks)
  end do





end

