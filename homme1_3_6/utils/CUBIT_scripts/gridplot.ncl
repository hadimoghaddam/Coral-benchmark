load "$NCARG_NCARG/nclscripts/csm/gsn_code.ncl"
load "$NCARG_NCARG/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_NCARG/nclscripts/csm/contributed.ncl"


begin
;	out_type = "ps"
	out_type = "pdf"
;	out_type = "X11"

	refine_type = "ARM"
	coarse_ne = 30
	num_refine = 8
	num_smth = 0

	if ((refine_type.eq."mountain").and.(num_refine.gt.1)) then
		drawmtn = True ; draw mtn from TC 5
	else
		drawmtn = False
	end if

	if (num_refine.lt.2) then
		gridname = "uniform_"+coarse_ne
	else
		gridname = refine_type + "_" + coarse_ne + "_x" + num_refine
		if (num_smth.ne.0) then
			gridname = gridname + "_s"+num_smth
		end if
	end if
	gridfile = "exodus/"+gridname+".g"
	if (.not.isfilepresent(gridfile)) then
		print((/"Can not find "+gridfile+"!"/))
		exit
	end if

	print((/"Plotting mesh from "+gridfile/))
	system("ln -s "+gridfile+" "+gridfile+".nc")

	pi4= atan(1.d);
	pi2 = acos(0.d)
	pi = pi2*2.d
	f = addfile(gridfile+".nc","r")
	num_el_blk=dimsizes(f->eb_status)

	if ((num_el_blk.ne.6).and.(num_el_blk.ne.1)) then
		print("Neither cube nor sphere, can't plot!")
		system("/bin/rm -f "+gridfile+".nc")
		exit
	end if

	if (num_el_blk.eq.6) then
		IsCube = True
	else
		IsCube = False
	end if

	; cartesian coords:
	coordx = f->coord(0,:)
	coordy = f->coord(1,:)
	coordz = f->coord(2,:)

	; convert to lat/lon (project from cube to sphere!)
	if (IsCube) then 
		tol = 1e-8
		print("Projecting coordinates onto sphere...")
		n_nodes = dimsizes(coordx)
		r = sqrt(coordx*coordx + coordy*coordy + coordz*coordz)
		lat = new(n_nodes,"double")
		lon = new(n_nodes,"double")
		face = new(n_nodes,"double")
		do i=0,n_nodes-1
			face(i) = -1
			if ((coordx(i).le.-pi4+tol).and.(face(i).eq.-1)) then
				face(i) = 2
				alpha = -coordy(i)
				beta = coordz(i)
			end if
			if ((coordx(i).ge.pi4-tol).and.(face(i).eq.-1)) then
				face(i) = 0
				alpha = coordy(i)
				beta = coordz(i)
			end if
			if ((coordy(i).le.-pi4+tol).and.(face(i).eq.-1)) then
				face(i) = 3
				alpha = coordx(i)
				beta = coordz(i)
			end if
			if ((coordy(i).ge.pi4-tol).and.(face(i).eq.-1)) then
				face(i) = 1
				alpha = -coordx(i)
				beta = coordz(i)
			end if
			if ((coordz(i).le.-pi4+tol).and.(face(i).eq.-1)) then
				face(i) = 5
				alpha = coordy(i)
				beta = coordx(i)
			end if
			if ((coordz(i).ge.pi4-tol).and.(face(i).eq.-1)) then
				face(i) = 4
				alpha = coordy(i)
				beta = -coordx(i)
			end if
			if (face(i).eq.-1) then
				print("Error: face not assigned to a node!")
				print((/i+" "+coordx(i)+" "+coordy(i)+" "+coordz(i)/))
				system("rm -f "+gridfile+".nc")
				exit
			end if
			if (face(i).lt.4) then
				lon(i) = alpha+pi2*face(i)
				lat(i) = atan(tan(beta)*cos(alpha))
			end if
			if (face(i).eq.4) then
				lon(i) = atan2(tan(alpha), -tan(beta))
				if (tan(alpha)*tan(alpha)+tan(beta)*tan(beta).lt.tol) then
					lat(i) = pi2
				else
					lat(i) = atan(1.d/sqrt(tan(alpha)*tan(alpha)+tan(beta)*tan(beta)))
				end if
			end if
			if (face(i).eq.5) then
				lon(i) = atan2(tan(alpha), tan(beta));-pi
				if (tan(alpha)*tan(alpha)+tan(beta)*tan(beta).lt.tol) then
					lat(i) = -pi2
				else
					lat(i) = -atan(1.d/sqrt(tan(alpha)*tan(alpha)+tan(beta)*tan(beta)))
				end if
			end if
		end do
		print("... done!")
	else
		lat = asin(coordz)
		lon = atan2(coordy,coordx)
	end if
	lat = lat*180.d/pi
	lon = lon*180.d/pi

	if (drawmtn) then
	; contours for TC5 mountain
		nlat = 540
		lats = latGlobeF(nlat,"lat","latitude","degrees_north")
		nlon = 1080
		lons = lonGlobeF(nlon,"lon","longitude","degrees_east")
		mountain = new((/nlat,nlon/),"double")
		mountain = 0.
		mountain!0 = "lat"
		mountain&lat = lats
		mountain!1 = "lon"
		mountain&lon = lons
		theta0 = 30.
		bigr = 20.
		; theta0 = 32.5
		; bigr = 5.
		lambda0 = -90.
		lambda1 = 270.
		do i=0,nlon-1
			do j=0, nlat-1
				dl = min((/lons(i)-lambda0,lons(i)-lambda1/))
				dt = lats(j)-theta0
				; dt = (lats(j)-theta0)/2.
;				smallr = min((/sqrt(dl*dl+dt*dt),bigr/))
;				mountain(j,i) = 2000.*(1.-smallr/bigr)
				if (sqrt(dl*dl+dt*dt).lt.bigr) then
					mountain(j,i) = 2000.
				end if
			end do
		end do
	end if

	print("number of verticies = "+dimsizes(lon))
	print("lat min/max = "+min(lat)+" "+max(lat))
  
	dimnames = getvardims(f)
	dimsz = getfiledimsizes(f)
	do i=0,dimsizes(dimnames)-1
		if ( dimnames(i).eq."num_elem") 
			print("dimname[i]="+dimnames(i)+" "+dimsz(i))
			nelem=dimsz(i)
		end if
	end do  

	map = new ( (/nelem,4/), "integer", -99 )

	count=0
	fcnt = dimsizes(f->connect1)
	print("dimsizes(map1)="+fcnt)
	n=fcnt(0)
	map(count:(n-1),:) = (/ f->connect1 /)
	count=count+n

	if (IsCube) 
		fcnt = dimsizes(f->connect2)
		print("dimsizes(map2)="+fcnt)
		n=fcnt(0)
		map(count:(count+n-1),:) = (/ f->connect2 /)
		count=count+n

		fcnt = dimsizes(f->connect3)
		print("dimsizes(map2)="+fcnt)
		n=fcnt(0)
		map(count:(count+n-1),:) = (/ f->connect3 /)
		count=count+n

		fcnt = dimsizes(f->connect4)
		print("dimsizes(map2)="+fcnt)
		n=fcnt(0)
		map(count:(count+n-1),:) = (/ f->connect4 /)
		count=count+n

		fcnt = dimsizes(f->connect5)
		print("dimsizes(map2)="+fcnt)
		n=fcnt(0)
		map(count:(count+n-1),:) = (/ f->connect5 /)
		count=count+n

		fcnt = dimsizes(f->connect6)
		print("dimsizes(map2)="+fcnt)
		n=fcnt(0)
		map(count:(count+n-1),:) = (/ f->connect6 /)
		count=count+n
	end if

	nelem=count
	print(dimsizes(map))
	print("number of elements = "+nelem)

	; Orthographic Projection
	wks = gsn_open_wks(out_type,"./pdfs/"+gridname)

	res = True
	res@tiMainString = gridname

	res@mpProjection      = "Orthographic"
	if ((refine_type.eq."mountain").or.(refine_type.eq."ARM"))
		; North America
		res@mpCenterLatF      =  30.
		res@mpCenterLonF      =  240.
	else
		; Africa
		res@mpCenterLatF      =  15.
		res@mpCenterLonF      =  25.
	end if

	res@vpXF      = 0.05
	res@vpYF      = 0.9
	res@vpWidthF  = 0.9
	res@vpHeightF = 0.8

	res@gsnDraw  = False       ; don't draw the plots now
	res@gsnFrame = False       ; or advance the frame

	if (refine_type.eq."ARM")
		res@mpOutlineOn            = True
		res@mpOutlineBoundarySets = "USStates"
		res@mpUSStateLineColor = "Gray"
	else
		res@mpOutlineOn            = False
	end if
	res@mpPerimOn              = False
	res@mpLandFillColor        = "tan"
	res@mpOceanFillColor       = "LightBlue"
	res@mpInlandWaterFillColor = "Blue"
	res@mpGreatCircleLinesOn = True

	if (drawmtn) then
		res@cnLineLabelsOn = False
		res@cnInfoLabelOn = False
	end if

	gsn_define_colormap(wks,(/"white","black","tan","LightBlue","Blue"/))

	if (drawmtn) then
		plot = gsn_csm_contour_map(wks,mountain, res)
	else
		plot = gsn_csm_map(wks,res) ; create the plot
	end if
  draw(plot)

	; polygon resources
	res_p             = True

	res_p@gsLineThicknessF = 1.0
	res_p@gsLineColor   = "black"

	j1 = ispan(0,3,1)
	j2 = (j1+1)%4

	xlon = new ( (/5/), "double")
	xlat = new ( (/5/), "double")

	do i=0,nelem-1
		if ( mod(i,500).eq.0) then
			print ("i = "+i+"/"+(nelem-1))
		end if
		xlon(0:3) = lon(map(i,:)-1)
		xlat(0:3) = lat(map(i,:)-1)

		do j=0,2
			if ( abs(xlon(j+1)-xlon(j)) .gt. 180.0) then
				if (xlon(j+1) .gt. xlon(j) ) then
					xlon(j)=xlon(j)+360.
				else
					xlon(j+1)=xlon(j+1)+360.
				end if
			end if
		end do

		xlon(4)=xlon(0)
		xlat(4)=xlat(0)
		gsn_polyline(wks, plot, xlon,xlat,res_p)
	end do

	if (out_type.eq."ps") then
		delete(wks)
		wks = gsn_open_wks(out_type,"./pdfs/"+gridname+"_stereo")
	else
		frame(wks)
	end if

	; Stereographic
	res2 = True
	res2@tiMainString = gridfile
	res2@tiMainString = res@tiMainString

	res2@gsnDraw = False
	res2@gsnFrame = False
  
;	res2@mpOutlineOn = False
	res2@mpLandFillColor        = "tan"
	res2@mpOceanFillColor       = "LightBlue"
	res2@mpInlandWaterFillColor = "Blue"
	res2@mpGreatCircleLinesOn = True

	res2@mpGridAndLimbOn = True
	res2@mpGridLineDashPattern = 2
	res2@mpGridLineColor = "DarkSlateGray"

	res2@gsnMajorLonSpacing = 60
	res2@mpGridLonSpacingF = 60
	res2@gsnMajorLatSpacing = 45
	res2@mpGridLatSpacingF = 45

	if (drawmtn) then
		res2@cnLineLabelsOn = False
		res2@cnInfoLabelOn = False
	end if

	gsn_define_colormap(wks,(/"white","black","tan","LightBlue","Blue"/))
	if (drawmtn) then
		plot2 = gsn_csm_contour_map_ce(wks,mountain, res2)
	else
		plot2 = gsn_csm_map(wks,res2)
	end if
	draw(plot2)

	j1 = ispan(0,3,1)
	j2 = (j1+1)%4

	do i=0,nelem-1
		if ( mod(i,500).eq.0) then
			print ("i = "+i+"/"+(nelem-1))
		end if
		xlon(0:3) = lon(map(i,:)-1)
		xlat(0:3) = lat(map(i,:)-1)

		do j=0,2
			if ( abs(xlon(j+1)-xlon(j)) .gt. 180.0) then
				if (xlon(j+1) .gt. xlon(j) ) then
					xlon(j)=xlon(j)+360.
				else
					xlon(j+1)=xlon(j+1)+360.
				end if
			end if
		end do

		xlon(4)=xlon(0)
		xlat(4)=xlat(0)
		gsn_polyline(wks, plot2, xlon,xlat,res_p)
	end do

	frame(wks)
	system("/bin/rm -f "+gridfile+".nc")

end
