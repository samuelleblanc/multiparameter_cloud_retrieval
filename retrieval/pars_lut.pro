; program to compare parameters luts create via differente surface albedos

pro pars_lut,ief

dir='/home/leblanc/SSFR3/data/'

dir='/argus/roof/SSFR3/model/'
test=0
twowvl=0
snow=0
xplot=1
win=1

if win then dir='C:\Users\Samuel\Research\SSFR3\data\' else $
 dir='/argus/roof/SSFR3/model/'


if test eq 1 then begin
lbl=[$;'Pars_LUT_hires_20120524_test.out',$
;     'Pars_LUT_hires_20120804_test.out',$
;     'Pars_LUT_hires_20120812_test.out',$
;     'Pars_LUT_hires_20120820_test.out',$
;     'Pars_LUT_hires_20120913_test.out',$
     'Pars_LUT_hires_20130110_test2est.out',$
     'Pars_LUT_hires_20130111_test.out',$
;     'Pars_LUT_hires_win_test.out',$
     'Pars_LUT_hires_snow_test.out'];,$
;     'Pars_LUT_hires_high_test.out']
endif else begin
  if test eq 2 then begin
  lbl=[$;'Pars_LUT_hires_20120524_test2.out',$
   ;  'Pars_LUT_hires_20120804_test2.out',$
  ;   'Pars_LUT_hires_20120812_test2.out',$
 ;    'Pars_LUT_hires_20120820_test2.out',$
;     'Pars_LUT_hires_20120913_test2.out',$
     'Pars_LUT_hires_20130110_test2.out',$
     'Pars_LUT_hires_20130111_test2.out',$
;     'Pars_LUT_hires_win_test2.out',$
     'Pars_LUT_hires_snow_test2.out'] ;,$
;     'Pars_LUT_hires_high_test2.out']
  endif else begin
  if snow then begin
  lbl=['Pars_LUT_v4_hires4_20130110.out',$
     'Pars_LUT_v4_hires4_20130111.out',$
     'Pars_LUT_v4_hires4_snow.out']
  endif else begin
  lbl=['Pars_LUT_v4_hires4_20120524.out',$
     ;  'Pars_LUT_v4_hires4_20120804.out',$
       'Pars_LUT_v4_hires4_20120812.out',$
       'Pars_LUT_v4_hires4_20120820.out',$
       'Pars_LUT_v4_hires4_20120913.out',$
       'Pars_LUT_v4_hires4_20120525_win.out',$
       'Pars_LUT_v4_hires4_20120525_high.out',$ ;]
       'Pars_LUT_v4_hires4_20120525_low.out',$
       'Pars_LUT_v4_hires4_20120523_snd.out',$
       'Pars_LUT_v4_hires4_20120525_snd.out',$
       'Pars_LUT_v4_hires4_20120602_snd.out',$
      ; 'Pars_LUT_v4_hires4_20120806_snd.out',$
       'Pars_LUT_v4_hires4_20120813_snd.out',$
       'Pars_LUT_v4_hires4_20120816_snd.out',$
       'Pars_LUT_v4_hires4_20120820_snd.out',$
       'Pars_LUT_v4_hires4_20120824_snd.out',$
       'Pars_LUT_v4_hires4_20120912_snd.out']        
  endelse
  endelse
endelse
if twowvl then begin
  if snow then begin
  lbl=['Pars_LUT_hires_20130110_2wvl.out',$
     'Pars_LUT_hires_20130111_2wvl.out',$
     'Pars_LUT_hires_snow_2wvl.out']
  endif else begin
  lbl=['Pars_LUT_hires_20120524_2wvl.out',$
       'Pars_LUT_hires_20120804_2wvl.out',$
       'Pars_LUT_hires_20120812_2wvl.out',$
       'Pars_LUT_hires_20120820_2wvl.out',$
       'Pars_LUT_hires_20120913_2wvl.out',$
       'Pars_LUT_hires_win_2wvl.out',$
       'Pars_LUT_hires_high_2wvl.out']
  endelse
endif


if snow then begin
 lbl='Pars_LUT_'+['20130110','20130111']+'.out'
 ll=['20130110_snd','20130111_snd']
 lbl='Pars_LUT_'+ll+'_v6.out'
endif else begin
 lbl='Pars_LUT_'+['20120524','20120524_low','20120524_high','20120524_win',$
                  '20120804','20120820','20120523_snd','20120525_snd','20120602_snd',$
                  '20120806_snd','20120813_snd','20120816_snd','20120820_snd',$
                  '20120824_snd','20120912_snd']+'_v6.out'
 ll=['20120523_snd','20120525_snd','20120602_snd',$
     '20120806_snd','20120806_snd3','20120813_snd','20120816_snd','20120816_snd2','20120820_snd',$
                  '20120824_snd','20120824_snd2','20120912_snd']

 lbl='Pars_LUT_'+ll+'_v6.out'
endelse


restore, dir+lbl[0]
;save, par_hires, tau_hires,ref_hires, pars, taus, ref, wp

par=fltarr(n_elements(tau_hires),n_elements(ref_hires),n_elements(wp),n_elements(par_hires[0,0,0,*]),n_elements(lbl))

for i=0, n_elements(lbl)-1 do begin

  print, 'restoring '+lbl[i]
  restore, dir+lbl[i]
  par[*,*,*,*,i]=par_hires
endfor

;ief=8

std=par_hires*0.
mn=par_hires*0.
mx=par_hires*0.
avg=par_hires*0.
for t=0, n_elements(tau_hires)-1 do begin
  for r=0, n_elements(ref_hires)-1 do begin
    for w=0, n_elements(wp)-1 do begin
      for p=0, n_elements(par_hires[0,0,0,*])-1 do begin
        std[t,r,w,p]=stddev(par[t,r,w,p,*],/nan)
        mn[t,r,w,p]=min(par[t,r,w,p,*])
        mx[t,r,w,p]=max(par[t,r,w,p,*])
        avg[t,r,w,p]=par[t,r,w,p,ief] ;mean(par[t,r,w,p,*],/nan)
      endfor
    endfor
  endfor
endfor
;stop

if xplot then begin
  if win then set_plot, 'win' else set_plot, 'x'
  device, decomposed=0
  loadct, 39
  !p.multi=[0,4,4]
  w=0
  window, 0 , retain=2,xsize=1200, ysize=900
  !x.omargin=[0,0] &!p.charsize=2.0 & !y.omargin=[0,0]
  for r=0, n_elements(ref_hires)-1, 10 do begin
    for p=0, n_elements(par_hires[0,0,0,*])-1 do begin
      yr=[min([min(par[*,r,*,p,*]),min(avg[*,r,*,p])]),max([max(par[*,r,*,p,*]),max(avg[*,r,*,p])])]
      print, 'range',yr
      w=0
      plot, tau_hires, avg[*,r,w,p], xtitle='tau',ytitle='parameter',yrange=yr
      for i=0, n_elements(lbl)-1 do $
       oplot, tau_hires, par[*,r,w,p,i],linestyle=1,color=(i+1)*250/(n_elements(lbl))
      oplot, tau_hires, avg[*,r,w,p],thick=4.5
     ; oplot, tau_hires, avg[*,r,w,p]-par[*,r,w,p,0],linestyle=2
      ;oplot, tau_hires, par[*,r,w,p,0],psym=4
      w=1
      for i=0, n_elements(lbl)-1 do $
       oplot, tau_hires, par[*,r,w,p,i],linestyle=5,color=(i+1)*250/(n_elements(lbl))
      oplot, tau_hires, par[*,r,w,p,0], linestyle=5, thick=4.5
      legend,['P:'+string(p,format='(I2)')],box=0,/right, charsize=1.1
      if p eq 0 then legend,['Ice','Liquid'],linestyle=[1,5],pspacing=1.2,charsize=1.1,box=0,/bottom
    endfor
;   plot, findgen(10)
    legend,lbl, textcolors=(findgen(n_elements(lbl))+1)*250/(n_elements(lbl)),box=0, charsize=1.1;, position=[0.9,0.6],/normal
    xyouts, 0.5, 0.5, 'Reff='+string(ref_hires[r],format='(F5.2)')+'!4l!Xm',/normal,alignment=0.5

    img=tvrd(/true)
    write_png, dir+'pars_spread_ref'+string(ref_hires[r],format='(F05.2)')+'.png',img

    cursor,x,y
  endfor

  stop
endif

if snow then lbsn='_snow' else lbsn=''
lbsn=lbsn+'_'+ll[ief]
if test eq 1 then fn=dir+'pars_std'+lbsn+'_test.out' else $
 if test eq 2 then fn=dir+'pars_std'+lbsn+'_test2.out' else fn=dir+'pars_std_v6'+lbsn+'.out'
if twowvl then fn=dir+'pars_std'+lbsn+'_2wvl.out'
print, 'saving '+fn
save, std,avg,tau_hires,ref_hires,wp,filename=fn

stop


end
