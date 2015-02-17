@legend.pro
pro plot_example_sp

dirdat='/home/leblanc/SSFR3/data/'
dir='/home/leblanc/SSFR3/plots/'
l='/'

dirdat='C:\Users\Samuel\Research\SSFR3\data\'
dir='C:\Users\Samuel\Research\SSFR3\plots\'
l='\'

; get spectra of clear days
restore, dirdat+'sp_at_wv.out'
print, 'restoring spectra file: '+dir+'sp_at_wv.out'

spz_clear=spz[*,59]
spn_clear=spn[*,51]

u=where(spn_clear lt 0 or spn_clear gt 2)
spn_clear[u]=!values.f_nan
;stop
; get spectra of cloudy days
restore, dirdat+'sp_at_cl.out'
print, 'restoring spectra file: '+dir+'sp_at_cl.out'
spz_cloud=spz[*,50]
spn_cloud=spn[*,38]
for i=0, n_elements(nadlambda)-1 do spn_clear[i]=mean(spn[i,[51,52,53,100,101,102,103]])
ii=where(spn_clear gt 2 or spn_clear lt 0)
spn_clear[ii]=spn_clear[ii+2]
spn_clear=smooth(spn_clear,4)
stop

fn=dir+'example_sp'
set_plot,'ps'
print, 'making plot :'+fn
loadct, 39, /silent
device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fn+'.ps'
device, xsize=20, ysize=20
 !p.font=1 & !p.thick=7 & !p.charsize=2.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=4 & !x.thick=4
 !p.multi=0 & !x.margin=[7,7] &!x.omargin=[0,0]

 plot, nadlambda, spn_clear, ytitle='Irradiance (W/m!U2!N nm)',xtitle='Wavelength (nm)',$
  xrange=[300.,1750.], ystyle=9,/nodata ,yrange=[0,1.5]

 tvlct,107,255,117,100
 tvlct,255,117,173,248
 tvlct,241,241,087,247
 tvlct,240,136,000,249
; polyfill, [740,780,780,740],[0,0,1.5,1.5],color=100

; polyfill, [794,844,844,794],[0,0,1.5,1.5],color=247
; polyfill, [890,1000,1000,890],[0,0,1.5,1.5],color=248
; polyfill, [1090,1180,1180,1090],[0,0,1.5,1.5],color=249
 oplot,nadlambda, spn_cloud, color=0 ,linestyle=1,thick=8
 oplot,nadlambda, spn_clear, color=0,linestyle=0

 xyouts, 460., 1.05, 'Irradiance - clear', color=0, orientation=-60,charsize=1.7
 xyouts, 325., 0.11, 'Irradiance - cloudy', color=0, orientation=-5,charsize=1.7

 axis, yaxis=1, yrange=[0,0.15],ytitle='Radiance (W/m!U2!N nm sr)', /save,color=70
 axis, yaxis=1, yrange=[0,0.15],ytickname=[' ',' ',' ',' ',' ',' ',' ',' ']
 oplot, zenlambda, spz_cloud, linestyle=0,color=70
 oplot, zenlambda, spz_clear, linestyle=1,color=70,thick=8

 xyouts, 600., 0.128, 'Radiance - cloudy',color=70, orientation=-60,charsize=1.7
 xyouts, 400., 0.050, 'Radiance - clear',color=70, orientation=-60,charsize=1.7

 ;legend, ['Irradiance - Clear','Irradiance - Cloudy','Radiance - Clear','Radiance - Cloudy'],linestyle=[1,1,0,0],color=[70,0,70,0],/right,box=0,pspacing=1
 ; legend, ['Radiance','Irradiance'],linestyle=[0,1],color=[0,0],position=[1450,0.13],box=0,pspacing=1,/right  
 ; legend, ['|','|'],linestyle=[0,1],color=[70,70],position=[1700,0.13],box=0,pspacing=1,/right
 ; xyouts, 1149.5,0.131,'Cloudy | Clear',/data 
device, /close
spawn, 'convert '+fn+'.ps '+fn+'.png'

fn=dir+'example_sp1'
set_plot,'ps'
print, 'making plot :'+fn
loadct, 39, /silent
device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fn+'.ps'
device, xsize=20, ysize=20
 !p.font=1 & !p.thick=7 & !p.charsize=2.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=4 & !x.thick=4
 !p.multi=0 & !x.margin=[7,7] &!x.omargin=[0,0]

 plot, nadlambda, spn_clear, ytitle='Irradiance (W/m!U2!N nm)',xtitle='Wavelength (nm)',$
  xrange=[300.,1750.], ystyle=9,/nodata ,yrange=[0,1.5]

 tvlct,180,180,180,181
 tvlct,107,255,117,100

polyfill, [350.,740.,740.,350.],[0,0,1.5,1.5],color=181
polyfill, [780.,794.,794.,780.],[0,0,1.5,1.5],color=181
polyfill, [844.,890.,890.,844.],[0,0,1.5,1.5],color=181
polyfill, [1000.,1050.,1050.,1000.],[0,0,1.5,1.5],color=181

 oplot,nadlambda, spn_cloud, color=0 ,linestyle=1,thick=8
 oplot,nadlambda, spn_clear, color=0,linestyle=0

 xyouts, 460., 1.05, 'Irradiance - clear', color=0, orientation=-60,charsize=1.7
 xyouts, 325., 0.11, 'Irradiance - cloudy', color=0, orientation=-5,charsize=1.7

 axis, yaxis=1, yrange=[0,0.15],ytitle='Radiance (W/m!U2!N nm sr)', /save,color=70
 axis, yaxis=1, yrange=[0,0.15],ytickname=[' ',' ',' ',' ',' ',' ',' ',' ']
 oplot, zenlambda, spz_cloud, linestyle=0,color=70
 oplot, zenlambda, spz_clear, linestyle=1,color=70,thick=8

 xyouts, 600., 0.128, 'Radiance - cloudy',color=70, orientation=-60,charsize=1.7
 xyouts, 400., 0.050, 'Radiance - clear',color=70, orientation=-60,charsize=1.7

 ;legend, ['Irradiance - Clear','Irradiance - Cloudy','Radiance - Clear','Radiance - Cloudy'],linestyle=[1,1,0,0],color=[70,0,70,0],/right,box=0,pspacing=1
 ; legend, ['Radiance','Irradiance'],linestyle=[0,1],color=[0,0],position=[1450,0.13],box=0,pspacing=1,/right  
 ; legend, ['|','|'],linestyle=[0,1],color=[70,70],position=[1700,0.13],box=0,pspacing=1,/right
 ; xyouts, 1149.5,0.131,'Cloudy | Clear',/data 
device, /close
spawn, 'convert '+fn+'.ps '+fn+'.png'

fn=dir+'example_sp2'
set_plot,'ps'
print, 'making plot :'+fn
loadct, 39, /silent
device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fn+'.ps'
device, xsize=20, ysize=20
 !p.font=1 & !p.thick=7 & !p.charsize=2.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=4 & !x.thick=4
 !p.multi=0 & !x.margin=[7,7] &!x.omargin=[0,0]

 plot, nadlambda, spn_clear, ytitle='Irradiance (W/m!U2!N nm)',xtitle='Wavelength (nm)',$
  xrange=[300.,1750.], ystyle=9,/nodata ,yrange=[0,1.5]

 tvlct,107,255,117,100
 tvlct,255,117,173,248
 tvlct,241,241,087,247
 tvlct,240,136,000,249
 tvlct,180,180,180,181

polyfill, [350.,740.,740.,350.],[0,0,1.5,1.5],color=181
polyfill, [780.,794.,794.,780.],[0,0,1.5,1.5],color=181
polyfill, [844.,890.,890.,844.],[0,0,1.5,1.5],color=181
polyfill, [1000.,1050.,1050.,1000.],[0,0,1.5,1.5],color=181
tvlct,219,238,244,71

  polyfill,[495,505,505,495],[0,0,1.5,1.5],color=100
  polyfill,[1180,1310,1310,1180],[0,0,1.5,1.5],color=100
  polyfill,[980,1075,1075,980],[0,0,1.5,1.5],color=100;,spacing=0.2
  polyfill,[1050,1075,1075,1050],[0,0,1.5,1.5],color=100
  polyfill,[1490,1650,1650,1490],[0,0,1.5,1.5],color=100
; polyfill, [740,780,780,740],[0,0,1.5,1.5],color=100

; polyfill, [794,844,844,794],[0,0,1.5,1.5],color=247
; polyfill, [890,1000,1000,890],[0,0,1.5,1.5],color=248
; polyfill, [1090,1180,1180,1090],[0,0,1.5,1.5],color=249
 oplot,nadlambda, spn_cloud, color=0 ,linestyle=1,thick=8
 oplot,nadlambda, spn_clear, color=0,linestyle=0

 xyouts, 460., 1.05, 'Irradiance - clear', color=0, orientation=-60,charsize=1.7
 xyouts, 325., 0.11, 'Irradiance - cloudy', color=0, orientation=-5,charsize=1.7

 axis, yaxis=1, yrange=[0,0.15],ytitle='Radiance (W/m!U2!N nm sr)', /save,color=70
 axis, yaxis=1, yrange=[0,0.15],ytickname=[' ',' ',' ',' ',' ',' ',' ',' ']
 oplot, zenlambda, spz_cloud, linestyle=0,color=70
 oplot, zenlambda, spz_clear, linestyle=1,color=70,thick=8

 xyouts, 600., 0.128, 'Radiance - cloudy',color=70, orientation=-60,charsize=1.7
 xyouts, 400., 0.050, 'Radiance - clear',color=70, orientation=-60,charsize=1.7

 ;legend, ['Irradiance - Clear','Irradiance - Cloudy','Radiance - Clear','Radiance - Cloudy'],linestyle=[1,1,0,0],color=[70,0,70,0],/right,box=0,pspacing=1
 ; legend, ['Radiance','Irradiance'],linestyle=[0,1],color=[0,0],position=[1450,0.13],box=0,pspacing=1,/right  
 ; legend, ['|','|'],linestyle=[0,1],color=[70,70],position=[1700,0.13],box=0,pspacing=1,/right
 ; xyouts, 1149.5,0.131,'Cloudy | Clear',/data 
device, /close
spawn, 'convert '+fn+'.ps '+fn+'.png'

fn=dir+'example_sp2_only'
set_plot,'ps'
print, 'making plot :'+fn
loadct, 39, /silent
device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fn+'.ps'
device, xsize=20, ysize=20
 !p.font=1 & !p.thick=7 & !p.charsize=2.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=4 & !x.thick=4
 !p.multi=0 & !x.margin=[7,7] &!x.omargin=[0,0]

 plot, nadlambda, spn_clear, ytitle='Irradiance (W/m!U2!N nm)',xtitle='Wavelength (nm)',$
  xrange=[300.,1750.], ystyle=9,/nodata ,yrange=[0,1.5]

 tvlct,107,255,117,100
 tvlct,255,117,173,248
 tvlct,241,241,087,247
 tvlct,240,136,000,249
 tvlct,180,180,180,181

;polyfill, [350.,1050.,1050.,350.],[0,0,1.5,1.5],color=181
tvlct,219,238,244,71

  polyfill,[495,505,505,495],[0,0,1.5,1.5],color=100
  polyfill,[1180,1310,1310,1180],[0,0,1.5,1.5],color=100
  polyfill,[980,1075,1075,980],[0,0,1.5,1.5],color=100;,spacing=0.2
  polyfill,[1050,1075,1075,1050],[0,0,1.5,1.5],color=100
  polyfill,[1490,1650,1650,1490],[0,0,1.5,1.5],color=100
; polyfill, [740,780,780,740],[0,0,1.5,1.5],color=100

; polyfill, [794,844,844,794],[0,0,1.5,1.5],color=247
; polyfill, [890,1000,1000,890],[0,0,1.5,1.5],color=248
; polyfill, [1090,1180,1180,1090],[0,0,1.5,1.5],color=249
 oplot,nadlambda, spn_cloud, color=0 ,linestyle=1,thick=8
 oplot,nadlambda, spn_clear, color=0,linestyle=0

 xyouts, 460., 1.05, 'Irradiance - clear', color=0, orientation=-60,charsize=1.7
 xyouts, 325., 0.11, 'Irradiance - cloudy', color=0, orientation=-5,charsize=1.7

 axis, yaxis=1, yrange=[0,0.15],ytitle='Radiance (W/m!U2!N nm sr)', /save,color=70
 axis, yaxis=1, yrange=[0,0.15],ytickname=[' ',' ',' ',' ',' ',' ',' ',' ']
 oplot, zenlambda, spz_cloud, linestyle=0,color=70
 oplot, zenlambda, spz_clear, linestyle=1,color=70,thick=8

 xyouts, 600., 0.128, 'Radiance - cloudy',color=70, orientation=-60,charsize=1.7
 xyouts, 400., 0.050, 'Radiance - clear',color=70, orientation=-60,charsize=1.7

 ;legend, ['Irradiance - Clear','Irradiance - Cloudy','Radiance - Clear','Radiance - Cloudy'],linestyle=[1,1,0,0],color=[70,0,70,0],/right,box=0,pspacing=1
 ; legend, ['Radiance','Irradiance'],linestyle=[0,1],color=[0,0],position=[1450,0.13],box=0,pspacing=1,/right  
 ; legend, ['|','|'],linestyle=[0,1],color=[70,70],position=[1700,0.13],box=0,pspacing=1,/right
 ; xyouts, 1149.5,0.131,'Cloudy | Clear',/data 
device, /close
spawn, 'convert '+fn+'.ps '+fn+'.png'

fn=dir+'example_sp2_only_rad'
set_plot,'ps'
print, 'making plot :'+fn
loadct, 39, /silent
device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fn+'.ps'
device, xsize=20, ysize=20
 !p.font=1 & !p.thick=7 & !p.charsize=2.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=4 & !x.thick=4
 !p.multi=0 & !x.margin=[7,7] &!x.omargin=[0,0]

 plot, nadlambda, spn_clear, ytitle='Irradiance (W/m!U2!N nm)',xtitle='Wavelength (nm)',$
  xrange=[300.,1750.], ystyle=9,/nodata ,yrange=[0,1.5]

 tvlct,107,255,117,100
 tvlct,255,117,173,248
 tvlct,241,241,087,247
 tvlct,240,136,000,249
 tvlct,180,180,180,181

;polyfill, [350.,1050.,1050.,350.],[0,0,1.5,1.5],color=181
tvlct,219,238,244,71

  polyfill,[495,505,505,495],[0,0,1.5,1.5],color=100
  polyfill,[1180,1310,1310,1180],[0,0,1.5,1.5],color=100
  polyfill,[980,1075,1075,980],[0,0,1.5,1.5],color=100;,spacing=0.2
  polyfill,[1050,1075,1075,1050],[0,0,1.5,1.5],color=100
  polyfill,[1490,1650,1650,1490],[0,0,1.5,1.5],color=100
; polyfill, [740,780,780,740],[0,0,1.5,1.5],color=100

; polyfill, [794,844,844,794],[0,0,1.5,1.5],color=247
; polyfill, [890,1000,1000,890],[0,0,1.5,1.5],color=248
; polyfill, [1090,1180,1180,1090],[0,0,1.5,1.5],color=249
; oplot,nadlambda, spn_cloud, color=0 ,linestyle=1,thick=8
; oplot,nadlambda, spn_clear, color=0,linestyle=0

; xyouts, 460., 1.05, 'Irradiance - clear', color=0, orientation=-60,charsize=1.7
; xyouts, 325., 0.11, 'Irradiance - cloudy', color=0, orientation=-5,charsize=1.7

 axis, yaxis=1, yrange=[0,0.15],ytitle='Radiance (W/m!U2!N nm sr)', /save,color=70
 axis, yaxis=1, yrange=[0,0.15],ytickname=[' ',' ',' ',' ',' ',' ',' ',' ']
 oplot, zenlambda, spz_cloud, linestyle=0,color=70
 oplot, zenlambda, spz_clear, linestyle=1,color=70,thick=8

 xyouts, 600., 0.128, 'Radiance - cloudy',color=70, orientation=-60,charsize=1.7
 xyouts, 400., 0.050, 'Radiance - clear',color=70, orientation=-60,charsize=1.7

 ;legend, ['Irradiance - Clear','Irradiance - Cloudy','Radiance - Clear','Radiance - Cloudy'],linestyle=[1,1,0,0],color=[70,0,70,0],/right,box=0,pspacing=1
 ; legend, ['Radiance','Irradiance'],linestyle=[0,1],color=[0,0],position=[1450,0.13],box=0,pspacing=1,/right  
 ; legend, ['|','|'],linestyle=[0,1],color=[70,70],position=[1700,0.13],box=0,pspacing=1,/right
 ; xyouts, 1149.5,0.131,'Cloudy | Clear',/data 
device, /close
spawn, 'convert '+fn+'.ps '+fn+'.png'


fn=dir+'example_sp3'
set_plot,'ps'
print, 'making plot :'+fn
loadct, 39, /silent
device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fn+'.ps'
device, xsize=20, ysize=20
 !p.font=1 & !p.thick=7 & !p.charsize=2.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=4 & !x.thick=4
 !p.multi=0 & !x.margin=[7,7] &!x.omargin=[0,0]

 plot, nadlambda, spn_clear, ytitle='Irradiance (W/m!U2!N nm)',xtitle='Wavelength (nm)',$
  xrange=[300.,1750.], ystyle=9,/nodata ,yrange=[0,1.5]

 tvlct,107,255,117,100
 tvlct,255,117,173,248
 tvlct,241,241,087,247
 tvlct,240,136,000,249
 tvlct,180,180,180,181
polyfill, [350.,740.,740.,350.],[0,0,1.5,1.5],color=181
polyfill, [780.,794.,794.,780.],[0,0,1.5,1.5],color=181
polyfill, [844.,890.,890.,844.],[0,0,1.5,1.5],color=181
polyfill, [1000.,1050.,1050.,1000.],[0,0,1.5,1.5],color=181
tvlct,219,238,244,71

  polyfill,[495,505,505,495],[0,0,1.5,1.5],color=100
  polyfill,[1180,1310,1310,1180],[0,0,1.5,1.5],color=100
  polyfill,[980,1075,1075,980],[0,0,1.5,1.5],color=100;,spacing=0.2
  polyfill,[1050,1075,1075,1050],[0,0,1.5,1.5],color=100
  polyfill,[1490,1650,1650,1490],[0,0,1.5,1.5],color=100
 polyfill, [740,780,780,740],[0,0,1.5,1.5],color=249;,spacing=0.1
 polyfill, [794,844,844,794],[0,0,1.5,1.5],color=249;,spacing=0.1
 polyfill, [890,1000,1000,890],[0,0,1.5,1.5],color=249;,spacing=0.15
 polyfill, [1075,1180,1180,1075],[0,0,1.5,1.5],color=249
 polyfill, [1310,1490,1490,1310], [0,0,1.5,1.5],color=249
 oplot,nadlambda, spn_cloud, color=0 ,linestyle=1,thick=8
 oplot,nadlambda, spn_clear, color=0,linestyle=0

 xyouts, 460., 1.05, 'Irradiance - clear', color=0, orientation=-60,charsize=1.7
 xyouts, 325., 0.11, 'Irradiance - cloudy', color=0, orientation=-5,charsize=1.7

 axis, yaxis=1, yrange=[0,0.15],ytitle='Radiance (W/m!U2!N nm sr)', /save,color=70
 axis, yaxis=1, yrange=[0,0.15],ytickname=[' ',' ',' ',' ',' ',' ',' ',' ']
 oplot, zenlambda, spz_cloud, linestyle=0,color=70
 oplot, zenlambda, spz_clear, linestyle=1,color=70,thick=8

 xyouts, 600., 0.128, 'Radiance - cloudy',color=70, orientation=-60,charsize=1.7
 xyouts, 400., 0.050, 'Radiance - clear',color=70, orientation=-60,charsize=1.7

 ;legend, ['Irradiance - Clear','Irradiance - Cloudy','Radiance - Clear','Radiance - Cloudy'],linestyle=[1,1,0,0],color=[70,0,70,0],/right,box=0,pspacing=1
 ; legend, ['Radiance','Irradiance'],linestyle=[0,1],color=[0,0],position=[1450,0.13],box=0,pspacing=1,/right  
 ; legend, ['|','|'],linestyle=[0,1],color=[70,70],position=[1700,0.13],box=0,pspacing=1,/right
 ; xyouts, 1149.5,0.131,'Cloudy | Clear',/data 
device, /close
spawn, 'convert '+fn+'.ps '+fn+'.png'

fn=dir+'example_sp3_only'
set_plot,'ps'
print, 'making plot :'+fn
loadct, 39, /silent
device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fn+'.ps'
device, xsize=20, ysize=20
 !p.font=1 & !p.thick=7 & !p.charsize=2.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=4 & !x.thick=4
 !p.multi=0 & !x.margin=[7,7] &!x.omargin=[0,0]

 plot, nadlambda, spn_clear, ytitle='Irradiance (W/m!U2!N nm)',xtitle='Wavelength (nm)',$
  xrange=[300.,1750.], ystyle=9,/nodata ,yrange=[0,1.5]

 tvlct,107,255,117,100
 tvlct,255,117,173,248
 tvlct,241,241,087,247
 tvlct,240,136,000,249
 tvlct,180,180,180,181
;polyfill, [350.,1050.,1050.,350.],[0,0,1.5,1.5],color=181
tvlct,219,238,244,71

 ; polyfill,[512,518,518,512],[0,0,1.5,1.5],color=71
 ; polyfill,[1180,1310,1310,1180],[0,0,1.5,1.5],color=71
 ; polyfill,[980,1075,1075,980],[0,0,1.5,1.5],color=71;,spacing=0.2
 ; polyfill,[1050,1075,1075,1050],[0,0,1.5,1.5],color=71
 ; polyfill,[1490,1650,1650,1490],[0,0,1.5,1.5],color=71
 polyfill, [740,780,780,740],[0,0,1.5,1.5],color=249;,spacing=0.1
 polyfill, [794,844,844,794],[0,0,1.5,1.5],color=249;,spacing=0.1
 polyfill, [890,1000,1000,890],[0,0,1.5,1.5],color=249;,spacing=0.15
 polyfill, [1075,1180,1180,1075],[0,0,1.5,1.5],color=249
 polyfill, [1310,1490,1490,1310], [0,0,1.5,1.5],color=249
 oplot,nadlambda, spn_cloud, color=0 ,linestyle=1,thick=8
 oplot,nadlambda, spn_clear, color=0,linestyle=0

 xyouts, 460., 1.05, 'Irradiance - clear', color=0, orientation=-60,charsize=1.7
 xyouts, 325., 0.11, 'Irradiance - cloudy', color=0, orientation=-5,charsize=1.7

 axis, yaxis=1, yrange=[0,0.15],ytitle='Radiance (W/m!U2!N nm sr)', /save,color=70
 axis, yaxis=1, yrange=[0,0.15],ytickname=[' ',' ',' ',' ',' ',' ',' ',' ']
 oplot, zenlambda, spz_cloud, linestyle=0,color=70
 oplot, zenlambda, spz_clear, linestyle=1,color=70,thick=8

 xyouts, 600., 0.128, 'Radiance - cloudy',color=70, orientation=-60,charsize=1.7
 xyouts, 400., 0.050, 'Radiance - clear',color=70, orientation=-60,charsize=1.7

 ;legend, ['Irradiance - Clear','Irradiance - Cloudy','Radiance - Clear','Radiance - Cloudy'],linestyle=[1,1,0,0],color=[70,0,70,0],/right,box=0,pspacing=1
 ; legend, ['Radiance','Irradiance'],linestyle=[0,1],color=[0,0],position=[1450,0.13],box=0,pspacing=1,/right  
 ; legend, ['|','|'],linestyle=[0,1],color=[70,70],position=[1700,0.13],box=0,pspacing=1,/right
 ; xyouts, 1149.5,0.131,'Cloudy | Clear',/data 
device, /close
spawn, 'convert '+fn+'.ps '+fn+'.png'



fn=dir+'example_sp3_onlyi_rad'
set_plot,'ps'
print, 'making plot :'+fn
loadct, 39, /silent
device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fn+'.ps'
device, xsize=20, ysize=20
 !p.font=1 & !p.thick=7 & !p.charsize=2.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=4 & !x.thick=4
 !p.multi=0 & !x.margin=[7,7] &!x.omargin=[0,0]

 plot, nadlambda, spn_clear, ytitle='Irradiance (W/m!U2!N nm)',xtitle='Wavelength (nm)',$
  xrange=[300.,1750.], ystyle=9,/nodata ,yrange=[0,1.5]

 tvlct,107,255,117,100
 tvlct,255,117,173,248
 tvlct,241,241,087,247
 tvlct,240,136,000,249
 tvlct,180,180,180,181
;polyfill, [350.,1050.,1050.,350.],[0,0,1.5,1.5],color=181
tvlct,219,238,244,71

 ; polyfill,[512,518,518,512],[0,0,1.5,1.5],color=71
 ; polyfill,[1180,1310,1310,1180],[0,0,1.5,1.5],color=71
 ; polyfill,[980,1075,1075,980],[0,0,1.5,1.5],color=71;,spacing=0.2
 ; polyfill,[1050,1075,1075,1050],[0,0,1.5,1.5],color=71
 ; polyfill,[1490,1650,1650,1490],[0,0,1.5,1.5],color=71
 polyfill, [740,780,780,740],[0,0,1.5,1.5],color=249;,spacing=0.1
 polyfill, [794,844,844,794],[0,0,1.5,1.5],color=249;,spacing=0.1
 polyfill, [890,1000,1000,890],[0,0,1.5,1.5],color=249;,spacing=0.15
 polyfill, [1075,1180,1180,1075],[0,0,1.5,1.5],color=249
 polyfill, [1310,1490,1490,1310], [0,0,1.5,1.5],color=249
; oplot,nadlambda, spn_cloud, color=0 ,linestyle=1,thick=8
; oplot,nadlambda, spn_clear, color=0,linestyle=0

; xyouts, 460., 1.05, 'Irradiance - clear', color=0, orientation=-60,charsize=1.7
; xyouts, 325., 0.11, 'Irradiance - cloudy', color=0, orientation=-5,charsize=1.7

 axis, yaxis=1, yrange=[0,0.15],ytitle='Radiance (W/m!U2!N nm sr)', /save,color=70
 axis, yaxis=1, yrange=[0,0.15],ytickname=[' ',' ',' ',' ',' ',' ',' ',' ']
 oplot, zenlambda, spz_cloud, linestyle=0,color=70
 oplot, zenlambda, spz_clear, linestyle=1,color=70,thick=8

 xyouts, 600., 0.128, 'Radiance - cloudy',color=70, orientation=-60,charsize=1.7
 xyouts, 400., 0.050, 'Radiance - clear',color=70, orientation=-60,charsize=1.7

 ;legend, ['Irradiance - Clear','Irradiance - Cloudy','Radiance - Clear','Radiance - Cloudy'],linestyle=[1,1,0,0],color=[70,0,70,0],/right,box=0,pspacing=1
 ; legend, ['Radiance','Irradiance'],linestyle=[0,1],color=[0,0],position=[1450,0.13],box=0,pspacing=1,/right  
 ; legend, ['|','|'],linestyle=[0,1],color=[70,70],position=[1700,0.13],box=0,pspacing=1,/right
 ; xyouts, 1149.5,0.131,'Cloudy | Clear',/data 
device, /close
spawn, 'convert '+fn+'.ps '+fn+'.png'




stop
end
