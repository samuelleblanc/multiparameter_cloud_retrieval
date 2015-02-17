;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Write input file program                                                    ;;
;; used to make the input file for uvspec                                      ;;
;; program to build the mixed phase clouds
;; is not suitable for any other use

@make_ic_files.pro
@make_wc_files.pro
pro write_inp_mix, doy, sza, atm_file, input_file, azimuth, wvl, zout, $
  quiet=quiet, slit=slit, cloudl=cloudl,h2o=h2o,alb_file=alb_file,ice=ice,ic_files=ic_files,$
  cloudi=cloudi, wp=wp, kurudz=kurudz,wc_mie=wc_mie,hi_slit=hi_slit,pw=pw, nofile=nofile,$
  ic_dat=ic_dat, wc_included=wc_included,no_file=no_file,noff=noff,sea=sea,base=base

  if n_elements(base) lt 1 then basefile=0 else basefile=1
  if n_elements(kurudz) lt 1 then kurudz=0 else kurudz=1
  if n_elements(nofile) lt 1 then nofile=0 else nofile=1
  if nofile eq 0 and n_elements(no_file) lt 1 then nofile=0 else nofile=1
  ;if nofile then print, 'nofile'
  if n_elements(wc_included) lt 1 then wci=0 else wci=1
  if n_elements(sea) lt 1 then sea=0 else sea=1

cloud=cloudl
  ;cld =[tau,ref,alt,thick]   ; tau,Reff,cloud_height_km; cloud_thickness_km
 
; split the contributions liquid water and ice water to taus
  taul=cloud[0]*(1.-wp)
  taui=cloudi[0]*wp

  lwp=2./3.*cloud[1]*taul
  lwc=lwp/cloud[3]*0.001
  ref=cloud[1]
  refi=cloudi[1]
;  lwc=twc*(1.-wp)
;  iwc=twc*wp
  iwp=2./3.*refi*taui
  iwc=iwp/cloudi[3]*0.001
;  dzi=cloudi[3]*1000.
;  taui=iwc*dzi*3./2./refi
;  dzl=cloud[3]*1000.
;  taul=lwc*dzl*3./2./ref

if nofile then begin
  k=strsplit(input_file,/extract,'/')
  if n_elements(noff) lt 1 then fi='/lustre/janus_scratch/leblanse/cloud/input/sp_hires5_20120524/'+k[n_elements(k)-1] else $
   fi=noff
endif else fi=input_file
  low_level=cloud[2]-0.5*cloud[3]
  if low_level le 0.0 then low_level=0.002

  uc=98
  if wp ne 1.0 then begin
    if wci then begin 
      openw ,uc,input_file+'lcld.dat'
      printf,uc,cloud[2]+cloud[3],' 0 0'
      printf,uc,cloud[2]  ,' '+string(lwc)+' '+string(ref)
      printf,uc,low_level,' 0 0'
      free_lun,uc
    endif else begin
      openw ,uc,input_file+'lcld.dat'
      printf,uc,cloud[2]+cloud[3],' '+fi+'lcld0.dat',format='(F12.6," ",A)'
      printf,uc,cloud[2]  ,' '+fi+'lcld1.dat',format='(F12.6," ",A)'
      printf,uc,low_level,' '+fi+'lcld0.dat',format='(F12.6," ",A)'
      free_lun,uc
      if not nofile then make_wc_files, input_file+'lcld0.dat',[0,ref,cloud[2],cloud[3]],wvls=wvl,wc_mie=wc_mie
      if not nofile then make_wc_files, input_file+'lcld1.dat',[taul,ref,cloud[2],cloud[3]],wvls=wvl,wc_mie=wc_mie
    endelse
  endif

  low_leveli=cloudi[2]-0.5*cloudi[3]
  if low_leveli le 0.0 then low_leveli=0.002
  if wp ne 0.0 then begin
    openw ,uc,input_file+'icld.dat'
    printf,uc,cloudi[2]+cloudi[3],' '+fi+'cld0.dat',format='(F12.6," ",A)'
    printf,uc,cloudi[2]  ,' '+fi+'cld1.dat',format='(F12.6," ",A)'
    printf,uc,low_leveli,' '+fi+'cld0.dat',format='(F12.6," ",A)'
    if not nofile then make_ic_files, input_file+'cld0.dat', [0,cloudi[1],cloudi[2],cloudi[3]],/new,ic_dat=ic_dat
    if not nofile then make_ic_files, input_file+'cld1.dat', [taui,refi,cloudi[2],cloudi[3]],/new,ic_dat=ic_dat
    free_lun,uc
  endif

ui=99
openw,ui,input_file;,/get_lun
if basefile then begin
  printf, ui, 'include    '+base
endif else begin
  printf,ui,'data_files_path   /home5/sleblan2/libradtran/libRadtran-1.7/data'
  if kurudz then printf,ui, 'solar_file /home5/sleblan2/libradtran/libRadtran-1.7/data/solar_flux/kurudz_1.0nm.dat' else $
  printf,ui,'solar_file        /home5/sleblan2/libradtran/solar_SSFR.dat' ;/projects/leblanse/libradtran/libRadtran-1.6-beta/data/solar_flux/kurudz_0.1nm.dat';/projects/leblanse/libradtran/solar_SSFR.dat'
  printf,ui,'atmosphere_file   '+atm_file
  if not sea then printf,ui,'albedo_file       '+alb_file  else printf,ui, 'cox_and_munk_u10  6'  ; 

  printf,ui,'rte_solver        disort2'
  printf,ui,'nstr              28'
  printf,ui,'correlated_k      SBDART'        ; pseudo-spectral definition of atmospheric absorption

  printf,ui,'sza               '+string(sza)    ; solar zenith angle (deg)
  printf,ui,'day_of_year       '+string(doy)    ; day of year for Sun-Earth distance

  printf,ui,'phi0              '+string(azimuth+180.0); solar azimuth angle (deg)
  printf,ui,'umu               -1  # -1:downward radiance; 1:upward radiance; 0:sidward radiance' ;for radiances (ship)
  printf,ui,'phi               270.0   # output azimuth angle (flight-direction: NNW = 350°)' ;for radiances(ship direction)
endelse

if wp ne 0.0 then begin
  printf,ui,'ic_files  '+input_file+'icld.dat'
  printf,ui,'ic_layer'
endif 
if wp ne 1.0 then begin
  if wci then begin
    printf,ui,'wc_file  '+input_file+'lcld.dat'
    printf,ui,'wc_properties mie'
    printf,ui,'wc_properties_interpolate'
  endif else begin
    printf,ui,'wc_files '+input_file+'lcld.dat'
    printf,ui,'wc_layer'
  endelse
endif

if n_elements(h2o) gt 0 then printf,ui,'h2o_precip        '+string(h2o,format='(F6.3)')
printf,ui,'wavelength        '+string(wvl[0],format='(I4)')+'  '+string(wvl[1],format='(I4)') ; wavelengths

printf,ui,'zout              '+string(zout, format='('+strtrim(string(n_elements(zout)),2)+'(" ",F8.2))')
if not wci then printf,ui,'disort_icm moments'

if keyword_set(hi_slit) then begin ; if set, use slit function, must change for IngAas
  if wvl[0] le 940 then printf,ui,'slit_function_file /projects/leblanse/libradtran/vis_0.1nm.dat' else $
   printf,ui,'slit_function_file /projects/leblanse/libradtran/nir_0.1nm.dat'
endif

if keyword_set(slit) then begin ; if set, use slit function, must change for IngAas
  if wvl[0] le 940 then printf,ui,'slit_function_file /nobackupp8/sleblan2/dat/slit/4STAR_vis_slit_1nm.dat' else $    ;'slit_function_file /projects/leblanse/libradtran/vis_1nm.dat' else $
   printf,ui,'slit_function_file /nobackupp8/sleblan2/dat/slit/4STAR_nir_slit_1nm.dat'  ;'slit_function_file /projects/leblanse/libradtran/nir_1nm.dat'
;if wvl[0] le 940 then printf,ui,'slit_function_file /lustre/janus_scratch/leblanse/data/vis_1nm.dat' else $
;   printf,ui,'slit_function_file /lustre/janus_scratch/leblanse/data/nir_1nm.dat'

endif

if not basefile then begin
  if n_elements(pw) gt 0 then printf,ui, 'h2o_precip  '+string(pw)

  printf,ui,'deltam on'
  printf,ui,'quiet'
endif

free_lun,ui

if not keyword_set(quiet) then print, 'input file saved to: '+input_file

end



;;;;;;;;;;;;;
;; New base file writer to simplify writing large amount of files for many cases
;;;;;;;;;;;;;
pro write_base, base, doy, sza, atm_file, in, azimuth, alb_file=alb_file, kurudz=kurudz,sea=sea,pw=pw

  if n_elements(kurudz) lt 1 then kurudz=0 else kurudz=1
  if n_elements(sea) lt 1 then sea=0 else sea=1


ui=96
openw,ui,base
  printf,ui,'data_files_path   /home5/sleblan2/libradtran/libRadtran-1.7/data'
  if kurudz then printf,ui, 'solar_file /home5/sleblan2/libradtran/libRadtran-1.7/data/solar_flux/kurudz_1.0nm.dat' else $
  printf,ui,'solar_file        /home5/sleblan2/libradtran/solar_SSFR.dat' ;/projects/leblanse/libradtran/libRadtran-1.6-beta/data/solar_flux/kurudz_0.1nm.dat';/projects/leblanse/libradtran/solar_SSFR.dat'
  printf,ui,'atmosphere_file   '+atm_file
  if not sea then printf,ui,'albedo_file       '+alb_file  else printf,ui, 'cox_and_munk_u10  6'  ;

  printf,ui,'rte_solver        disort2'
  printf,ui,'nstr              28'
  printf,ui,'correlated_k      SBDART'        ; pseudo-spectral definition of atmospheric absorption

  printf,ui,'sza               '+string(sza)    ; solar zenith angle (deg)
  printf,ui,'day_of_year       '+string(doy)    ; day of year for Sun-Earth distance

  printf,ui,'phi0              '+string(azimuth+180.0); solar azimuth angle (deg)
  printf,ui,'umu               -1  # -1:downward radiance; 1:upward radiance; 0:sidward radiance' ;for radiances (ship)
  printf,ui,'phi               270.0   # output azimuth angle (flight-direction: NNW = 350°)' ;for radiances(ship direction)


  if n_elements(pw) gt 0 then printf,ui, 'h2o_precip  '+string(pw)

  printf,ui,'deltam on'
  printf,ui,'quiet'
  free_lun,ui

end
