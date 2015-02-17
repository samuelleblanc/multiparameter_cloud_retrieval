; program to analyse some SEAC4RS data
; plots the spectra of DC8 and ER2 as it goes into cirrus cloud
; 

@C:\Users\Samuel\Research\SEAC4RS\pro\read_iwg_dc8.pro
@C:\Users\Samuel\Research\SEAC4RS\pro\read_IWG_er2.pro

pro plot_cirrus

dir='C:\Users\Samuel\Research\SEAC4RS\data\'
restore, dir+'20130913_calibspcs.out'
nsp_er2=zspectra
zsp_er2=nspectra
tm_er2=tmhrs
restore, dir+'20130913_calibspcs_dc8.out'
nsp_dc8=nspectra
zsp_dc8=zspectra
tm_dc8=tmhrs

read_iwg_dc8, dir+'nav_dc8_20130913.iwg',utc_dc8,lat_dc8,lon_dc8,alt_dc8,sza_dc8,tem_dc8
read_iwg_er2, dir+'nav_er2_20130913.iwg',utc_er2,lat_er2,lon_er2,alt_er2,sza_er2

fle=where(tm_er2 gt 18.56 and tm_er2 lt 18.75)
fld=where(tm_dc8 gt 18.56 and tm_dc8 lt 18.75)

fue=where(utc_er2 gt 18.56 and utc_er2 lt 18.75)
fud=where(utc_dc8 gt 18.56 and utc_dc8 lt 18.75)

lon_er2=interpol(lon_er2,utc_er2,tm_er2)
lon_dc8=interpol(lon_dc8,utc_dc8,tm_dc8)

set_plot, 'win'
device, decomposed=0
loadct,39
window, 0, retain=2,xsize=1000,ysize=800
!p.multi=[0,1,3] & !p.charsize=2.3

nul=min(abs(zenlambda-500),i500)
nul=min(abs(zenlambda-1600),i1600)


fle_d=fle
for i=0, n_elements(fle)-1 do begin
  nul=min(abs(lon_dc8[fld]-lon_er2[fle[i]]),u)
  fle_d[i]=fld[u]
endfor



plot, lon_er2[fle],zsp_er2[i500,fle],xtitle='Longitude',ytitle='Irradiance',title='Zenith'
oplot,lon_er2[fle],zsp_er2[i500,fle],color=70
oplot,lon_er2[fle],zsp_er2[i1600,fle],color=250
oplot,lon_er2[fle],zsp_er2[i500,fle]-nsp_er2[i500,fle],color=30

oplot,lon_dc8[fld],zsp_dc8[i500,fld],color=70,linestyle=2
oplot,lon_dc8[fld],zsp_dc8[i1600,fld],color=250,linestyle=2
oplot,lon_dc8[fle_d],zsp_dc8[i500,fle_d]-nsp_dc8[i500,fle_d],color=30,linestyle=2

plot, lon_er2[fle],nsp_er2[i500,fle],xtitle='Longitude',ytitle='Irradiance',title='Nadir' 
oplot,lon_er2[fle],nsp_er2[i500,fle],color=70
oplot,lon_er2[fle],nsp_er2[i1600,fle],color=250
oplot,lon_er2[fle],zsp_er2[i1600,fle]-nsp_er2[i1600,fle],color=220

oplot,lon_dc8[fld],nsp_dc8[i500,fld],color=70,linestyle=2
oplot,lon_dc8[fld],nsp_dc8[i1600,fld],color=250,linestyle=2
oplot,lon_dc8[fle_d],zsp_dc8[i1600,fle_d]-nsp_dc8[i1600,fle_d],color=220,linestyle=2

;fle_d=fle
;for i=0, n_elements(fle)-1 do begin
;  nul=min(abs(lon_dc8[fld]-lon_er2[fle[i]]),u)
;  fle_d[i]=fld[u]
;endfor

plot, lon_er2[fle],((zsp_er2[i500,fle]-nsp_er2[i500,fle])-(zsp_dc8[i500,fle_d]-nsp_dc8[i500,fle_d]))/zsp_er2[i500,fle],$
 xtitle='Longitude',ytitle='Irradiance',title='Flux divergence',yr=[-0.2,0.9]
oplot,lon_er2[fle],((zsp_er2[i500,fle]-nsp_er2[i500,fle])-(zsp_dc8[i500,fle_d]-nsp_dc8[i500,fle_d]))/zsp_er2[i500,fle],color=70
oplot,lon_er2[fle],((zsp_er2[i1600,fle]-nsp_er2[i1600,fle])-(zsp_dc8[i1600,fle_d]-nsp_dc8[i1600,fle_d]))/zsp_er2[i1600,fle],color=250
oplot,lon_er2,lon_er2*0.,linestyle=1


window, 3,retain=2,xsize=900,ysize=800
!p.multi=[0,1,3] & !p.charsize=2.3

nul=min(abs(zenlambda-500),i500)
nul=min(abs(zenlambda-1600),i1600)

plot, tm_er2[fle],zsp_er2[i500,fle],xtitle='UTC',ytitle='Irradiance',title='Zenith'
oplot,tm_er2[fle],zsp_er2[i500,fle],color=70
oplot,tm_er2[fle],zsp_er2[i1600,fle],color=250
oplot,tm_er2[fle],zsp_er2[i500,fle]-nsp_er2[i500,fle],color=30

oplot,tm_dc8[fld],zsp_dc8[i500,fld],color=70,linestyle=2
oplot,tm_dc8[fld],zsp_dc8[i1600,fld],color=250,linestyle=2
oplot,tm_dc8[fld],zsp_dc8[i500,fld]-nsp_dc8[i500,fle],color=30,linestyle=2

plot, tm_er2[fle],nsp_er2[i500,fle],xtitle='UTC',ytitle='Irradiance',title='Nadir'
oplot,tm_er2[fle],nsp_er2[i500,fle],color=70
oplot,tm_er2[fle],nsp_er2[i1600,fle],color=250
oplot,tm_er2[fle],zsp_er2[i1600,fle]-nsp_er2[i1600,fle],color=220

oplot,tm_dc8[fld],nsp_dc8[i500,fld],color=70,linestyle=2
oplot,tm_dc8[fld],nsp_dc8[i1600,fld],color=250,linestyle=2
oplot,tm_dc8[fld],zsp_dc8[i1600,fld]-nsp_dc8[i1600,fle],color=220,linestyle=2

;fle_d=fle
;for i=0, n_elements(fle)-1 do begin
;  nul=min(abs(lon_dc8[fld]-lon_er2[fle[i]]),u)
;  fle_d[i]=fld[u]
;endfor

plot, tm_er2[fle],((zsp_er2[i500,fle]-nsp_er2[i500,fle])-(zsp_dc8[i500,fle_d]-nsp_dc8[i500,fle_d]))/zsp_er2[i500,fle],$
 xtitle='UTC',ytitle='Irradiance',title='Flux divergence',yr=[-0.2,0.9]
oplot,tm_er2[fle],((zsp_er2[i500,fle]-nsp_er2[i500,fle])-(zsp_dc8[i500,fle_d]-nsp_dc8[i500,fle_d]))/zsp_er2[i500,fle],color=70
oplot,tm_er2[fle],((zsp_er2[i1600,fle]-nsp_er2[i1600,fle])-(zsp_dc8[i1600,fle_d]-nsp_dc8[i1600,fle_d]))/zsp_er2[i1600,fle],color=250
oplot,tm_er2,lon_er2*0.,linestyle=1

ps=!p

curs:
wset,3
!p=ps
cursor,x,y
print, x

nul=min(abs(x-tm_er2[fle]),ii)
oplot, [tm_er2[fle[ii]],tm_er2[fle[ii]]],[0,1],linestyle=2


window,1,retain=2
!p.multi=0
m=4997
me=4817
ii=400
print, ii
redo:
plot,zenlambda,(zsp_er2[*,fle[ii]]-nsp_er2[*,fle[ii]]),xtitle='Wavelength (nm)',ytitle='Net Irradiance',$
 title='UTC:'+string(tm_er2[fle[ii]])+' dc8:'+string(tm_dc8[fle_d[ii]])
oplot,zenlambda,(zsp_dc8[*,fle_d[ii]]-nsp_dc8[*,fle_d[ii]]),color=80

read,ii
goto,redo

window, 2, retain=2
!p.multi=[0,1,3]
plot,zenlambda,((zsp_er2[*,fle[ii]]-nsp_er2[*,fle[ii]])-(zsp_dc8[*,fle_d[ii]]-nsp_dc8[*,fle_d[ii]]))/zsp_er2[*,fle[ii]],$
 xtitle='Wavelength (nm)',ytitle='Absorptance (%)'
plot,zenlambda,(nsp_er2[*,fle[ii]]-nsp_dc8[*,fle_d[ii]])/zsp_er2[*,fle[ii]],xtitle='Wavelength (nm)',ytitle='Reflectance'
plot,zenlambda,(zsp_dc8[*,fle_d[ii]]/zsp_er2[*,fle[ii]]),xtitle='Wavelength (nm)',ytitle='Transmittance'

;plot, zenlambda,((zsp_er2[*,me]-nsp_er2[*,me])-(zsp_dc8[*,m]-nsp_dc8[*,m]))/zsp_er2[*,me]
;oplot,zenlambda,zenlambda*0.,linestyle=1

stop
;oplot,lon_dc8[fld],zsp_dc8[i500,fld]-nsp_dc8[i500,fld],color=70,linestyle=2
;oplot,lon_dc8[fld],zsp_dc8[i1600,fld]-nsp_dc8[i1600,fld],color=250,linestyle=2
goto, curs

stop
end
