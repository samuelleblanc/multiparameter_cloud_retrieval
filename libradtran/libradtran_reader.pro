;+
; NAME:
;   libradtran_reader
;
; PURPOSE:
;   read in the data from a libradtran output file
;
; CATEGORY:
;   libradtran, radiance and irradiance
;
; CALLING SEQUENCE:
;   data=libradtran_reader(file=filename)
;
; OUTPUT:
;   structure that contains all the data from the libradtran output file
;
; KEYWORDS:
;   - file : must be the name of the output file
;   - zout : must be the values of the zout that was included (to split up output
;   - radiance : to set to reading in radiances
;
; DEPENDENCIES:
;
; NEEDED FILES:
;   - output file from libradtran
;
; EXAMPLE:
;
;
; MODIFICATION HISTORY:
; Written:  Samuel LeBlanc, LASP CU Boulder, July 28th
; Modified: August, 11th, 2010 by Samuel LeBlanc
;           - added zout keyword, to split up the output into different zout values
;           - added radiance keyword, to read in values without radiance
;---------------------------------------------------------------------------

function libradtran_reader, file=file, zout=zout, radiance=radiance, quiet=quiet

if not keyword_set(file) then message, 'No File name specified'
if not keyword_set(quiet) then print, 'Only for DISORT'
if keyword_set(radiance) and not keyword_set(quiet) then print, 'for one azimuth, phi with radiance'

on_error, 2

;on_ioerror, io
lun=95
openr, lun, file;, /get_lun

first=fltarr(7)
second=fltarr(1)
third=fltarr(3)
count=0
while not eof(lun) do begin
  readf, lun, first
  if keyword_set(radiance) then  begin
    readf, lun, second
    readf, lun, third
  endif
  count = count +1

  if count gt 1 then begin
    wvl=[wvl,first[0]]
    dir_dn=[dir_dn,first[1]/1000.0]
    dif_dn=[dif_dn,first[2]/1000.0]
    dif_up=[dif_up,first[3]/1000.0]
    if keyword_set(radiance) then phi=[phi,second[0]]
    if keyword_set(radiance) then rad=[rad,third[2]/1000.]
    if keyword_set(radiance) then if phi[count-2] ne second[0] then message, 'phi not equal at line'+string(count)
  endif else begin
    wvl=first[0]
    dir_dn=first[1]/1000.0
    dif_dn=first[2]/1000.0
    dif_up=first[3]/1000.0
    if keyword_set(radiance) then phi=second[0]
    if keyword_set(radiance) then rad=third[2]/1000.0
  endelse
endwhile
free_lun,lun

if keyword_set(zout) then begin
  r=n_elements(zout)
  w=fltarr(r,n_elements(wvl)/r)
  ddr=fltarr(r,n_elements(wvl)/r)
  ddf=fltarr(r,n_elements(wvl)/r)
  duf=fltarr(r,n_elements(wvl)/r)
  if keyword_set(radiance) then p=fltarr(r,n_elements(wvl)/r)
  if keyword_set(radiance) then ra=fltarr(r,n_elements(wvl)/r)

  for i=0, r-1 do begin
    w[i,*]=wvl[i:*:r]
    ddr[i,*]=dir_dn[i:*:r]
    ddf[i,*]=dif_dn[i:*:r]
    duf[i,*]=dif_up[i:*:r]
    if keyword_set(radiance) then p[i,*]=phi[i:*:r]
    if keyword_set(radiance) then ra[i,*]=rad[i:*:r]
  endfor
  wvl=w & dir_dn=ddr & dif_dn=ddf & dif_up=duf
  if keyword_set(radiance) then begin 
    phi=p
    rad=ra
  endif
endif else zout=0

if keyword_set(radiance) then $
  data={wvl:wvl,dir_dn:dir_dn,dif_dn:dif_dn,dif_up:dif_up,rad:rad,zout:zout} else $
  data={wvl:wvl,dir_dn:dir_dn,dif_dn:dif_dn,dif_up:dif_up,zout:zout}

;io: message, 'File opening failed'
return, data
end
