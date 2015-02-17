; program to plot samples of kisq values for 2 cases

pro plot_samp_kisq

dir='C:\Users\Samuel\Research\SSFR3\data\'


; restore the values of sample liquid
restore, dir+'sample_kisq5_20120525.out' ;liquid
ki1=ki & sp1=sp & spm1=spm & t1=tau & r1=ref & r1m=refm & t1m=taum & w1=w & par1=par
ts1=40.3 & rs1=8. & tv1=38.9 & rv1=9.
ts1=43.1 & rs1=9. & tv1=41.7 & rv1=9.
ts1=33 & rs1=7 & tv1=31 & rv1=4 & t1=30 & r1=5
print, 'liq utc:',ut,i
spp1=interp_sp(spm1,t1m,r1m,taus,refs)

restore, dir+'sample_kisq5_20130110.out' ;ice
ki2=ki & sp2=sp & spm2=spm & t2=tau & r2=ref & r2m=refm & t2m=taum & w2=w & par2=par 
ts2=0. & rs2=0. & tv2=0. & rv2=0.
ts2=30.5 & rs2=30. & tv2=27.7 & rv2=26.
ts2=14 & rs2=10 & tv2=7 & rv2=14
ts2=10 & rs2=22 & tv2=9 & rv2=11
ts2=9 & rs2=55 & tv2=9 & rv2=20 & t2=8 & r2=42
print, 'ice utc:',ut,i

spp2=interp_sp(spm2,t2m,r2m,taus,refs)

restore, dir+'sample_kisq5_20120806.out' ;liquid/mix
ki3=ki & sp3=sp & spm3=spm & t3=tau & r3=ref & r3m=refm & t3m=taum & w3=w & par3=par
t3=3 & r3=47

ts3=19.3 & rs3=30. & tv3=19.3 & rv3=30. 
ts3=25 & rs3=30 & tv3=28 & rv3=30
ts3=17 & rs3=28 & tv3=13 & rv3=30
;ts3=18 & rs3=30 & tv3=14 & rv3=30
t3l=14 & r3l=29

t3i=2 & r3i=59

k=findgen(100)/33./100.
for r=0,29 do ki3[*,r,0]=ki3[*,r,0]+k



spp3=interp_sp(spm3,t3m,r3m,taus,refs)

if 0 then begin
  fp=dir+'..\plots\kisq\kisq_samp_sp'
  print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=45, ysize=15
   !p.font=1 & !p.thick=5 & !p.charsize=4.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,3,2,0,0] & !x.margin=[7,2] & !y.margin=[4,2] & !y.omargin=[0,0] & !x.omargin=[0,0]

  plot, wvl,sp1, xtitle='Wavelength (nm)',ytitle='Radiance (Wm!U-2!Nnm!U-1!Nsr!U-1!N)',xr=[400,1700],ysty=0
  oplot,wvlm,spp1[t1-1,r1-1,*,w1]*0.98,color=50
  oplot,wvlm,spp1[ts1-1,rs1-1,*,0],color=150
  oplot,wvlm,spp1[tv1-1,rv1-1,*,0],color=250 
;  legend,['Liquid'],box=0,/right,/bottom
legend,['Measurement','Current work','Slope','2-wavelength'],textcolors=[0,50,150,250],box=0,/right,charsize=2.0

ff3=1.;19842

  plot, wvl,sp3, xtitle='Wavelength (nm)',ytitle='Radiance (Wm!U-2!Nnm!U-1!Nsr!U-1!N)',xr=[400,1700];,title='Mix'
  oplot,wvlm,spp3[t3-1,r3-1,*,0]*ff3,color=50
  oplot,wvlm,spp3[t3-1,r3-1,*,1]*ff3,color=50,linestyle=1 
  oplot,wvlm,spp3[ts3-1,rs3-1,*,0]*ff3,color=150
  oplot,wvlm,spp3[tv3-1,rv3-1,*,0]*ff3,color=250  

ff=findgen(n_elements(wvlm))/n_elements(wvlm)/20.+0.975

  plot, wvl,sp2, xtitle='Wavelength (nm)',ytitle='Radiance (Wm!U-2!Nnm!U-1!Nsr!U-1!N)',xr=[400,1700],ysty=0
  oplot,wvlm,spp2[t2-1,r2-1,*,w2]*ff,color=50 
  oplot,wvlm,spp3[ts3-1,rs3-1,*,0],color=150
  oplot,wvlm,spp3[tv3-1,rv3-1,*,0],color=250 
; legend,['Ice'],box=0,/right,/bottom
legend,['Measurement','Multi-parameter'],textcolors=[0,50],box=0,/right,charsize=2.0

  device, /close
  spawn, 'convert '+fp+'.ps '+fp+'.png'
endif

iv=where((wvlm gt 900. and wvlm lt 1000.)  or (wvlm ge 1091. and wvlm lt 1200.) or $
         (wvlm ge 1288. and wvlm lt 1502.) or (wvlm ge 1694.) or (wvlm lt 404.) ,complement=ivv)

spp3[t3-1,r3-1,*,w3]=spp3[t3-1,r3-1,*,w3]-0.0025

  fp=dir+'..\plots\kisq\kisq_samp_sp4'
  print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=45, ysize=20
   !p.font=1 & !p.thick=5 & !p.charsize=4.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,3,2,0,0] & !x.margin=[6,2] & !y.margin=[0,0.6] & !y.omargin=[4,2] & !x.omargin=[2,0] & !x.ticklen=0.05
!x.minor=3
tvlct,20,150,20,150
tvlct,0,70,0,151
xtn=[' ',' ',' ',' ',' ',' ',' ',' '] 

  plot, wvl,sp1, ytitle='Radiance!C(Wm!U-2!Nnm!U-1!Nsr!U-1!N)',xr=[400,1700],ysty=0,xtickname=xtn,title='A - Liquid',xticks=5
  oplot,wvlm,spp1[t1-1,r1-1,*,w1],color=150
  oplot,wvlm,spp1[ts1-1,rs1-1,*,0],color=50
  oplot,wvlm,spp1[tv1-1,rv1-1,*,0],color=250
  spn1=interpol(sp1,wvl,wvlm)
;  legend,['Liquid'],box=0,/right,/bottom 
legend,['Measurement','Current work','Slope','2-wavelength'],textcolors=[0,150,50,250],box=0,/right,charsize=2.0
;legend,['!9t!X=39, r!De!N=7 !9m!Xm','!9t!X=43, r!De!N=9 !9m!Xm','!9t!X=41, r!De!N=9 !9m!Xm'],$
; textcolors=[150,50,250],box=0,/bottom,charsize=2.0 
ff3=1.;19842 

  plot, wvl,sp3, ytitle='Radiance!C(Wm!U-2!Nnm!U-1!Nsr!U-1!N)',xr=[400,1700],xtickname=xtn,$
   yr=[0,0.26] ,title='B - Mixed-pase',xticks=5 ;for samp3 yr=[0,0.22]
  spp3[t3-1,r3-1,185:191,1]=spp3[t3-1,r3-1,185:191,1]-0.002
  oplot,wvlm,spp3[t3-1,r3-1,*,w3]*ff3,color=151,linestyle=5*w3
  oplot,wvlm,spp3[t3l,r3l,*,0]*ff3,color=150,linestyle=0
  oplot,wvlm,spp3[ts3-1,rs3-1,*,0]*ff3,color=50
  oplot,wvlm,spp3[tv3-1,rv3-1,*,0]*ff3,color=250
  oplot,wvlm,spp3[t3-1,r3-1,*,1]*ff3,color=151,linestyle=2
  oplot,wvlm,spp3[t3-1,r3-1,*,1]*ff3,color=151,thick=0.8
  ;oplot,wvlm,spp3[t3l,r3l,*,0]*ff3,color=150,linestyle=0, thick=8
  ;legend,['Liquid','Ice'],box=0,position=[1150,0.1],pspacing=1.2,linestyle=[0,2],color=[0,0],charsize=2.0,/data
  legend,['!9t!X='+strtrim(t3l+1,2)+', r!De!N=30 !9m!Xm, liquid','!9t!X='+strtrim(t3,2)+', r!De!N='+strtrim(r3,2)+$
          ' !9m!Xm, ice',$
          '!9t!X='+strtrim(ts3,2)+', r!De!N='+strtrim(rs3,2)+' !9m!Xm',$
          '!9t!X='+strtrim(tv3,2)+', r!De!N='+strtrim(rv3,2)+' !9m!Xm'],$
 textcolors=[150,151,50,250],box=0,position=[1720,0.25],charsize=2.0,$
  color=[150,150,255,255],linestyle=[0,2,0,0],pspacing=1.2,/right

  spn3=interpol(sp3,wvl,wvlm)
;ff=findgen(n_elements(wvlm))/n_elements(wvlm)/20.+0.975
 
  plot, wvl,sp2,ytitle='Radiance!C(Wm!U-2!Nnm!U-1!Nsr!U-1!N)',xr=[400,1700],ysty=1,xtickname=xtn,$
   yr=[0,0.086],title='C - Ice',xticks=5
  oplot,wvlm,spp2[t2-1,r2-1,*,w2],color=150
  oplot,wvlm,spp2[ts2-1,rs2-1,*,1],color=50
  oplot,wvlm,spp2[tv2-1,rv2-1,*,1],color=250
  spn2=interpol(sp2,wvl,wvlm)
  legend,['!9t!X='+strtrim(t2,2)+', r!De!N='+strtrim(r2,2)+' !9m!Xm','!9t!X='+strtrim(ts2,2)+$
   ', r!De!N='+strtrim(rs2,2)+' !9m!Xm',$
   '!9t!X='+strtrim(tv2,2)+', r!De!N='+strtrim(rv2,2)+' !9m!Xm'],$
   textcolors=[150,50,250],box=0,/righ,charsize=2.0   

; legend,['Ice'],box=0,/right,/bottom 
;legend,['Measurement','Multi-parameter'],textcolors=[0,150],box=0,/right,charsize=2.0 
 nan=!values.f_nan
spn1[iv]=nan & spn2[iv]=nan & spn3[iv]=nan
spp1[*,*,iv,*]=nan & spp2[*,*,iv,*]=nan & spp3[*,*,iv,*]=nan

tvlct,190,190,190,200
if 0 then begin 
set_plot, 'win'
!p.multi=0 & !p.thick=1 & !p.charsize=2 
plot, wvlm, (spn1-spp1[t1-1,r1-1,*,w1])/spn1*100.
stop 
 
endif

  plot,wvlm,(spn1-spp1[t1-1,r1-1,*,w1])/spn1*100.,ytitle='Radiance!Cdifference (%)',xr=[400,1700],$
   xtit='Wavelength (nm)',/nodata,yr=[-20,40],xticks=5
  oplot,wvlm,wvlm*0.,linestyle=1,color=200
  oplot,wvlm,(spn1-spp1[t1-1,r1-1,*,w1])/spn1*100.,color=150
  oplot,wvlm,(spn1-spp1[ts1-1,rs1-1,*,0])/spn1*100.,color=50
  oplot,wvlm,(spn1-spp1[tv1-1,rv1-1,*,0])/spn1*100.,color=250 
  legend,['!9t!X='+strtrim(t1,2)+', r!De!N='+strtrim(r1,2)+' !9m!Xm','!9t!X='+strtrim(ts1,2)+', r!De!N='+strtrim(rs1,2)+' !9m!Xm',$
          '!9t!X='+string(tv1,format='(I2)')+', r!De!N='+string(rv1,format='(I1)')+' !9m!Xm'],$
   textcolors=[150,50,250],box=0,charsize=2.0,position=[400,40]
  xyouts,450,-15,'15.24 UTC',charsize=2.0
;  legend,['rms=3.1%','rms=6.4%','rms=5.9%'],textcolors=[150,50,250],box=0,charsize=2.0,position=[1000,40]


  plot,wvlm,(spn3-spp3[t3-1,r3-1,*,w3])/spn3*100.,ytitle='Radiance!Cdifference (%)',xr=[400,1700],$
   xtit='Wavelength (nm)',/nodata,yr=[-20,30],xticks=5
  oplot,wvlm,wvlm*0.,linestyle=1,color=200
  oplot,wvlm,smooth((spn3-spp3[t3-1,r3-1,*,w3])/spn3*100.,3,/nan),color=151,linestyle=5*w3 
  oplot,wvlm,(spn3-spp3[t3l,r3l,*,0])/spn3*100.,color=150,linestyle=0
  oplot,wvlm,(spn3-spp3[ts3-1,rs3-1,*,0])/spn3*100.,color=50
  oplot,wvlm,(spn3-spp3[tv3-1,rv3-1,*,0])/spn3*100.,color=250
  oplot,wvlm,smooth((spn3-spp3[t3-1,r3-1,*,1])/spn3*100.,3,/nan),color=151,linestyle=2
  oplot,wvlm,smooth((spn3-spp3[t3-1,r3-1,*,1])/spn3*100.,3,/nan),color=151,thick=0.8
  ;oplot,wvlm,(spn3-spp3[t3l,r3l,*,0])/spn3*100.,color=150,linestyle=0,thick=8
  xyouts, 450, -15,'22.22 UTC',charsize=2.0
;  legend,['rms=7.2%','rms=22.8%'],textcolors=[150,151],box=0,charsize=2.0,position=[700,-10]
;  legend,['rms=13.3%','rms=7.3%'],textcolors=[50,250],box=0,charsize=2.0,position=[1100,-10]

  plot,wvlm,(spn2-spp2[t2-1,r2-1,*,w2])/spn2*100.,ytitle='Radiance!Cdifference (%)',xr=[400,1700],$
   xtit='Wavelength (nm)',/nodata,yr=[-38,65],xticks=5
  oplot,wvlm,wvlm*0.,linestyle=1,color=200
  oplot,wvlm,(spn2-spp2[t2-1,r2-1,*,w2])/spn2*100.,color=150 
  oplot,wvlm,(spn2-spp2[ts2-1,rs2-1,*,1])/spn2*100.,color=50
  oplot,wvlm,(spn2-spp2[tv2-1,rv2-1,*,1])/spn2*100.,color=250
  xyouts, 450, -26,'19.46 UTC',charsize=2.0
;  legend,['rms=5.9%','rms=22.5%','rms=20.2%'],textcolors=[150,50,250],box=0,charsize=2.0,position=[400,60]
  device, /close 
  spawn, 'convert '+fp+'.ps '+fp+'.png' 

;for analysis
sk1=smooth(reform(spn1-spp1[t1-1,r1-1,*,w1])/spn1*100.,3,/nan)
ss1=smooth(reform(spn1-spp1[ts1-1,rs1-1,*,0])/spn1*100.,3,/nan)
sv1=smooth(reform(spn1-spp1[tv1-1,rv1-1,*,0])/spn1*100.,3,/nan)

sk2=smooth(reform(spn2-spp2[t2-1,r2-1,*,w2])/spn2*100.,3,/nan)
ss2=smooth(reform(spn2-spp2[ts2-1,rs2-1,*,1])/spn2*100.,3,/nan)
sv2=smooth(reform(spn2-spp2[tv2-1,rv2-1,*,1])/spn2*100.,3,/nan)

sk3=smooth(reform(spn3-spp3[t3-1,r3-1,*,1])/spn3*100.,3,/nan)
ss3=smooth(reform(spn3-spp3[ts3-1,rs3-1,*,0])/spn3*100.,3,/nan)
sv3=smooth(reform(spn3-spp3[tv3-1,rv3-1,*,0])/spn3*100.,3,/nan)
sk3l=smooth(reform(spn3-spp3[t3l,r3l,*,0])/spn3*100.,3,/nan)

; get rms
s1=[[sk1],[ss1],[sv1]]
s2=[[sk2],[ss2],[sv2]]
s3=[[sk3],[ss3],[sv3],[sk3l]]

rms1=fltarr(3,3,2)
rms2=fltarr(3,3,2)
rms3=fltarr(4,3,2)
for i=0,2 do begin
  rms1[i,0,0]=sqrt(mean(s1[*,i]*s1[*,i],/nan))
  rms2[i,0,0]=sqrt(mean(s2[*,i]*s2[*,i],/nan))
  rms3[i,0,0]=sqrt(mean(s3[*,i]*s3[*,i],/nan))
  rms1[i,1,0]=sqrt(mean(s1[0:180,i]*s1[0:180,i],/nan))
  rms2[i,1,0]=sqrt(mean(s2[0:180,i]*s2[0:180,i],/nan))
  rms3[i,1,0]=sqrt(mean(s3[0:180,i]*s3[0:180,i],/nan))
  rms1[i,2,0]=sqrt(mean(s1[181:*,i]*s1[181:*,i],/nan))
  rms2[i,2,0]=sqrt(mean(s2[181:*,i]*s2[181:*,i],/nan))
  rms3[i,2,0]=sqrt(mean(s3[181:*,i]*s3[181:*,i],/nan)) 
endfor
rms3[i,0,0]=sqrt(mean(s3[*,i]*s3[*,i],/nan))
rms3[i,1,0]=sqrt(mean(s3[0:180,i]*s3[0:180,i],/nan))
rms3[i,2,0]=sqrt(mean(s3[181:*,i]*s3[181:*,i],/nan))


for i=0,2 do begin
  rms1[i,0,1]=sqrt(total(s1[*,i]*s1[*,i],/nan))
  rms2[i,0,1]=sqrt(total(s2[*,i]*s2[*,i],/nan))
  rms3[i,0,1]=sqrt(total(s3[*,i]*s3[*,i],/nan))
  rms1[i,1,1]=sqrt(total(s1[0:180,i]*s1[0:180,i],/nan))
  rms2[i,1,1]=sqrt(total(s2[0:180,i]*s2[0:180,i],/nan))
  rms3[i,1,1]=sqrt(total(s3[0:180,i]*s3[0:180,i],/nan))
  rms1[i,2,1]=sqrt(total(s1[181:*,i]*s1[181:*,i],/nan))
  rms2[i,2,1]=sqrt(total(s2[181:*,i]*s2[181:*,i],/nan))
  rms3[i,2,1]=sqrt(total(s3[181:*,i]*s3[181:*,i],/nan))
endfor 
rms3[i,0,1]=sqrt(total(s3[*,i]*s3[*,i],/nan))
rms3[i,1,1]=sqrt(total(s3[0:180,i]*s3[0:180,i],/nan))
rms3[i,2,1]=sqrt(total(s3[181:*,i]*s3[181:*,i],/nan))


stop

;;;;;;;
;; plot a zoomed in figure of normalized radiance
;;;;;;;

  fp=dir+'..\plots\kisq\kisq_sp_zoom'
  print, 'making plot :'+fp
  set_plot, 'ps'  
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=20, ysize=16
   !p.font=1 & !p.thick=5 & !p.charsize=2.5 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=0 & !x.margin=[7,1] & !y.margin=[0,0] & !y.omargin=[4,1] & !x.omargin=[0,0]

   tvlct,20,150,20,150
     plot, wvl,sp3/max(sp3), ytitle='Normalized!Cradiance',xr=[900,1700],xtitle='Wavelength (nm)',yr=[0,0.5];,title='Mix'
  oplot,wvlm,spp3[t3-1,r3-1,*,1]/max(spp3[t3-1,r3-1,*,1])*0.9,color=150,linestyle=2
  oplot,wvlm,spp3[t3l,r3l,*,0]/max(spp3[t3l,r3l,*,0]),color=150,linestyle=0,thick=8
  oplot,wvlm,spp3[ts3-1,rs3-1,*,0]/max(spp3[ts3-1,rs3-1,*,0]),color=50
  oplot,wvlm,spp3[tv3-1,rv3-1,*,0]/max(spp3[tv3-1,rv3-1,*,0]),color=250
  oplot,wvlm,spp3[t3l,r3l,*,0]/max(spp3[t3l,r3l,*,0]),color=150,linestyle=0,thick=8
legend,['Measurement','Current work','Slope','2-wavelength'],textcolors=[0,150,50,250],box=0,/right,charsize=2.0


     device, /close  
  spawn, 'convert '+fp+'.ps '+fp+'.png'




;stop

  fp=dir+'..\plots\kisq\kisq_samp2'
  print, 'making plot :'+fp 
  set_plot, 'ps' 
  loadct, 39, /silent 
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=45, ysize=16
   !p.font=1 & !p.thick=5 & !p.charsize=4.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,3,2,0,1] & !x.margin=[6,2] & !y.margin=[0,0.2] & !y.omargin=[4,2] & !x.omargin=[1,5]

  lvl=[0,0.037,0.05,0.085,0.1,0.107,0.115,0.25,0.5,1.25,3.0,5.0,15.,30.] ;findgen(20)/19.
  clv=(findgen(n_elements(lvl))+1.)*(250./n_elements(lvl))

  contour, ki1[*,0:29,0],taus,refs[0:29],levels=lvl,c_colors=clv,$
   xtickname=xtn,ytitle='r!De!N (!9m!Xm)',yr=[0,30],title='A'
  contour, ki1[*,9:*,1],taus,refs[9:*],levels=lvl,c_colors=clv,c_linestyle=[1,1,1],$
   xtitle='!9t!X',ytitle='r!De!N (!9m!Xm)',yr=[10,60]

  contour, ki3[*,0:29,0],taus,refs[0:29],levels=lvl,c_colors=clv,$
   xtickname=xtn,ytitle='r!De!N (!9m!Xm)',yr=[0,30],title='B' 
  contour, ki3[*,9:*,1],taus,refs[9:*],levels=lvl,c_colors=clv,c_linestyle=[1,1,1],$
   xtitle='!9t!X',ytitle='r!De!N (!9m!Xm)',yr=[10,60]

  contour, ki2[*,0:29,0],taus,refs[0:29],levels=lvl,c_colors=clv,$
   xtickname=xtn,ytitle='r!De!N (!9m!Xm)',yr=[0,30],title='C' 
  contour, ki2[*,9:*,1],taus,refs[9:*],levels=lvl,c_colors=clv,c_linestyle=[1,1,1],$
   xtitle='!9t!X',ytitle='r!De!N (!9m!Xm)',yr=[10,60]
  
  contour, transpose([[lvl],[lvl]]),[0,1],lvl,xtickname=[' ',' '],xticks=1,yr=[0.03,30],ysty=9,$
   levels=lvl,/fill,c_colors=clv,/noerase,position=[0.93,0.2,0.94,0.92],ytickname=xtn,/ylog
  axis,1,yaxis=1,yr=[0.03,30],ytitle='!9c!X!U2!N',/ylog,yticklen=0.2  

  device, /close
  spawn, 'convert '+fp+'.ps '+fp+'.png'

stop
end





; interpolate the spectra to match exactly the hires grid
function interp_sp, spin,tin,rin,tout,rout
nv=n_elements(spin[0,0,*,0])
nti=n_elements(tin)
nri=n_elements(rin)
nto=n_elements(tout)
nro=n_elements(rout)

spt=fltarr(nto,nri,nv,2)
spout=fltarr(nto,nro,nv,2)

for w=0, 1 do begin
  for v=0, nv-1 do begin
    for r=0,nri-1 do spt[*,r,v,w]=interpol(spin[*,r,v,w],tin,tout)
    for t=0,nto-1 do spout[t,*,v,w]=interpol(spt[t,*,v,w],rin,rout)
  endfor
  for t=0,nto-1 do for r=0,nro-1 do spout[t,r,*,w]=smooth(spout[t,r,*,w],2)
endfor

return,spout
end


