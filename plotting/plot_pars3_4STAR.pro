; program to plot all 15 parameters as they vary with tau and ref for ice and water

pro plot_pars,lbl

win=1

;if win then dir='C:\Users\Samuel\Research\SSFR3\' else $ 
; dir='/home/leblanc/SSFR3/plots/new/'
dir='C:\Users\Samuel\Research\4STAR\'

;fp=dir+'data\par_std_sza_v1_20120525.out'

restore, 'C:\Users\Samuel\Research\SSFR3\data\par_std_sza_v1_20120525.out'
ss=std  
std=std[*,*,*,*,1]


fp=dir+'model\arctic\par_v1_20130911_snow_ice_raw.out'
;fp=dir+'model\arctic\par_v1_20130911_snow_ice_raw.out'
restore, fp
avg=pars[*,*,*,*]
;ss=std
;std=std[*,*,*,*,1]


for r=0,59 do begin 
  for w=0,1 do begin
    std[*,r,w,3]=smooth(std[*,r,w,3],3)
    std[*,r,w,14]=smooth(std[*,r,w,14],3)
  endfor
endfor

; now set up plotting

;fp=dir+'plots\new\pars5'
fp=dir+'plots\pars5_lowt'
print, 'making plot :'+fp
set_plot, 'ps'
 loadct, 39, /silent
 device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
 device, xsize=40, ysize=26
  !p.font=1 & !p.thick=5 & !p.charsize=4.9 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
  !p.multi=[0,4,4,0,0] & !x.margin=[6,1.5] & !y.margin=[0.155555,0.4] & !y.omargin=[3,1] & !x.omargin=[0,0] & !y.ticklen=0.05

tvlct,220,220,220,201
tvlct,250,200,200,251
tvlct,200,200,250,71

del='!9'+string("266B)+'!X' ;"
bar='!9'+string("244B)+'!X' ;"
ds='!U'+del+'!N'+bar+'!D'+del+'!9l!X!I'
dds='!U'+del+'!e2!X!N'+bar+'!D'+del+'!9l!X!e2!X!I'

lls=['!9C!D1.0!N!X',ds+'1.2!N',ds+'1.5!N','!8r!D1.2!N!X','!8<R>!D1.25!N!X','!8<R>!D1.6!N!X','!8<R>!D1.0!N!X',$
     '!8C!D1.6!N!X',dds+'1.0!N',dds+'1.2!N','!8sl!D0.55!N!X','!8R!D1.04!N!X','!8r!D1.0!N!X','!8r!D0.6!N!X','!8sl!D1.6!N!X']
pos=[[5,-1],[0,-8],[40,6.5],[5,2.8],[40,0.23],[40,0.115],[0,0.18],[60,0.81],[-9,0.3],$
     [42,0],[05,-1.98],[5,0.2],[5,1.0],[5,2.1],[60,0.01]]
chs=[2.2,3.9,3.9,2.2,2.2,2.2,2.2,2.2,3.9,3.8,2.2,2.2,2.2,2.2,2.2]

tau=taus
 for p=0, 14 do begin
 
  ;yr=[min(avg[0:99,[09,19,29],*,p]-std[0:99,[09,19,29],*,p],/nan)*0.98,$
  ;    max(avg[0:99,[09,19,29],*,p]+std[0:99,[09,19,29],*,p],/nan)*1.02]
  yr=[min(avg[0:99,[09,19,24],*,p]-std[0:99,[09,19,24],*,p],/nan)*0.98,$
      max(avg[0:99,[09,19,24],*,p]+std[0:99,[09,19,24],*,p],/nan)*1.02]
  if p eq 10 then begin
   yr[1]=max(avg[0:99,[09,19,29],*,p]+std[0:99,[09,19,29],*,p],/nan)*0.96 & std[*,*,*,p]=std[*,*,*,p]/2.
  endif
  if p eq 14 then begin
   yr=[-0.002,0.030]
   for i=0,59 do for j=0,1 do avg[*,i,j,p]=smooth(avg[*,i,j,p],10)
   for i=0,59 do for j=0,1 do std[*,i,j,p]=smooth(std[*,i,j,p],10) 
   ;for i=0,99 do std[i,*,*,p]=std[i,*,*,p]*0.+1.00015*i   
  endif
  if p eq 3 then begin
    yr=[0.7,3.2]
    for i=9,59 do std[*,i,1,p]=smooth(std[*,i,1,p],10)
  endif
  if p eq 9 then yr=[-0.079,0.048]

 xra=[1,20]
 if p gt 10 then plot, tau,avg[*,09,0,p],xtitle='Optical thickness',xrange=xra,$
   ytitle='!9h!X!D'+string(p+1,format='(I2)')+'!N',yr=yr, xticklen=0.1,/nodata else $
   plot, tau,avg[*,14,0,p],xtickname=[' ',' ',' ',' ',' ',' '],xrange=xra,$
    ytitle='!9h!X!D'+string(p+1,format='(I2)')+'!N',yr=yr, xticklen=0.1,/nodata
 
  pl=avg[0:99,09,0,p]+std[0:99,09,0,p] & ml=avg[0:99,09,0,p]-std[0:99,09,0,p]
  lp=where(pl gt yr[1],nlp) & if nlp gt 0 then pl[lp]=yr[1]
  lm=where(ml lt yr[0],nlm) & if nlm gt 0 then ml[lm]=yr[0]
  polyfill,[tau[0:99],reverse(tau[0:99])],[ml,reverse(pl)],color=201,$
   clip=[1,yr[0],100,yr[1]],spacing=0.06,orientation=-45.
  oplot,tau,avg[*,09,0,p],thick=7
  pl=avg[0:99,09,1,p]+std[0:99,09,1,p] & ml=avg[0:99,09,1,p]-std[0:99,09,1,p] 
  lp=where(pl gt yr[1],nlp) & if nlp gt 0 then pl[lp]=yr[1] 
  lm=where(ml lt yr[0],nlm) & if nlm gt 0 then ml[lm]=yr[0]
  polyfill,[tau[0:99],reverse(tau[0:99])],[ml,reverse(pl)],color=201,$
   clip=[1,yr[0],100,yr[1]],spacing=0.08,orientation=45.
  oplot,tau,avg[*,09,1,p],linestyle=2,thick=7 
 
  pl=avg[0:99,19,0,p]+std[0:99,19,0,p] & ml=avg[0:99,19,0,p]-std[0:99,19,0,p] 
  lp=where(pl gt yr[1],nlp) & if nlp gt 0 then pl[lp]=yr[1]
  lm=where(ml lt yr[0],nlm) & if nlm gt 0 then ml[lm]=yr[0] 
  polyfill,[tau[0:99],reverse(tau[0:99])],[ml,reverse(pl)],color=71,$
   clip=[1,yr[0],100,yr[1]],spacing=0.06,orientation=-45.
  oplot,tau,avg[*,19,0,p],color=70,thick=7
  pl=avg[0:99,19,1,p]+std[0:99,19,1,p] & ml=avg[0:99,19,1,p]-std[0:99,19,1,p] 
  lp=where(pl gt yr[1],nlp) & if nlp gt 0 then pl[lp]=yr[1]
  lm=where(ml lt yr[0],nlm) & if nlm gt 0 then ml[lm]=yr[0] 
  polyfill,[tau[0:99],reverse(tau[0:99])],[ml,reverse(pl)],color=71,$
   clip=[1,yr[0],100,yr[1]],spacing=0.08,orientation=45.
  oplot,tau,avg[*,19,1,p],color=70,linestyle=2,thick=7

  pl=avg[0:99,29,0,p]+std[0:99,29,0,p] & ml=avg[0:99,29,0,p]-std[0:99,29,0,p] 
  lp=where(pl gt yr[1],nlp) & if nlp gt 0 then pl[lp]=yr[1]
  lm=where(ml lt yr[0],nlm) & if nlm gt 0 then ml[lm]=yr[0] 
  polyfill,[tau[0:99],reverse(tau[0:99])],[ml,reverse(pl)],color=251,$
   clip=[1,yr[0],100,yr[1]],spacing=0.06,orientation=-45.
  oplot,tau,avg[*,29,0,p],color=250,thick=7

;  pl=avg[0:99,29,1,p]+std[0:99,29,1,p] & ml=avg[0:99,29,1,p]-std[0:99,29,1,p] 
;  lp=where(pl gt yr[1],nlp) & if nlp gt 0 then pl[lp]=yr[1]
;  lm=where(ml lt yr[0],nlm) & if nlm gt 0 then ml[lm]=yr[0] 
;  polyfill,[tau[0:99],reverse(tau[0:99])],[ml,reverse(pl)],color=251,$
;   clip=[1,yr[0],100,yr[1]],spacing=0.08,orientation=45.
;  oplot,tau,avg[*,29,1,p],color=250,linestyle=2,thick=7

  legend,lls[p],box=0,position=pos[*,p],charsize=chs[p],/data
 endfor

 legend,['r!De!N=10 !9m!Xm','r!De!N=20 !9m!Xm','r!De!N=30 !9m!Xm','Liquid','Ice'],textcolors=[0,70,250,0,0],color=[255,255,255,0,0],linestyle=[0,0,0,0,2],pspacing=1.2,box=0,position=[0.8,0.2],/normal,charsize=2.6

 device, /close
 spawn, 'convert '+fp+'.ps '+fp+'.png'

stop
end
