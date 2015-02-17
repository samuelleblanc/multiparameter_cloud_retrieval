;program to plot an example top of atmosphere spectra


pro plot_examp_sp

dirdat='C:\Users\Samuel\Research\SSFR3\data\'
dir='C:\Users\Samuel\Research\SSFR3\plots\'
l='\'


; restore the model data
restore, dirdat+'sav.out'
wvlm=reform(aero.wvl[0,*])
irrup=smooth(reform(clean.dir_dn[1,*]+clean.dif_dn[1,*])*1000.,2)
irra=smooth(reform(aero.dir_dn[1,*]+aero.dif_dn[1,*])*1000.,2)
irrc=smooth(reform(cloud.dir_dn[1,*]+cloud.dif_dn[1,*])*1000.,2)


dat=read_ascii(dirdat+'solar_SSFR.dat')
wvl=dat.field1[0,*]
irr=smooth(dat.field1[1,*]*cos(30.*!dtor),2)

;stop
fn=dir+'sp_toa_e'
set_plot,'ps'
print, 'making plot :'+fn
loadct, 39, /silent
device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fn+'.ps'
device, xsize=20, ysize=20
 !p.font=1 & !p.thick=7 & !p.charsize=3.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=4 & !x.thick=4
 !p.multi=0 & !x.margin=[7,2] &!x.omargin=[0,0]

tvlct,0,180,0,120

 plot, wvl,irr,ytitle='Irradiance (Wm!U-2!N nm!U-1!N)',xtitle='Wavelength (nm)',$
  xrange=[350.,1750.], ystyle=1 ,yrange=[0,2.0],xtickv=[400,700,1000,1300,1600],xticks=4
 oplot,wvlm,irrup, color=120
 ;oplot,wvlm,irra,color=250
 oplot,wvlm,irrc,color=50

  xyouts, 500,1.75, 'Top of atmosphere',charsize=2.0
  xyouts, 620,1.5,'At Troposphere',charsize=2.0,orientat=-55,color=120
  ;xyouts, 450,1.25,'Under aerosols',charsize=2.0,orienta=-55,color=250
  xyouts, 450,0.6,'Under clouds',charsize=2.0,orienta=-35,color=50



;stop 

 ;tvlct,107,255,117,100
 ;tvlct,255,117,173,248
 ;tvlct,241,241,087,247
 ;tvlct,240,136,000,249
; polyfill, [740,780,780,740],[0,0,1.5,1.5],color=100

; polyfill, [794,844,844,794],[0,0,1.5,1.5],color=247
; polyfill, [890,1000,1000,890],[0,0,1.5,1.5],color=248
; polyfill, [1090,1180,1180,1090],[0,0,1.5,1.5],color=249
 ;oplot,nadlambda, spn_cloud, color=0 ,linestyle=1,thick=8
 ;oplot,nadlambda, spn_clear, color=0,linestyle=0

 ;xyouts, 460., 1.05, 'Irradiance - clear', color=0, orientation=-60,charsize=1.7
 ;xyouts, 325., 0.11, 'Irradiance - cloudy', color=0, orientation=-5,charsize=1.7

 ;axis, yaxis=1, yrange=[0,0.15],ytitle='Radiance (W/m!U2!N nm sr)', /save,color=70
 ;axis, yaxis=1, yrange=[0,0.15],ytickname=[' ',' ',' ',' ',' ',' ',' ',' ']
 ;oplot, zenlambda, spz_cloud, linestyle=0,color=70
 ;oplot, zenlambda, spz_clear, linestyle=1,color=70,thick=8

 ;xyouts, 600., 0.128, 'Radiance - cloudy',color=70, orientation=-60,charsize=1.7
 ;xyouts, 400., 0.050, 'Radiance - clear',color=70, orientation=-60,charsize=1.7

 ;legend, ['Irradiance - Clear','Irradiance - Cloudy','Radiance - Clear','Radiance - Cloudy'],linestyle=[1,1,0,0],color=[70,0,70,0],/right,box=0,pspacing=1
 ; legend, ['Radiance','Irradiance'],linestyle=[0,1],color=[0,0],position=[1450,0.13],box=0,pspacing=1,/right  
 ; legend, ['|','|'],linestyle=[0,1],color=[70,70],position=[1700,0.13],box=0,pspacing=1,/right
 ; xyouts, 1149.5,0.131,'Cloudy | Clear',/data 
device, /close
spawn, 'convert '+fn+'.ps '+fn+'.png'




end
