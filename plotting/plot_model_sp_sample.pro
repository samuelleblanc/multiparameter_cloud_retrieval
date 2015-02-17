; program to plot a few modeled spectra
; for use in the general retrieval method paper (ice and liquid water clouds from below)
; udpates the plot sample_sp_v2.png from preivous (plot_retr_pdfs.pro)

pro plot_model_sp_sample

win=1

if win then fn='C:\Users\Samuel\Research\SSFR3\model\hires5\' else $
 fn='/argus/roof/SSFR3/model/' ;sp_hires_20120524.out'
if win then dir='C:\Users\Samuel\Research\SSFR3\plots\new\' else $
 dir='/home/leblanc/SSFR3/plots/'
if win then begin

lbl=['20120524',$
     '20120524_high',$
     '20120524_low',$
     '20120524_win',$
     '20120804',$
     '20120806_snd',$
     '20120813_snd',$
     '20120816_snd',$
     '20120820',$
     '20120912_snd']+'.out'

endif else begin
lbl=['20120524.out',$
       '20120804.out',$
       '20120812.out',$
       '20120820.out',$
       '20120913.out',$
       '20120525_win.out',$
       '20120525_high.out',$
       '20120525_low.out',$
       '20120523_snd.out',$
       '20120525_snd.out',$
       '20120602_snd.out',$
       '20120806_snd.out',$
       '20120813_snd.out',$
       '20120816_snd.out',$
       '20120820_snd.out',$
       '20120824_snd.out',$
       '20120912_snd.out']
endelse

nt=19 ;n_elements(tau)
nr=20 ;n_elements(ref)
nl=297;n_elements(zenlambda)
nw=2

sps=fltarr(nt,nr,nl,nw,n_elements(lbl))
spn=sps
for i=0, n_elements(lbl)-1 do begin
  f=fn+'sp_hires5_'+lbl[i]
  print, 'restoring: '+f
  restore, f
  sps[*,*,*,*,i]=sp
  for t=0, nt-1 do for r=0,nr-1 do for w=0,nw-1 do spn[t,r,*,w,i]=sps[t,r,*,w,i]/max(sps[t,r,*,w,i])
endfor
std=stddev(spn,dimension=5,/nan)

if 0 then begin
    fp=dir+'model_sample_sp_v2'
  ; for a cloud of tau 100, ref 15, wp 0
  t=17 & r=5 & w=0 & t2=8 & w2=1 & r2=12 & t3=1

  nul=min(abs(tau-50),t)
  nul=min(abs(tau-15),t2)
  nul=min(abs(tau-3),t3)
  
  nul=min(abs(ref-10),r)
  nul=min(abs(ref-30),r2)

  stop
  print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=40, ysize=15
   !p.font=1 & !p.thick=6 & !p.charsize=4.3 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,3,1] & !x.margin=[6,1] & !y.margin=[3,1] & !x.omargin=[0,1]

  tvlct,225,90,90,253
  tvlct,90,225,90,133
  tvlct,90,90,225,40
  tvlct,100,100,100,254

  ; now restore the model spectra
  ;  fn='/argus/roof/SSFR3/model/sp_hires_20120524.out'
  ;  print, 'restoring : '+fn
  ;  restore, fn
  if win then restore, 'C:\Users\Samuel\Research\SSFR3\model\sp_clear.out' else $ 
   restore, '/home/leblanc/SSFR3/data/sp_clear.out'
  wvl=zenlambda
  plot, wvl, sps[t,r,*,w,0],/nodata, yr=[0,0.40],ytitle='Radiance (Wm!U-2!Nnm!U-1!Nsr!U-1!N)',$
   xtit='Wavelength (nm)',xr=[400,1700]
  oplot,wvl, sps[t,r,*,w,0],color=40
  oplot,wvl, sps[t2,r,*,w,0],color=253
  oplot,wvl, sps[t,r,*,w2,0],color=133
  oplot,wvl, sps[t2,r,*,w2,0],color=210
  oplot,wvl, sps[t2,r2,*,w2,0],color=254
  oplot,wvl, rad,color=100

  legend, ['!9t!X=100, r!Deff!N=15 !9m!Xm liquid','!9t!X=20, r!Deff!N=15 !9m!Xm liquid',$
           '!9t!X=100, r!Deff!N=15 !9m!Xm ice','!9t!X=20, r!Deff!N=15 !9m!Xm ice',$
           '!9t!X=20, r!Deff!N=40 !9m!Xm ice','clear'],$;,'!9t!X=2, r!Deff!N=40 !9m!Xm ice','clear'],$
           textcolors=[40,253,133,210,254,100],box=0,charsize=2.0, /right

  plot, wvl, sps[t,r,*,w,0],/nodata, yr=[0,1.0],ytitle='Normalized radiance',xtit='Wavelength (nm)',xr=[400,1700]
  oplot,wvl, sps[t,r,*,w,0]/max(sps[t,r,*,w,0]),color=40
  oplot,wvl, sps[t2,r,*,w,0]/max(sps[t2,r,*,w,0]),color=253
  oplot,wvl, sps[t,r,*,w2,0]/max(sps[t,r,*,w2,0]),color=133
  oplot,wvl, sps[t2,r,*,w2,0]/max(sps[t2,r,*,w2,0]),color=210
  oplot,wvl, sps[t2,r2,*,w2,0]/max(sps[t2,r2,*,w2,0]),color=254
  oplot,wvl, rad/max(rad),color=100

  legend, ['!9t!X=100, r!Deff!N=15 !9m!Xm liquid','!9t!X=20, r!Deff!N=15 !9m!Xm liquid',$
           '!9t!X=100, r!Deff!N=15 !9m!Xm ice','!9t!X=20, r!Deff!N=15 !9m!Xm ice',$
           '!9t!X=20, r!Deff!N=40 !9m!Xm ice','clear'],$ ;,'!9t!X=2, r!Deff!N=40 !9m!Xm ice','clear'],$
           textcolors=[40,253,133,210,254,100],box=0,charsize=2.0, /right
  
  plot, wvl, std[t,r,*,w,0],/nodata, yr=[0,0.1],ytitle='Standard deviation',xtit='Wavelength (nm)',xr=[400,1700]
  oplot,wvl, std[t,r,*,w,0],color=40
  oplot,wvl, std[t2,r,*,w,0],color=253
  oplot,wvl, std[t,r,*,w2,0],color=133
  oplot,wvl, std[t2,r,*,w2,0],color=210
  oplot,wvl, std[t2,r2,*,w2,0],color=254
;  oplot,wvl, rad/max(rad),color=100

  legend, ['!9t!X=100, r!Deff!N=15 !9m!Xm liquid','!9t!X=20, r!Deff!N=15 !9m!Xm liquid',$
           '!9t!X=100, r!Deff!N=15 !9m!Xm ice','!9t!X=20, r!Deff!N=15 !9m!Xm ice',$
           '!9t!X=20, r!Deff!N=40 !9m!Xm ice'],$ ;,'!9t!X=2, r!Deff!N=40 !9m!Xm ice','clear'],$
           textcolors=[40,253,133,210,254],box=0,charsize=2.0, /right

  device, /close
  spawn, 'convert "'+fp+'.ps" "'+fp+'.png"'
endif else begin
    fp=dir+'model_sample_sp_v5'
  ; make plots for taus of 3, 20, 100 and refs of 15 and 40 and ice and liquid
  nul=min(abs(tau-50),t)
  nul=min(abs(tau-15),t2)
  nul=min(abs(tau-3),t3)
   
  nul=min(abs(ref-10),r)
  nul=min(abs(ref-30),r2)

  ts=[t,t2,t3]
  rs=[r,r2]
  ws=[0,1]
  
  print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=40, ysize=20
   !p.font=1 & !p.thick=6 & !p.charsize=4.3 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,3,2] & !x.margin=[6,1] & !y.margin=[3,1] & !x.omargin=[0,1]

  tvlct,225,90,90,253
  tvlct,90,225,90,133
  tvlct,90,90,225,40
  tvlct,100,100,100,254

  ; now restore the model spectra
;  fn='/argus/roof/SSFR3/model/sp_hires_20120524.out'
;  print, 'restoring : '+fn
;  restore, fn
  if win then restore, 'C:\Users\Samuel\Research\SSFR3\model\sp_clear.out' else $
   restore, '/home/leblanc/SSFR3/data/sp_clear.out'  
  wvl=zenlambda
  t=0 & r=0
  cl=[40,253,135]
  plot, wvl, sps[ts[t],rs[r],*,0,0],/nodata, yr=[0,0.50],ytitle='Radiance (Wm!U-2!Nnm!U-1!Nsr!U-1!N)',$
   xr=[400,1700],xtickname=[' ',' ',' ',' ',' ',' '],ymargin=[1.2,1],xticks=5
  for t=0, n_elements(ts)-1 do begin
    oplot, wvl, sps[ts[t],rs[r],*,0,0],color=cl[t]
    oplot, wvl, sps[ts[t],rs[r],*,1,0],color=cl[t],linestyle=1
  endfor 
  oplot,wvl, rad,color=100

  legend,['r!Deff!N='+string(ref[rs[0]],format='(I2)')+' !9m!Xm','!9t!X='+string(tau[ts],format='(I3)'),'clear','ice','liquid'],$
   textcolors=[0,cl,100,0,0],linestyle=[0,0,0,0,0,1,0],color=[255,255,255,255,255,0,0],pspacing=1.3,position=[900,0.47],$
   /data,box=0,charsize=2.0
 ;legend, ['ice','liquid'],linestyle=[1,0],box=0, /right,/bottom,charsize=2.0,pspacing=1.3
  
  t=0
  plot, wvl, sps[ts[t],rs[r],*,0,0]/max(sps[ts[t],rs[r],*,0,0]),/nodata, yr=[0,1.00],ytitle='Normalized radiance',xr=[400,1700],$
   xtickname=[' ',' ',' ',' ',' ',' '],ymargin=[1.2,1],xticks=5
  for t=0, n_elements(ts)-1 do begin
    oplot, wvl, sps[ts[t],rs[r],*,0,0]/max(sps[ts[t],rs[r],*,0,0]),color=cl[t]
    oplot, wvl, sps[ts[t],rs[r],*,1,0]/max(sps[ts[t],rs[r],*,1,0]),color=cl[t],linestyle=1
  endfor
  oplot,wvl, rad/max(rad),color=100

  legend, ['r!Deff!N='+string(ref[rs[0]],format='(I2)')+' !9m!Xm'],textcolors=[0],/right,box=0,charsize=2.0
  ;legend, ['r!Deff!N=15 !9m!Xm','!9t!X='+string(tau[ts],format='(I3)'),'clear'], textcolors=[0,cl,100],/right,box=0,charsize=2.0
  ;legend, ['ice','liquid'],linestyle=[1,0],box=0, /right,/bottom,charsize=2.0,pspacing=1.3
  t=0
  plot, wvl, std[ts[t],rs[r],*,0,0],/nodata, yr=[0,0.10],ytitle='Standard deviation',xr=[400,1700],$
   xtickname=[' ',' ',' ',' ',' ',' '],ymargin=[1.2,1],xticks=5
  for t=0, n_elements(ts)-1 do begin
    oplot, wvl, std[ts[t],rs[r],*,0,0],color=cl[t]
    oplot, wvl, std[ts[t],rs[r],*,1,0],color=cl[t],linestyle=1
  endfor
  
 legend, ['r!Deff!N='+string(ref[rs[0]],format='(I2)')+' !9m!Xm'],textcolors=[0],/right,box=0,charsize=2.0
 ;legend, ['r!Deff!N=15 !9m!Xm','!9t!X='+string(tau[ts],format='(I3)')], textcolors=[0,cl],/right,box=0,charsize=2.0
 ;legend, ['ice','liquid'],linestyle=[1,0],box=0, /right,/bottom,charsize=2.0,pspacing=1.3

  r=1 & t=0
  plot, wvl, sps[ts[t],rs[r],*,0,0],/nodata,ytitle='Radiance (Wm!U-2!Nnm!U-1!Nsr!U-1!N)',xr=[400,1700],$
   xtitle='Wavelength (nm)',ymargin=[3,-1],xticks=5,yr=[0,0.5]
  for t=0, n_elements(ts)-1 do begin
    oplot, wvl, sps[ts[t],rs[r],*,0,0],color=cl[t]
    oplot, wvl, sps[ts[t],rs[r],*,1,0],color=cl[t],linestyle=1
  endfor
  oplot,wvl, rad,color=100

 legend, ['r!Deff!N='+string(ref[rs[1]],format='(I2)')+' !9m!Xm'],textcolors=[0],/right,box=0,charsize=2.0
 ;legend, ['r!Deff!N=40 !9m!Xm','!9t!X='+string(tau[ts],format='(I3)'),'clear'], textcolors=[0,cl,100],/right,box=0,charsize=2.0
 ;legend, ['ice','liquid'],linestyle=[1,0],box=0, /right,/bottom,charsize=2.0,pspacing=1.3
 
  t=0
  plot, wvl, sps[ts[t],rs[r],*,0,0],/nodata, yr=[0,1.0],ytitle='Normalized radiance',xr=[400,1700],xtitle='Wavenlength (nm)',ymargin=[3,-1],xticks=5
  for t=0, n_elements(ts)-1 do begin
    oplot, wvl, sps[ts[t],rs[r],*,0,0]/max(sps[ts[t],rs[r],*,0,0]),color=cl[t]
    oplot, wvl, sps[ts[t],rs[r],*,1,0]/max(sps[ts[t],rs[r],*,1,0]),color=cl[t],linestyle=1
  endfor
  oplot,wvl, rad/max(rad),color=100
  
  legend, ['r!Deff!N='+string(ref[rs[1]],format='(I2)')+' !9m!Xm'],textcolors=[0],/right,box=0,charsize=2.0
 ;legend, ['r!Deff!N=40 !9m!Xm','!9t!X='+string(tau[ts],format='(I3)'),'clear'], textcolors=[0,cl,100],/right,box=0,charsize=2.0
 ;legend, ['ice','liquid'],linestyle=[1,0],box=0, /right,/bottom,charsize=2.0,pspacing=1.3
  t=0
  plot, wvl, std[ts[t],rs[r],*,0,0],/nodata, yr=[0,0.10],ytitle='Standard deviation',xr=[400,1700],xtitle='Wavelength (nm)',ymargin=[3,-1],xticks=5
  for t=0, n_elements(ts)-1 do begin
    oplot, wvl, std[ts[t],rs[r],*,0,0],color=cl[t]
    oplot, wvl, std[ts[t],rs[r],*,1,0],color=cl[t],linestyle=1
  endfor

  legend, ['r!Deff!N='+string(ref[rs[1]],format='(I2)')+' !9m!Xm'],textcolors=[0],/right,box=0,charsize=2.0
  ;legend, ['r!Deff!N=40 !9m!Xm','!9t!X='+string(tau[ts],format='(I3)')], textcolors=[0,cl],/right,box=0,charsize=2.0
  ;legend, ['ice','liquid'],linestyle=[1,0],box=0, /right,/bottom,charsize=2.0,pspacing=1.3

  device, /close
  spawn, 'convert "'+fp+'.ps" "'+fp+'.png"'

endelse
stop
end
