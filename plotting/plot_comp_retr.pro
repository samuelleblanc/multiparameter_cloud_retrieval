; program to plot the comparison of the retrieved optical depth, effective radius and phase 
; for the parameter method, pat's method, and two wavelength method.
; this makes a whisker-box type plot ... needs work and update
; also plots a single day example of the retrieved time trace comparison between these various retrievals

pro plot_comp_retr

dir='/home/leblanc/SSFR3/data/'
dir='C:\Users\Samuel\Research\SSFR3\retrieved\'
lbls=['20120523',$
      '20120525',$
      '20120602',$
      '20120806',$
      '20120813',$
      '20120816',$
      '20120820',$
      '20120824',$
      '20120912',$
      '20130110',$
      '20130111']

nlbl=n_elements(lbls)

;sample stats
if 1 then begin
hi_stat=fltarr(nlbl,7) ;mean, std, min, max ,25th perentile, 75th percentile, median, for tau - parameters
hm_stat=fltarr(nlbl,7) ;for tau - pat's
hc_stat=fltarr(nlbl,7) ;for tau - 2wvl
hir_stat=fltarr(nlbl,7) ;mean, std, min, max ,25th perentile, 75th percentile, median, for ref - parameters 
hmr_stat=fltarr(nlbl,7) ;for ref - pat's 
hcr_stat=fltarr(nlbl,7) ;for ref - 2wvl
wpi_stat=fltarr(nlbl)  ;for percent of ice phase
wpm_stat=fltarr(nlbl)
wpc_stat=fltarr(nlbl) 
hk_stat=fltarr(nlbl,7)
hkr_stat=fltarr(nlbl,7)
wpk_stat=fltarr(nlbl)


for p=0, nlbl-1 do begin
  restore, dir+'retrieved_pdf_'+lbls[p]+'.out'
  tau_rtm1=tau_rtm & ref_rtm1=ref_rtm & wp_rtm1=wp_rtm
  restore, dir+'retrieved_pdf_'+lbls[p]+'_pat.out'
  tau_rtm2=tau_rtm & ref_rtm2=ref_rtm & wp_rtm2=wp_rtm
  restore, dir+'retrieved_pdf_'+lbls[p]+'_2wvl.out'
  tau_rtm3=tau_rtm & ref_rtm3=ref_rtm & wp_rtm3=wp_rtm
  nans2=where(wp_rtm2 eq 1.,ct2)
  nans3=where(wp_rtm3 eq 1.,ct3)
  nans1=where(wp_rtm1 eq 1.,ct1)
  ;if ct1 gt 0 then begin
  ;  tau_rtm1[nans1]=!values.f_nan
  ;  ref_rtm1[nans1]=!values.f_nan
  ;endif
  if ct2 gt 0 then begin
    tau_rtm2[nans2]=!values.f_nan
    ref_rtm2[nans2]=!values.f_nan
  endif
  if ct3 gt 0 then begin
    tau_rtm3[nans3]=!values.f_nan
    ref_rtm3[nans3]=!values.f_nan
  endif
  ref_rtm2=ref_rtm2+2.
  ref_rtm3=ref_rtm3+2.
  nans1=where(ref_rtm1 le 2.,ct1)
  nans2=where(ref_rtm2 le 2.,ct2)
  nans3=where(ref_rtm3 le 2.,ct3)
  if ct1 gt 0 then begin
    tau_rtm1[nans1]=!values.f_nan
    ref_rtm1[nans1]=!values.f_nan
  endif
  if ct2 gt 0 then begin
    tau_rtm2[nans2]=!values.f_nan
    ref_rtm2[nans2]=!values.f_nan
  endif
  if ct3 gt 0 then begin
    tau_rtm3[nans3]=!values.f_nan
    ref_rtm3[nans3]=!values.f_nan
  endif
  ;mean
  hi_stat[p,0]=mean(tau_rtm1,/nan) & hm_stat[p,0]=mean(tau_rtm2,/nan)
  hc_stat[p,0]=mean(tau_rtm3,/nan)
  ;stddev
  hi_stat[p,1]=stddev(tau_rtm1,/nan) & hm_stat[p,1]=stddev(tau_rtm2,/nan)
  hc_stat[p,1]=stddev(tau_rtm3,/nan)
  ;min
  hi_stat[p,2]=min(tau_rtm1,/nan) & hm_stat[p,2]=min(tau_rtm2,/nan)
  hc_stat[p,2]=min(tau_rtm3,/nan)
  ;max
  hi_stat[p,3]=max(tau_rtm1,/nan) & hm_stat[p,3]=max(tau_rtm2,/nan)
  hc_stat[p,3]=max(tau_rtm3,/nan)
  ;25th and 75th percentile
  fhi=where(finite(tau_rtm1) eq 1,cfi)
  if cfi lt 1 then fhi=[0,1]
  hhi=tau_rtm1[sort(tau_rtm1[fhi])]
  inhi=n_elements(hhi)/2
  hi_stat[p,4]=median(hhi[0:inhi-1],/even)
  hi_stat[p,5]=median(hhi[inhi:*],/even) 
  fhm=where(finite(tau_rtm2) eq 1,cfm)
  if cfm lt 1 then fhm=[0,1]
  hhm=tau_rtm2[sort(tau_rtm2[fhm])]
  inhm=n_elements(hhm)/2
  hm_stat[p,4]=median(hhm[0:inhm-1],/even)
  hm_stat[p,5]=median(hhm[inhm:*],/even)
  fhc=where(finite(tau_rtm3) eq 1,cfc)
  if cfc lt 1 then fhc=[0,1]
  hhc=tau_rtm3[sort(tau_rtm3[fhc])]
  inhc=n_elements(hhc)/2
  hc_stat[p,4]=median(hhc[0:inhc-1],/even)
  hc_stat[p,5]=median(hhc[inhc:*],/even) 
  ;median
  hi_stat[p,6]=median(tau_rtm1[fhi])
  hm_stat[p,6]=median(tau_rtm2[fhm])
  hc_stat[p,6]=median(tau_rtm3[fhc]) 
  ;mean
  hir_stat[p,0]=mean(ref_rtm1,/nan) & hmr_stat[p,0]=mean(ref_rtm2,/nan)
  hcr_stat[p,0]=mean(ref_rtm3,/nan)
  ;stddev
  hir_stat[p,1]=stddev(ref_rtm1,/nan) & hmr_stat[p,1]=stddev(ref_rtm2,/nan)
  hcr_stat[p,1]=stddev(ref_rtm3,/nan)
  ;min
  hir_stat[p,2]=min(ref_rtm1,/nan) & hmr_stat[p,2]=min(ref_rtm2,/nan)
  hcr_stat[p,2]=min(ref_rtm3,/nan)
  ;max
  hir_stat[p,3]=max(ref_rtm1,/nan) & hmr_stat[p,3]=max(ref_rtm2,/nan)
  hcr_stat[p,3]=max(ref_rtm3,/nan)
  ;25th and 75th percentile
  hhir=ref_rtm1[sort(ref_rtm1[fhi])]
  inhir=n_elements(hhir)/2
  hir_stat[p,4]=median(hhir[0:inhir-1],/even)
  hir_stat[p,5]=median(hhir[inhir:*],/even)
  hhmr=ref_rtm2[sort(ref_rtm2[fhm])]
  inhmr=n_elements(hhmr)/2
  hmr_stat[p,4]=median(hhmr[0:inhmr-1],/even)
  hmr_stat[p,5]=median(hhmr[inhmr:*],/even)
  hhcr=ref_rtm3[sort(ref_rtm3[fhc])]
  inhcr=n_elements(hhcr)/2
  hcr_stat[p,4]=median(hhcr[0:inhcr-1],/even)
  hcr_stat[p,5]=median(hhcr[inhcr:*],/even)
  ;median
  hir_stat[p,6]=median(ref_rtm1[fhi])
  hmr_stat[p,6]=median(ref_rtm2[fhm])
  hcr_stat[p,6]=median(ref_rtm3[fhc])
  ; phase
  nul=where(wp_rtm1 eq 1.,ct1) & nul=where(wp_rtm2 eq 1., ct2) & nul=where(wp_rtm3 eq 1., ct3) 
  wpi_stat[p]=float(ct1)/float(n_elements(wp_rtm1))*100.
  wpm_stat[p]=float(ct2)/float(n_elements(wp_rtm2))*100.
  wpc_stat[p]=float(ct3)/float(n_elements(wp_rtm3))*100.
endfor
;endif

; sample pwhisker plotting
;if 0 then begin
  fp=dir+'comp_retr'
  print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=43, ysize=40
   !p.font=1 & !p.thick=5 & !p.charsize=4.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,1,3] & !x.margin=[6,16] & !y.margin=[3,3] & !p.symsize=1.5

;tvlct,225,90,90,253
;tvlct,90,225,90,133
;tvlct,90,90,225,40
tvlct, 150,0,150,40
tvlct, 150,170,0,253
tvlct, 255,125,0,133
;stop
usersym, [ -1, 1, 1, -1, -1 ,1], [ 1, 1, -1, -1, 1 ,1], /fill
  plot, findgen(nlbl)+1, hi_stat[*,0],psym=2, xtickname=lbls, title='Comparison of retrieved values from different methods',$
   ytitle='Optical depth',xticks=nlbl-1,yrange=[0,200],xrange=[1,nlbl],/nodata,xstyle=3,ymargin=[0,3],xtickformat='(A1)'
  plots,[0.7,11.3],[0,0],thick=2,linestyle=2
  for p=0, nlbl-1 do begin
    plots, [p+0.83,p+0.83],[hi_stat[p,2],hi_stat[p,3]],thick=5,color=40
    plots, [p+0.83,p+0.83],[hi_stat[p,4],hi_stat[p,5]],thick=45,color=40
    plots, p+0.83,hi_stat[p,0],psym=1
    plots, p+0.83,hi_stat[p,6],psym=6
    plots, [p+1,p+1],[hm_stat[p,2],hm_stat[p,3]],thick=5 ,color=253
    plots, [p+1,p+1],[hm_stat[p,4],hm_stat[p,5]],thick=45,color=253
    plots, p+1,hm_stat[p,0],psym=1
    plots, p+1,hm_stat[p,6],psym=6
    plots, [p+1.17,p+1.17],[hc_stat[p,2],hc_stat[p,3]],thick=5 ,color=133
    plots, [p+1.17,p+1.17],[hc_stat[p,4],hc_stat[p,5]],thick=45,color=133
    plots, p+1.17,hc_stat[p,0],psym=1
    plots, p+1.17,hc_stat[p,6],psym=6
  endfor
  y_ch_size = !p.charsize * float(!d.y_ch_size) / !d.y_vsize
  x_ch_size = !p.charsize * float(!d.x_ch_size) / !d.x_vsize
  xyouts,!x.s[0]+!x.s[1]*(findgen(nlbl)+1)+0.5*x_ch_size,!y.window[0]-0.5*y_ch_size,/norm,lbls,align=1.0,$
   orientation=45,charsize=2
  legend,['Multi-parameter','Slope','2 wavelengths','Mean','Median'],box=0,pspacing=1,psym=[8,8,8,1,6],$
   textcolors=[40,253,133,0,0],position=[11.4,150],color=[40,253,133,0,0],charsize=2.3,/fill
  tvlct,100,100,100,201
  legend,['25!Uth!N - 75!Uth!N percentile','Min - Max'],box=0, charsize=2.3,linestyle=[0,0],thick=[45,5],$
   pspacing=1.25,position=[11.1,40],color=[201,201]
  
  plot, findgen(nlbl)+1,wpi_stat,psym=2, ytitle='Liquid water proportion (%)',xtickname=lbls,$
   xticks=nlbl-1,yrange=[0,100],xrange=[1,nlbl],/nodata,xstyle=3,ymargin=[4.5,4.5],xtickformat='(A1)'
  for p=0, nlbl-1 do begin
    plots,[p+0.83,p+0.83],[0,100.-wpi_stat[p]],color=40,thick=45
    plots,[p+1,p+1],[0,100.-wpm_stat[p]],color=253,thick=45
    plots,[p+1.17,p+1.17],[0,100.-wpc_stat[p]],color=133,thick=45
  endfor 
  y_ch_size = !p.charsize * float(!d.y_ch_size) / !d.y_vsize
  x_ch_size = !p.charsize * float(!d.x_ch_size) / !d.x_vsize
  xyouts,!x.s[0]+!x.s[1]*(findgen(nlbl)+1)+0.5*x_ch_size,!y.window[0]-0.5*y_ch_size,/norm,lbls,align=1.0,$
   orientation=45,charsize=2 

 
  plot, findgen(nlbl)+1,hir_stat[*,0],psym=2,ymargin=[5,0],xtickname=lbls,$
   ytitle='Effective radius (!9m!Xm)',xticks=nlbl-1,yrange=[0,50],xrange=[1,nlbl],/nodata,xstyle=3,xtickformat='(A1)'; ,ystyle=9
  plots,[0.7,11.3],[0,0],thick=2,linestyle=2
  for p=0, nlbl-1 do begin 
    plots, [p+0.83,p+0.83],[hir_stat[p,2],hir_stat[p,3]],thick=5,color=40
    plots, [p+0.83,p+0.83],[hir_stat[p,4],hir_stat[p,5]],thick=45,color=40
    plots, p+0.83,hir_stat[p,0],psym=1
    plots, p+0.83,hir_stat[p,6],psym=6
    plots, [p+1,p+1],[hmr_stat[p,2],hmr_stat[p,3]],thick=5 ,color=253
    plots, [p+1,p+1],[hmr_stat[p,4],hmr_stat[p,5]],thick=45,color=253
    plots, p+1,hmr_stat[p,0],psym=1
    plots, p+1,hmr_stat[p,6],psym=6
    plots, [p+1.17,p+1.17],[hcr_stat[p,2],hcr_stat[p,3]],thick=5 ,color=133
    plots, [p+1.17,p+1.17],[hcr_stat[p,4],hcr_stat[p,5]],thick=45,color=133
    plots, p+1.17,hcr_stat[p,0],psym=1
    plots, p+1.17,hcr_stat[p,6],psym=6
  endfor 
    y_ch_size = !p.charsize * float(!d.y_ch_size) / !d.y_vsize 
  x_ch_size = !p.charsize * float(!d.x_ch_size) / !d.x_vsize 
  xyouts,!x.s[0]+!x.s[1]*(findgen(nlbl)+1)+0.5*x_ch_size,!y.window[0]-0.5*y_ch_size,/norm,lbls,align=1.0,$
   orientation=45,charsize=2
 ; axis, yaxis=1, yrange=[0,100],ytitle='Ice water proportion (%)',/save
 ; a=findgen(17)*(!PI*2./16.)
 ; usersym,cos(a),sin(a)
  ;for p=0,nlbl-1 do begin
  ;  usersym,cos(a),sin(a),/fill
  ;  plots, p+0.83, wpi_stat[p],psym=8,symsize=1.8, color=40
  ;  plots, p+1, wpm_stat[p], psym=8, symsize=1.8, color=253
  ;  plots, p+1.17, wpc_stat[p],psym=8, symsize=1.8, color=133
  ;  usersym,cos(a),sin(a)
  ;  plots, p+0.83, wpi_stat[p],psym=8,symsize=2.2,thick=8
  ;  plots, p+1, wpm_stat[p], psym=8, symsize=2.2, thick=8
  ;  plots, p+1.17, wpc_stat[p],psym=8, symsize=2.2, thick=8
  ;endfor
  device, /close
  spawn, 'convert "'+fp+'.ps" "'+fp+'.png"'
endif

; now plot a single example of a time trace comparison
;for p=0, n_elements(lbls)-1 do begin  ; for the lbls
p=1
  restore, dir+'retrieved_pdf_'+lbls[p]+'.out'
  tau_rtm1=tau_rtm & ref_rtm1=ref_rtm & wp_rtm1=wp_rtm & tau_err1=tau_err & ref_err1=ref_err & wp_err1=wp_err
  restore, dir+'retrieved_pdf_'+lbls[p]+'_pat.out'
  tau_rtm2=tau_rtm & ref_rtm2=ref_rtm & wp_rtm2=wp_rtm & tau_err2=tau_err & ref_err2=ref_err & wp_err2=wp_err
  restore, dir+'retrieved_pdf_'+lbls[p]+'_2wvl.out'
  tau_rtm3=tau_rtm & ref_rtm3=ref_rtm & wp_rtm3=wp_rtm & tau_err3=tau_err & ref_err3=ref_err & wp_err3=wp_err

  nans2=where(wp_rtm2 eq 1.,ct2)
  nans3=where(wp_rtm3 eq 1.,ct3)
  if ct2 gt 0 then begin
    tau_rtm2[nans2]=!values.f_nan
    ref_rtm2[nans2]=!values.f_nan
  endif
  if ct3 gt 0 then begin
    tau_rtm3[nans3]=!values.f_nan
    ref_rtm3[nans3]=!values.f_nan
  endif
  ref_rtm2=ref_rtm2+2.
  ref_rtm3=ref_rtm3+2.
  ref_err2=ref_err2+2.
  ref_err3=ref_err3+2.
  nans1=where(ref_rtm1 le 2.,ct1)
  nans2=where(ref_rtm2 le 2.,ct2)
  nans3=where(ref_rtm3 le 2.,ct3)
  if ct1 gt 0 then begin
    tau_rtm1[nans1]=!values.f_nan
    ref_rtm1[nans1]=!values.f_nan
  endif
  if ct2 gt 0 then begin
    tau_rtm2[nans2]=!values.f_nan
    ref_rtm2[nans2]=!values.f_nan
  endif
  if ct3 gt 0 then begin
    tau_rtm3[nans3]=!values.f_nan
    ref_rtm3[nans3]=!values.f_nan
  endif
  fhi=where(finite(tau_rtm1) eq 1)
  fhm=where(finite(tau_rtm2) eq 1)
  fhc=where(finite(tau_rtm3) eq 1)

if 1 then begin
  fp=dir+'tmhrs_comp_'+lbls[p]
  print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=30, ysize=40
   !p.font=1 & !p.thick=5 & !p.charsize=4.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,1,3] & !x.margin=[6,3] & !y.margin=[3,1] & !p.symsize=1.5
  tvlct,225,90,90,253 
  tvlct,90,225,90,133 
  tvlct,90,90,225,40
tvlct, 150,0,150,40
tvlct, 150,170,0,253
tvlct, 255,125,0,153


  
  plot, tmhrs, tau_rtm1, /nodata, xtitle='UTC (H)',ytitle='Optical depth',yrange=[0,160],ymargin=[-2,1]
  oplot, tmhrs[fhi],tau_rtm1[fhi], psym=-4, color=40
  errplot, tmhrs[fhi],tau_err1[0,fhi],tau_err1[1,fhi],color=40
  oplot, tmhrs[fhm],tau_rtm2[fhm], psym=-1, color=253
  errplot, tmhrs[fhm],tau_err2[0,fhm],tau_err2[1,fhm],color=253
  oplot, tmhrs[fhc],tau_rtm3[fhc], psym=-5, color=153
  errplot, tmhrs[fhc],tau_err3[0,fhc],tau_err3[1,fhc],color=153
  
  plot, tmhrs, wp_err1, /nodata, xtitle='UTC (H)', ytitle='Liquid water propability (%)', yrange=[0,100],ymargin=[6,6]
  oplot,tmhrs[fhi], 100.-wp_err1[fhi]*100., psym=-4, color=40
  oplot,tmhrs[fhm], 100.-wp_err2[fhm]*100., psym=-1, color=253
  oplot,tmhrs[fhc], 100.-wp_err3[fhc]*100., psym=-5, color=153

  plot, tmhrs, ref_rtm1, /nodata, xtitle='UTC (H)',ytitle='Effective radius (!9m!Xm)',yrange=[0,25],ymargin=[3,-2]
  oplot, tmhrs[fhi],ref_rtm1[fhi], psym=-4, color=40
  errplot, tmhrs[fhi],ref_err1[0,fhi],ref_err1[1,fhi],color=40
  oplot, tmhrs[fhm],ref_rtm2[fhm], psym=-1, color=253
  errplot, tmhrs[fhm],ref_err2[0,fhm],ref_err2[1,fhm],color=253
  oplot, tmhrs[fhc],ref_rtm3[fhc], psym=-5, color=153
  errplot, tmhrs[fhc],ref_err3[0,fhc],ref_err3[1,fhc],color=153
  legend,['Multi-parameter','Slope','2-Wavelengths'],textcolors=[40,253,153],box=0,charsize=2.2

  device, /close
  spawn, 'convert "'+fp+'.ps" "'+fp+'.png"'
  
endif
;if p eq 1 then stop
;endfor

stop
end
