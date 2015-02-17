; Program to determine the surface albedo from MODIS and average SGP site
; for Boulder
; during the month of may 2012
@legend.pro
pro albedo

; get the data of surface albedo from sgp and
dir='C:\Users\Samuel\Research\SSFR3\surface_albedo\'
restore, dir+'alb.out'; '/home/leblanc/DC3_SEAC4RS/surface_albedo/alb.out'
;restore, dir+'boud_alb_new.out' ;'/home/leblanc/DC3_SEAC4RS/surface_albedo/boud_alb_new.out'

alb_wvl=[350.,469.,555.,645.,858.,1240.,1640.,2130.]
su_alb =[0.02,0.038955,0.0758601,0.07409,0.26779,0.29993,0.224589,0.124088]
su_alb[4:*]=su_alb[4:*]+0.1

wvl_sgp=wvl
alb_sgp=alb
alb_sgp2=alb_sgp
restore, dir+'modis_surface_albedo_avg.out' ;'/argus/sat/modis/Boulder/modis_surface_albedo_avg.out'
alb_boud=fltarr(n_elements(wvl_sgp),n_elements(doy))
ratio=fltarr(n_elements(wvl)+1)

fl=where(wvl_sgp gt 1300. and wvl_sgp lt 1600.)
fl2=where(alb_sgp[fl] gt 0.09)
alb_sgp2[fl]=interpol(alb_sgp[fl[fl2]],wvl_sgp[fl[fl2]],wvl_sgp[fl])
fl1=where(wvl_sgp gt 1680. and wvl_sgp lt 2200.)
fl22=where(wvl_sgp[fl1] lt 1785. or wvl_sgp[fl1] gt 1965.)
al=smooth(alb_sgp[fl1],15)
alb_sgp2[fl1]=interpol(al[fl22],wvl_sgp[fl1[fl22]],wvl_sgp[fl1])

alb_sgp3=alb_sgp2
fll=where(wvl_sgp gt 1400.)
alb_sgp3[fll]=alb_sgp2[fll]+0.1
alb_sgp3[fl]=interpol(alb_sgp3[fl[fl2]],wvl_sgp[fl[fl2]],wvl_sgp[fl])

wvl=[wvl,716.]
albedo=[[albedo],[replicate(0.17,n_elements(doy))]]

set_plot, 'win'
device, decomposed=0
window,0,retain=2
loadct, 39
plot, wvl_sgp,alb_sgp,yrange=[0,1]
oplot,wvl_sgp,alb_sgp2,color=250

for i=0, n_elements(doy)-2 do begin
  oplot, wvl, albedo[i,*],psym=2,color=i*50
  for n=0,n_elements(wvl)-1 do begin
    nul=min(abs(wvl_sgp-wvl[n]),in)
    ratio[n]=albedo[i,n]/alb_sgp3[in]
  endfor
;  wvl=[wvl,716.]
;  ratio=[ratio,1.]
  ratios=interpol(ratio[sort(wvl)],wvl[sort(wvl)],wvl_sgp)
  alb_boud[*,i]=alb_sgp3*ratios
  
  oplot, wvl_sgp, alb_boud[*,i],color=i*50
endfor

stop


;set_plot, 'x'
;loadct, 39, /silent
;device,decomposed=0
fp=dir+'boulder_albedo_modis' ;'/home/leblanc/DC3_SEAC4RS/surface_albedo/boulder_albedo_modis'
print, 'making plot :'+fp
set_plot, 'ps'
 loadct, 39, /silent
 device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
 device, xsize=20, ysize=20
  !p.font=1 & !p.thick=5 & !p.charsize=2.0 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
  !p.multi=0 & !x.margin=[6,4]

lbl=strarr(n_elements(doy)-1)
cl=intarr(n_elements(doy)-1)
plot, wvl_sgp,alb_sgp2, xtitle='Wavelength (nm)', ytitle='surface albedo', title='Boulder surface albedo',yrange=[0,0.5]
;oplot, wvl,boud_alb, color=70
;oplot, alb_wvl, su_alb, color=250, psym=2
for i=0, n_elements(doy)-2 do begin
  oplot, wvl_sgp, alb_boud[*,i],color=(i+1)*50
  oplot, wvl[0:n_elements(wvl)-2],albedo[i,0:n_elements(wvl)-2],psym=7,symsize=2.3
  oplot, wvl[0:n_elements(wvl)-2],albedo[i,0:n_elements(wvl)-2],psym=7,symsize=1.8,color=(i+1)*50
  lbl[i]=string(julday(1,0,2012)+float(doy[i]),format='(C(CYI4,"-",CMOI02,"-",CDI02))')
  cl[i]=(i+1)*50
endfor
legend,['SGP average',lbl],textcolors=[0,cl],box=0, /right

;legend,['SGP average','Boulder calculated','MODIS over Boulder'],textcolors=[0,70,250],box=0,/right

;p=tvrd(true=1)
;write_png,'/home/leblanc/DC3_SEAC4RS/surface_albedo/boulder_albedo.png',p
device, /close
 spawn, 'convert "'+fp+'.ps" "'+fp+'.png"'
stop
for i=0, n_elements(doy)-2 do begin
  openw,lun,dir+'albedo_'+lbl[i]+'.dat',/get_lun
  print, 'making file: albedo_'+lbl[i]+'.dat'
  for k=0, n_elements(wvl_sgp)-1 do printf, lun, wvl_sgp[k],alb_boud[k,i]
  close,/all
endfor
stop
end
