; program to make the wc_files
; takes input of optical depth and effective radius to calculate the accurate extension coefficient

pro make_wc_files, file, cloud,wvls=wvls,wc_mie=wc_mie

;cld should be an array of ;cld =[tau,ref,alt,thick]   ; tau,Reff,cloud_height_km; cloud_thickness_km
  iwp=2./3.*cloud[1]*cloud[0]
  iwc=iwp/cloud[3]*0.001
  refi=cloud[1]

if n_elements(wvls) lt 1 then vv=0 else vv=1

if n_elements(wc_mie) lt 1 then restore, '../model/mie_hi.out' else begin ;'wc_mie_water.out' else begin
  ext=wc_mie.ext
  nmom=wc_mie.nmom
  pmom=wc_mie.pmom
  ref=wc_mie.ref
  ssa=wc_mie.ssa
  wvl=wc_mie.wvl
endelse
;nstr=512
nstr=max(nmom);256
pm=fltarr(nstr)
if vv then begin 
  vv0=wvls[0]-20
  vv1=wvls[1]+20
  nul=min(abs(wvl-vv0/1000.),v0)
  nul=min(abs(wvl-vv1/1000.),v1)
endif else begin
  v0=0
  v1=n_elements(wvl)
endelse
openw, lun, file, /get_lun
for i=v0, v1-1 do begin
;  ex=interpol(ext[*,i],ref,refi);/1E17
  ;ex=interpol(ext[i,*],ref,refi)
;  ex=ext[i,ir]
;  ex=ex*iwc
  ;ss=interpol(ssa[*,i],ref,refi)
  ;ss=interpol(ssa[i,*],ref,refi)
  nul=min(abs(ref-refi),ir)
  ex=ext[i,ir]
  ex=ex*iwc  
  ss=ssa[i,ir]
;  for j=0, nmom[0,ir,i]-1 do pm[j]=pmom[j,0,ir,i]/(2.*j+1.)
  for j=0, nmom[i,ir]-1 do pm[j]=pmom[j,i,ir]/(2.*j+1.)
;printf, lun, wvl[i]*1000.,ex,ss,pm[0:nmom[0,ir,i]-1],format='(F6.1," ",F16.11," ",'+strtrim(nstr+1)+'(F11.7," "))'
printf, lun, wvl[i]*1000.,ex,ss,pm[0:nmom[i,ir]-1],format='(F6.1," ",F16.11," ",'+string(nmom[i,ir]+1,format='(I5)')+'(F11.7," "))'
if cloud[0] ne 0  and i eq 10 then begin
  print, cloud[0],cloud[1],iwp, iwc, ext[i,ir],ex/iwc*100.,ex
  ;stop
endif
endfor
close,lun
free_lun,lun
end
