; program to make plots for the poster
; plots example spectra
; plots specific sections of the spectra


@legend.pro
pro plot_for_poster

dirdat='/home/leblanc/SSFR3/data/'
dir='/home/leblanc/SSFR3/plots/'
l='/'

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

fn=dir+'example_sp'
set_plot,'ps'
print, 'making plot :'+fn
loadct, 39, /silent
device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fn+'.ps'
device, xsize=20, ysize=20
 !p.font=1 & !p.thick=5 & !p.charsize=2.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
 !p.multi=0 & !x.margin=[7,7] &!x.omargin=[0,0]

 plot, nadlambda, spn_clear, title='Measured spectra',ytitle='Irradiance (W/m!U2!N nm)',xtitle='Wavelength (nm)',xrange=[300.,1750.], ystyle=9,/nodata ,yrange=[0,1.5]

 tvlct,107,255,117,100
 tvlct,255,117,173,248
 tvlct,241,241,087,247
 tvlct,240,136,000,249
; polyfill, [740,780,780,740],[0,0,1.5,1.5],color=100
 
; polyfill, [794,844,844,794],[0,0,1.5,1.5],color=247
; polyfill, [890,1000,1000,890],[0,0,1.5,1.5],color=248
; polyfill, [1090,1180,1180,1090],[0,0,1.5,1.5],color=249
 oplot,nadlambda, spn_cloud, color=0 ,linestyle=1
 oplot,nadlambda, spn_clear, color=70,linestyle=1
 
 axis, yaxis=1, yrange=[0,0.15],ytitle='Radiance (W/m!U2!N nm sr)', /save
 oplot, zenlambda, spz_cloud, linestyle=0
 oplot, zenlambda, spz_clear, linestyle=0,color=70

 ;legend, ['Irradiance - Clear','Irradiance - Cloudy','Radiance - Clear','Radiance - Cloudy'],linestyle=[1,1,0,0],color=[70,0,70,0],/right,box=0,pspacing=1
 ; legend, ['Radiance','Irradiance'],linestyle=[0,1],color=[0,0],position=[1450,0.13],box=0,pspacing=1,/right
 ; legend, ['|','|'],linestyle=[0,1],color=[70,70],position=[1700,0.13],box=0,pspacing=1,/right
 ; xyouts, 1149.5,0.131,'Cloudy | Clear',/data 
device, /close
spawn, 'convert '+fn+'.ps '+fn+'.png'

fn=dir+'example_oxa'
set_plot,'ps'
print, 'making plot :'+fn
loadct, 39, /silent
device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fn+'.ps'
device, xsize=20, ysize=20
 !p.font=1 & !p.thick=5 & !p.charsize=3.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
 !p.multi=0 & !x.margin=[7,3] &!x.omargin=[0,0]

  nul=min(abs(zenlambda-750.),fi)
  nul=min(abs(zenlambda-775.),la)
  alpha="141B  ;"
  tvlct,191,255,128,100
  i=[fi-5,fi-4,fi-3,fi-2,fi-1,la+1,la+2,la+3,la+4,la+5]
  spn=spz_cloud[fi-5:la+5]/interpol(spz_cloud[i],zenlambda[i],zenlambda[fi-5:la+5],/spline)
  plot, zenlambda[fi-5:la+5],spn,title='Oxygen-A',$
   ytitle='I/I!Do!N',xtitle='Wavelength (nm)'
  polyfill, [zenlambda[fi-1:la+1],zenlambda[fi-1]],[spn[4:n_elements(spn)-5],spn[4]],color=100

device, /close
spawn, 'convert '+fn+'.ps '+fn+'.png'

fn=dir+'example_oxa_I_Io'
set_plot,'ps'
print, 'making plot :'+fn
loadct, 39, /silent
device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fn+'.ps'
device, xsize=20, ysize=20
 !p.font=1 & !p.thick=8 & !p.charsize=3.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
 !p.multi=0 & !x.margin=[7,3] &!x.omargin=[0,0]

  nul=min(abs(zenlambda-750.),fi)
  nul=min(abs(zenlambda-775.),la)
  alpha="141B  ;"
  tvlct,191,255,128,100
  i=[fi-5,fi-4,fi-3,fi-2,fi-1,la+1,la+2,la+3,la+4,la+5]
  spn=interpol(spz_cloud[i],zenlambda[i],zenlambda[fi-5:la+5])
  plot, zenlambda[fi-5:la+5],spz_cloud[fi-5:la+5],title='Oxygen-A',$
   ytitle='Radiance (W/m!U2!N nm sr)',xtitle='Wavelength (nm)',psym=-6,yrange=[0.06,0.1]
  ;polyfill, [zenlambda[fi-1:la+1],zenlambda[fi-1]],[spn[4:n_elements(spn)-5],spn[4]],color=100
  oplot, zenlambda[fi-5:la+5],spn,color=70,psym=-6
  lam="154B ;"

  xyouts, zenlambda[fi+3]-5.,spz_cloud[fi+3],'I!D!9'+string(lam)+'!X!N'
  xyouts, zenlambda[fi+3],spn[8]+0.002,'I!Do !9'+string(lam)+'!X!N',color=70

device, /close
spawn, 'convert '+fn+'.ps '+fn+'.png'




fn=dir+'example_water'
set_plot,'ps'
print, 'making plot :'+fn
loadct, 39, /silent
device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fn+'.ps'
device, xsize=20, ysize=20
 !p.font=1 & !p.thick=5 & !p.charsize=3.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
 !p.multi=0 & !x.margin=[7,3] &!x.omargin=[0,0]

  fi=201
  la=229
  tvlct,240,136,000,249
  i=[fi-5,fi-4,fi-3,fi-2,fi-1,la+1,la+2,la+3,la+4,la+5]
  spnw=spz_cloud[fi-5:la+5]/interpol(spz_cloud[i],zenlambda[i],zenlambda[fi-5:la+5],/spline)
  plot, zenlambda[fi-5:la+5],spnw,title='Water vapor',ytitle='I/I!Do!N',xtitle='Wavelength (nm)'
  polyfill, [zenlambda[fi+8:la-4],zenlambda[fi+8]],[spnw[13:n_elements(spnw)-10],spnw[13]],color=249


device, /close
spawn, 'convert '+fn+'.ps '+fn+'.png'


stop
end
