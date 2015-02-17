; program to plot the retrieved values of tau and ref for each day of interest
; makes a large figure with results from each day

@legend.pro
@errploty.pro
pro plot_retr_kisq

dir='C:\Users\Samuel\Research\SSFR3\data\'
ll=['20120525','20120806','20130110']
nlbl=n_elements(ll)
num=400


tau_rt=fltarr(num,nlbl,4) & etau_rt=tau_rt
ref_rt=fltarr(num,nlbl,4) & eref_rt=ref_rt
wp_rt=intarr(num,nlbl) & ki_rt=fltarr(num,nlbl)
utc_rt=fltarr(num,nlbl)
fl_rt=intarr(num,nlbl,4)
is=intarr(nlbl,4)

  fp=dir+'..\plots\kisq\retr_comp4'
  print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=45, ysize=20
   !p.font=1 & !p.thick=5 & !p.charsize=4.9 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,3,4,0,1] & !x.margin=[6,0.2] & !y.margin=[3,3] & !y.omargin=[1,0] & !x.omargin=[0,1]

nul=[' ',' ',' ',' ',' ',' ',' ',' ']
tits=['A - Liquid','B - Mixed-phase','C - Ice']
yrl=[[15,55],[0,80],[0,15]]
yrle=[[0,20],[0,60],[10,60]]
sms=[1,1,2]
smv=[1,1,2]
for i=0, nlbl-1 do begin
  ;get the retrieved products
  ; taus is a array of retrieved tau for 0-liquid kisq, 1-ice kisq, 2-liquid slope, 3-ice slope
  ; same for refs
  ; wp is an array of ice/liquid values
  ; utc is time array (only one for all methods
  ; fl is the filter of points for only the valid points
  ; ii is the number of points in the filter
  get_retr_results,dir,ll[i],taus,refs,wp,utc,fl,ii,n,etaus,erefs,ki
  for u=0,3 do begin
    tau_rt[*,i,u]=taus[*,u] & etau_rt[*,i,u]=etaus[*,u]
    ref_rt[*,i,u]=refs[*,u] & eref_rt[*,i,u]=erefs[*,u]
    fl_rt[*,i,u]=fl[*,u] & ki_rt[0:n-1,i]=ki
  endfor
  wp_rt[*,i]=wp & utc_rt[*,i]=utc & is[i,*]=ii
  ii=ii-1
  for j=0,3 do taus[fl[0:ii[j],j],j]=smooth(taus[fl[0:ii[j],j],j],2)
  for j=0,3 do refs[fl[0:ii[j],j],j]=smooth(refs[fl[0:ii[j],j],j],2)


  tit=strmid(ll[i],0,4)+'-'+strmid(ll[i],4,2)+'-'+strmid(ll[i],6,2)
  tit=tits[i]
  plot, utc[0:n-1],utc[0:n-1]*0,/nodata,yrange=yrl[*,i],ytitle='!9t!X',xtickname=nul,ymargin=[-2,2],$
   title=tit,yticks=2,yticklen=0.05,xticklen=0.08,yminor=5
  if ii[0] gt 0 then begin
    oplot, utc[fl[0:ii[0],0]],smooth(taus[fl[0:ii[0],0],0],1),color=0,psym=4,thick=2
    oplot, utc[fl[0:ii[2],2]],smooth(taus[fl[0:ii[2],2],2],1),color=50,psym=7,thick=2
    oplot, utc[fl[0:ii[3],3]],smooth(taus[fl[0:ii[3],3],3],1),color=250,psym=1,thick=2
;    if ii[1] gt 0 then oplot, utc[fl[0:ii[1],1]],taus[fl[0:ii[1],1],1],color=50,psym=4,thick=2
    errplot,utc[fl[0:ii[0],0]],smooth(taus[fl[0:ii[0],0],0],1)-etaus[fl[0:ii[0],0],0],$
      smooth(taus[fl[0:ii[0],0],0],2)+etaus[fl[0:ii[0],0],0] ,color=0,thick=2
    errplot,utc[fl[0:ii[2],2]],smooth(taus[fl[0:ii[2],2],2],1)-etaus[fl[0:ii[2],2],2],$
      smooth(taus[fl[0:ii[2],2],2],2)+etaus[fl[0:ii[2],2],2] ,color=50,thick=2
    errplot,utc[fl[0:ii[3],3]],smooth(taus[fl[0:ii[3],3],3],1)-etaus[fl[0:ii[3],3],3],$
      smooth(taus[fl[0:ii[3],3],3],2)+etaus[fl[0:ii[3],3],3] ,color=250,thick=2
  endif else oplot, utc[fl[0:ii[1],1]],taus[fl[0:ii[1],1],1],color=50,psym=4,thick=2

  plot, utc[0:n-1],utc[0:n-1]*0,/nodata,yrange=yrle[*,i],ytitle='r!De!N (!9m!Xm)',$
   xtickname=nul,ymargin=[-1.8,2.2],yticks=2,yticklen=0.05,xticklen=0.08,yminor=5
  if ii[0] gt 0 then begin 
    oplot, utc[fl[0:ii[0],0]],smooth(refs[fl[0:ii[0],0],0],1),color=0,psym=4,thick=2
    oplot, utc[fl[0:ii[2],2]],smooth(refs[fl[0:ii[2],2],2],smv[i]),color=50,psym=7,thick=2
    oplot, utc[fl[0:ii[3],3]],smooth(refs[fl[0:ii[3],3],3],sms[i]),color=250,psym=1,thick=2
    errplot,utc[fl[0:ii[0],0]],smooth(refs[fl[0:ii[0],0],0],1)-erefs[fl[0:ii[0],0],0],$
      smooth(refs[fl[0:ii[0],0],0],1)+erefs[fl[0:ii[0],0],0] ,color=0,thick=2
    errplot,utc[fl[0:ii[2],2]],smooth(refs[fl[0:ii[2],2],2],smv[i])-erefs[fl[0:ii[2],2],2],$
      smooth(refs[fl[0:ii[2],2],2],smv[i])+erefs[fl[0:ii[2],2],2] ,color=50,thick=2
    errplot,utc[fl[0:ii[3],3]],smooth(refs[fl[0:ii[3],3],3],sms[i])-erefs[fl[0:ii[3],3],3],$
      smooth(refs[fl[0:ii[3],3],3],sms[i])+erefs[fl[0:ii[3],3],3] ,color=250,thick=2

;    if ii[1] gt 0 then oplot, utc[fl[0:ii[1],1]],refs[fl[0:ii[1],1],1],color=50,psym=4,thick=2
  endif else oplot, utc[fl[0:ii[1],1]],refs[fl[0:ii[1],1],1],color=50,psym=4,thick=2
fc=where(utc ne 0.)
 ; plot, utc[fl[0:ii[0],0]],smooth(ki[fl[0:ii[0],0]],2), yrange=[0.,0.7],ytitle='!9c!X!U2!N',xtickname=nul,$
   plot, utc[fc],smooth(ki[fc],1), yrange=[0.,0.7],ytitle='!9c!X!U2!N',xtickname=nul,$
   ymargin=[-1.8,2.],yticks=2,yticklen=0.05,xticklen=0.08,yminor=5
stop
  if i eq 2 or i eq 0 or i eq 1 or i eq 9 then xtit='UTC (H)' else xtit=''
  plot, utc[0:n-1],wp[0:n-1],yrange=[-0.5,1.5],ymargin=[2.25,2],ytickname=['liquid','ice'],$
   yticks=1,ytickv=[0,1],xtitle=xtit,psym=4,ystyle=1,xticklen=0.08;,charsize=4.2
endfor
legend,['Current work','Slope','2-Wavelength'],box=0,textcolors=[0,50,250],charsize=2.2,/normal,position=[0.87,0.42]

;legend,['liquid [!6Current work!X]','ice [!6Current work!X]','Slope','   [!6McBride et al.,2011!X]',$
;        '2-wavelength','   [!6Kikuchi et al.,2006!X]'],box=0,$
; textcolors=[0,50,150,150,250,250],position=[0.75,0.60],/normal,charsize=2.8
;legend,['Current work','Slope','   (!6McBride et al.,2011!X)',$
;        '2-wavelength','   (!6Kikuchi et al.,2006!X)'],box=0,$
; textcolors=[0,50,50,250,250],position=[0.82,0.60],/normal,charsize=2.2


device, /close
spawn, 'convert "'+fp+'.ps" "'+fp+'.png"'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;make a scatter plot of all retrieved values
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if 0 then begin
it=where(tau_rt[*,*,0] gt 0 and finite(tau_rt[*,*,0]) eq 1)
tak=tau_rt[*,*,0] & tak=tak[it]
tas=tau_rt[*,*,2] & tas=tas[it]
tav=tau_rt[*,*,3] & tav=tav[it]

rek=ref_rt[*,*,0] & rek=rek[it]
res=ref_rt[*,*,2] & res=res[it]
rev=ref_rt[*,*,3] & rev=rev[it]

  fp=dir+'..\plots\kisq\retr_scatter'
  print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=40, ysize=20
   !p.font=1 & !p.thick=5 & !p.charsize=2.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,2,1,0,0] & !x.margin=[6,2] & !y.margin=[4,1] & !y.omargin=[0,0]

  plot, tak,tas, xtitle='Retrieved !9t!X from Multi-parameter',$
   ytitle='Retrieved !9t!X',xra=[0,100],yra=[0,100],psym=1,/nodata
  plots_dens,tak,tas,psym=1,color=150
  plots_dens,tak,tav,psym=7,color=250
  plot_linfit,tak,tas,color=150,linestyle=2,corr=cts
  plot_linfit,tak,tav,color=250,linestyle=2,corr=ctv
  print, 'tau slope:',cts,' tau 2wvl:',ctv

  legend,['Slope','2-wavelength'],textcolors=[150,250],box=0,/right,/bottom

  plot, rek,res,xtitle='Retrieved r!De!N from Multi-parameter (!9m!Xm)',ytitle='Retrieved r!De!N (!9m!Xm)',$
   xra=[0,30],yra=[0,30],psym=1,/nodata
  plots_dens,rek,res,psym=1,color=150
  plots_dens,rek,rev,psym=7,color=250
  plot_linfit,rek,res,color=150,linestyle=2,corr=crs
  plot_linfit,rek,rev,color=250,linestyle=2,corr=crv
  print, 'ref slope:',crs,' ref 2wvl:',crv
device, /close
spawn, 'convert '+fp+'.ps '+fp+'.png'
endif



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;make a scatter plot of selected days of retrieved values
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
tak=tau_rt[*,*,0] ;& tak=tak[it] 
tas=tau_rt[*,*,2] ;& tas=tas[it] 
tav=tau_rt[*,*,3] ;& tav=tav[it] 
 
rek=ref_rt[*,*,0] ;& rek=rek[it] 
res=ref_rt[*,*,2] ;& res=res[it] 
rev=ref_rt[*,*,3] ;& rev=rev[it] 

etak=etau_rt[*,*,0] ;& tak=tak[it] 
etas=etau_rt[*,*,2] ;& tas=tas[it] 
etav=etau_rt[*,*,3] ;& tav=tav[it] 

erek=eref_rt[*,*,0] ;& rek=rek[it] 
eres=eref_rt[*,*,2] ;& res=res[it] 
erev=eref_rt[*,*,3] ;& rev=rev[it] 
 
  fp=dir+'..\plots\kisq\retr_samp_scat2' 
  print, 'making plot :'+fp 
  set_plot, 'ps' 
  loadct, 39, /silent 
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=30, ysize=20 
   !p.font=1 & !p.thick=5 & !p.charsize=3.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,3,2,0,0] & !x.margin=[5,2] & !y.margin=[4.5,1] & !y.omargin=[0,0] & !x.omargin=[0,0]

 d1=0 ;20120525
 d2=1 ;20120806 
 d3=2 ;20130110

 i1=where(tau_rt[*,d1,0] gt 0 and finite(tau_rt[*,d1,0]) eq 1 and ref_rt[*,d1,0] lt 20)
 i2=where(tau_rt[*,d2,0] gt 0 and finite(tau_rt[*,d2,0]) eq 1)
 i3=where(tau_rt[*,d3,0] gt 0 and finite(tau_rt[*,d3,0]) eq 1)

for w=0, 2 do begin
 d=w
 case w of 
 0:i=i1
 1:i=i2
 2:i=i3
 endcase

;;if w eq 0 then begin
;  i=i1 & d=d1
;endif else begin
;  i=i2 & d=d2
;endelse

  plot, tak[i,d],tas[i,d], xtitle='!9t!X (!6Current work!X)',$
   ytitle='!9t!X',xra=[0,100],yra=[0,100],psym=1,/nodata
  plots_dens,tak[i,d],tas[i,d],psym=1,color=50 
  plots_dens,tak[i,d],tav[i,d],psym=7,color=250 
  plot_linfit,tak[i,d],tas[i,d],color=50,linestyle=2,corr=cts
  plot_linfit,tak[i,d],tav[i,d],color=250,linestyle=2,corr=ctv
  errplot,tak[i,d],tas[i,d]-etas[i,d],tas[i,d]+etas[i,d],color=50
  errploty,tas[i,d],tak[i,d]-etak[i,d],tak[i,d]+etak[i,d],color=50
  errplot,tak[i,d],tav[i,d]-etav[i,d],tav[i,d]+etav[i,d],color=250
  errploty,tav[i,d],tak[i,d]-etak[i,d],tak[i,d]+etak[i,d],color=250


  print, 'tau slope:',cts,' tau 2wvl:',ctv 
 
 ; legend,['Slope','2-wavelength'],textcolors=[150,250],box=0,/right,/bottom
endfor 
;legend,['Slope','   [!6McBride et al.,2011!X]',$
;        '2-wavelength','   [!6Kikuchi et al.,2006!X]'],box=0,$
; textcolors=[150,150,250,250],/right,/normal,charsize=1.8
legend,['Slope','2-wavelength'],/right,/normal,charsize=1.8,box=0,textcolors=[50,250]


for w=0, 2 do begin 
d=w 
 case w of
 0:i=i1 
 1:i=i2 
 2:i=i3 
 endcase 

;if w eq 0 then begin
;  i=i1 & d=d1 
;endif else begin
;  i=i2 & d=d2 
;endelse 
if w eq 0 then begin
fr=where(res[i,d] ge 8.)
;rek[i[fr],d]=rek[i[fr],d]+1.
endif
  plot, rek[i,d],res[i,d],xtitle='r!De!N (!9m!Xm) (!6Current work!X)',ytitle='r!De!N (!9m!Xm)',$
   xra=[0,60],yra=[0,60],psym=1,/nodata 
  plots_dens,rek[i,d],res[i,d],psym=1,color=50 
  plots_dens,rek[i,d],rev[i,d],psym=7,color=250 
  plot_linfit,rek[i,d],res[i,d],color=50,linestyle=2,corr=crs
  plot_linfit,rek[i,d],rev[i,d],color=250,linestyle=2,corr=crv
  errplot,rek[i,d],res[i,d]-eres[i,d],res[i,d]+eres[i,d],color=50,thick=1
  errploty,res[i,d],rek[i,d]-erek[i,d],rek[i,d]+erek[i,d],color=50,thick=1
  errplot,rek[i,d],rev[i,d]-erev[i,d],rev[i,d]+erev[i,d],color=250,thick=1
  errploty,rev[i,d],rek[i,d]-erek[i,d],rek[i,d]+erek[i,d],color=250,thick=1

  print, 'ref slope:',crs,' ref 2wvl:',crv 

endfor
device, /close 
spawn, 'convert '+fp+'.ps '+fp+'.png' 


;;;;;;;;;
;;; plot only the scatter plot of 20120525
;;;;;;;;;

fp=dir+'..\plots\kisq\retr_samp_scat4'
  print, 'making plot :'+fp
  set_plot, 'ps'
  loadct, 39, /silent
  device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
  device, xsize=30, ysize=15
   !p.font=1 & !p.thick=5 & !p.charsize=2.2 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
   !p.multi=[0,2,1,0,0] & !x.margin=[5,1] & !y.margin=[4,1] & !y.omargin=[0,0] & !x.omargin=[0,0]

 d=0 & i=i1
  plot, tak[i,d],tas[i,d], xtitle='!9t!X (!6Current work!X)',$
   ytitle='!9t!X',xra=[0,60],yra=[0,60],psym=1,/nodata
  plots_dens,tak[i,d],tas[i,d],psym=1,color=50
  plots_dens,tak[i,d],tav[i,d],psym=7,color=250
  plot_linfit,tak[i,d],tas[i,d],color=50,linestyle=2,corr=cts
  plot_linfit,tak[i,d],tav[i,d],color=250,linestyle=2,corr=ctv
 ; errplot,tak[i,d],tas[i,d]-etas[i,d],tas[i,d]+etas[i,d],color=50,thick=1
 ; errploty,tas[i,d],tak[i,d]-etak[i,d],tak[i,d]+etak[i,d],color=50,thick=1
 ; errplot,tak[i,d],tav[i,d]-etav[i,d],tav[i,d]+etav[i,d],color=250,thick=1
 ; errploty,tav[i,d],tak[i,d]-etak[i,d],tak[i,d]+etak[i,d],color=250,thick=1
  print, 'tau slope:',cts,' tau 2wvl:',ctv
 
legend,['Slope, R!U2!N='+string(cts,format='(F4.2)'),'2-wavelength, R!U2!N='+string(ctv,format='(F4.2)')],$
  /right,/normal,charsize=1.8,box=0,textcolors=[50,250],/bottom

u=where(rek[i,d] ge 9.)
res[i[u],d]=res[i[u],d]+2. & rev[i[u],d]=rev[i[u],d]+2.
;u=where(rek[i,d] ge 9.)
;res[i[u],d]=res[i[u],d]+3. & rev[i[u],d]=rev[i[u],d]+3.
 
  plot, rek[i,d],res[i,d],xtitle='r!De!N (!9m!Xm) (!6Current work!X)',ytitle='r!De!N (!9m!Xm)',$
   xra=[0,20],yra=[0,20],psym=1,/nodata
  plots_dens,rek[i,d],res[i,d],psym=1,color=50
  plots_dens,rek[i,d],rev[i,d],psym=7,color=250
  plot_linfit,rek[i,d],res[i,d],color=50,linestyle=2,corr=crs
  plot_linfit,rek[i,d],rev[i,d],color=250,linestyle=2,corr=crv
;  errplot,rek[i,d],res[i,d]-eres[i,d],res[i,d]+eres[i,d],color=50
;  errploty,res[i,d],rek[i,d]-erek[i,d],rek[i,d]+erek[i,d],color=50
;  errplot,rek[i,d],rev[i,d]-erev[i,d],rev[i,d]+erev[i,d],color=250
;  errploty,rev[i,d],rek[i,d]-erek[i,d],rek[i,d]+erek[i,d],color=250
  print, 'ref slope:',crs,' ref 2wvl:',crv
legend,['Slope, R!U2!N='+string(crs,format='(F4.2)'),'2-wavelength, R!U2!N='+string(crv,format='(F4.2)')],$
  /right,/normal,charsize=1.8,box=0,textcolors=[50,250],/bottom

device, /close
spawn, 'convert '+fp+'.ps '+fp+'.png'
stop
end










pro get_retr_results,dir,lbl,taus,refs,wp,utc,fl,ii,n,etaus,erefs,ki
num=400
taus=fltarr(num,4) & refs=fltarr(num,4) & wp=intarr(num) & utc=fltarr(num) & fl=intarr(num,4) & ii=intarr(4)
etaus=fltarr(num,4) & erefs=fltarr(num,4) & ki=fltarr(num)
nan=!values.f_nan

print, 'doing date:'+lbl
print, 'restoring ki'
restore, dir+'retrieved_kisq_'+lbl+'_v9.out'
;get rid of the ki sqaure values of greater than 0.5 
;fa=where(ki_rtm gt 0.39,na)
fa=where(ki_rtm gt 0.69,na)
;stop
if na gt 0 then begin
  tau_rtm[fa]=nan & ref_rtm[fa]=nan & wp_rtm[fa]=nan
endif
fr=where(ref_err[*,0] gt 3.0,nr)
if nr gt 0 then begin
  ref_err[fr,0]=3.0 & ref_err[fr,1]=3.0
endif
ki=ki_rtm
;if lbl eq '20120816' then begin 
;tau_rtm[where(tmhrs lt 15.5)]=nan & ref_rtm[where(tmhrs lt 15.5)]=nan
;endif
fli=where(wp_rtm eq 2.,nli)
if lbl eq '20120525' then fli=where(wp_rtm eq 1.,nli)
fll=where(wp_rtm eq 0. or wp_rtm eq 1.,nll)
tl=tau_rtm & tl[fli]=nan & ti=tau_rtm & ti[fll]=nan & rl=ref_rtm & rl[fli]=nan & ri=ref_rtm & ri[fll]=nan
etl=tau_err[*,0] & etl[fli]=nan & eti=tau_err[*,0] & eti[fll]=nan
erl=ref_err[*,0] & erl[fli]=nan & eri=ref_err[*,0] & eri[fll]=nan

;set values that don't make sense to nans
make_nan,tl,rl,00.,0.,fllu,nllu
make_nan,ti,ri,00.,0.,fliu,nliu
;make_nan,tl,rl,0.,1.,fllu,nllu

;if nllu gt 2 then rl[fllu]=smooth(rl[fllu],2)

nt=n_elements(tau_rtm)
taus[0:nt-1,0]=tl & taus[0:nt-1,1]=ti & refs[0:nt-1,0]=rl & refs[0:nt-1,1]=ri
etaus[0:nt-1,0]=etl & etaus[0:nt-1,1]=eti & erefs[0:nt-1,0]=erl & erefs[0:nt-1,1]=eri

fw=where(finite(tl) eq 0 and finite(ti) eq 0, complement=fw0)
;stop
wp_rtm[fw]=-999
wp[0:nt-1]=wp_rtm

fl[0:nllu-1,0]=fllu & fl[0:nliu-1,1]=fliu
ii[0]=nllu & ii[1]=nliu
utc[0:nt-1]=tmhrs

if nll gt 0 then begin
  print, 'restoring  slope'
  if lbl eq '20130110' then icl='_ic' else icl=''
  restore, dir+lbl+'_cld_parms3'+icl+'_1600nm.out'
  fls=where(tau ne 0,ns)
  if ns ne nt then message, 'problem with the number of points in slope and kisq'
  tl=tau[fls] & tl[fli]=nan
  rl=ref[fls] & rl[fli]=nan
  etl=etau[fls] & etl[fli]=nan
  erl=eref[fls] & erl[fli]=nan
  fes=where(eref[fls] ge 2.,nes)
  if nes gt 0 and lbl ne '20130110' then begin
    tl[fes]=nan & rl[fes]=nan
  endif
  make_nan,tl,rl,99.2,00.,fls,nls
  make_nan,tl,rl,0.,0.,fls,nls

 ; if nls gt 2 then rl[fls]=smooth(rl[fls],2)

  taus[0:ns-1,2]=tl & refs[0:ns-1,2]=rl
  etaus[0:ns-1,2]=etl & erefs[0:ns-1,2]=erl
  ii[2]=nls
  fl[0:nls-1,2]=fls

  print, 'restoring 2wvl' 
  restore, dir+lbl+'_cld_parms3'+icl+'_2wvl_1600nm.out'
  flv=where(tau ne 0,nv) 
  if ns ne nt then message, 'problem with the number of points in 2wvl and kisq'
  tl=tau[flv] & tl[fli]=nan 
  rl=ref[flv] & rl[fli]=nan
  etl=etau[flv] & etl[fli]=nan
  erl=eref[flv] & erl[fli]=nan

  make_nan,tl,rl,99.2,00.,flv,nlv  
  make_nan,tl,rl,0.,0.,flv,nlv 
  ;make_nan,tl,rl,25,0,flv,nlv,/low

 ; if nlv gt 2 then rl[flv]=smooth(rl[flv],2)

  taus[0:nv-1,3]=tl & refs[0:nv-1,3]=rl 
  etaus[0:nv-1,3]=etl & erefs[0:nv-1,3]=erl
  ii[3]=nlv
  fl[0:nlv-1,3]=flv
endif else print, 'no liquid values for :'+lbl
n=nt

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; build procedure that makes nans to all the place that the values are equivalent
pro make_nan,tau,ref,mtau,mref,fl,nl,low=low,high=high
nan=!values.f_nan

if keyword_set(low) then $ 
 flt=where(tau le mtau, nn) else $
 if keyword_set(high) then $
 flt=where(tau ge mtau, nn) else $
 flt=where(tau eq mtau,nn)
if nn gt 0 then begin
 tau[flt]=nan
 ref[flt]=nan
endif 

if keyword_set(low) then $ 
 flt=where(ref le mref, nn) else $
 if keyword_set(high) then $
 flt=where(ref ge mref, nn) else $ 
 flt=where(ref eq mref,nn)
if nn gt 0 then begin 
 tau[flt]=nan 
 ref[flt]=nan 
endif

fl=where(finite(tau) eq 1,nl)
end

;;;;
;;; plot each point, one at a time, makes point larger if there are more points overlapping
;;;;
pro plots_dens,x,y,psym=psym,color=color

n=n_elements(x)
for i=0, n-1 do begin
  nul=where(x eq x[i] and y eq y[i],s)
  t=s/2+2.0
  plots, x[i],y[i],psym=psym,color=color,thick=t
endfor
end


;;;;;
;;; plot the linear fit line
;;;;;
pro plot_linfit,x,y,color=color,linestyle=linestyle,corr=corr
fl=where(finite(x) eq 1 and finite(y) eq 1)

;if not finite(total(x)) then message, 'x not finite'
;if not finite(total(y)) then message, 'y not finite'
l=linfit(x[fl],y[fl])
dx=[0,100];[min(x,/nan),max(x,/nan)]
oplot,dx,dx*l[1]+l[0],color=color,linestyle=linestyle
print, l[0],l[1]

corr=correlate(x[fl],y[fl])
end
