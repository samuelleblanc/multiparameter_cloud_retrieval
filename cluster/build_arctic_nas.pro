;+
; NAME:
;   build_arctic_nas
;
; PURPOSE:
;   create the input files and list file for running libradtran for ice and liquid water clouds
;   builds the base input files for an entire reference table/ look-up-table
;   For the cluster systems
;   After running libradtran (not in here) will produce radiance spectra at defined altitudes
;
; CALLING SEQUENCE:
;   build_arctic_nas
;
; INPUT:
;   - none in command line
;
; OUTPUT:
;   - cld_ta??_re??_v?.in files for ice and liquid clouds, 
;     - where ta?? is the tau index
;     - re?? is the ref index
;     - v? is the wavelenght index, 0 for vis spectrometer (350-981 nm) and 1 for nir spectrometer (981-1700 nm)
;   - list file with the command to run uvspec for each individual input file (lut point) 
;
; KEYWORDS:
;   - none
;
; DEPENDENCIES:
;   - zensun.pro
;   - write_inp_mix.pro
;     - make_ic_files.pro
;     - make_wc_files.pro
;  
; NEEDED FILES:
;   - atmosphere profile file for day
;   - albedo file for the day
;   - mie_hi.out file for water cloud (legendre coefficients factorisation of the scattering phase function)
;   - baum_2011_ice_512.out file for ice cloud (legendre coefficients factorisation of the scattering phase function)
;
; EXAMPLE:
;   IDL > .r build_arctic_nas.pro
;   IDL > build_arctic_nas
;
;
; MODIFICATION HISTORY:
; Written:  Samuel LeBlanc, LASP CU Boulder, date unknown
; Modified: By Samuel LeBlanc, June 13th, Cupertino, CA
;           - ported over from Janus cluster to Pleiades cluster
;             - changed directories and corrected water cloud overwriting ice clouds input files
;           By Samuel LeBlanc, August 7th, Pocomoke City, MD, near Wallops Flight Center
;           - modified from SEAC4RS use to arctic ARISE mission
;---------------------------------------------------------------------------
@zensun.pro
;@make_ic_files.pro
;@write_inp_mix_profile.pro
@write_inp_mix.pro

pro build_arctic_nas

;set the proper directories
;date='20130911_icenosnow'  ;date
;date='20140911_hi_lowcld'
date='20140919_ice'
vv='v1'  ; version string
;pw=5./9.2*(18.3+9.2)
; z0=0.5, z1=1.5 or normal, z2=3, z3=5, z4=7, z5=9
; w0=5mm, w1=10mm, w2=15mm, w3=20mm, w4=25mm, w5=30mm
; changes in surface albedo
; ab1=2012-08-04, ab2=2012-08-12, ab3=2012-08-20, ab4=2012-09-13
; dref refer to ref increasing with altitude, with 10 layers, with ref/2. at bottom, and ref*1.5 at top


indir ='/nobackupp8/sleblan2/rtm/input/'+vv+'_'+date+'/' ;'/lustre/janus_scratch/leblanse/cloud/input/'+vv+'_'+date+'/'
outdir='/nobackupp8/sleblan2/rtm/output/'+vv+'_'+date+'/' ;'/lustre/janus_scratch/leblanse/cloud/output/'+vv+'_'+date+'/'
;indir ='/projects/leblanse/cloud/rt_files/input/sp_hires5_'+date+'/'
;outdir='/projects/leblanse/cloud/rt_files/output/sp_hires5_'+date+'/'
dir   ='/home5/sleblan2/4STAR/runs/' ;'/projects/leblanse/4STAR/'
datdir='/home5/sleblan2/4STAR/rtm_dat/' ;'/projects/leblanse/cloud/'

; load the liquid water mie file
print, 'restoring saved water and ice properties'
;restore, 'wc_mie_water.out'
restore, datdir+'mie_hi.out'
wc_mie={ext:ext,nmom:nmom,pmom:pmom,ref:ref,ssa:ssa,wvl:wvl}
restore, datdir+'baum_2011_ice_512.out'
      nstr=512
ic_dat={ext:ext,nmom:nmom,pmom:pmom,ref:ref,ssa:ssa,wvl:wvl,nstr:nstr}

spawn,'mkdir '+indir
spawn,'mkdir '+outdir
;spawn,'mkdir '+dir
list_file=dir+'run_'+vv+'_'+date+'.sh'

alb=0.2

;make the table spacing
;tau=[1.,2.,3.,4.,5.,7.,8.,10.,12.,15.,20.,25.,30.,35.,40.,45.,50.,60.,70.,80.,90.,100.]
;new tau spacing
tau=[0.2,0.5,1.,2.,3.,4.,5.,7.,8.,10.,12.,15.,20.,25.,30.,35.,40.,45.,50.,60.,70.,80.,90.,100.]
ref=[2.,3.,4.,5.,6.,7.,8.,9.,10.,11.,12.,13.,14.,15.,16.,17.,18.,20.,22.,23.,25.,28.,$
     30.,32.,35.,38.,40.,43.,45.,48.,50.,52.,55.,58.,60.]

;lat=64.6 ;29.609106 ;40.0079166
;lon=-145.08 ;95.168302 ;-105.26825

lat=72.02 ; for 20140919
lon=129.3 ;for 20140919
doy=julian_day(strmid(date,0,4),strmid(date,4,2),strmid(6,2))
zensun, doy,18.41,lat, lon, sza, azi, solfac
print, 'opening list_file:'+list_file

;sza=50. ;snd, for all z, and all w
;sza=45. ;snd2
;sza=55. ;sdn3
;sza=40. ;snd4
;sza=50
sza=70.8 ;for 20140919

uu=97
openw,uu,list_file

;for v5
;atm_file='/lustre/janus_scratch/leblanse/wx/atmos_aero_20120525_at.dat.dat'
;alb_file='/lustre/janus_scratch/leblanse/albedo_2012-05-24.dat';snow_albedo.dat'; albedo_2012-05-24.dat'
;atm_file='/projects/leblanse/libradtran/libRadtran-1.7/data/atmmod/afglms.dat'
;alb_file='/projects/leblanse/cloud/albedo_2012-05-24.dat'
if (0) then begin ; for v1 20130911_icenosnow
atm_file='/nobackupp8/sleblan2/dat/atmos_aero_20130911_at.dat'
;alb_file='/nobackupp8/sleblan2/dat/albedo_snow_ice.dat';snow_albedo.dat'; albedo_2012-05-24.dat'
alb_file='/nobackupp8/sleblan2/dat/albedo_ice.dat'
zout=[0.2,3.0]
cldbot=1.0 & clddz=0.5
endif

if (0) then begin ; for v1 20140911 hi lowcld (high clouds over low clouds flight level albedo)
  atm_file='/nobackupp8/sleblan2/dat/atmos_aero_20140911_at.dat'
  alb_file='/nobackupp8/sleblan2/dat/albedo_lowcld.dat'
  zout=[0.2,7.0]
 cldbot=8.0 & clddz=0.5
endif

if (1) then begin ;for 20140919
atm_file='/nobackupp8/sleblan2/dat/atmos_20140919.dat'
  alb_file='/nobackupp8/sleblan2/dat/albedo_20140919_2158.dat'
  zout=[0.2,2.0]
 cldbot=0.3 & clddz=1.5
endif

uvspec_p='/home5/sleblan2/libradtran/libRadtran-1.7/bin/uvspec'
albedo=0.2

base=indir+'base.in'
write_base, base, doy, sza, atm_file, in, azi, alb_file=alb_file, /kurudz

  for t=0, n_elements(tau)-1 do begin
    for r=0, n_elements(ref)-1 do begin
       cloud=[tau[t],ref[r],cldbot,clddz]
        if ref[r] le 30. then begin       
          fn='cld_ta'+string(t,format='(I02)')+'_re'+string(r,format='(I02)')+'_v0'
          outf=outdir+fn+'.out' & inf =indir +fn+'.in' & inf2=indir+'../v1_20120525_dref/'+fn+'.in'
          wvl=[400.,981.]
          write_inp_mix, doy, sza, atm_file, inf, azi, wvl, zout,$; /nofile,noff=inf2,$ 
           /quiet, cloudl=cloud,alb_file=alb_file,cloudi=cloud, wp=0.,wc_mie=wc_mie,/kurudz,/slit,base=base  ;,/prof; ,pw=pw
          printf, uu, uvspec_p+' < '+inf+' > '+outf

          fn='cld_ta'+string(t,format='(I02)')+'_re'+string(r,format='(I02)')+'_v1'
          outf=outdir+fn+'.out' & inf =indir +fn+'.in' & inf2=indir+'../v1_20120525_dref/'+fn+'.in'
          wvl=[981.,1700.]
          write_inp_mix, doy, sza, atm_file, inf, azi, wvl, zout,$; /nofile,noff=inf2,$ 
           /quiet, cloudl=cloud,alb_file=alb_file,cloudi=cloud, wp=0.,wc_mie=wc_mie,/kurudz,/slit, base=base;,/prof ;,pw=pw
          printf, uu, uvspec_p+' < '+inf+' > '+outf
        endif
        print, tau[t],ref[r] 
;        if ref[r] ge 5. then begin
;          write_inp_mix, doy, sza, atm_file, inf, azi, wvl, zout,$; /nofile,noff=inf2,$ 
;           /quiet, cloudl=cloud,alb_file=alb_file,cloudi=cloud, wp=0.,wc_mie=wc_mie,/kurudz,/slit;,/prof ;,pw=pw
;          printf, uu, '/projects/leblanse/libradtran/libRadtran-1.7/bin/uvspec < '+inf+' > '+outf
;        endif
        print, tau[t],ref[r] 
        if ref[r] ge 5. then begin
          fn='cld_ta'+string(t,format='(I02)')+'_re'+string(r,format='(I02)')+'_v0_ice'
          outf=outdir+fn+'.out'& inf =indir +fn+'.in' & inf2=indir+'../v1_20120525_dref/'+fn+'.in'
          wvl=[400.,981.]
          write_inp_mix, doy, sza, atm_file, inf, azi, wvl, zout,$;/nofile,noff=inf2,$
           /quiet, cloudl=cloud,alb_file=alb_file,cloudi=cloud, wp=1.,ic_dat=ic_dat,/kurudz,/slit,base=base;,/prof ;,pw=pw
          printf, uu, uvspec_p+' < '+inf+' > '+outf

          fn='cld_ta'+string(t,format='(I02)')+'_re'+string(r,format='(I02)')+'_v1_ice'
          outf=outdir+fn+'.out'& inf =indir +fn+'.in' & inf2=indir+'../v1_20120525_dref/'+fn+'.in'
          wvl=[981.,1700.]
          write_inp_mix, doy, sza, atm_file, inf, azi, wvl, zout,$; /nofile,noff=inf2,$ 
           /quiet, cloudl=cloud,alb_file=alb_file,cloudi=cloud, wp=1.,ic_dat=ic_dat,/kurudz,/slit,base=base;,/prof ;,pw=pw
          printf, uu, uvspec_p+' < '+inf+' > '+outf
        endif
        print, inf
    endfor   ;ref loop
  endfor    ;tau loop

free_lun,uu

end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Write input file program                                                    ;;
;; used to make the input file for uvspec                                      ;;
;; use radiance keyword to set radiance (zenith pointing)                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro write_input_file, doy, sza, tau_file, atm_file, input_file, azimuth, asy, ssa, wvl, zout, albedo, radiance=radiance,$
  quiet=quiet, tau_scale=tau_scale, slit=slit, nofile=nofile, aod=aod,cloud=cloud,h2o=h2o,alb_file=alb_file,ice=ice,ic_files=ic_files

if n_elements(cloud) gt 0 then begin
  ;cld =[tau,ref,alt,thick]   ; tau,Reff,cloud_height_km; cloud_thickness_km
  lwp=2./3.*cloud[1]*cloud[0]
  lwc=lwp/cloud[3]*0.001
  ref=cloud[1]
  uc=98
  openw ,uc,input_file+'cld.dat'
  if n_elements(ic_files) eq 0 then begin
    printf,uc,cloud[2]+cloud[3],0  ,0
    printf,uc,cloud[2]  ,         lwc,ref
    printf,uc,cloud[2]-0.5*cloud[3],0  ,0
  endif else begin
    printf,uc,cloud[2]+cloud[3],' '+input_file+'cld0.dat',format='(F12.6," ",A)'
    printf,uc,cloud[2]  ,' '+input_file+'cld1.dat',format='(F12.6," ",A)'
    printf,uc,cloud[2]-0.5*cloud[3],' '+input_file+'cld0.dat',format='(F12.6," ",A)'
    make_ic_files, input_file+'cld0.dat', [0,cloud[1],cloud[2],cloud[3]],/new
    make_ic_files, input_file+'cld1.dat', cloud,/new
  endelse
  free_lun,uc
endif

ui=99
openw,ui,input_file;,/get_lun
printf,ui,'data_files_path   /projects/leblanse/libradtran/libRadtran-1.6-beta/data'
printf,ui,'solar_file        /projects/leblanse/libradtran/solar_SSFR.dat' ;/projects/leblanse/libradtran/libRadtran-1.6-beta/data/solar_flux/kurudz_0.1nm.dat';/projects/leblanse/libradtran/solar_SSFR.dat'
printf,ui,'atmosphere_file   '+atm_file

;printf,ui,'albedo_library    IGBP    # Spectral albedo library '
;printf,ui,'surface_type      13      # urban albedo from library'
if albedo lt 0 then albedo=albedo*(-1.)
;printf,ui,'albedo            '+string(albedo)  ; 
printf,ui,'albedo_file     '+alb_file  ; 

printf,ui,'rte_solver        disort2'
if n_elements(cloud) lt 1 then printf,ui,'nstr              6' else printf,ui,'nstr             28'
printf,ui,'correlated_k      SBDART'        ; pseudo-spectral definition of atmospheric absorption
if keyword_set(radiance) then begin
  printf,ui,'umu               -1  # -1:downward radiance; 1:upward radiance; 0:sidward radiance' ;for radiances (ship)
  printf,ui,'phi               270.0   # output azimuth angle (flight-direction: NNW = 350°)' ;for radiances(ship direction)
endif

if n_elements(cloud) lt 1 then begin
  printf,ui,'aerosol_default'                   ; initialize aerosol
  if not keyword_set(nofile) then printf,ui,'aerosol_tau_file  '+tau_file else printf, ui, 'aerosol_set_tau  '+string(aod)
  printf,ui,'aerosol_set_ssa   '+string(ssa)
  printf,ui,'aerosol_set_gg    '+string(asy)
  if keyword_set(tau_scale) then printf, ui, 'aerosol_scale_tau   '+string(tau_scale)
endif else begin
  if n_elements(ice) gt 0 then begin
    if n_elements(ic_files) gt 0 then printf,ui,'ic_files  '+input_file+'cld.dat' else printf,ui,'ic_file  '+input_file+'cld.dat'
    printf,ui,'ic_layer'
    if n_elements(ic_files) eq 0 then begin
      printf,ui,'ic_properties baum'
      printf,ui,'ic_properties_interpolate'
    endif
  endif else begin  
    printf,ui,'wc_file '+input_file+'cld.dat'
    printf,ui,'wc_layer'
    printf,ui,'wc_properties mie'
    printf,ui,'wc_properties_interpolate'
  endelse
endelse

if n_elements(h2o) gt 0 then printf,ui,'h2o_precip        '+string(h2o,format='(F6.3)')
printf,ui,'wavelength        '+string(wvl[0],format='(I4)')+'  '+string(wvl[1],format='(I4)') ; wavelengths

if n_elements(ic_files) eq 0 then begin
  printf,ui,'altitude          1.66' ;0.263 # elevation (ASL) of CalTech in km'      
  printf,ui,'zout              '+string(zout, format='('+strtrim(string(n_elements(zout)),2)+'(" ",F8.2))')
endif else begin
  printf,ui,'zout              '+string(zout+1.66, format='('+strtrim(string(n_elements(zout)),2)+'(" ",F8.2))')
  printf,ui,'disort_icm moments'
endelse

if keyword_set(slit) then begin ; if set, use slit function, must change for IngAas
  if wvl[0] le 940 then printf,ui,'slit_function_file /projects/leblanse/libradtran/vis_0.1nm.dat' else printf,ui,'slit_function_file /projects/leblanse/libradtran/nir_0.1nm.dat'
endif

printf,ui,'deltam on'
printf,ui,'quiet'
free_lun,ui

if not keyword_set(quiet) then print, 'input file saved to: '+input_file

end

