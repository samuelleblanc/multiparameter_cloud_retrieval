; program to make the ic_files
; takes input of optical depth and effective radius to calculate the accurate extension coefficient

pro make_ic_files, file, cloud,new=new,phase=phase,ic_dat=ic_dat

;cld should be an array of ;cld =[tau,ref,alt,thick]   ; tau,Reff,cloud_height_km; cloud_thickness_km
  iwp=2./3.*cloud[1]*cloud[0]
  iwc=iwp/cloud[3]*0.001
  refi=cloud[1]

if n_elements(ic_dat) lt 1 then begin
  if n_elements(phase) gt 0 then begin
    restore, phase
    nstr=max(nmom)
    pm=fltarr(nstr)
    wvl=wvl/1000. ;make the wavelengths into microns
  endif else begin
    if n_elements(new) lt 1 then begin
      restore, 'baum_2011_ice_512.out'
      nstr=512
    endif else begin
      restore, 'baum_2011_small_xxs.out'
      nstr=255
    endelse
    pm=fltarr(nstr)
  endelse
endif else begin
  ext=ic_dat.ext
  nmom=ic_dat.nmom
  pmom=ic_dat.pmom
  ref=ic_dat.ref
  ssa=ic_dat.ssa
  wvl=ic_dat.wvl
  nstr=ic_dat.nstr
  pm=fltarr(nstr)
endelse


openw, lun, file, /get_lun
for i=0, n_elements(wvl)-1 do begin
  ex=interpol(ext[*,i],ref,refi)
  ex=ex*iwc
  ss=interpol(ssa[*,i],ref,refi)
  nul=min(abs(ref-refi),ir)
  if n_elements(phase) gt 0 then begin
    nstr=nmom[ir,i]
    for j=0, nstr-1 do pm[j]=pmom[j,0,ir,i]/(2.*j+1.)
  endif else $
   if n_elements(new) lt 1 then for j=0, nstr-1 do pm[j]=pmom[j,0,ir,i]/(2.*j+1.) else for j=0, nstr-1 do pm[j]=pmom[j,0,ir,i]/(2.*j+1.)/(2.*j+1.)
  printf, lun, wvl[i]*1000.,ex,ss,pm[0:nstr-1],format='(F6.1," ",F16.11," ",'+strtrim(nstr+1)+'(F11.7," "))'
if cloud[0] ne 0  and i eq 10 then begin
  print, cloud[0],cloud[1],iwp, iwc, ext[ir,i],ex/iwc*100.,ex
;  stop
endif
endfor
close,lun
free_lun,lun
end
