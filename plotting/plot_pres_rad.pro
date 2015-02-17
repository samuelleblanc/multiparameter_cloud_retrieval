; program to plot the modeled spectra for a few optical thickness and effective radius


@get_params4.pro
pro plot_pres_rad

dir='C:\Users\Samuel\Research\SSFR3\'
restore, dir+'model\sp_clear.out'
lbl='snow_ice'



dir='C:\Users\Samuel\Research\4STAR\model\arctic\'
fp=dir+'sp_v1_20130911_'+lbl+'_lowt_raw.out';'model\v1\sp_v2_20120525_lowt.out'
print, 'restoring :'+fp
restore, fp
;splow=sp & taul=tau
splow=reform(sp[*,*,0,*,*]) & taul=tau & zenlambda=wvl

;stop

dir='C:\Users\Samuel\Research\4STAR\'
;fp=dir+'model\v1\sp_v1_20120525.out'
fp=dir+'model\arctic\sp_v1_20130911_'+lbl+'_raw.out'
print, 'restoring :'+fp
restore, fp
stop
wv=wvl ;zenlambda
wvz=zenlambda
sp=reform(sp[*,*,0,*,*])


if 0 then begin
fp=dir+'plots\new\model_sp_rad'
print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=30, ysize=20
   !p.font=1 & !p.thick=6 & !p.charsize=2.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,2,2] & !x.margin=[0,0.7] & !y.margin=[0,0.6] & !x.omargin=[8,1] & !y.omargin=[3.5,0.2]

  tvlct,140,230,250,40
  tvlct,0,150,0,150

  cl=[150,250,50]
  t=[2,7,16]
  r=[8,22]
  xtn=[' ',' ',' ',' ',' ',' ',' ',' ',' ']
  
  plot, wv,sp[t[0],r[0],*,0],/nodata,xtickname=xtn,yr=[0,0.24],ytitle='Radiance!C(Wm!U-2!Nnm!U-1!Nsr!U-1!N)',$
   yticklen=0.05,xticklen=0.1
  oplot,wvl,rad,color=40
  for w=0,1 do begin
    for i=0,2 do oplot,wv,sp[t[i],r[0],*,w],color=cl[i],linestyle=w*2
  endfor
  legend,['r!De!N='+string(ref[r[0]],format='(I2)')+' !9m!Xm','!9t!X='+string(tau[t],format='(I3)'),'clear','ice','liquid'],$
   textcolors=[0,cl,40,0,0],linestyle=[0,0,0,0,0,2,0],color=[255,255,255,255,255,0,0],pspacing=1.3,position=[1100,0.22],$
   /data,box=0,charsize=2.0
  
  plot, wv,sp[t[0],r[1],*,0],/nodata,xtickname=xtn,yr=[0,0.24],ytickname=xtn,yticklen=0.05,xticklen=0.1 
  oplot,wvl,rad,color=40 
  for w=0,1 do begin 
    for i=0,2 do oplot,wv,sp[t[i],r[1],*,w],color=cl[i],linestyle=w*2 
  endfor 
  legend, ['r!De!N='+string(ref[r[1]],format='(I2)')+' !9m!Xm'],textcolors=[0],/right,box=0,charsize=2.0

  
  plot, wv,sp[t[0],r[0],*,0],/nodata,yr=[0,1.0],ytitle='Normalized radiance',xtitle='Wavelength (nm)',yticklen=0.05,xticklen=0.1
  oplot,wvl,rad/max(rad),color=40
  for w=0,1 do begin
    for i=0,2 do oplot,wv,sp[t[i],r[0],*,w]/max(sp[t[i],r[0],*,w]),color=cl[i],linestyle=w*2
  endfor
  legend, ['r!De!N='+string(ref[r[0]],format='(I2)')+' !9m!Xm'],textcolors=[0],/right,box=0,charsize=2.0

  plot, wv,sp[t[0],r[0],*,0],/nodata,yr=[0,1.0],ytickname=xtn,xtitle='Wavelength (nm)',yticklen=0.05,xticklen=0.1
  oplot,wvl,rad/max(rad),color=40
  for w=0,1 do begin 
    for i=0,2 do oplot,wv,sp[t[i],r[1],*,w]/max(sp[t[i],r[1],*,w]),color=cl[i],linestyle=w*2
  endfor  
  legend, ['r!De!N='+string(ref[r[1]],format='(I2)')+' !9m!Xm'],textcolors=[0],/right,box=0,charsize=2.0
  

  device, /close
  spawn, 'convert "'+fp+'.ps" "'+fp+'.png"'
endif
;stop

if 0 then begin
fp=dir+'plots\new\model_sp_rad2'
print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=18, ysize=30
   !p.font=1 & !p.thick=6 & !p.charsize=3.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,1,4] & !x.margin=[0,0.7] & !y.margin=[0,0.6] & !x.omargin=[8,1] & !y.omargin=[3.5,0.2]
   cl=[150,250,50]
  t=[2,7,16]
  r=[17,22]
 tvlct,140,230,250,40
  xtn=[' ',' ',' ',' ',' ',' ',' ',' ',' '] 
   tvlct,0,150,0,150
   plot, wv,sp[t[0],r[0],*,0],/nodata,xtickname=xtn,yr=[0,0.24],ytitle='Radiance!C(Wm!U-2!Nnm!U-1!Nsr!U-1!N)',$
   yticklen=0.05,xticklen=0.1
  for w=0,1 do begin
    for i=0,2 do oplot,wv,sp[t[i],r[0],*,w],color=cl[i],linestyle=w*2
  endfor
  legend,['r!De!N='+string(ref[r[0]],format='(I2)')+' !9m!Xm','!9t!X='+string(tau[t],format='(I3)'),'ice','liquid'],$
   textcolors=[0,cl,0,0],linestyle=[0,0,0,0,2,0],color=[255,255,255,255,0,0],pspacing=1.3,position=[1200,0.23],$
   /data,box=0,charsize=2.0

  plot, wv,sp[t[0],r[0],*,0],/nodata,yr=[0,1.0],ytitle='Normalized radiance',yticklen=0.05,xticklen=0.1,xtickname=xtn
  for w=0,1 do begin
    for i=0,2 do oplot,wv,sp[t[i],r[0],*,w]/max(sp[t[i],r[0],*,w]),color=cl[i],linestyle=w*2
  endfor
  legend,['r!De!N='+string(ref[r[0]],format='(I2)')+' !9m!Xm','!9t!X='+string(tau[t],format='(I3)'),'ice','liquid'],$
   textcolors=[0,cl,0,0],linestyle=[0,0,0,0,2,0],color=[255,255,255,255,0,0],pspacing=1.3,position=[1200,1.00],$
   /data,box=0,charsize=2.0
  ;legend, ['r!De!N='+string(ref[r[0]],format='(I2)')+' !9m!Xm'],textcolors=[0],/right,box=0,charsize=2.0

  r=[8,17,22]
  plot, wv,sp[12,r[0],*,0],/nodata,yr=[0,1.0],ytitle='Normalized radiance',xtickname=xtn,yticklen=0.05,xticklen=0.1
  for w=0,1 do begin
    for i=0,2 do oplot,wv,sp[12,r[i],*,w]/max(sp[12,r[i],*,w]),color=cl[i],linestyle=w*2
  endfor
  legend,['!9t!X='+string(tau[12],format='(I3)'),'r!De!N='+string(ref[r],format='(I2)')+' !9m!Xm','ice','liquid'],$
   textcolors=[0,cl,0,0],linestyle=[0,0,0,0,2,0],color=[255,255,255,255,0,0],pspacing=1.3,position=[1200,1.00],$
   /data,box=0,charsize=2.0 


  t=[0,1,2]
  plot, wv,sp[t[0],r[1],*,0],/nodata,yr=[0,1.0],ytitle='Normalized radiance',xtitle='Wavelength (nm)',yticklen=0.05,xticklen=0.1
  oplot,wvl,rad/max(rad),color=40
  for w=0,1 do begin 
    for i=0,2 do oplot,wv,sp[t[i],r[1],*,w]/max(sp[t[i],r[1],*,w]),color=cl[i],linestyle=w*2
  endfor 
  oplot,wvl,rad/max(rad),color=40
  legend,['r!De!N='+string(ref[r[1]],format='(I2)')+' !9m!Xm','!9t!X='+string(tau[t],format='(I3)'),'clear','ice','liquid'],$
   textcolors=[0,cl,40,0,0],linestyle=[0,0,0,0,0,2,0],color=[255,255,255,255,255,0,0],pspacing=1.3,position=[1200,1.00],$
   /data,box=0,charsize=2.0


  device, /close
  spawn, 'convert "'+fp+'.ps" "'+fp+'.png"'
endif

if 0 then begin

fp=dir+'plots\new\model_sp_rad3'
print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=18, ysize=16
   !p.font=1 & !p.thick=6 & !p.charsize=2.5 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,1,2] & !x.margin=[0,0.7] & !y.margin=[0,0.6] & !x.omargin=[8,1] & !y.omargin=[3.5,0.2]
   cl=[150,250,50]
  t=[2,7,16]
  r=[17,22]
  tvlct,140,230,250,40
  xtn=[' ',' ',' ',' ',' ',' ',' ',' ',' ']
   tvlct,0,150,0,150
   plot, wv,sp[t[0],r[0],*,0],/nodata,xtickname=xtn,yr=[0,0.24],ytitle='Radiance!C(Wm!U-2!Nnm!U-1!Nsr!U-1!N)',$
   yticklen=0.05,xticklen=0.1
  for w=0,1 do begin
    for i=0,2 do oplot,wv,sp[t[i],r[0],*,w],color=cl[i],linestyle=w*2
  endfor
  legend,['r!De!N='+string(ref[r[0]],format='(I2)')+' !9m!Xm','!9t!X='+string(tau[t],format='(I3)'),'ice','liquid'],$
   textcolors=[0,cl,0,0],linestyle=[0,0,0,0,2,0],color=[255,255,255,255,0,0],pspacing=1.3,position=[1100,0.23],$
   /data,box=0,charsize=2.0

  plot, wv,sp[t[0],r[0],*,0],/nodata,yr=[0,1.0],ytitle='Normalized radiance',yticklen=0.05,xticklen=0.1,xtitle='Wavelength (nm)'
  for w=0,1 do begin
    for i=0,2 do oplot,wv,sp[t[i],r[0],*,w]/max(sp[t[i],r[0],*,w]),color=cl[i],linestyle=w*2
  endfor
  legend,['r!De!N='+string(ref[r[0]],format='(I2)')+' !9m!Xm','!9t!X='+string(tau[t],format='(I3)'),'ice','liquid'],$
   textcolors=[0,cl,0,0],linestyle=[0,0,0,0,2,0],color=[255,255,255,255,0,0],pspacing=1.3,position=[1100,1.00],$
   /data,box=0,charsize=2.0

  device, /close
  spawn, 'convert "'+fp+'.ps" "'+fp+'.png"'

endif 


if 0 then begin
for uu=0, 26 do begin
fp=dir+'plots\present\rad4\'+string(uu,format='(I02)')
print, 'making plot :'+fp 
  set_plot, 'ps' 
  loadct, 39, /silent 
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=24, ysize=15   
   !p.font=1 & !p.thick=6 & !p.charsize=2.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=1 & !x.margin=[0,0.7] & !y.margin=[0,0.6] & !x.omargin=[8,1] & !y.omargin=[3.5,0.2]
   cl=[150,250,50]
  t=[2,7,16]
  r=[17,22]
  ;tvlct,140,230,250,40
  xtn=[' ',' ',' ',' ',' ',' ',' ',' ',' ']
  ;tvlct,0,150,0,150 

  plot, wv,sp[t[0],r[0],*,0],/nodata,yr=[0,1.0],ytitle='Normalized radiance',yticklen=0.05,xticklen=0.1,xtitle='Wavelength (nm)'  
  loadct,1
  revct
  !p.thick=1.0
  for i=0,22<uu do oplot, wv, sp[12,i,*,0]/max(sp[12,i,*,0]),color=(i+3)*7
  xyouts,460,0.4,'liquid!Cr!De!N='+string(ref[22<uu],format='(I2)')+' !9m!Xm',color=(i+2)*7,charsize=2.8   

  loadct,3
  revct
  for i=8,uu+8 do oplot, wv, sp[12,i,*,1]/max(sp[12,i,*,1]),color=(i-1)*6
  xyouts,1000,0.70,'ice!Cr!De!N='+string(ref[uu+8],format='(I2)')+' !9m!Xm',color=(i-2)*6,charsize=2.8 

  tvlct,0,0,0,0
  tvlct,170,222,255,10
  tvlct,0,0,107,238
  tvlct,255,175,90,160
  tvlct,82,0,0,82
  xyouts,1400,0.8,'!9t!X='+string(tau[12],format='(I2)'),charsize=2.8
  ;xyouts,460,0.4,'liquid!Cr!De!N='+string(ref[21>uu],format='(I2)')+' !9m!Xm',color=clb[uu],charsize=2.8
  ;xyouts,650,0.87,'liquid!Cr!De!N='+string(ref[22],format='(I2)')+' !9m!Xm',color=238
  ;xyouts,1000,0.70,'ice!Cr!De!N='+string(ref[uu+8],format='(I2)')+' !9m!Xm',color=clr[uu],charsize=2.8
  ;xyouts,730,0.20,'        ice!Cr!De!N='+string(ref[34],format='(I2)')+' !9m!Xm',color=82

  tvlct,220,220,220,201
  ;xyouts, 990,0.60,'{',color=201,alignment=0.5,charsize=7.2,orientation=-90, charthick=0.5
  ;xyouts, 1200,0.32,'{',color=201,alignment=0.5,charsize=7.6,orientation=-90, charthick=0.5
  ;xyouts, 1510,0.13,'{',color=201,alignment=0.5,charsize=8.2,orientation=-90, charthick=0.5
  ;xyouts, 1010,0.65,'1',color=201
  ;xyouts, 1230,0.37,'2',color=201
  ;xyouts, 1540,0.18,'3',color=201


  ;legend,['r!De!N='+string(ref[r[0]],format='(I2)')+' !9m!Xm','!9t!X='+string(tau[t],format='(I3)'),'ice','liquid'],$ 
  ; textcolors=[0,cl,0,0],linestyle=[0,0,0,0,2,0],color=[255,255,255,255,0,0],pspacing=1.3,position=[1200,1.00],$ 
  ; /data,box=0,charsize=2.0 
 
  device, /close
  ;spawn, 'convert "'+fp+'.ps" "'+fp+'.png"'
endfor
endif


; set the colors
clb=[1,2,(indgen(23)+5)*7] ;the blues
clr=[1,2,(indgen(23)+1)*6]

if 1 then begin
for uu=0, 24 do begin
fp=dir+'plots\present\r5_snow_ice\'+string(uu,format='(I02)')
print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=34, ysize=15
   !p.font=1 & !p.thick=6 & !p.charsize=2.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,2,1] & !x.margin=[0,0.7] & !y.margin=[0,0.6] & !x.omargin=[8,1] & !y.omargin=[3.5,0.2]
   cl=[150,250,50]
  t=[2,7,16]
  r=[17,22]
  ;tvlct,140,230,250,40
  xtn=[' ',' ',' ',' ',' ',' ',' ',' ',' ']
  ;tvlct,0,150,0,150 

  plot, wv,sp[t[0],r[0],*,0],/nodata,yr=[0,1.0],ytitle='Normalized radiance',yticklen=0.05,xticklen=0.1,xtitle='Wavelength (nm)'
  loadct,1
  revct
  !p.thick=2.0
  tvlct,220,220,220,201
  tvlct,255,255,255,202
    ;polyfill,[950,950,1100,1100,950],[0,1,1,0,0],color=201
    ;polyfill,[1150,1150,1350,1350,1150],[0,1,1,0,0],color=201
    ;polyfill,[1450,1450,1650,1650,1450],[0,1,1,0,0],color=201
  ;xyouts, 980,0.47,'{',color=201,alignment=0.5,charsize=6.2,orientation=-90, charthick=0.8
  ;xyouts, 1200,0.37,'{',color=201,alignment=0.5,charsize=6.2,orientation=-90, charthick=0.8
  ;xyouts, 1510,0.23,'{',color=201,alignment=0.5,charsize=7.2,orientation=-90, charthick=0.8
  ;xyouts, 1010,0.52,'1',color=201
  ;xyouts, 1230,0.42,'2',color=201
  ;xyouts, 1540,0.28,'3',color=201

  if uu gt 2 then for i=0,uu-3 do oplot, wv, sp[i,17,*,0]/max(sp[i,17,*,0]),color=(i+5)*7
;  tvlct,160,230,160,4 & tvlct,160,230,190,3 & tvlct,160,230,220,2 & tvlct,160,230,250,1  

  tvlct,50,240,130,1 & tvlct, 50,220,180,2
 if uu gt 0 then  oplot, wvz, splow[1,17,*,0]/max(splow[1,17,*,0]),color=1
 if uu gt 1 then  oplot, wvz, splow[2,17,*,0]/max(splow[2,17,*,0]),color=2

;  for i=0,3  do oplot, wv, splow[i,17,*,0]/max(splow[i,17,*,0]),color=i+1
  tvlct,0,0,0,0 
  tvlct,170,222,255,10 
  tvlct,0,0,107,238   
  tvlct,255,175,90,160 
  tvlct,82,0,0,82 
  xyouts,1300,0.79,'Liquid!Cr!De!N='+string(ref[17],format='(I2)')+' !9m!Xm',color=0,charsize=2.8
  ;xyouts,1490,0.15,'!9t!X='+string(tau[0],format='(I2)'),color=10
  ;xyouts,650,0.83,'!9t!X='+string(tau[21],format='(I3)'),color=238
  tvlct,50,240,50,74
  oplot,wvl,rad/max(rad),color=74,thick=3
  xyouts,480,0.13,'Clear',color=74
  ;xyouts,760,0.10,'!9t!X=0.2',color=1
  ;xyouts,590,0.36,'!9t!X=0.5',color=2
  if uu eq 1 then xyouts,800,0.8,'!9t!X=0.2',color=1,charsize=2.8
  if uu eq 2 then xyouts,800,0.8,'!9t!X=0.5',color=2,charsize=2.8
  if uu gt 2 then xyouts,800,0.8,'!9t!X='+string(tau[uu-3],format='(I3)'),color=clb[uu],charsize=2.8


  loadct,39
  plot,wv,sp[0,0,*,0],/nodata,yr=[0,1.0],ytickname=xtn,yticklen=0.05,xticklen=0.1,xtitle='Wavelength (nm)'
  tvlct,220,220,220,201
  ;xyouts, 980,0.55,'{',color=201,alignment=0.5,charsize=6.2,orientation=-90, charthick=0.8
  ;xyouts, 1200,0.37,'{',color=201,alignment=0.5,charsize=6.2,orientation=-90, charthick=0.8
  ;xyouts, 1510,0.23,'{',color=201,alignment=0.5,charsize=7.2,orientation=-90, charthick=0.8
  ;xyouts, 1010,0.60,'1',color=201
  ;xyouts, 1230,0.42,'2',color=201
  ;xyouts, 1540,0.28,'3',color=201

  loadct,3
  revct
  tvlct,150,130,0,4 & tvlct,150,130,0,3 & tvlct,200,180,0,2 & tvlct,250,230,0,1
  if uu gt 2 then for i=0,uu-3 do oplot, wv, sp[i,17,*,1]/max(sp[i,17,*,1]),color=(i+1)*6
  if uu gt 0 then for i=1,1  do oplot, wvz, splow[i,17,*,1]/max(splow[i,17,*,1]),color=i
  if uu gt 1 then for i=2,2  do oplot, wvz, splow[i,17,*,1]/max(splow[i,17,*,1]),color=i
  tvlct,0,0,0,0
  tvlct,170,222,255,10
  tvlct,0,0,107,238
  tvlct,255,175,90,160
  tvlct,255,243,231,160
  tvlct,178,5,0,82
  xyouts,1300,0.8,'Ice!Cr!De!N='+string(ref[17],format='(I2)')+' !9m!Xm',color=0,charsize=2.8 
  ;xyouts,980,0.43,'!9t!X='+string(tau[0],format='(I2)'),color=12
  ;xyouts,740,0.09,'!9t!X='+string(tau[21],format='(I3)'),color=132 
  ;xyouts,470,0.5,'!9t!X=0.2',color=1 
  if uu eq 1 then xyouts,800,0.8,'!9t!X=0.2',color=1,charsize=2.8 
  if uu eq 2 then xyouts,800,0.8,'!9t!X=0.5',color=2,charsize=2.8
  if uu gt 2 then xyouts,800,0.8,'!9t!X='+string(tau[uu-3],format='(I3)'),color=clr[uu],charsize=2.8 


  device, /close
;stop
  ;spawn, 'convert "'+fp+'.ps" "'+fp+'.png"'
endfor
endif
stop
if 0 then begin
for uu=0, 21 do begin
;fp=dir+'plots\new\model_sp_rad6'
fp=dir+'plots\present\rad6\'+string(uu,format='(I02)')
print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=34, ysize=15
   !p.font=1 & !p.thick=6 & !p.charsize=2.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,2,1] & !x.margin=[0,0.7] & !y.margin=[0,0.6] & !x.omargin=[8,1] & !y.omargin=[3.0,0.2]
   cl=[150,250,50]
  t=[2,7,16]
  r=[17,22]
  ;tvlct,140,230,250,40
  xtn=[' ',' ',' ',' ',' ',' ',' ',' ',' ']
  ;tvlct,0,150,0,150 

  plot, wv,sp[t[0],r[0],*,0],/nodata,yr=[0,1.3],ytitle='Normalized radiance',yticklen=0.05,xticklen=0.1,$
   xtitle='Wavelength (nm)',xr=[950,1700]
  loadct,1
  revct
  !p.thick=2.0
  is=where(wv gt 998. and wv lt 1100.)
  ii=[213,214]  
  vi=[1175,1225]
  th=7.0 & thh=10.
  i2=[262,263]
  v2=[1475,1525]
  ;i1000=181
  nul=min(abs(wv-1000.),i1000)
  tvlct, 0,0,0,0

  for i=0,21<uu do oplot, wv, sp[i,17,*,0]/max(sp[i,17,i1000,0]),color=(i+5)*7
  ;for i=21,4,-4 do begin
    i=i-1
    xyouts,1120,1.0,'!9t!X='+string(tau[i],format='(I3)'),color=(i+5)*7,charsize=2.8
    oplot, wv[is],sp[i,17,is,0]/max(sp[i,17,i1000,0]),thick=th+thh
    oplot, wv[is],sp[i,17,is,0]/max(sp[i,17,i1000,0]),color=(i+5)*7,thick=th
    kl=linfit(wv[is[[0,n_elements(is)-1]]],sp[i,17,is[[0,n_elements(is)-1]],0]/max(sp[i,17,i1000,0]))
    low=wv[is]*kl[1]+kl[0]
    polyfill,[wv[is],reverse(wv[is])],[reform(sp[i,17,is,0]/max(sp[i,17,i1000,0])),reverse(low)],$
     color=(i+5)*7,spacing=0.06,orientation=90+i*8
    ll=linfit(wv[ii],sp[i,17,ii,0]/max(sp[i,17,i1000,0]))
    oplot, vi,vi*ll[1]+ll[0],thick=th+thh
    oplot, vi,vi*ll[1]+ll[0],color=(i+5)*7,thick=th
    l2=linfit(wv[i2],sp[i,17,i2,0]/max(sp[i,17,i1000,0]))
    oplot, v2,v2*l2[1]+l2[0],thick=th +thh
    oplot, v2,v2*l2[1]+l2[0],color=(i+5)*7,thick=th
  ;endfor
  tvlct,0,0,0,0
  tvlct,170,222,255,10
  tvlct,0,0,107,238   
  tvlct,255,175,90,160
  tvlct,82,0,0,82
  xyouts,1450,1.1,'Liquid!Cr!De!N='+string(ref[17],format='(I2)')+' !9m!Xm',color=0,charsize=2.8
  ;xyouts,1570,0.37,'!9t!X='+string(tau[0],format='(I2)'),color=0,charsize=2.8,charthick=10.0
  ;xyouts,1570,0.37,'!9t!X='+string(tau[0],format='(I2)'),color=10,charsize=2.8,charthick=0.8
  ;xyouts,1120,1.0,'!9t!X='+string(tau[i],format='(I3)'),color=(i+5)*7,charsize=2.8
  ;xyouts,1100,1.2,'1',charsize=2.8
  ;xyouts,1200,0.7,'2',charsize=2.8
  ;xyouts,1450,0.4,'3',charsize=2.8
  ;arrow,1110,1.18,1075,1.1,/data,thick=2
  ;arrow,1210,0.68,1200,0.59,/data,thick=2
  ;arrow,1470,0.38,1480,0.25,/data,thick=2

  loadct,39
  plot,wv,sp[0,0,*,0],/nodata,yr=[0,1.3],ytickname=xtn,yticklen=0.05,xticklen=0.1,xtitle='Wavelength (nm)',xr=[950,1700]

loadct,3
  revct
  for i=0,21<uu do oplot, wv, sp[i,17,*,1]/max(sp[i,17,i1000,1]),color=(i+1)*6
  tvlct,0,0,0,0
  i=i-1
  xyouts,1120,1.0,'!9t!X='+string(tau[i],format='(I3)'),color=(i+1)*6,charsize=2.8
  ;for i=2,21,4 do begin 
    oplot, wv[is],sp[i,17,is,1]/max(sp[i,17,i1000,1]),thick=th+thh
    oplot, wv[is],sp[i,17,is,1]/max(sp[i,17,i1000,1]),color=(i+1)*6,thick=th 
    kl=linfit(wv[is[[0,n_elements(is)-1]]],sp[i,17,is[[0,n_elements(is)-1]],1]/max(sp[i,17,i1000,1]))
    low=wv[is]*kl[1]+kl[0]
    polyfill,[wv[is],reverse(wv[is])],[reform(sp[i,17,is,1]/max(sp[i,17,i1000,1])),reverse(low)],$
     color=(i+1)*6,spacing=0.06,orientation=90+i*8
    ll=linfit(wv[ii],sp[i,17,ii,1]/max(sp[i,17,i1000,1]))
    oplot, vi,vi*ll[1]+ll[0],thick=th+thh
    oplot, vi,vi*ll[1]+ll[0],color=(i+1)*6,thick=th 
    l2=linfit(wv[i2],sp[i,17,i2,1]/max(sp[i,17,i1000,1]))
    oplot, v2,v2*l2[1]+l2[0],thick=th+thh
    oplot, v2,v2*l2[1]+l2[0],color=(i+1)*6,thick=th 
  ;endfor 

  tvlct,0,0,0,0
  tvlct,170,222,255,10
  tvlct,0,0,107,238
  tvlct,255,175,90,160
  tvlct,255,243,231,160
  tvlct,178,5,0,82
  xyouts,1450,1.1,'Ice!Cr!De!N='+string(ref[17],format='(I2)')+' !9m!Xm',color=0,charsize=2.8
  ;xyouts,1560,0.3,'!9t!X='+string(tau[0],format='(I2)'),color=0,charsize=2.8,charthick=10.0
  ;xyouts,1560,0.3,'!9t!X='+string(tau[0],format='(I2)'),color=12,charsize=2.8,charthick=0.8
  ;xyouts,960,0.4,'!9t!X='+string(tau[21],format='(I3)'),color=132,charsize=2.8

  ;xyouts,1100,1.15,'1',charsize=2.8
  ;xyouts,1200,0.7,'2',charsize=2.8
  ;xyouts,1450,0.4,'3',charsize=2.8
  ;arrow,1110,1.13,1075,0.97,/data,thick=2
  ;arrow,1210,0.68,1200,0.59,/data,thick=2
  ;arrow,1470,0.38,1480,0.25,/data,thick=2

 
  device, /close
  ;spawn, 'convert "'+fp+'.ps" "'+fp+'.png"'
endfor
endif

stop

if 0 then begin
fp=dir+'plots\new\model_sp_rad_n11'
print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=34, ysize=15
   !p.font=1 & !p.thick=6 & !p.charsize=2.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,2,1] & !x.margin=[7,1] & !y.margin=[0,0.6] & !x.omargin=[0,0] & !y.omargin=[3.0,0.2]
   cl=[150,250,50]
  t=[2,7,16]
  r=[17,22]
  ;tvlct,140,230,250,40
  xtn=[' ',' ',' ',' ',' ',' ',' ',' ',' ']
  ;tvlct,0,150,0,150 
 
  plot, wv,sp[t[0],r[0],*,0],/nodata,yr=[0,1.0],ytitle='Normalized radiance',yticklen=0.05,xticklen=0.1,$
   xtitle='Wavelength (nm)',xr=[400,800]
  loadct,1
  revct
  !p.thick=5.0
  is=where(wv gt 530. and wv lt 610.)
  th=7.0 & thh=10.
  tvlct, 0,0,0,0
 
  for i=0,3 do oplot, wv, sp[i,17,*,0]/max(sp[i,17,*,0]),color=((i+1)*4)*7
    tvlct,50,240,130,1 & tvlct, 50,220,180,2
  oplot, wv, splow[1,17,*,0]/max(splow[1,17,*,0]),color=1
  oplot, wv, splow[2,17,*,0]/max(splow[2,17,*,0]),color=2
  tvlct,50,240,50,77
  oplot,wvl,rad/max(rad),color=77
  ss=where(wvl gt 530. and wvl lt 610.)

  for i=0,3 do begin
    ll=linfit(wv[is],sp[i,17,is,0]/max(sp[i,17,*,0]))
    oplot, wv[is],ll[0]+ll[1]*wv[is],thick=th+thh
    oplot, wv[is],ll[0]+ll[1]*wv[is],color=(i+5)*7,thick=th
  endfor
  ll=linfit(wv[is],splow[1,17,is,0]/max(splow[1,17,*,0]))
  oplot, wv[is], ll[0]+ll[1]*wv[is],color=0,thick=th+thh
  oplot, wv[is], ll[0]+ll[1]*wv[is],color=1,thick=th
  ll=linfit(wv[is],splow[2,17,is,0]/max(splow[2,17,*,0]))
  oplot, wv[is], ll[0]+ll[1]*wv[is],color=0,thick=th+thh
  oplot, wv[is], ll[0]+ll[1]*wv[is],color=2,thick=th
    ll=linfit(wvl[ss],rad[ss]/max(rad))
  oplot, wv[is], ll[0]+ll[1]*wv[is],color=0,thick=th+thh 
  oplot, wv[is], ll[0]+ll[1]*wv[is],color=77,thick=th 
  xyouts,530,0.2,'Clear',color=77
  xyouts,700,0.19,'!9t!X=0.2',color=1
  xyouts,650,0.39,'!9t!X=0.5',color=2
  xyouts,640,0.55,'!9t!X=1',color=5*7
  xyouts,700,0.69,'!9t!X=4',color=16*7

get_low_pars, splow,wv,parl

; now restore the parameters.
fp=dir+'data\par_std_sza_v1_20120525.out'
print, 'restoring:' +fp
restore, fp
loadct, 39

  yr=[-2.25,-1.25]
  sl='r!De!N='+['10','20','30']+' !9m!Xm'

;  parl[1,*,0,10]=parl[1,*,0,10]-0.15

  plot, taus, pars[*,9,0,10,1], ytitle='!9h!X!D11!N',xtitle='Optical thickness',yr=yr,/nodata,xr=[0,4]
  !p.thick=5
 ; oplot,taus, pars[*,9,0,10,1],psym=-7
 ; oplot,taus, pars[*,9,1,10,1],linestyle=2,psym=-7
  oplot,taul[1:*], parl[1:*,8,0,10],psym=-7
  oplot,taul[1:*], parl[1:*,8,1,10],linestyle=2,psym=-7

 ; oplot,taus, pars[*,19,0,10,1],color=70,psym=-7
 ; oplot,taus, pars[*,19,1,10,1],linestyle=2,color=70,psym=-7
  oplot,taul[1:*], parl[1:*,17,0,10],color=70,psym=-7
  oplot,taul[1:*], parl[1:*,17,1,10],linestyle=2,color=70,psym=-7

 ; oplot,taus, pars[*,29,0,10,1],color=250,psym=-7
 ; oplot,taus, pars[*,29,1,10,1],linestyle=2,color=250,psym=-7
  oplot,taul[1:*], parl[1:*,22,0,10],color=250,psym=-7
  oplot,taul[1:*], parl[1:*,22,1,10],linestyle=2,color=250,psym=-7

  legend,[sl,'ice','liquid'],textcolor=[0,70,250,0,0],box=0,charsize=2.2,/bottom,linestyle=[0,0,0,2,0],$
   color=[255,255,255,0,0],/right,pspacing=1.2
 
  device, /close
  spawn, 'convert "'+fp+'.ps" "'+fp+'.png"'
endif

stop
end





; procedure to flip the color table
pro revct
tvlct,r,g,b,/get
  r=reverse(r) & g=reverse(g) & b=reverse(b)
  tvlct,r,g,b
end



; procedure to build the low tau parameters
pro get_low_pars, sp,wv,par

nt=n_elements(sp[*,0,0,0])
nr=n_elements(sp[0,*,0,0])
nw=2
get_params,wv,sp[0,0,*,0],pp
np=n_elements(pp)
par=fltarr(nt,nr,nw,np)
for t=0,nt-1 do begin
  for r=0, nr-1 do begin
    for w=0, nw-1 do begin
      ss=reform(sp[t,r,*,w])
      get_params,wv,ss,pp
      par[t,r,w,*]=pp
    endfor ; wp loop
  endfor ; ref loop
endfor ; tau loop
end
