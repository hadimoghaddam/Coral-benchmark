load "$NCARG_NCARG/nclscripts/csm/gsn_code.ncl"
load "$NCARG_NCARG/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_NCARG/nclscripts/csm/contributed.ncl"

;***********************************************************************;
; function  || T || on 2D horizontal array
;***********************************************************************;
function norml2(varz[*][*]:double,gw[*]:double)
local i,output
begin
  s2 =  dimsizes(varz) 
  gs =  dimsizes(gw)

  if ( s2(0) .ne. gs(0) ) then
     print ("norml2: error: first dimension does not match Gauss weight dimension: " + s2(0) + " " + gs(0) )
  end if
  if ( 2*s2(0) .ne. s2(1) ) then
     print ("norml2: error: second dimsion is not 2x first dimension") 
  end if
  
  varl = ( gw # (varz^2) )/sum(gw)
  output = sum(varl)/s2(1)
  output = sqrt(output)
  return(output)
end
function norml1(varz[*][*]:double,gw[*]:double)
local i,output
begin
  s2 =  dimsizes(varz) 
  gs =  dimsizes(gw)

  if ( s2(0) .ne. gs(0) ) then
     print ("norml1: error: first dimension does not match Gauss weight dimension: " + s2(0) + " " + gs(0) )
  end if
  if ( 2*s2(0) .ne. s2(1) ) then
     print ("norml1: error: second dimsion is not 2x first dimension") 
  end if
  
  varl = ( gw # (varz) )/sum(gw)
  output = sum(varl)/s2(1)
  return(output)
end

;***********************************************************************;
; NCL script to plot Jakob et al reference solutions
; Mark Taylor 2010-10-1
; edited by Mike Levy, 2011-01-19
;***********************************************************************;
begin
; swtc5
; -----
pdf_out_dir = "./"
fref = addfile("~/CompHOMMEtoRef/reference/swtc5ref.720.360.213-nu2.5e11.nc","r")
fhomme = addfiles("./movies/swtc51.nc","r")

if (isfilevar(fhomme[0],"gw")) then
  print ("using gaussian grid")
  gauss_grid = 1    ; use shagc routines
else
  if (fhomme[0]->lat(0) .lt. -89.99999 ) then
    print ("using equally spaced grid")
    gauss_grid = 2    ; use shaec routines
  else
    print ("assuming shifted equally spaced grid")
    gauss_grid = 3     ; default, fixed-offset grid, need to interpolate using fo2fsh
  end if
end if



nlat = dimsizes(fhomme[0]->lat)
nlon = dimsizes(fhomme[0]->lon)
nlat@double = True
lat  = latGau(nlat, "lat", "latitude", "degrees_north")
gwt  = latGauWgt(nlat, "lat", "gaussian weights", "")
lon  = lonGlobeF(nlon, "lon", "longitude", "degrees_east")
print("HOMME & T213 reference solutions compared on grid: "+nlon+" x "+nlat)

geo_ref = (/fref->geopotential(0,:,:)/)
geo_ref!0 = "lat"
geo_ref&lat = fhomme[0]->lat
geo_ref!1 = "lon"
geo_ref&lon = fhomme[0]->lon

zeta_ref = (/fref->zeta(0,:,:)/)
zeta_ref!0 = "lat"
zeta_ref&lat = fhomme[0]->lat
zeta_ref!1 = "lon"
zeta_ref&lon = fhomme[0]->lon

wks = gsn_open_wks("pdf",pdf_out_dir+"swtc5-HOMMEref")
res=True
res@cnLevelSpacingF = 100.d 

res@tiMainString        = "HOMME (NE=240 & NP=4, ~0.125:S:o:N:)"
contour = gsn_csm_contour_map(wks,geo_ref,res)     ; Draw a contour plot.  ;

res@tiMainOffsetYF = 0.025

itime = 15
print("geop errors")
print("-----------")
do n=0,0
		time = fhomme[n]->time
		geo = (/fhomme[n]->geop(itime,0,:,:)/)
	if (n.eq.0) then
		geo!0 = "lat"
		geo&lat = fhomme[0]->lat
		geo!1 = "lon"
		geo&lon = fhomme[0]->lon
	end if

	refmax = max(geo_ref)
	diffmax = max(abs(geo-geo_ref))
	refl2 = norml2(geo_ref,gwt)
	diffl2 = norml2(abs(geo-geo_ref),gwt)
	refl1 = norml1(geo_ref,gwt)
	diffl1 = norml1(abs(geo-geo_ref),gwt)
  
	; print("ref mass = "+norml1(geo_ref,gwt) )
	; print("    mass = "+norml1(geo,gwt) )
	print("l1,l2,mx = "+diffl1/refl1+" "+diffl2/refl2+" "+diffmax/refmax)
  
	res@tiMainString        = "l:B:2:N: err = "+diffl2/refl2+":C:"
	contour = gsn_csm_contour_map(wks,geo,res)     ; Draw a contour plot.  ;
end do
;print("contouring at time="+itime)


geodiff = geo
geodiff = geo-geo_ref
res@cnMinLevelValF = -200.
res@cnMaxLevelValF = 200.
res@cnLevelSpacingF = 20.d 
;contour = gsn_csm_contour_map(wks,geodiff,res)     ; Draw a contour plot.  ;
delete(wks)

res@cnLevelSelectionMode = "ManualLevels"
;delete(res@cnMinLevelValF)
;delete(res@cnMaxLevelValF)
;delete(res@cnLevelSpacingF)
res@cnMinLevelValF = -5e-5
res@cnMaxLevelValF = 5e-5
res@cnLevelSpacingF = 25d-6/3.
res@cnLineLabelFormat = "!*+^e"

wks = gsn_open_wks("pdf",pdf_out_dir+"swtc5-HOMMEref-zeta")

res@tiMainString        = "HOMME (NE=240 & NP=4, ~0.125:S:o:N:)"
contour = gsn_csm_contour_map(wks,zeta_ref,res)     ; Draw a contour plot.  ;

res@tiMainOffsetYF = 0.025
print("zeta errors")
print("-----------")
do n=0,0
		time = fhomme[n]->time
		zeta = (/fhomme[n]->zeta(itime,0,:,:)/)
	if (n.eq.0) then
		zeta!0 = "lat"
		zeta&lat = fhomme[0]->lat
		zeta!1 = "lon"
		zeta&lon = fhomme[0]->lon
	end if

	refmax = max(zeta_ref)
	diffmax = max(abs(zeta-zeta_ref))
	refl2 = norml2(zeta_ref,gwt)
	diffl2 = norml2(abs(zeta-zeta_ref),gwt)
	refl1 = norml1(abs(zeta_ref),gwt)
	diffl1 = norml1(abs(zeta-zeta_ref),gwt)
  
	print("l1,l2,mx = "+diffl1/refl1+" "+diffl2/refl2+" "+diffmax/refmax)
  
	res@tiMainString        = "l:B:2:N: err = "+diffl2/refl2+":C:"
	contour = gsn_csm_contour_map(wks,zeta,res)     ; Draw a contour plot.  ;
end do

zetadiff = zeta
zetadiff = zeta-zeta_ref
res@cnMinLevelValF = -200.
res@cnMaxLevelValF = 200.
res@cnLevelSpacingF = 20.d 
;contour = gsn_csm_contour_map(wks,zetadiff,res)     ; Draw a contour plot.  ;



end

