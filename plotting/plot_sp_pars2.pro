; program to plot a sample spectra with all the regions of each parameter highlighted
; uses measured spectra as based

pro plot_sp_pars

dir='/home/leblanc/SSFR3/data/'
dir='C:\Users\Samuel\Research\SSFR3\data\'

restore,dir+'20120525_sp_ex.out'
wvl=wl

fn=dir+'sp_pars2'
set_plot,'ps'
print, 'making plot :'+fn
loadct, 39, /silent
device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fn+'.ps'
device, xsize=20, ysize=20
 !p.font=1 & !p.thick=8 & !p.charsize=2.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
 !p.multi=0 & !x.margin=[7,3] &!x.omargin=[0,0]

 sp=sp/max(sp)

 plot, wvl,sp, xtitle='Wavelength (nm)',ytitle='Normalized radiance',xrange=[350.,1700.]
 clrs=findgen(15)/14.*254


;;;; part of program to put parameters in shading instead of colored
if 1 then begin
loadct, 0, /silent
  ;par 11
  polyfill, [550.,550.,680.,680.,550.],[0,0.91,0.91,0,0],color=230
  xyouts, 651., 0.89,'}',charsize=5.0,orientation=90,color=230,alignment=0.
  xyouts, 555., 0.95,'!9h!X!D11!N',color=200

  ;par7
  polyfill, [1000.,1000.,1050.,1050.,1000.],[0,0.75,0.75,0,0],color=244
  xyouts, 1041.,0.735,'}',charsize=2.2,orientation=90.,color=244,alignment=0.
  xyouts, 1000.,0.78,'!9h!X!D7!N',color=200
  ;par9
  polyfill, [1000.,1000.,1077.,1077.,1000.],[0,0.65,0.65,0,0],color=230
  xyouts, 1061.,0.63,'}',charsize=3.2,orientation=90.,color=230,alignment=0.
  xyouts, 1018.,0.68,'!9h!X!D9!N',color=200
  ;par1
  polyfill, [1000.,1000.,1077.,1077.,1000.],[0,0.55,0.55,0,0],color=215
  xyouts, 1061.,0.53,'}',charsize=3.2,orientation=90.,color=215,alignment=0.
  xyouts, 1018.,0.58,'!9h!X!D1!N',color=200
  ;par 13
  plots,[1000.,1000.,1032.,1065.,1065.],[0.,0.465,0.485,0.465,0.],color=180
  xyouts, 1012.,0.495,'!9h!X!D13!N',color=180
  ;par 12
  plots,[1040.,1040.],[0.,0.395],color=150
  xyouts, 1006.,0.415,'!9h!X!D12!N',color=150

  ;par 14
  plots,[600.,600.,735.,870.,870.],[0.,0.85,0.88,0.85,0.],color=200
  xyouts, 712.,0.9,'!9h!X!D14!N',color=200

  ;par5
  polyfill, [1248.,1248.,1270.,1270.,1248.],[0,0.45,0.45,0,0],color=240
  xyouts, 1225.,0.468,'!9h!X!D5!N',color=200
  ;par 10
  polyfill, [1200.,1200.,1300.,1300.,1200.],[0,0.35,0.35,0,0],color=215
  xyouts, 1278.,0.335,'}',charsize=4.0,orientation=90,color=215,alignment=0.
  xyouts, 1208.,0.388,'!9h!X!D10!N',color=215
  ;par4
  plots,[1200.,1200.,1219.,1237.,1237.],[0.,0.24,0.26,0.24,0.],color=150
  xyouts, 1198.,0.28,'!9h!X!D4!N',color=150
  ;par2 
  plots,[1193.,1193.],[0,0.53],color=100
  xyouts,1174.,0.55,'!9h!X!D2!N',color=150

  ;par 15
  polyfill, [1565.,1565.,1634.,1634.,1565.],[0,0.33,0.33,0,0],color=244
  xyouts, 1620.,0.320,'}',charsize=2.9,orientation=90,color=244,alignment=0.
  xyouts, 1570.,0.36,'!9h!X!D15!N',color=200
  ;par 6
  polyfill, [1565.,1565.,1644.,1644.,1565.],[0,0.23,0.23,0,0],color=230
  xyouts, 1626.,0.220,'}',charsize=2.97,orientation=90,color=230,alignment=0.
  xyouts, 1580.,0.26,'!9h!X!D6!N',color=200
  ;par8
  polyfill, [1493.,1493.,1600.,1600.,1493.],[0,0.15,0.15,0,0],color=215
  xyouts, 1578.,0.135,'}',charsize=4.2,orientation=90,color=215,alignment=0.
  xyouts, 1508.,0.188,'!9h!X!D8!N',color=200
  ;par3
  plots, [1492,1492],[0,0.3],color=150
  xyouts,1477.,0.32,'!9h!X!D3!N',color=200

  oplot, wvl,sp
endif else begin

;par 1
 nul=min(abs(wvl-1000.),i01)
 nul=min(abs(wvl-1100.),i11)
 oplot, wvl[i01:i11],sp[i01:i11],color=clrs[0],thick=120 ;psym=7,color=clrs[0], symsize=2
 oplot, wvl[i01:i11],sp[i01:i11],color=255,thick=15
;par 2
 nul=min(abs(wvl-1200.),id2)
 plots,wvl[id2],sp[id2],psym=1,color=clrs[1],symsize=2

;par 3
 nul=min(abs(wvl-1500.),id3)
 plots,wvl[id3],sp[id3],psym=1,color=clrs[2],symsize=2

;par 4
 nul=min(abs(wvl-1200.),i04) 
 nul=min(abs(wvl-1237.),i14)
 plots, wvl[i04],sp[i04],psym=7,color=clrs[3],symsize=2
 plots, wvl[i14],sp[i14],psym=7,color=clrs[3],symsize=2

;par 5
 nul=min(abs(wvl-1245.),i05)
 nul=min(abs(wvl-1270.),i15) 
 oplot, wvl[i05:i15],sp[i05:i15], thick=90,color=clrs[4]

;par 6
 nul=min(abs(wvl-1565.),i06)
 nul=min(abs(wvl-1640.),i16)  
 oplot, wvl[i06:i16],sp[i06:i16], thick=90,color=clrs[5] 

;par 7
 nul=min(abs(wvl-1000.),i07)
 nul=min(abs(wvl-1050.),i17)  
 oplot, wvl[i07:i17],sp[i07:i17], thick=80,color=clrs[6]

;par 8
 nul=min(abs(wvl-1490.),i08)
 nul=min(abs(wvl-1600.),i18) 
 oplot, wvl[i08:i18],sp[i08:i18], thick=50,color=clrs[7]

;par 9
 nul=min(abs(wvl-1000.),i09)
 nul=min(abs(wvl-1080.),i19) 
 oplot, wvl[i09:i19],sp[i09:i19], thick=40,color=clrs[8]

;par 10
 nul=min(abs(wvl-1200.),i010)
 nul=min(abs(wvl-1310.),i110) 
 oplot, wvl[i010:i110],sp[i010:i110], thick=50,color=clrs[9]

;par 11
 nul=min(abs(wvl-550.),i011)
 nul=min(abs(wvl-680.),i111)
 ll=linfit(wvl[i011:i111],sp[i011:i111]) 
 oplot, wvl[i011:i111],ll[0]+ll[1]*wvl[i011:i111], thick=80,color=clrs[10]

;par 12
 nul=min(abs(wvl-1000.),id12) 
 plots,wvl[id12],sp[id12],psym=1,color=clrs[11]

;par 13
 nul=min(abs(wvl-1040.),id13)
 plots,wvl[id13],sp[id13],psym=1,color=clrs[12]

;par 14 
 nul=min(abs(wvl-1065.),id14)
 plots,wvl[id14],sp[id14],psym=1,color=clrs[13]

;par 15 
 nul=min(abs(wvl-1565.),i015)
 nul=min(abs(wvl-1634.),i115)
 lv=linfit(wvl[i015:i115],sp[i015:i115])
 oplot,wvl[i015:i115],lv[0]+lv[1]*wvl[i015:i115],thick=50,color=clrs[14]

 oplot,wvl,sp
 plots,wvl[id2],sp[id2],psym=1,color=clrs[1],symsize=2
 plots,wvl[id3],sp[id3],psym=1,color=clrs[2],symsize=2
 plots, wvl[i04],sp[i04],psym=7,color=clrs[3],symsize=2
 plots, wvl[i14],sp[i14],psym=7,color=clrs[3],symsize=2
 plots,wvl[id12],sp[id12],psym=1,color=clrs[11],symsize=2.3
 plots,wvl[id13],sp[id13],psym=1,color=clrs[12],symsize=2.3
 plots,wvl[id14],sp[id14],psym=1,color=clrs[13],symsize=2.3

neta="150B ;'"
estr='!9'+string(neta)+'!X'
legend,estr+'='+string(indgen(15)+1,format='(I2)'),textcolors=clrs,box=0,/right,charsize=1.8
endelse

device, /close
spawn, 'convert "'+fn+'.ps" "'+fn+'.png"'
stop
end
