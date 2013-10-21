load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;===============================================================
; This script contains a panel of 6 maps of:
; 1) Total Cloud Cover (CALIPSO observations & Model with Calipso simulator)
; 2) Net Cloud Radiative Effect (CERES observations & Model CRE)
; 3) Parasol Reflectance (PARASOL observations & Model with Parasol simulator)
;
; This NCL script has been made for example data 2008. Variable names follow CMIP5 convention.
; 
; You need to make the following changes (find 'Metric'): 
; 1)File format of output file (example: pdf or eps) & Choose color table
; 2)Title of output file
; 3)Directories of input files and working directory
; 4)Input files
;
; Christine Nam
;    Laboratoire de Météorologie Dynamique
;    Institut Pierre Simon Laplace
;    Centre National de la Recherche Scientifique
;    Paris, France
;    Nov. 2012
; 
; Support of this work came from the EUCLIPSE project - European Union, Seventh Framework Programme (FP7/2007–2013) grant 244067. 
;
;===============================================================
; FILE INFORMATION
; --------------------------------------------------------------
; example: wks = gsn_open_wks("Metric1","Metric2")
  wks = gsn_open_wks("pdf","IPSL5Bamip_QualityControlMaps_2008")  ;file type: "x11";"pdf";"eps"

  plot = new(6,graphic)              ; create plot array

;  cmap = RGBtoCmap("RGBmatlab.txt")     ; CNam: using personalized color table
;  gsn_define_colormap(wks, cmap) 	
  gsn_define_colormap(wks,"matlab_jet")  ; CNam: uncomment for NCL predefined table
  
;===============================================================
; MODELS with COSP Calipso and Parasol satellite simulators
; --------------------------------------------------------------
; example: directoryA = "/Metric3/" ; Directory of CRE data
;	   directoryB = "/Metric3/" ; Directory of COSP simulator
;	   directoryC = "/Metric3/" ; Working Directory
  directoryA = "/prodigfs/esg/CMIP5/merge/IPSL/IPSL-CM5B-LR/amip/mon/atmos/Amon/r1i1p1/v20120526/"
  directoryB = "/prodigfs/esg/CMIP5/merge/IPSL/IPSL-CM5B-LR/amip/mon/atmos/cfMon/r1i1p1/v20120526/"
  directoryC = "/data/cnlmd/CMIP5_AMIP_Metric/"

; --------------------------------------------------------------
; Extracting variables for 2008 from original AMIP files. 
; --------------------------------------------------------------
; example: systemfunc("cdo selear,2008 "+directoryA+"Metric4_origfile "+directoryC+"Metric4_2008file"
     extract1=systemfunc("cdo selyear,2008 "+directoryA+"rlut/rlut_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc "+directoryC+"rlut_Amon_IPSL-CM5B-LR_amip_r1i1p1_2008.nc")
     extract2=systemfunc("cdo selyear,2008 "+directoryA+"rlutcs/rlutcs_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc "+directoryC+"rlutcs_Amon_IPSL-CM5B-LR_amip_r1i1p1_2008.nc")
     extract3=systemfunc("cdo selyear,2008 "+directoryA+"rsut/rsut_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc "+directoryC+"rsut_Amon_IPSL-CM5B-LR_amip_r1i1p1_2008.nc")
     extract4=systemfunc("cdo selyear,2008 "+directoryA+"rsutcs/rsutcs_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc "+directoryC+"rsutcs_Amon_IPSL-CM5B-LR_amip_r1i1p1_2008.nc")
     extract5=systemfunc("cdo selyear,2008 "+directoryB+"cltcalipso/cltcalipso_cfMon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc "+directoryC+"cltcalipso_cfMon_IPSL-CM5B-LR_amip_r1i1p1_2008.nc")
     extract6=systemfunc("cdo selyear,2008 "+directoryB+"cllcalipso/cllcalipso_cfMon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc "+directoryC+"cllcalipso_cfMon_IPSL-CM5B-LR_amip_r1i1p1_2008.nc")
     extract7=systemfunc("cdo selyear,2008 "+directoryB+"parasolRefl/parasolRefl_cfMon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc "+directoryC+"parasolRefl_cfMon_IPSL-CM5B-LR_amip_r1i1p1_2008.nc")


; --------------------------------------------------------------
; Cloud Radiative Effect files
; --------------------------------------------------------------
	file101="rlut_Amon_IPSL-CM5B-LR_amip_r1i1p1_2008.nc" 	; "Metric4"
	file102="rlutcs_Amon_IPSL-CM5B-LR_amip_r1i1p1_2008.nc"
	file103="rsut_Amon_IPSL-CM5B-LR_amip_r1i1p1_2008.nc"
	file104="rsutcs_Amon_IPSL-CM5B-LR_amip_r1i1p1_2008.nc"
   apple  = addfile(directoryC+file101,"r")
   pear   = addfile(directoryC+file102,"r")
   orange = addfile(directoryC+file103,"r")
   cherry = addfile(directoryC+file104,"r")

; --------------------------------------------------------------
; COSP simulator files
; --------------------------------------------------------------
	file201 = "cltcalipso_cfMon_IPSL-CM5B-LR_amip_r1i1p1_2008.nc" ; "Metric4"
	file202 = "parasolRefl_cfMon_IPSL-CM5B-LR_amip_r1i1p1_2008.nc"
   lychee   = addfile(directoryC+file201,"r")
   plum     = addfile(directoryC+file202,"r")

; -------------------------------------------------------------
; Import variables
; -------------------------------------------------------------
   IPSL5B_lat=apple->lat
     print(IPSL5B_lat)
     nlat=dimsizes(IPSL5B_lat)
   IPSL5B_lon=apple->lon
     print(IPSL5B_lon)
     nlon=dimsizes(IPSL5B_lon)

   IPSL5B_time=apple->time(:)
      ntime = dimsizes(IPSL5B_time)

   IPSL5B_LW_full=apple->rlut(:,:,:)  
   IPSL5B_LW_clear=pear->rlutcs(:,:,:)  
   IPSL5B_SW_full=orange->rsut(:,:,:)  
   IPSL5B_SW_clear=cherry->rsutcs(:,:,:) 
	IPSL5B_LW_full@_FillValue=1e20
	IPSL5B_LW_clear@_FillValue=1e20
	IPSL5B_SW_full@_FillValue=1e20
	IPSL5B_SW_clear@_FillValue=1e20

   IPSL5B_Totalcld_in=lychee->cltcalipso(:,:,:)
	IPSL5B_Totalcld_in@_FillValue=1e20

   IPSL5B_parasol=plum->parasolRefl(:,:,:,:)
	IPSL5B_parasol@_FillValue=1e20

;---------------------------------------------------------------
; Parasol Linear Interpolation of COSP output
;---------------------------------------------------------------
   sza=fspan(0,80,5)
        nsza=dimsizes(sza)
        print(sza)

        tadpole=asciiread("/home/cnlmd/NCL_scripts/parasol_sza.txt",(/96,12/),"float")
        tadpole!0="lat"
        tadpole!1="month"
        tadpole&lat=IPSL5B_lat
        tadpole&lat@units = "degrees_north"
        printVarSummary(tadpole)
        printMinMax(tadpole,True)
        tadpolelat=tadpole&lat

; CNam: 'Frog' is for non-ipsl models with different 'nlat'
        frog=linint1_Wrap(tadpolelat,tadpole(month|:,lat|:),False,IPSL5B_lat, 0) 
        printVarSummary(frog)
        printMinMax(frog,True)

        ;---------------------------------------------------------------
        IPSL5B_refl=new((/ntime,nlat,nlon/),float)
        IPSL5B_refl!0="time"
        IPSL5B_refl!1="lat"
        IPSL5B_refl!2="lon"
        IPSL5B_refl&lat=IPSL5B_lat
        IPSL5B_refl&lon=IPSL5B_lon
        ;---------------------------------------------------------------

   do m=0,(ntime-1)
     do l=0,(nlat-1)
     do k=0,(nlon-1)
     do i=0,(nsza-2)
         if (frog(m,l).ge. sza(i) .and. frog(m,l).lt.sza(i+1)) then
            IPSL5B_refl(m,l,k)= IPSL5B_parasol(m,i,l,k) + ((frog(m,l)-sza(i))*((IPSL5B_parasol(m,i+1,l,k)-IPSL5B_parasol(m,i,l,k))/(sza(i+1)-sza(i))))
         end if
     end do ; i         
     end do ;k
     end do ;l 
  end do ;m

  printVarSummary(IPSL5B_refl)
        delete(frog)
        delete(IPSL5B_parasol)

; -------------------------------------------------------------
; Model Calculations
; -------------------------------------------------------------
   IPSL5B_CRE=IPSL5B_LW_clear-IPSL5B_LW_full+IPSL5B_SW_clear-IPSL5B_SW_full
	IPSL5B_CRE!0      = "time"            ; assign dimension names
	IPSL5B_CRE!1      = "lat"             ; assign dimension names
	IPSL5B_CRE!2      = "lon"             ; assign dimension names    		
	IPSL5B_CRE&lat      = IPSL5B_lat             ; assign dimension names
	IPSL5B_CRE&lon      = IPSL5B_lon             ; assign dimension names    
	IPSL5B_CRE@_FillValue=1e20
	printVarSummary(IPSL5B_CRE)

   IPSL5B_CREavg=dim_avg_Wrap(IPSL5B_CRE(lat|:,lon|:,time|:))
	printVarSummary(IPSL5B_CREavg)


   IPSL5B_Totalcld=dim_avg_Wrap(IPSL5B_Totalcld_in(lat|:,lon|:,time|:))

   IPSL5B_Reflectance=dim_avg_Wrap(IPSL5B_refl(lat|:,lon|:,time|:))


;===============================================================
; SATELLITE OBSERVATIONS
;===============================================================
   directoryD = "/data/cnlmd/Satellites_v20110323/GOCCP_Monthly/" ; Metric 3
      file302 = "REFL1DIR_PARASOL_grid2x2_2008monmean_CFMIP2.nc"  
      file303 = "MapLowMidHigh330m_2008_avg_CFMIP2_sat_2.1.nc"	  ; Metric 4
   fig   = addfile(directoryD+file302,"r")
   peach = addfile(directoryD+file303,"r")
         printVarSummary(fig)   ; overview of var

   directoryE = "/data/cnlmd/Satellites_v20110323/CERES/"	; Metric 3
      file401 = "rlut_CERES-EBAF_L4_Ed2-6_2008.nc"		; Metric 4
      file402 = "rlutcs_CERES-EBAF_L4_Ed2-6_2008.nc"
      file403 = "rsut_CERES-EBAF_L4_Ed2-6_2008.nc"
      file404 = "rsutcs_CERES-EBAF_L4_Ed2-6_2008.nc"
        pineapple = addfile(directoryE+file401,"r")
        grape = addfile(directoryE+file402,"r")
        kiwi = addfile(directoryE+file403,"r")
        banana = addfile(directoryE+file404,"r")


; -------------------------------------------------------------
; import variable: reorder the data's longitude coordinates
; -------------------------------------------------------------
   lat=peach->latitude
   lon=peach->longitude
       ilon=dimsizes(peach->longitude(:))
       jlat=dimsizes(peach->latitude(:))

   Satellite_Totalcld_in=peach->cltcalipso(:,:,:)
     Satellite_Totalcld_in@_FillValue = -9999
     Satellite_Total=dim_avg_Wrap(Satellite_Totalcld_in(latitude|:,longitude|:,time|:))*100
     Satellite_Total!0="latitude"
     Satellite_Total!1="longitude"
     Satellite_Total&latitude=peach->latitude(:)
     Satellite_Total&longitude=peach->longitude(:)
     Satellite_Total&latitude@units="degrees_north"
     Satellite_Total&longitude@units="degrees_east"
     printVarSummary(Satellite_Total)

   Satellite_Refl=fig->reflectance(:,:,:)
     Satellite_Refl@_FillValue = -9999   
     Satellite_Reflectance=dim_avg_Wrap(Satellite_Refl(latitude|:,longitude|:,time|:))
     Satellite_Reflectance&latitude@units="degrees_north"
     Satellite_Reflectance&longitude@units="degrees_east"
     printVarSummary(Satellite_Reflectance)

; -------------------------------------------------------------
; CERES observations have different lat lon co-ordinates than GOCCP
; -------------------------------------------------------------
    longwave_inB=f2fsh_Wrap(pineapple->rlut(:,:,:),(/jlat,ilon/))
        ;printVarSummary(longwave_inB)
        ;----- REGRID: 0->360   ==>  -180->180  ------
     CERES_rgrid0180_AllTropic_longwave=longwave_inB(lon|0:((ilon/2)-1),time|:,lat|:)
     CERES_rgrid180360_AllTropic_longwave=longwave_inB(lon|(ilon/2):(ilon-1),time|:,lat|:)
     CERES_rgrid_AllTropic_longwave = array_append_record(CERES_rgrid180360_AllTropic_longwave,CERES_rgrid0180_AllTropic_longwave,0)
        ;printVarSummary(CERES_rgrid_AllTropic_longwave)
        ;----- SELECT REGION: -----
        CERES_LW_full=CERES_rgrid_AllTropic_longwave(time|:,lat|:,lon|:)
        printVarSummary(CERES_LW_full)
                delete(CERES_rgrid0180_AllTropic_longwave)
                delete(CERES_rgrid180360_AllTropic_longwave)
                delete(CERES_rgrid_AllTropic_longwave)


    longwave_clear_inB=f2fsh_Wrap(grape->rlutcs(:,:,:),(/jlat,ilon/))
        ;printVarSummary(longwave_clear_inB)
        ;----- REGRID: 0->360   ==>  -180->180  ------
     CERES_rgrid0180_AllTropic_longwave_clear=longwave_clear_inB(lon|0:((ilon/2)-1),time|:,lat|:)
     CERES_rgrid180360_AllTropic_longwave_clear=longwave_clear_inB(lon|(ilon/2):(ilon-1),time|:,lat|:)
     CERES_rgrid_AllTropic_longwave_clear = array_append_record(CERES_rgrid180360_AllTropic_longwave_clear,CERES_rgrid0180_AllTropic_longwave_clear,0)
        ;printVarSummary(CERES_rgrid_AllTropic_longwave_clear)
        ;----- SELECT REGION: -----
        CERES_LW_clear=CERES_rgrid_AllTropic_longwave_clear(time|:,lat|:,lon|:)
        printVarSummary(CERES_LW_clear)
                delete(CERES_rgrid0180_AllTropic_longwave_clear)
                delete(CERES_rgrid180360_AllTropic_longwave_clear)
                delete(CERES_rgrid_AllTropic_longwave_clear)


    shortwave_inB=f2fsh_Wrap(kiwi->rsut(:,:,:),(/jlat,ilon/))
        ;printVarSummary(shortwave_inB)
        ;----- REGRID: 0->360   ==>  -180->180  ------
     CERES_rgrid0180_AllTropic_shortwave=shortwave_inB(lon|0:((ilon/2)-1),time|:,lat|:)
     CERES_rgrid180360_AllTropic_shortwave=shortwave_inB(lon|(ilon/2):(ilon-1),time|:,lat|:)
     CERES_rgrid_AllTropic_shortwave = array_append_record(CERES_rgrid180360_AllTropic_shortwave,CERES_rgrid0180_AllTropic_shortwave,0)
        ;printVarSummary(CERES_rgrid_AllTropic_shortwave)
        ;----- SELECT REGION: -----
        CERES_SW_full=CERES_rgrid_AllTropic_shortwave(time|:,lat|:,lon|:)
        printVarSummary(CERES_SW_full)
                delete(CERES_rgrid0180_AllTropic_shortwave)
                delete(CERES_rgrid180360_AllTropic_shortwave)
                delete(CERES_rgrid_AllTropic_shortwave)


    shortwave_clear_inB=f2fsh_Wrap(banana->rsutcs(:,:,:),(/jlat,ilon/))
        ;printVarSummary(shortwave_clear_inB)
        ;----- REGRID: 0->360   ==>  -180->180  ------
     CERES_rgrid0180_AllTropic_shortwave_clear=shortwave_clear_inB(lon|0:((ilon/2)-1),time|:,lat|:)
     CERES_rgrid180360_AllTropic_shortwave_clear=shortwave_clear_inB(lon|(ilon/2):(ilon-1),time|:,lat|:)
     CERES_rgrid_AllTropic_shortwave_clear = array_append_record(CERES_rgrid180360_AllTropic_shortwave_clear,CERES_rgrid0180_AllTropic_shortwave_clear,0)
        ;printVarSummary(CERES_rgrid_AllTropic_shortwave_clear)
        ;----- SELECT REGION: -----
        CERES_SW_clear=CERES_rgrid_AllTropic_shortwave_clear(time|:,lat|:,lon|:)
        printVarSummary(CERES_SW_clear)
                delete(CERES_rgrid0180_AllTropic_shortwave_clear)
                delete(CERES_rgrid180360_AllTropic_shortwave_clear)
                delete(CERES_rgrid_AllTropic_shortwave_clear)


   CERES_LW_full@_FillValue=1.e+20
   CERES_LW_clear@_FillValue=1.e+20
   CERES_SW_full@_FillValue=1.e+20
   CERES_SW_clear@_FillValue=1.e+20


   CERES_CRE=CERES_LW_clear-CERES_LW_full+CERES_SW_clear-CERES_SW_full
     CERES_CRE!0      = "time"             ; assign dimension names
     CERES_CRE!1      = "lat"             ; assign dimension names
     CERES_CRE!2      = "lon"             ; assign dimension names  
     printVarSummary(CERES_CRE)

   CERES_CREavg=dim_avg_Wrap(CERES_CRE(lat|:,lon|:,time|:))
     CERES_CREavg&lat=lat
     CERES_CREavg&lon=lon
     CERES_CREavg&lat@units="degrees_north"
     CERES_CREavg&lon@units="degrees_east"


;======================================================================  
; FIGURE 1
;======================================================================  
  res001                      = True               ; enable plot options
  res001@gsnFrame             = False               ; advance frame
  res001@gsnDraw             = False               ; draw 
  res001@gsnMaximize          = True               ; Maximize plot in frame.
  res001@cnFillOn             = True               ; Fill contours
  res001@cnFillMode           = "RasterFill"       ; Blocks vs. Smooth
  res001@cnLinesOn            = False              ; Contour lines off
  res001@cnMinLevelValF       = 0.                 ; min contour
  res001@cnMaxLevelValF       = 100                 ; max contour
  res001@cnLevelSpacingF      = 5              ; interval of contours
  res001@gsnSpreadColors      = True               ; spread colors around 0
  res001@gsnSpreadColorStart  = 1                  ; start at color XXX in colormap
  res001@tiMainString         = "IPSL5B Lidar Total Cld Cover"  ;Main title
  res001@gsnLeftString        = ""                 ; string at left top of plot
  res001@lbTitlePosition      = 1                  ; colorbar title position
  res001@lbTitleString        = ""       ; colorbar title
  res001@lbOrientation        = "vertical"
  res001@cnLevelSelectionMode = "ExplicitLevels"    ; set explicit contour levels
  res001@cnLevels=(/ 0,10,20,30,40,50,60,70,80,90,100 /)   ; set levels

  res001@tmXTBorderOn      = True ; kills border line (x-axis top)
  res001@tmYRBorderOn      = True ; kills border line (y-axis right)
  res001@tmXTOn            = False ; kills tick marks (x-axis top)
  res001@tmYROn            = False ; kills tick marks (y-axis right)
  res001@tmXBLabelFontHeightF  = 0.025
  res001@tmYLLabelFontHeightF  = 0.025
  res001@lbLabelFontHeightF    = 0.025

  res001@lbLabelFont		        =21
  res001@lbLabelStride =4

  res001@mpGridAndLimbOn   = False           ; turn on lat/lon lines
  res001@mpPerimOn         = False 	      ; turn off perimeter  
  res001@mpProjection = "Robinson"       
  res001@mpGeophysicalLineThicknessF = 3.0


  res001@cnLabelBarEndStyle = "ExcludeOuterBoxes"

  plot(0) = gsn_csm_contour_map(wks,IPSL5B_Totalcld,res001)            ; plot contour map


;======================================================================  
; FIGURE 2
;======================================================================  
  res002                      = True               ; enable plot options
  res002@gsnFrame             = False              ; advance frame
  res002@gsnDraw              = False              ; draw
  res002@gsnMaximize          = True               ; Maximize plot in frame.

  res002@gsnSpreadColors      = True               ; spread colors around 0
  res002@gsnSpreadColorStart  = 3                  ; start at color XXX in colormap

  res002@tiMainString         = "IPSL5B Cloud Radiative Effect"  ;Main title
  res002@lbTitlePosition      = 1                  ; colorbar title position
  res002@lbTitleString        = ""       	   ; colorbar title
  res002@gsnLeftString        = ""                 ; string at left top of plot
  res002@lbOrientation        = "vertical"

  res002@cnFillOn             = True               ; Fill contours
  res002@cnFillMode           = "RasterFill"       ; Blocks vs. Smooth
  res002@cnLinesOn            = False              ; Contour lines off
  res002@cnMinLevelValF       = 40.                 ; min contour
  res002@cnMaxLevelValF       = -60                 ; max contour
  res002@cnLevelSelectionMode = "ExplicitLevels"    ; set explicit contour levels
  res002@cnLevels    = (/-60,-50,-40,-30,-20,-10,0,10,20,30,40 /)   ; set levels

  res002@tmXTBorderOn      = True ; kills border line (x-axis top)
  res002@tmYRBorderOn      = True ; kills border line (y-axis right)
  res002@tmXTOn            = False ; kills tick marks (x-axis top)
  res002@tmYROn            = False ; kills tick marks (y-axis right)
  res002@tmXBLabelFontHeightF  = 0.025
  res002@tmYLLabelFontHeightF  = 0.025
  res002@lbLabelFontHeightF    = 0.025

  res002@lbLabelFont		=21
  res002@lbLabelStride		=2

  res002@mpGridAndLimbOn   = False            ; turn on lat/lon lines
  res002@mpPerimOn         = False 	      ; turn off perimeter  
  res002@mpProjection = "Robinson"       
  res002@mpGeophysicalLineThicknessF = 3.0

  res002@cnLabelBarEndStyle = "ExcludeOuterBoxes"

  plot(2) = gsn_csm_contour_map(wks,IPSL5B_CREavg,res002)            ; plot contour map


;======================================================================  
; FIGURE 3
;======================================================================  
  res003                      = True               ; enable plot options
  res003@gsnFrame             = False              ; advance frame
  res003@gsnDraw              = False              ; draw
  res003@gsnMaximize          = True               ; Maximize plot in frame.
  res003@gsnSpreadColors      = True               ; spread colors around 0
  res003@gsnSpreadColorStart  = 1                  ; start at color XXX in colormap

  res003@tiMainString         = "IPSL5B Parasol Refl."  ;Main title
  res003@gsnLeftString        = ""                 ; string at left top of plot
  res003@lbTitlePosition      = 1                  ; colorbar title position
  res003@lbTitleString        = ""       ; colorbar title
  res003@lbOrientation        = "vertical"

  res003@cnFillOn             = True               ; Fill contours
  res003@cnFillMode           = "RasterFill"       ; Blocks vs. Smooth
  res003@cnLinesOn            = False              ; Contour lines off
  res003@cnMinLevelValF       = 0.                 ; min contour
  res003@cnMaxLevelValF       = 0.8                 ; max contour
  res003@cnLevelSelectionMode = "ExplicitLevels"    ; set explicit contour levels
  res003@cnLevels    = (/0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8 /)   ; set levels

  res003@tmXTBorderOn      = True ; kills border line (x-axis top)
  res003@tmYRBorderOn      = True ; kills border line (y-axis right)
  res003@tmXTOn            = False ; kills tick marks (x-axis top)
  res003@tmYROn            = False ; kills tick marks (y-axis right)
  res003@tmXBLabelFontHeightF  = 0.025
  res003@tmYLLabelFontHeightF  = 0.025
  res003@lbLabelFontHeightF    = 0.025

  res003@lbLabelFont		=21
  res003@lbLabelStride		=2

  res003@mpGridAndLimbOn   = False            ; turn on lat/lon lines
  res003@mpPerimOn         = False 	      ; turn off perimeter  
  res003@mpProjection = "Robinson"       
  res003@mpGeophysicalLineThicknessF = 3.0

  res003@cnLabelBarEndStyle = "ExcludeOuterBoxes"

  plot(4) = gsn_csm_contour_map(wks,IPSL5B_Reflectance,res003)            ; plot contour map


;======================================================================  
; FIGURE 3
;======================================================================  
  res004                      = True               ; enable plot options
  res004@gsnFrame             = False               ; advance frame
  res004@gsnDraw             = False               ; draw 
  res004@gsnMaximize          = True               ; Maximize plot in frame.
  res004@cnFillOn             = True               ; Fill contours
  res004@cnFillMode           = "RasterFill"       ; Blocks vs. Smooth
  res004@cnLinesOn            = False              ; Contour lines off
  res004@cnMinLevelValF       = 0.                 ; min contour
  res004@cnMaxLevelValF       = 100                 ; max contour
  res004@cnLevelSpacingF      = 5              ; interval of contours
  res004@gsnSpreadColors      = True               ; spread colors around 0
  res004@gsnSpreadColorStart  = 1                  ; start at color XXX in colormap
  res004@tiMainString         = "CALIPSO Total Cld Cover"  ;Main title
  res004@gsnLeftString        = ""                 ; string at left top of plot
  res004@lbTitlePosition      = 1                  ; colorbar title position
  res004@lbTitleString        = ""       ; colorbar title
  res004@lbOrientation        = "vertical"
  res004@cnLevelSelectionMode = "ExplicitLevels"    ; set explicit contour levels
  res004@cnLevels=(/ 0,10,20,30,40,50,60,70,80,90,100 /)   ; set levels

  res004@tmXTBorderOn      = True ; kills border line (x-axis top)
  res004@tmYRBorderOn      = True ; kills border line (y-axis right)
  res004@tmXTOn            = False ; kills tick marks (x-axis top)
  res004@tmYROn            = False ; kills tick marks (y-axis right)
  res004@tmXBLabelFontHeightF  = 0.025
  res004@tmYLLabelFontHeightF  = 0.025
  res004@lbLabelFontHeightF    = 0.025

  res004@lbLabelFont		        =21
  res004@lbLabelStride =4

  res004@mpGridAndLimbOn   = False           ; turn on lat/lon lines
  res004@mpPerimOn         = False 	      ; turn off perimeter  
  res004@mpProjection = "Robinson"       
  res004@mpGeophysicalLineThicknessF = 3.0


  res004@cnLabelBarEndStyle = "ExcludeOuterBoxes"

  plot(1) = gsn_csm_contour_map(wks,Satellite_Total,res004)            ; plot contour map


;======================================================================  
; FIGURE 4
;======================================================================  
  res005                      = True               ; enable plot options
  res005@gsnFrame             = False              ; advance frame
  res005@gsnDraw              = False              ; draw
  res005@gsnMaximize          = True               ; Maximize plot in frame.

  res005@gsnSpreadColors      = True               ; spread colors around 0
  res005@gsnSpreadColorStart  = 3                  ; start at color XXX in colormap

  res005@tiMainString         = "CERES Cloud Radiative Effect"  ;Main title
  res005@gsnLeftString        = ""                 ; string at left top of plot
  res005@lbTitlePosition      = 1                  ; colorbar title position
  res005@lbTitleString        = ""       ; colorbar title
  res005@lbOrientation        = "vertical"

  res005@cnFillOn             = True               ; Fill contours
  res005@cnFillMode           = "RasterFill"       ; Blocks vs. Smooth
  res005@cnLinesOn            = False              ; Contour lines off
  res005@cnMinLevelValF       = 40.                 ; min contour
  res005@cnMaxLevelValF       = -60                 ; max contour
  res005@cnLevelSelectionMode = "ExplicitLevels"    ; set explicit contour levels
  res005@cnLevels    = (/-60,-50,-40,-30,-20,-10,0,10,20,30,40 /)   ; set levels

  res005@tmXTBorderOn      = True ; kills border line (x-axis top)
  res005@tmYRBorderOn      = True ; kills border line (y-axis right)
  res005@tmXTOn            = False ; kills tick marks (x-axis top)
  res005@tmYROn            = False ; kills tick marks (y-axis right)
  res005@tmXBLabelFontHeightF  = 0.025
  res005@tmYLLabelFontHeightF  = 0.025
  res005@lbLabelFontHeightF    = 0.025

  res005@lbLabelFont		=21
  res005@lbLabelStride		=2

  res005@mpGridAndLimbOn   = False            ; turn on lat/lon lines
  res005@mpPerimOn         = False 	      ; turn off perimeter  
  res005@mpProjection = "Robinson"       
  res005@mpGeophysicalLineThicknessF = 3.0

  res005@cnLabelBarEndStyle = "ExcludeOuterBoxes"

  plot(3) = gsn_csm_contour_map(wks,CERES_CREavg,res005)            ; plot contour map


;======================================================================  
; FIGURE 5
;======================================================================  
  res006                      = True               ; enable plot options
  res006@gsnFrame             = False              ; advance frame
  res006@gsnDraw              = False              ; draw
  res006@gsnMaximize          = True               ; Maximize plot in frame.

  res006@gsnSpreadColors      = True               ; spread colors around 0
  res006@gsnSpreadColorStart  = 1                  ; start at color XXX in colormap

  res006@tiMainString         = "Parasol Reflectance"  ;Main title
  res006@gsnLeftString        = ""                 ; string at left top of plot
  res006@gsnRightString        = ""                 ; string at left top of plot
  res006@lbTitlePosition      = 1                  ; colorbar title position
  res006@lbTitleString        = ""       ; colorbar title
  res006@lbOrientation        = "vertical"

  res006@cnFillOn             = True               ; Fill contours
  res006@cnFillMode           = "RasterFill"       ; Blocks vs. Smooth
  res006@cnLinesOn            = False              ; Contour lines off
  res006@cnMinLevelValF       = 0.                 ; min contour
  res006@cnMaxLevelValF       = 0.8                 ; max contour
  res006@cnLevelSelectionMode = "ExplicitLevels"    ; set explicit contour levels
  res006@cnLevels    = (/0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8 /)   ; set levels

  res006@tmXTBorderOn      = True ; kills border line (x-axis top)
  res006@tmYRBorderOn      = True ; kills border line (y-axis right)
  res006@tmXTOn            = False ; kills tick marks (x-axis top)
  res006@tmYROn            = False ; kills tick marks (y-axis right)
  res006@tmXBLabelFontHeightF  = 0.025
  res006@tmYLLabelFontHeightF  = 0.025
  res006@lbLabelFontHeightF    = 0.025

  res006@lbLabelFont		=21
  res006@lbLabelStride		=2

  res006@mpGridAndLimbOn   = False            ; turn on lat/lon lines
  res006@mpPerimOn         = False 	      ; turn off perimeter  
  res006@mpProjection = "Robinson"       
  res006@mpGeophysicalLineThicknessF = 3.0

  res006@cnLabelBarEndStyle = "ExcludeOuterBoxes"

  plot(5) = gsn_csm_contour_map(wks,Satellite_Reflectance,res006)            ; plot contour map


;======================================================================
; PANEL PLOT 
;======================================================================
  res_Panel                     = True      ; modify the panel plot
  res_Panel@gsnMaximize         = True      ; maximize plot 

  res_Panel@gsnPanelXWhiteSpacePercent = 5    ;extra white space between panels in the x and y directions
  res_Panel@gsnPanelYWhiteSpacePercent = 5

  res_Panel@txString            = "Quality Check IPSL5B AMIP 2008 (comp. Monthly)"
  res_Panel@txFontHeightF       = 0.015


;======================================================================
  gsn_panel(wks,plot,(/3,2/),res_Panel)             ; now draw as one plot

end
