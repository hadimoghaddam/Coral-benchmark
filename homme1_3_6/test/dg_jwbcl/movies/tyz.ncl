;Vertical plots on 3D Data-slices
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; R. Nair SCD/NCAR, DGAM/05 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;
;  Main program
;
begin
 
  xdat = "eta26.dat"
  fdat = "zonal_T.dat"

  m=61
  n=26

  data= asciiread(fdat,(/n,m/),"float")

  z = asciiread(xdat,(/n/),"float")

  r2d = 180.0/3.14159265

;  tx(:,:,:) =tx(:,:,:)*r2d
;  ty(:,:,:) =ty(:,:,:)*r2d

  zl     = new((/n/),float)
  yl     = new((/m/),float)
  yp     = new((/n/),float)


    do j = 0, m-1
     yl(j) = j * (180./(m-1)) - 90.
    end do

    do k = 0, n-1
     zl(k) =  k * (1.0/(n-1)) 
    end do

;  ff      = new((/m,n/),float)
;  ff(:,:) = data(:,:)
  
  print(zl(:))
;
;  Define a color map.
;
;
; Create a workstation.
;
  NCGM=0
  X11=1
  PS=0
  PDF=0


  if (NCGM .eq. 1) then
    wks = gsn_open_wks("ncgm","T-yz")
  end if
  if (X11 .eq. 1) then
    wks = gsn_open_wks("x11","T-yz")
  end if
  if (PS .eq. 1) then
    wks = gsn_open_wks("ps","T-yz")
  end if
  if (PDF .eq. 1) then
    wks = gsn_open_wks("pdf","T-yz")
  end if

;  Define a color map.
;
; gsn_define_colormap(wks,"BlAqGrYeOrRe")
; gsn_define_colormap(wks,"rainbow+white")
; gsn_define_colormap(wks,"WhViBlGrYeOrReWh")
; gsn_define_colormap(wks,"WhBlReWh")
; gsn_define_colormap(wks,cmap)
  gsn_define_colormap(wks,"WhViBlGrYeOrRe")

; To make background color to white
;
    setvalues wks
   "wkBackgroundColor" : (/ 1.0,1.0,1.0 /)
    end setvalues
;
  res = True
;
  res@sfXArray    = yl   ; X axes data points
  res@sfYArray    = zl   ; Y axes data points
  res@trYLog      = False
  res@trYReverse  = True             ;Reverse the vertical axis 

  res@vpXF      = 0.15   ; Change the size and location of the
  res@vpYF      = 0.8    ; plot on the viewport.
  res@vpWidthF  = .75          ; choose width of plot
  res@vpHeightF = .65          ; choose height of plot

   res@sfXCStartV = -90.0
   res@sfXCEndV   =  90.0
   res@sfYCStartV = max(zl)
   res@sfYCEndV   = min(zl) 

;   res@tmYUseLeft    = False      ; Keep right axis independent of left.
;   res@tmYRLabelsOn  = True       ; Turn on right axis labels.
    res@tmYRLabelFont = 25         ; Change font of labels.
    res@tmYLOn        = True       ; Turn on right axis tick marks.
    res@tmYLMinorOn   = True      ; No minor tick marks.

    res@tmXTMinorOn   = False      ; No minor tick marks.
    res@tmXBMinorOn   = False      ; No minor tick marks.
  
    res@tmYRMode      = "Explicit"  ; Define own tick mark labels.
    res@tmXBMode      = "Explicit" ; Define own tick mark labels.
    res@tmXBLabelFont = 25         ; Change the font.
    res@tmXBLabelFontHeightF = 0.020 ; Change the font.

    res@tiYAxisString = "eta levels"

  res@tmXBValues    = (/-90.,  -60., -30., 0., 30., 60., 90./)
  res@tmXBLabels    = (/"90S","60S","30S","EQ","30N","60N","90N"/)

; Cotour Styles 
  res@cnFillOn       = True                  ; turn on color fill
 ;res@lbLabelBarOn   = False                 ; turn of label bar
  res@cnLineLabelsOn = True                  ; force line labels 
  res@cnInfoLabelOn  = False                 ; turn off cn info label
  res@cnLineDashPattern  = 0     ; Solid line contours
  res@cnLineThicknessF   = 1.0   ; Double the line thickness.
  res@cnMonoLineColor    = True
  res@cnLineColor        = 1     ; black

;  mnlvl = 210                    ; Minimum contour level.
;  mxlvl = 310                    ; Maximum contour level.
 spcng = 10                      ; Contour level spacing.
 mnlvl= min(data(:,:))
 mxlvl= max(data(:,:))
 ncn= (mxlvl-mnlvl)/spcng + 1  ; Number of contour levels.

 res@cnLevelSelectionMode = "ManualLevels" ; Define your own
 res@cnMinLevelValF       = mnlvl          ; contour levels.
 res@cnMaxLevelValF       = mxlvl
 res@cnLevelSpacingF      = spcng



  res@gsnSpreadColors = True               ; use full color table
  res@gsnSpreadColorStart =  27
  res@gsnSpreadColorEnd   =  103

;
;  Title
;
  txres = True
  txres@txFontHeightF = 0.020
  txres@txFontColor = 1
  txres@txJust = "CenterCenter"
  gsn_text_ndc(wks, "Held-Suarez Test: Averaged Zonal Temperature (K)", 0.5, 0.83, txres)

 ;plot =  gsn_csm_contour(wks,data,res)
  plot =  gsn_contour(wks,data,res)


  frame(wks)

end


