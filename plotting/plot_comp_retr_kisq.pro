; program to plot the comparison of the retrieved optical depth, effective radius and phase 
; for the parameter method, pat's method, and two wavelength method.
; this makes a whisker-box type plot ... needs work and update
; also plots a single day example of the retrieved time trace comparison between these various retrievals

pro plot_comp_retr_kisq

bias=0
twelve=0
win=1


if win then dir='/argus/roof/SSFR3/retrieved/' else $ ;'/home/leblanc/SSFR3/data/'
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
hi_stat=fltarr(nlbl,7) ;for tau - multi ice ;mean, std, min, max ,25th perentile, 75th percentile, median, for tau - parameters
hl_stat=fltarr(nlbl,7) ;for tau - multi liquid
hm_stat=fltarr(nlbl,7) ;for tau - pat's
hc_stat=fltarr(nlbl,7) ;for tau - 2wvl
hd_stat=fltarr(nlbl,7) ;for tau - 2wvl 1227nm
hir_stat=fltarr(nlbl,7) ;mean, std, min, max ,25th perentile, 75th percentile, median, for ref - parameters 
hlr_stat=fltarr(nlbl,7) ;for ref - multi liquid
hmr_stat=fltarr(nlbl,7) ;for ref - pat's 
hcr_stat=fltarr(nlbl,7) ;for ref - 2wvl
hdr_stat=fltarr(nlbl,7) ;for ref - 2wvl 1227nm
wpi_stat=fltarr(nlbl)  ;for percent of ice phase
wpm_stat=fltarr(nlbl)
wpc_stat=fltarr(nlbl) 

; for kisq
hk_stat=fltarr(nlbl,7)
hki_stat=fltarr(nlbl,7)
hkr_stat=fltarr(nlbl,7)
hkir_stat=fltarr(nlbl,7)
wk_stat=fltarr(nlbl)

for p=0, nlbl-1 do begin
  restore, dir+'retrieved_pdf_'+lbls[p]+'_limp2_v4.out' ;'_limp.out'
  ;restore, dir+'retrieved_kisq_'+lbls[p]+'.out'
;  tau_rtm1=tau_rtm & ref_rtm1=ref_rtm & wp_rtm1=wp_rtm & tau_rtmi=tau_rtm & ref_rtmi=ref_rtm
  if bias then begin
    ; bias correct the results
    print, 'bias correcting the retrieved values'
    restore, '/home/leblanc/SSFR3/data/bias.out'
    for i=0, n_elements(tmhrs)-1 do begin
      nul=min(abs(tau_rtm[i]-tau),nt)
      nul=min(abs(ref_rtm[i]-ref),nr)
      nw=fix(wp_rtm[i])
      tau_rtm[i]=tau_rtm[i]-taubb[nt,nr,nw]
      if tau_rtm[i] ge 100 then tau_rtm[i]=100.
      ref_rtm[i]=ref_rtm[i]-refbb[nt,nr,nw]
    endfor
  endif
  tau_rtm1=tau_rtm & ref_rtm1=ref_rtm & wp_rtm1=wp_rtm & tau_rtmi=tau_rtm & ref_rtmi=ref_rtm & wp_err1=wp_err

  print, 'tau:', mean(tau_rtm,/nan),'ref:',mean(ref_rtm,/nan),'par',p
  restore, dir+'retrieved_'+lbls[p]+'_pat.out'
  tau_rtm2=tau_rtm/2. & ref_rtm2=ref_rtm & wp_rtm2=wp_rtm
  restore, dir+'retrieved_'+lbls[p]+'_2wvl.out'
  tau_rtm3=tau_rtm/2. & ref_rtm3=ref_rtm & wp_rtm3=wp_rtm
  restore, dir+'retrieved_'+lbls[p]+'_2wvl_1227nm.out'
  tau_rtm4=tau_rtm & ref_rtm4=ref_rtm & wp_rtm4=wp_rtm
  restore, dir+'retrieved_kisq_'+lbls[p]+'.out'
  tau_rtmk=tau_rtm & ref_rtmk=ref_rtm & wp_rtmk=wp_rtm & tau_rtmki=tau_rtm & ref_rtmki=ref_rtm

  nans1=where(ref_rtm1 le 2. or ref_rtm1 ge 49.,ct1)
  nans2=where(ref_rtm2 le 2. or ref_rtm2 ge 49.,ct2)
  nans3=where(ref_rtm3 le 2. or ref_rtm3 ge 49.,ct3)
  nans4=where(ref_rtm4 le 2. or ref_rtm4 ge 49.,ct4)
  nani1=where(ref_rtmi le 5. or ref_rtmi ge 49.,ci1)
  nansk=where(ref_rtmk le 2. or ref_rtmk ge 49.,ctk)

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
  if ci1 gt 0 then begin
    tau_rtmi[nani1]=!values.f_nan
    ref_rtmi[nani1]=!values.f_nan  
  endif
  if ct4 gt 0 then begin
    tau_rtm4[nans4]=!values.f_nan
    ref_rtm4[nans4]=!values.f_nan
  endif  
  if ctk gt 0 then begin
    tau_rtmk[nansk]=!values.f_nan & tau_rtmki[nansk]=!values.f_nan
    ref_rtmk[nansk]=!values.f_nan & ref_rtmki[nansk]=!values.f_nan
  endif

  nans1=where(tau_rtm1 le 1. or tau_rtm1 ge 98.,ct1)
  nans2=where(tau_rtm2 le 1. or tau_rtm2 ge 98.,ct2)
  nans3=where(tau_rtm3 le 1. or tau_rtm3 ge 96.,ct3)
  nans4=where(tau_rtm4 le 1. or tau_rtm4 ge 96.,ct3)
  nani1=where(tau_rtmi le 1. or tau_rtmi ge 98.,ci1)
  nansk=where(tau_rtmk le 1. or tau_rtmk ge 98.,ctk)
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
  if ct4 gt 0 then begin
    tau_rtm4[nans4]=!values.f_nan
    ref_rtm4[nans4]=!values.f_nan
  endif
  if ci1 gt 0 then begin
    tau_rtmi[nani1]=!values.f_nan
    ref_rtmi[nani1]=!values.f_nan
  endif
  if ctk gt 0 then begin
    tau_rtmk[nansk]=!values.f_nan & tau_rtmki[nansk]=!values.f_nan
    ref_rtmk[nansk]=!values.f_nan & ref_rtmki[nansk]=!values.f_nan
  endif 

  nanss=where(wp_err1 ge 0.3 and wp_err1 le 0.7,cwi)  
  if cwi gt 0 then begin
    tau_rtm1[nanss]=!values.f_nan & ref_rtm1[nanss]=!values.f_nan & tau_rtm2[nanss]=!values.f_nan & ref_rtm2[nanss]=!values.f_nan
    tau_rtmi[nanss]=!values.f_nan & ref_rtmi[nanss]=!values.f_nan & tau_rtm3[nanss]=!values.f_nan & ref_rtm3[nanss]=!values.f_nan
    tau_rtm4[nanss]=!values.f_nan & ref_rtm4[nanss]=!values.f_nan
  endif
  fhl2=where(finite(tau_rtm1) eq 1,ctl2) & fhm2=where(finite(tau_rtm2) eq 1, ctm2) & fhc2=where(finite(tau_rtm3) eq 1, ctc2) & fhd2=where(finite(tau_rtm4) eq 1,ctd2)
  fhk2=where(finite(tau_rtmk) eq 1,ctk2)

;  nans2=where(wp_rtm2 eq 1.,ct2) 
;  nans3=where(wp_rtm3 eq 1.,ct3)
  nans1=where(wp_rtm1 eq 1. or finite(wp_rtm1) eq 0  ,ct1)
  if ct1 gt 0 then begin
    tau_rtm1[nans1]=!values.f_nan & ref_rtm1[nans1]=!values.f_nan
    tau_rtm2[nans1]=!values.f_nan & ref_rtm2[nans1]=!values.f_nan
    tau_rtm3[nans1]=!values.f_nan & ref_rtm3[nans1]=!values.f_nan
    tau_rtm4[nans1]=!values.f_nan & ref_rtm4[nans1]=!values.f_nan
  endif
  nsk=where(wp_rtmk eq 1.,ctk)
  if ctk gt 0 then begin
    tau_rtmk[nsk]=!values.f_nan & ref_rtmk[nsk]=!values.f_nan
  endif
  nski=where(wp_rtmk eq 0., ctki)
  if ctki gt 0 then begin
    tau_rtmki[nski]=!values.f_nan & ref_rtmki[nski]=!values.f_nan
  endif
  nani1=where(wp_rtm1 eq 0., ci1)
  if ci1 gt 0 then begin
    tau_rtmi[nani1]=!values.f_nan & ref_rtmi[nani1]=!values.f_nan
  endif

  ;mean
  hi_stat[p,0]=mean(tau_rtmi,/nan) & hl_stat[p,0]=mean(tau_rtm1,/nan) & hk_stat[p,0]=mean(tau_rtmk,/nan) & hki_stat[p,0]=mean(tau_rtmki,/nan)
  hc_stat[p,0]=mean(tau_rtm3,/nan) & hm_stat[p,0]=mean(tau_rtm2,/nan) & hd_stat[p,0]=mean(tau_rtm4,/nan)
  ;stddev
  hi_stat[p,1]=stddev(tau_rtmi,/nan) & hl_stat[p,1]=stddev(tau_rtm1,/nan) & hk_stat[p,1]=stddev(tau_rtmk,/nan) & hki_stat[p,1]=stddev(tau_rtmki,/nan)
  hc_stat[p,1]=stddev(tau_rtm3,/nan) & hm_stat[p,1]=stddev(tau_rtm2,/nan) & hd_stat[p,1]=stddev(tau_rtm4,/nan)
  ;min
  hi_stat[p,2]=min(tau_rtmi,/nan) & hl_stat[p,2]=min(tau_rtm1,/nan) & hk_stat[p,2]=min(tau_rtmk,/nan) & hki_stat[p,2]=min(tau_rtmki,/nan)
  hc_stat[p,2]=min(tau_rtm3,/nan) & hm_stat[p,2]=min(tau_rtm2,/nan) & hd_stat[p,2]=min(tau_rtm4,/nan)
  ;max
  hi_stat[p,3]=max(tau_rtmi,/nan) & hl_stat[p,3]=max(tau_rtm1,/nan) & hk_stat[p,3]=max(tau_rtmk,/nan) & hki_stat[p,3]=max(tau_rtmki,/nan)
  hc_stat[p,3]=max(tau_rtm3,/nan) & hm_stat[p,3]=max(tau_rtm2,/nan) & hd_stat[p,3]=max(tau_rtm4,/nan)
  ;25th and 75th percentile
  fhi=where(finite(tau_rtmi) eq 1,cfi)
  if cfi lt 1 then fhi=[0,1]
  hhi=tau_rtmi[fhi[sort(tau_rtmi[fhi])]]
  inhi=n_elements(hhi)/2
  hi_stat[p,4]=median(hhi[0:inhi-1],/even) & hi_stat[p,5]=median(hhi[inhi:*],/even) 
  fhl=where(finite(tau_rtm1) eq 1,cfl)
  if cfl lt 1 then fhl=[0,1]
  hhl=tau_rtm1[fhl[sort(tau_rtm1[fhl])]]
  inhl=n_elements(hhl)/2
  hl_stat[p,4]=median(hhl[0:inhl-1],/even) & hl_stat[p,5]=median(hhl[inhl:*],/even)
  fhm=where(finite(tau_rtm2) eq 1,cfm)
  if cfm lt 1 then fhm=[0,1]
  hhm=tau_rtm2[fhm[sort(tau_rtm2[fhm])]]
  inhm=n_elements(hhm)/2
  hm_stat[p,4]=median(hhm[0:inhm-1],/even) & hm_stat[p,5]=median(hhm[inhm:*],/even)
  fhc=where(finite(tau_rtm3) eq 1,cfc)
  if cfc lt 1 then fhc=[0,1]
  hhc=tau_rtm3[fhc[sort(tau_rtm3[fhc])]]
  inhc=n_elements(hhc)/2
  hc_stat[p,4]=median(hhc[0:inhc-1],/even) & hc_stat[p,5]=median(hhc[inhc:*],/even) 
  fhd=where(finite(tau_rtm4) eq 1,cfd)
  if cfd lt 1 then fhd=[0,1]
  hhd=tau_rtm4[fhd[sort(tau_rtm4[fhd])]]
  inhd=n_elements(hhd)/2
  hd_stat[p,4]=median(hhd[0:inhd-1],/even) & hd_stat[p,5]=median(hhd[inhd:*],/even)
  fhk=where(finite(tau_rtmk) eq 1,cfk)
  if cfk lt 1 then fhk=[0,1]
  hhk=tau_rtmk[fhk[sort(tau_rtmk[fhk])]]
  inhk=n_elements(hhk)/2
  hk_stat[p,4]=median(hhk[0:inhk-1],/even) & hk_stat[p,5]=median(hhk[inhk:*],/even) 
  fhki=where(finite(tau_rtmki) eq 1,cfki)
  if cfki lt 1 then fhki=[0,1]
  hhki=tau_rtmki[fhki[sort(tau_rtmki[fhki])]]
  inhki=n_elements(hhki)/2
  hki_stat[p,4]=median(hhki[0:inhki-1],/even) & hki_stat[p,5]=median(hhki[inhki:*],/even)

  ;median
  hi_stat[p,6]=median(tau_rtmi[fhi]) & hl_stat[p,6]=median(tau_rtm1[fhl])
  hm_stat[p,6]=median(tau_rtm2[fhm]) & hd_stat[p,6]=median(tau_rtm4[fhd])
  hc_stat[p,6]=median(tau_rtm3[fhc]) & hk_stat[p,6]=median(tau_rtmk[fhk]) & hki_stat[p,6]=median(tau_rtmki[fhki])
 
  ;mean
  hir_stat[p,0]=mean(ref_rtmi,/nan) & hlr_stat[p,0]=mean(ref_rtm1,/nan) & hkr_stat[p,0]=mean(ref_rtmk,/nan) & hkir_stat[p,0]=mean(ref_rtmki,/nan)
  hcr_stat[p,0]=mean(ref_rtm3,/nan) & hmr_stat[p,0]=mean(ref_rtm2,/nan) & hdr_stat[p,0]=mean(ref_rtm4,/nan)
  ;stddev
  hir_stat[p,1]=stddev(ref_rtmi,/nan) & hlr_stat[p,1]=stddev(ref_rtm1,/nan) & hkr_stat[p,1]=stddev(ref_rtmk,/nan) & hkir_stat[p,1]=stddev(ref_rtmki,/nan)_
  hcr_stat[p,1]=stddev(ref_rtm3,/nan) & hmr_stat[p,1]=stddev(ref_rtm2,/nan) & hdr_stat[p,1]=stddev(ref_rtm4,/nan)
  ;min
  hir_stat[p,2]=min(ref_rtmi,/nan) & hlr_stat[p,2]=min(ref_rtm1,/nan) & hkr_stat[p,2]=min(ref_rtmk,/nan) & hkir_stat[p,2]=min(ref_rtmki,/nan)
  hcr_stat[p,2]=min(ref_rtm3,/nan) & hmr_stat[p,2]=min(ref_rtm2,/nan) & hdr_stat[p,2]=min(ref_rtm4,/nan)
  ;max
  hir_stat[p,3]=max(ref_rtmi,/nan) & hlr_stat[p,3]=max(ref_rtm1,/nan) & hkr_stat[p,3]=max(ref_rtmk,/nan) & hkir_stat[p,3]=max(ref_rtmki,/nan)
  hcr_stat[p,3]=max(ref_rtm3,/nan) & hmr_stat[p,3]=max(ref_rtm2,/nan) & hdr_stat[p,3]=max(ref_rtm4,/nan)
  ;25th and 75th percentile
  hhir=ref_rtmi[fhi[sort(ref_rtm1[fhi])]]
  inhir=n_elements(hhir)/2
  hir_stat[p,4]=median(hhir[0:inhir-1]);,/even)
  hir_stat[p,5]=median(hhir[inhir:*]);,/even)
  hhlr=ref_rtm1[fhl[sort(ref_rtm1[fhl])]]
  inhlr=n_elements(hhlr)/2 
  hlr_stat[p,4]=median(hhlr[0:inhlr-1],/even)
  hlr_stat[p,5]=median(hhlr[inhlr:*],/even)
  hhmr=ref_rtm2[fhm[sort(ref_rtm2[fhm])]]
  inhmr=n_elements(hhmr)/2
  hmr_stat[p,4]=median(hhmr[0:inhmr-1],/even)
  hmr_stat[p,5]=median(hhmr[inhmr:*],/even)
  hhcr=ref_rtm3[fhc[sort(ref_rtm3[fhc])]]
  inhcr=n_elements(hhcr)/2
  hcr_stat[p,4]=median(hhcr[0:inhcr-1],/even)
  hcr_stat[p,5]=median(hhcr[inhcr:*],/even)
  hhdr=ref_rtm4[fhd[sort(ref_rtm4[fhd])]]
  inhdr=n_elements(hhdr)/2
  hdr_stat[p,4]=median(hhdr[0:inhdr-1],/even)
  hdr_stat[p,5]=median(hhdr[inhdr:*],/even)
  hhkr=ref_rtmk[fhk[sort(ref_rtmk[fhk])]] 
  inhkr=n_elements(hhkr)/2 
  hkr_stat[p,4]=median(hhkr[0:inhkr-1],/even) 
  hkr_stat[p,5]=median(hhkr[inhkr:*],/even) 
  hhkir=ref_rtmki[fhki[sort(ref_rtmki[fhki])]] 
  inhkir=n_elements(hhkir)/2 
  hkir_stat[p,4]=median(hhkir[0:inhkir-1],/even) 
  hkir_stat[p,5]=median(hhkir[inhkir:*],/even) 
  ;median
  hir_stat[p,6]=median(ref_rtmi[fhi]) & hlr_stat[p,6]=median(ref_rtm1[fhl])
  hmr_stat[p,6]=median(ref_rtm2[fhm]) & hdr_stat[p,6]=median(ref_rtm4[fhd])
  hcr_stat[p,6]=median(ref_rtm3[fhc]) & hkr_stat[p,6]=median(ref_rtmk[fhk]) & hkir_stat[p,6]=median(ref_rtmki[fhki])
  if hir_stat[p,6] eq hir_stat[p,4] and hir_stat[p,4] le hir_stat[p,5] then hir_stat[p,4]=hir_stat[p,4]-1.
  if hir_stat[p,6] eq hir_stat[p,5] and hir_stat[p,5] ge hir_stat[p,4] then hir_stat[p,5]=hir_stat[p,5]+1.
  ; phase
  nul=where(wp_rtm1 eq 1.,ct1) & nul=where(wp_rtm2 eq 1., ct2) & nul=where(wp_rtm3 eq 1., ct3) 
;if p eq 1 or p eq 10 then  wpi_stat[p]=float(total(wp_rtm1[fhl2]))/float(n_elements(wp_rtm1[fhl2]))*100. else $
  wpi_stat[p]=float(ct1)/float(n_elements(wp_rtm1))*100.

  wpi_stat[p]=float(total(wp_rtm1,/nan))/float(total(finite(wp_rtm1)))*100.
  if p eq 0 or p eq 2 or p eq 5 or p eq 8 then wpi_stat[p]=float(ct1)/float(n_elements(wp_rtm1))*100.
  if p eq 10 then wpi_stat[p]=float(total(wp_rtm1[fhl2]))/float(n_elements(wp_rtm1[fhl2]))*100.
  wpi_stat[p]=total(finite(ref_rtmi),/nan)/(total(finite(ref_rtm1))+total(finite(ref_rtmi)))*100.
  wpm_stat[p]=float(total(wp_rtm1[fhl2]))/float(n_elements(wp_rtm1[fhl2]))*100.
  wpc_stat[p]=(total(finite(ref_rtm1))+total(finite(ref_rtmi)))/n_elements(ref_rtm1)*100. 
 ;stop
  ;wpm_stat[p]=float(ct2)/float(n_elements(wp_rtm2[fhm]))*100.
  ;wpc_stat[p]=float(ct3)/float(n_elements(wp_rtm3[fhc]))*100.
if p eq 10 then stop
; if p eq 2 then stop
endfor
;endif
; sample pwhisker plotting
;if 0 then begin
if bias then blbl='_bias' else blbl=''
if twelve then blbl=blbl+'_1200nm'
  fp=dir+'comp_retr_kisq'+blbl
  print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=43, ysize=40
   !p.font=1 & !p.thick=5 & !p.charsize=4.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,1,3] & !x.margin=[6,16.5] & !y.margin=[3,3] & !p.symsize=1.5

;tvlct,225,90,90,253
;tvlct,90,225,90,133
;tvlct,90,90,225,40
tvlct, 150,0,150,40
tvlct, 150,170,0,253
tvlct, 255,125,0,133
tvlct, 230,80,230,41

if twelve then dx=0.2 else dx=0.1
if twelve then ddx=0.1 else ddx=0.
tickv=findgen(11)+1.
;stop
usersym, [ -1, 1, 1, -1, -1 ,1], [ 1, 1, -1, -1, 1 ,1], /fill
  plot, findgen(nlbl)+1, hi_stat[*,0],psym=2, xtickname=lbls,$; title='Comparison of retrieved values from different methods',$
   ytitle='Optical thickness',xticks=nlbl-1,yrange=[0,100],xrange=[0.9-ddx,nlbl+dx],/nodata,xstyle=3,ymargin=[0,3],xtickformat='(A1)',xtickv=tickv
  ;plots,[0.7,11.3],[0,0],thick=2,linestyle=2
  for p=0, nlbl-1 do begin
   if not finite(hl_stat[p,2]) then begin
    plots, [p,p]+1.,[hi_stat[p,2],hi_stat[p,3]],thick=5,color=41
    plots, [p,p]+1.,[hi_stat[p,4],hi_stat[p,5]],thick=45,color=41
    plots, p+1.,hi_stat[p,0],psym=1
    plots, p+1.,hi_stat[p,6],psym=6
   endif else begin
   ;if not finite(hi_stat[p,2]) then ddx=ddx-0.1
    plots, [p+0.76,p+0.76]-ddx,[hi_stat[p,2],hi_stat[p,3]],thick=5,color=41
    plots, [p+0.76,p+0.76]-ddx,[hi_stat[p,4],hi_stat[p,5]],thick=45,color=41
    plots, p+0.76-ddx,hi_stat[p,0],psym=1
    plots, p+0.76-ddx,hi_stat[p,6],psym=6
    plots, [p+0.93,p+0.93]-ddx,[hl_stat[p,2],hl_stat[p,3]],thick=5,color=40
    plots, [p+0.93,p+0.93]-ddx,[hl_stat[p,4],hl_stat[p,5]],thick=45,color=40
    plots, p+0.93-ddx,hl_stat[p,0],psym=1
    plots, p+0.93-ddx,hl_stat[p,6],psym=6
    plots, [p+1.1,p+1.1]-ddx,[hm_stat[p,2],hm_stat[p,3]],thick=5 ,color=253
    plots, [p+1.1,p+1.1]-ddx,[hm_stat[p,4],hm_stat[p,5]],thick=45,color=253
    plots, p+1.1-ddx,hm_stat[p,0],psym=1
    plots, p+1.1-ddx,hm_stat[p,6],psym=6
    plots, [p+1.26,p+1.26]-ddx,[hc_stat[p,2],hc_stat[p,3]],thick=5 ,color=133
    plots, [p+1.26,p+1.26]-ddx,[hc_stat[p,4],hc_stat[p,5]],thick=45,color=133
    plots, p+1.26-ddx,hc_stat[p,0],psym=1
    plots, p+1.26-ddx,hc_stat[p,6],psym=6
    if twelve then begin
      plots, [p+1.33,p+1.33],[hd_stat[p,2],hd_stat[p,3]],thick=5 ,color=240
      plots, [p+1.33,p+1.33],[hd_stat[p,4],hd_stat[p,5]],thick=45,color=240
      plots, p+1.33,hd_stat[p,0],psym=1
      plots, p+1.33,hd_stat[p,6],psym=6
    endif
   endelse
  endfor
  y_ch_size = !p.charsize * float(!d.y_ch_size) / !d.y_vsize
  x_ch_size = !p.charsize * float(!d.x_ch_size) / !d.x_vsize
  xyouts,!x.s[0]+!x.s[1]*(findgen(nlbl)+1)+0.5*x_ch_size,!y.window[0]-0.5*y_ch_size,/norm,lbls,align=1.0,$
   orientation=45,charsize=2
if twelve then begin
  legend,['Multi-parameter(ice)','Multi-patameter(liquid)','Slope','2-wavelengths','   515 nm & 1628 nm','2-wavelengths','   515 nm & 1227 nm','Mean','Median'],box=0,pspacing=1,psym=[8,8,8,8,8,8,8,1,6],$
   textcolors=[41,40,253,133,133,240,240,0,0],position=[11.4,85],color=[41,40,253,133,255,240,255,0,0],charsize=2.3,/fill
tvlct,100,100,100,201
  legend,['25!Uth!N - 75!Uth!N percentile','Min - Max'],box=0, charsize=2.3,linestyle=[0,0],thick=[45,5],$
   pspacing=1.25,position=[11.22,15],color=[201,201]
endif else begin
  legend,['Multi-parameter(ice) !9c!X!U2!N','Multi-patameter(liquid) !9c!X!U2!N','Slope','2-wavelengths','Mean','Median'],box=0,pspacing=1,psym=[8,8,8,8,1,6],$
   textcolors=[41,40,253,133,0,0],position=[11.3,75],color=[41,40,253,133,0,0],charsize=2.3,/fill
tvlct,100,100,100,201
  legend,['25!Uth!N - 75!Uth!N percentile','Min - Max'],box=0, charsize=2.3,linestyle=[0,0],thick=[45,5],$
   pspacing=1.25,position=[11.12,20],color=[201,201]
endelse
  
  plot, findgen(nlbl)+1,wpi_stat,psym=2, ytitle='Solutions that are liquid water (%)',xtickname=lbls,$
   xticks=nlbl-1,yrange=[0,100],xrange=[0.9-ddx,nlbl+dx],/nodata,xstyle=3,ymargin=[4.5,4.5],xtickformat='(A1)',xtickv=tickv
  for p=0, nlbl-1 do begin
    plots,[p+1.,p+1.],[0,100.-wpi_stat[p]],color=40,thick=45
  ;  plots,[p+1,p+1],[0,100.-wpm_stat[p]],color=253,thick=45
  ;  plots,[p+1.17,p+1.17],[0,100.-wpc_stat[p]],color=133,thick=45
  endfor 
  y_ch_size = !p.charsize * float(!d.y_ch_size) / !d.y_vsize
  x_ch_size = !p.charsize * float(!d.x_ch_size) / !d.x_vsize
  xyouts,!x.s[0]+!x.s[1]*(findgen(nlbl)+1)+0.5*x_ch_size,!y.window[0]-0.5*y_ch_size,/norm,lbls,align=1.0,$
   orientation=45,charsize=2 

 
  plot, findgen(nlbl)+1,hir_stat[*,0],psym=2,ymargin=[5,0],xtickname=lbls,$
   ytitle='Effective radius (!9m!Xm)',xticks=nlbl-1,yrange=[0,50],xrange=[0.9-ddx,nlbl+dx],/nodata,xstyle=3,xtickformat='(A1)',xtickv=tickv; ,ystyle=9
  plots,[0.7,11.3],[0,0],thick=2,linestyle=2
  for p=0, nlbl-1 do begin 
    if not finite(hl_stat[p,2]) then begin
    plots, [p,p]+1.,[hir_stat[p,2],hir_stat[p,3]],thick=5,color=41
    plots, [p,p]+1.,[hir_stat[p,4],hir_stat[p,5]],thick=45,color=41
    plots, p+1.,hir_stat[p,0],psym=1
    plots, p+1.,hir_stat[p,6],psym=6
   endif else begin
   ;if not finite(hi_stat[p,2]) then ddx=ddx-0.1
    plots, [p+0.76,p+0.76]-ddx,[hir_stat[p,2],hir_stat[p,3]],thick=5,color=41
    plots, [p+0.76,p+0.76]-ddx,[hir_stat[p,4],hir_stat[p,5]],thick=45,color=41
    plots, p+0.76-ddx,hir_stat[p,0],psym=1
    plots, p+0.76-ddx,hir_stat[p,6],psym=6
    plots, [p+0.93,p+0.93]-ddx,[hlr_stat[p,2],hlr_stat[p,3]],thick=5,color=40
    plots, [p+0.93,p+0.93]-ddx,[hlr_stat[p,4],hlr_stat[p,5]],thick=45,color=40
    plots, p+0.93-ddx,hlr_stat[p,0],psym=1
    plots, p+0.93-ddx,hlr_stat[p,6],psym=6
    plots, [p+1.1,p+1.1]-ddx,[hmr_stat[p,2],hmr_stat[p,3]],thick=5 ,color=253
    plots, [p+1.1,p+1.1]-ddx,[hmr_stat[p,4],hmr_stat[p,5]],thick=45,color=253
    plots, p+1.1-ddx,hmr_stat[p,0],psym=1
    plots, p+1.1-ddx,hmr_stat[p,6],psym=6
    plots, [p+1.26,p+1.26]-ddx,[hcr_stat[p,2],hcr_stat[p,3]],thick=5 ,color=133
    plots, [p+1.26,p+1.26]-ddx,[hcr_stat[p,4],hcr_stat[p,5]],thick=45,color=133
    plots, p+1.26-ddx,hcr_stat[p,0],psym=1
    plots, p+1.26-ddx,hcr_stat[p,6],psym=6
    if twelve then begin
      plots, [p+1.33,p+1.33],[hdr_stat[p,2],hdr_stat[p,3]],thick=5 ,color=240
      plots, [p+1.33,p+1.33],[hdr_stat[p,4],hdr_stat[p,5]],thick=45,color=240
      plots, p+1.33,hdr_stat[p,0],psym=1
      plots, p+1.33,hdr_stat[p,6],psym=6
    endif
   endelse
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









stop



; now plot a single example of a time trace comparison
corr_t=fltarr(n_elements(lbls),2)
corr_r=corr_t
lin_t=corr_t
lin_r=corr_t
err_r=fltarr(n_elements(lbls),4)
err_t=fltarr(n_elements(lbls),4)
 
for p=0, n_elements(lbls)-1 do begin  ; for the lbls
;p=1
  restore, dir+'retrieved_pdf_'+lbls[p]+'_limp2_v4.out' ;'_limp.out'
  if bias then begin
    ; bias correct the results
    print, 'bias correcting the retrieved values'
    restore, '/home/leblanc/SSFR3/data/bias.out'
    for i=0, n_elements(tmhrs)-1 do begin
      nul=min(abs(tau_rtm[i]-tau),nt)
      nul=min(abs(ref_rtm[i]-ref),nr)
      nw=fix(wp_rtm[i])
      tau_rtm[i]=tau_rtm[i]-taubb[nt,nr,nw]
      ref_rtm[i]=ref_rtm[i]-refbb[nt,nr,nw]
      tau_err[*,i]=tau_err[*,i]-taubb[nt,nr,nw]
      ref_err[*,i]=ref_err[*,i]-refbb[nt,nr,nw]
    endfor
  endif
  tau_rtm1=tau_rtm & ref_rtm1=ref_rtm & wp_rtm1=wp_rtm & tau_err1=tau_err & ref_err1=ref_err & wp_err1=wp_err
  tau_rtmi=tau_rtm & ref_rtmi=ref_rtm & tau_erri=tau_err & ref_erri=ref_err
  wpe=where(finite(wp_rtm) ne 1,cw)
  if cw gt 0 then wp_err1[wpe]=!values.f_nan
  restore, dir+'retrieved_'+lbls[p]+'_pat.out' ;_sp20.out'
  tau_rtm2=tau_rtm/2. & ref_rtm2=ref_rtm & wp_rtm2=wp_rtm & tau_err2=tau_err/2. & ref_err2=ref_err & wp_err2=wp_err
  restore, dir+'retrieved_'+lbls[p]+'_2wvl.out' ;_sp20.out'
  tau_rtm3=tau_rtm/2. & ref_rtm3=ref_rtm & wp_rtm3=wp_rtm & tau_err3=tau_err/2. & ref_err3=ref_err & wp_err3=wp_err
  restore, dir+'retrieved_'+lbls[p]+'_2wvl_1227nm.out'
  tau_rtm4=tau_rtm & ref_rtm4=ref_rtm & wp_rtm4=wp_rtm & tau_err4=tau_err & ref_err4=ref_err & wp_err4=wp_err

  nanss=where(wp_err1 ge 0.3 and wp_err1 le 0.7,cwi)
  if cwi gt 0 then begin
    tau_rtm1[nanss]=!values.f_nan & ref_rtm1[nanss]=!values.f_nan & tau_rtm2[nanss]=!values.f_nan & ref_rtm2[nanss]=!values.f_nan
    tau_rtmi[nanss]=!values.f_nan & ref_rtmi[nanss]=!values.f_nan & tau_rtm3[nanss]=!values.f_nan & ref_rtm3[nanss]=!values.f_nan
    tau_rtm4[nanss]=!values.f_nan & ref_rtm4[nanss]=!values.f_nan
  endif
 
  nans1=where(ref_rtm1 le 2. or ref_rtm1 ge 49.,ct1)
  nans2=where(ref_rtm2 le 2. or ref_rtm2 ge 49.,ct2)
  nans3=where(ref_rtm3 le 2. or ref_rtm3 ge 49.,ct3)
  nans4=where(ref_rtm4 le 2. or ref_rtm4 ge 49.,ct4)
  nansi=where(ref_rtmi le 5. or ref_rtmi ge 49.,cti)
  if ct1 gt 0 then begin
    tau_rtm1[nans1]=!values.f_nan
    ref_rtm1[nans1]=!values.f_nan
    wp_err1[nans1]=!values.f_nan
  endif
  if ct2 gt 0 then begin
    tau_rtm2[nans2]=!values.f_nan
    ref_rtm2[nans2]=!values.f_nan
  endif
  if ct3 gt 0 then begin
    tau_rtm3[nans3]=!values.f_nan
    ref_rtm3[nans3]=!values.f_nan
  endif
  if ct4 gt 0 then begin
    tau_rtm4[nans4]=!values.f_nan
    ref_rtm4[nans4]=!values.f_nan
  endif  
  if cti gt 0 then begin
    tau_rtmi[nansi]=!values.f_nan
    ref_rtmi[nansi]=!values.f_nan
    wp_err1[nansi]=!values.f_nan
  endif
  nans1=where(tau_rtm1 le 1. or tau_rtm1 ge 98.,ct1)
  nans2=where(tau_rtm2 le 1. or tau_rtm2 ge 98.,ct2)
  nans3=where(tau_rtm3 le 1. or tau_rtm3 ge 96.,ct3)
  nans4=where(tau_rtm4 le 1. or tau_rtm4 ge 96.,ct4)
  nansi=where(tau_rtmi le 1. or tau_rtmi ge 98.,cti)
  if ct1 gt 0 then begin
    tau_rtm1[nans1]=!values.f_nan
    ref_rtm1[nans1]=!values.f_nan
    wp_err1[nans1]=!values.f_nan
  endif
  if ct2 gt 0 then begin
    tau_rtm2[nans2]=!values.f_nan
    ref_rtm2[nans2]=!values.f_nan
  endif
  if ct3 gt 0 then begin
    tau_rtm3[nans3]=!values.f_nan
    ref_rtm3[nans3]=!values.f_nan
  endif
  if ct4 gt 0 then begin
    tau_rtm4[nans4]=!values.f_nan
    ref_rtm4[nans4]=!values.f_nan
  endif
  if cti gt 0 then begin
    tau_rtmi[nansi]=!values.f_nan
    ref_rtmi[nansi]=!values.f_nan
  endif
print, lbls[p],'tau:',mean(tau_rtm1,/nan),'ref:',mean(ref_rtm1,/nan)
 
  nans1=where(wp_rtm1 eq 1.,ct1)
  nans2=where(wp_rtm2 eq 1.,ct2)
  nans3=where(wp_rtm3 eq 1.,ct3)
  nans4=where(wp_rtm4 eq 1.,ct4)
  if ct1 gt 0 then begin
    tau_rtm1[nans1]=!values.f_nan
    ref_rtm1[nans1]=!values.f_nan
  endif
  if ct1 gt 0 then begin
    tau_rtm2[nans1]=!values.f_nan
    ref_rtm2[nans1]=!values.f_nan
  endif
  if ct1 gt 0 then begin
    tau_rtm3[nans1]=!values.f_nan
    ref_rtm3[nans1]=!values.f_nan
  endif
  if ct1 gt 0 then begin
    tau_rtm4[nans1]=!values.f_nan
    ref_rtm4[nans1]=!values.f_nan
  endif
  nansi=where(wp_rtm1 eq 0., cti)
  if cti gt 0 then begin
    tau_rtmi[nansi]=!values.f_nan
    ref_rtmi[nansi]=!values.f_nan
  endif
  fhl=where(finite(tau_rtm1) eq 1,cfhl)
  fhm=where(finite(tau_rtm2) eq 1,cfhm)
  fhc=where(finite(tau_rtm3) eq 1,cfhc)
  fhd=where(finite(tau_rtm4) eq 1,cfhd)
  fhi=where(finite(tau_rtmi) eq 1,cfhi)
  fer=where(finite(wp_err1) eq 1, cerr)

if 1 then begin
  fp=dir+'tmhrs_comp_kisq_'+lbls[p]+blbl
  print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=37, ysize=20 ;20 ;xsize was 30
   !p.font=1 & !p.thick=5 & !p.charsize=3.6 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,1,3] & !x.margin=[7,20] & !y.margin=[3,1] & !p.symsize=1.5 ; charsize was 4.2

tvlct, 150,0,150,40
tvlct, 150,170,0,253
tvlct, 255,125,0,153
tvlct, 230,80,230,41
  
  ymax=max([max(tau_err1[1,*],/nan),max(tau_err2[1,*],/nan),max(tau_err3[1,*],/nan),max(tau_erri[1,*],/nan),max(tau_err4[1,*],/nan)])
  if p eq 1 then ymax=100.
ymax=100.
  plot, tmhrs, tau_rtm, /nodata,ytitle='Optical thickness',yrange=[0,ymax],ymargin=[0,1.3],ystyle=0,xtickname=[' ',' ',' ',' ',' ',' ',' '],xticklen=0.1

 if cfhm gt 0 then begin
  oplot, tmhrs[fhm],tau_rtm2[fhm], psym=-1, color=253
  errplot, tmhrs[fhm],tau_err2[0,fhm],tau_err2[1,fhm],color=253
 endif
 if cfhc gt 0 then begin
  oplot, tmhrs[fhc],tau_rtm3[fhc], psym=-5, color=153
  errplot, tmhrs[fhc],tau_err3[0,fhc],tau_err3[1,fhc],color=153
 endif
 if cfhd gt 0 and twelve then begin
  oplot, tmhrs[fhd],tau_rtm4[fhd], psym=-5, color=240
  errplot, tmhrs[fhd],tau_err4[0,fhd],tau_err4[1,fhd],color=240
 endif
 if cfhl gt 0 then begin
  oplot, tmhrs[fhl],tau_rtm1[fhl], psym=-4, color=40
  errplot, tmhrs[fhl],tau_err1[0,fhl],tau_err1[1,fhl],color=40
 endif
 if cfhi gt 0 then begin
  oplot, tmhrs[fhi],tau_rtmi[fhi], psym=-4, color=41
  errplot, tmhrs[fhi],tau_erri[0,fhi],tau_erri[1,fhi],color=41
 endif
;  plot, tmhrs, wp_err1, /nodata, xtitle='UTC (H)', ytitle='Liquid water propability (%)', yrange=[0,100],ymargin=[6,6]
;  oplot,tmhrs[fhi], 100.-wp_err1[fhi]*100., psym=-4, color=40
;  oplot,tmhrs[fhm], 100.-wp_err2[fhm]*100., psym=-1, color=253
;  oplot,tmhrs[fhc], 100.-wp_err3[fhc]*100., psym=-5, color=153

  ymax=max([max(ref_err1[1,*],/nan),max(ref_err2[1,*],/nan),max(ref_err3[1,*],/nan),max(ref_erri[1,*],/nan),max(ref_err4[1,*],/nan)])
  if p eq 1 then ymax=35.
ymax=50.
  plot, tmhrs, ref_rtm, /nodata,ytitle='Effective radius (!9m!Xm)',yrange=[0,ymax],ystyle=0,ymargin=[1.0,0.2],xticklen=0.1 ,xtickname=[' ',' ',' ',' ',' ',' ',' '];4 was -2

 if cfhm gt 0 then begin
  oplot, tmhrs[fhm],ref_rtm2[fhm], psym=-1, color=253
  errplot, tmhrs[fhm],ref_err2[0,fhm],ref_err2[1,fhm],color=253
 endif
 if cfhc gt 0 then begin
  oplot, tmhrs[fhc],ref_rtm3[fhc], psym=-5, color=153
  errplot, tmhrs[fhc],ref_err3[0,fhc],ref_err3[1,fhc],color=153
;  legend,['Multi-parameter','Slope','2-Wavelengths'],textcolors=[40,253,153],box=0,charsize=2.2
 endif
 if cfhd gt 0 and twelve then begin
  oplot, tmhrs[fhd],ref_rtm4[fhd], psym=-5, color=240
  errplot, tmhrs[fhd],ref_err4[0,fhd],ref_err4[1,fhd],color=240
 endif
 if cfhl gt 0 then begin
  oplot, tmhrs[fhl],ref_rtm1[fhl], psym=-4, color=40
  errplot, tmhrs[fhl],ref_err1[0,fhl],ref_err1[1,fhl],color=40
 endif
 if cfhi gt 0 then begin
  oplot, tmhrs[fhi],ref_rtmi[fhi], psym=-4, color=41
  errplot, tmhrs[fhi],ref_erri[0,fhi],ref_erri[1,fhi],color=41
 endif

 plot, tmhrs, wp_err1, /nodata,xtitle='UTC (H)',ytitle='liquid water cloud!Cprobability (%)',yrange=[0,100],ymargin=[4,-0.8],xticklen=0.1
 if cerr gt 0 then  oplot,tmhrs[fer], 100.-(wp_err1[fer]*100.),psym=-4,color=40

 if twelve then begin
  if cfhi gt 0 then legend, ['Multi-parameter(ice)','Multi-parameter(liquid)','Slope','2-Wavelengths','   515 & 1628 nm','2-Wavelengths','   515 & 1227 nm'],box=0,textcolors=[41,40,253,153,153,240,240],charsize=2.2,position=[0.77,0.7],/normal else $
   legend, ['Multi-parameter(liquid)','Slope','2-Wavelengths','   515 & 1628 nm','2-Wavelengths','   515 & 1227 nm'],box=0,textcolors=[40,253,153,153,240,240],charsize=2.2,position=[0.77,0.7],/normal
 endif else begin
  if cfhi gt 0 then legend, ['Multi-parameter(ice)','Multi-parameter(liquid)','Slope','2-Wavelengths'],box=0,textcolors=[41,40,253,153],charsize=2.2,position=[0.77,0.7],/normal else $
   legend, ['Multi-parameter(liquid)','Slope','2-Wavelengths'],box=0,textcolors=[40,253,153],charsize=2.2,position=[0.77,0.7],/normal
 endelse

  device, /close
  spawn, 'convert "'+fp+'.ps" "'+fp+'.png"'
 if p eq 1 then stop 
endif

; now make scatter plots comparing each methods for each day
  if cfhm gt 0 then begin
    fp=dir+'scatter_comp_kisq_'+lbls[p]+blbl
  print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated,/tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=40, ysize=20 ;20 ;xsize was 30
   !p.font=1 & !p.thick=5 & !p.charsize=2.4 & !x.style=0 & !y.style=0 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,2,0] & !x.margin=[6,1] & !y.margin=[3,1] & !p.symsize=1.5 ; charsize was 4.2

tvlct, 150,0,150,40
tvlct, 150,170,0,253
tvlct, 255,125,0,153
tvlct, 230,80,230,41
  ff=where(finite(tau_rtm1) eq 1 and finite(tau_rtm2) eq 1 and finite(tau_rtm3) eq 1)
  if ff[0] eq -1 then ff=[0,1]
  mm=max([max(tau_rtm1[fhl]),max(tau_rtm2[fhm]),max(tau_rtm3[fhc])])
  plot, tau_rtm1[ff],tau_rtm2[ff],xtitle='Optical thickness from multi-parameter', ytitle='Optical thickness',/nodata,yr=[0,mm],xr=[0,mm]
  oplot,findgen(250),linestyle=2,thick=2
  oplot,tau_rtm1[ff],tau_rtm2[ff],color=253,psym=4
  oplot,tau_rtm1[ff],tau_rtm3[ff],color=153,psym=4
  legend,['Slope vs. Multi-parameter','2-Wavelengths vs. Multi-parameter'],textcolors=[253,153],box=0,/right,/bottom
  corr_t[p,0]=correlate(tau_rtm1[ff],tau_rtm2[ff])
  corr_t[p,1]=correlate(tau_rtm1[ff],tau_rtm3[ff])

  print, lbls[p],'tau corr',correlate(tau_rtm1[ff],tau_rtm2[ff]),correlate(tau_rtm1[ff],tau_rtm3[ff])
  print, 'slope',linfit(tau_rtm1[ff],tau_rtm2[ff]),linfit(tau_rtm1[ff],tau_rtm3[ff])
  ll=linfit(tau_rtm1[ff],tau_rtm2[ff])
  lin_t[p,0]=ll[1]
  ll=linfit(tau_rtm1[ff],tau_rtm3[ff])
  lin_t[p,0]=ll[1]

  mm=max([max(ref_rtm1[fhl]),max(ref_rtm2[fhm]),max(ref_rtm3[fhc])])
  plot, ref_rtm1[ff],ref_rtm2[ff],xtitle='Effective radius from multi-parameter (!9m!Xm)', ytitle='Effective radius (!9m!Xm)',/nodata,yr=[0,mm],xr=[0,mm]
  oplot,findgen(60),linestyle=2,thick=2
  oplot,ref_rtm1[ff],ref_rtm2[ff],color=253,psym=4
  oplot,ref_rtm1[ff],ref_rtm3[ff],color=153,psym=4
  legend,['Slope vs. Multi-parameter','2-Wavelengths vs. Multi-parameter'],textcolors=[253,153],box=0,/right,/bottom
  print, lbls[p],'tau corr',correlate(ref_rtm1[ff],ref_rtm2[ff]),correlate(ref_rtm1[ff],ref_rtm3[ff])
  print, 'slope',linfit(ref_rtm1[ff],ref_rtm2[ff]),linfit(ref_rtm1[ff],ref_rtm3[ff])
  corr_r[p,0]=correlate(ref_rtm1[ff],ref_rtm2[ff])
  corr_r[p,1]=correlate(ref_rtm1[ff],ref_rtm3[ff])

  err_r[p,0]=mean((ref_err1[1,*]-ref_err1[0,*])/ref_rtm1,/nan)
  err_r[p,1]=mean((ref_err2[1,*]-ref_err2[0,*])/ref_rtm2,/nan)
  err_r[p,2]=mean((ref_err3[1,*]-ref_err3[0,*])/ref_rtm3,/nan)
  err_r[p,3]=mean((ref_erri[1,*]-ref_erri[0,*])/ref_rtmi,/nan)

  err_t[p,0]=mean((tau_err1[1,*]-tau_err1[0,*])/tau_rtm1,/nan)
  err_t[p,1]=mean((tau_err2[1,*]-tau_err2[0,*])/tau_rtm2,/nan)
  err_t[p,2]=mean((tau_err3[1,*]-tau_err3[0,*])/tau_rtm3,/nan)
  err_t[p,3]=mean((tau_erri[1,*]-tau_erri[0,*])/tau_rtmi,/nan)

  ll=linfit(ref_rtm1[ff],ref_rtm2[ff])
  lin_r[p,0]=ll[1]
  ll=linfit(ref_rtm1[ff],ref_rtm3[ff])
  lin_r[p,0]=ll[1]

  device, /close
  spawn, 'convert '+fp+'.ps '+fp+'.png'

  endif
endfor

stop
end
