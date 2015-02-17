; program to plot example of the different params
; plots the 8 different ones

@legend.pro
pro plot_params_ex

restore, '/argus/roof/SSFR3/model/sp_liq_ice_new3.out'
dir='/home/leblanc/SSFR3/plots/'

sp=sp[0,1,*,0]
dsp=smooth(deriv(zenlambda,sp),2)
wvl=zenlambda

;parameter 1
fp=dir+'mod_par01'
print, 'making plot :'+fp
set_plot, 'ps'
 loadct, 39, /silent
 device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
 device, xsize=20, ysize=20
  !p.font=1 & !p.thick=5 & !p.charsize=2.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
  !p.multi=0 & !x.margin=[8,4] & !y.margin=[4,4]

  plot,zenlambda, sp,title='Parameter 1!CDeviation from linear near 1000 nm',psym=-4,xtitle='Wavelength (nm)',ytitle='Normalized radiance',xrange=[960,1130],yr=[0,0.5]
  

nul=min(abs(zenlambda-1000.),io)
nul=min(abs(zenlambda-1077.),in)

ln=linfit(zenlambda[[io,in]],sp[[io,in]])
p1=total(sp[io:in]-(ln[0]+ln[1]*zenlambda[io:in]))
 
  oplot, zenlambda[io:in], (ln[0]+ln[1]*zenlambda[io:in]), color=50, psym=-4
  for i=io, in do oplot, zenlambda[[i,i]],[reform(sp[i]),(ln[0]+ln[1]*zenlambda[i])],color=250

  legend,['Original','Linear interpolation','Difference'],textcolors=[0,50,250],box=0,/right
device, /close
spawn,'convert '+fp+'.ps '+fp+'.png'


;parameter 2
fp=dir+'mod_par02'
print, 'making plot :'+fp
set_plot, 'ps'
 loadct, 39, /silent
 device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
 device, xsize=20, ysize=20
  !p.font=1 & !p.thick=5 & !p.charsize=2.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
  !p.multi=0 & !x.margin=[8,4] & !y.margin=[4,4]

  plot, wvl, dsp, title='Parameter 2!Cderivative at 1200 nm',xtitle='Wavelength (nm)',ytitle='Derivative', xrange=[1150.,1250],yrange=[-0.01,0.01]
  nul=min(abs(wvl-1193.),ii)
  oplot,wvl[[ii,ii]],[dsp[ii],dsp[ii]],psym=-2,color=250
  legend,['Derivative','point of measure'],textcolors=[0,250],box=0, /right

device, /close
spawn,'convert '+fp+'.ps '+fp+'.png'

;parameter 3
fp=dir+'mod_par03'
print, 'making plot :'+fp
set_plot, 'ps'
 loadct, 39, /silent
 device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
 device, xsize=20, ysize=20
  !p.font=1 & !p.thick=5 & !p.charsize=2.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
  !p.multi=0 & !x.margin=[8,4] & !y.margin=[4,4]

  plot, wvl, dsp, title='Parameter 3!Cderivative at 1500 nm',xtitle='Wavelength (nm)',ytitle='Derivative', xrange=[1450.,1550],yrange=[-0.01,0.01]
  nul=min(abs(wvl-1493.),ii)
  oplot,wvl[[ii,ii]],[dsp[ii],dsp[ii]],psym=-2,color=250
  legend,['Derivative','point of measure'],textcolors=[0,250],box=0, /right

device, /close
spawn,'convert '+fp+'.ps '+fp+'.png'

;parameter 4
fp=dir+'mod_par04'
print, 'making plot :'+fp
set_plot, 'ps'
 loadct, 39, /silent
 device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
 device, xsize=20, ysize=20
  !p.font=1 & !p.thick=5 & !p.charsize=2.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
  !p.multi=0 & !x.margin=[8,4] & !y.margin=[4,4]

  plot, wvl, sp, title='Parameter 4!Cratio at 1200 nm',xtitle='Wavelength (nm)',ytitle='Normalized radiance', xrange=[1150.,1300],yrange=[0,0.5]
  nul=min(abs(wvl-1203.),io)
  nul=min(abs(wvl-1236.),in)

  oplot,wvl[[io,io]],[0,sp[io]],psym=-2,color=250
  oplot,wvl[[in,in]],[0,sp[in]],psym=-2,color=200
  legend,['Radiance','Ratio - numerator','Ratio - denominator'],textcolors=[0,250,200],box=0, /right

device, /close
spawn,'convert '+fp+'.ps '+fp+'.png'

;parameter 5
fp=dir+'mod_par05'
print, 'making plot :'+fp
set_plot, 'ps'
 loadct, 39, /silent
 device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
 device, xsize=20, ysize=20
  !p.font=1 & !p.thick=5 & !p.charsize=2.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
  !p.multi=0 & !x.margin=[8,4] & !y.margin=[4,4]

  plot, wvl, sp, title='Parameter 5!Cmean at 1250 nm',xtitle='Wavelength (nm)',ytitle='Normalized radiance', xrange=[1150.,1300],yrange=[0,0.5]
  nul=min(abs(wvl-1248.),io)
  nul=min(abs(wvl-1270.),in)

  oplot,wvl[io:in],sp[io:in],color=250,thick=12
  legend,['Radiance','Region of mean'],textcolors=[0,250],box=0, /right

device, /close
spawn,'convert '+fp+'.ps '+fp+'.png'

;parameter 6
fp=dir+'mod_par06'
print, 'making plot :'+fp
set_plot, 'ps'
 loadct, 39, /silent
 device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
 device, xsize=20, ysize=20
  !p.font=1 & !p.thick=5 & !p.charsize=2.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
  !p.multi=0 & !x.margin=[8,4] & !y.margin=[4,4]

  plot, wvl, sp, title='Parameter 6!Cmean at 1600 nm',xtitle='Wavelength (nm)',ytitle='Normalized radiance', xrange=[1450.,1700],yrange=[0,0.5]
  nul=min(abs(wvl-1565.),io)
  nul=min(abs(wvl-1644.),in)

  oplot,wvl[io:in],sp[io:in],color=250,thick=12
  legend,['Radiance','Region of mean'],textcolors=[0,250],box=0, /right

device, /close
spawn,'convert '+fp+'.ps '+fp+'.png'

;parameter 7
fp=dir+'mod_par07'
print, 'making plot :'+fp
set_plot, 'ps'
 loadct, 39, /silent
 device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
 device, xsize=20, ysize=20
  !p.font=1 & !p.thick=5 & !p.charsize=2.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
  !p.multi=0 & !x.margin=[8,4] & !y.margin=[4,4]

  plot, wvl, sp, title='Parameter 7!Cmean at 1000 nm',xtitle='Wavelength (nm)',ytitle='Normalized radiance', xrange=[950.,1100],yrange=[0,0.5]
  nul=min(abs(wvl-1000.),io)
  nul=min(abs(wvl-1050.),in)


  oplot,wvl[io:in],sp[io:in],color=250,thick=12
  legend,['Radiance','Region of mean'],textcolors=[0,250],box=0, /right

device, /close
spawn,'convert '+fp+'.ps '+fp+'.png'

;parameter 8
fp=dir+'mod_par08'
print, 'making plot :'+fp
set_plot, 'ps'
 loadct, 39, /silent
 device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
 device, xsize=20, ysize=20
  !p.font=1 & !p.thick=5 & !p.charsize=2.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
  !p.multi=0 & !x.margin=[8,4] & !y.margin=[4,4]

  plot,zenlambda, sp,title='Parameter 8!Cdeviation from linear near 1550 nm',psym=-4,xtitle='Wavelength (nm)',ytitle='Normalized radiance',xrange=[1450,1650],yr=[0,0.5]


nul=min(abs(zenlambda-1493.),io)
nul=min(abs(zenlambda-1600.),in)

ln=linfit(zenlambda[[io,in]],sp[[io,in]])
p1=total(sp[io:in]-(ln[0]+ln[1]*zenlambda[io:in]))

  oplot, zenlambda[io:in], (ln[0]+ln[1]*zenlambda[io:in]), color=50, psym=-4
  for i=io, in do oplot, zenlambda[[i,i]],[reform(sp[i]),(ln[0]+ln[1]*zenlambda[i])],color=250

  legend,['Original','Linear interpolation','Difference'],textcolors=[0,50,250],box=0,/right
device, /close
spawn,'convert '+fp+'.ps '+fp+'.png'

;parameter 9
fp=dir+'mod_par09'
print, 'making plot :'+fp
set_plot, 'ps'
 loadct, 39, /silent
 device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
 device, xsize=20, ysize=20
  !p.font=1 & !p.thick=5 & !p.charsize=2.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
  !p.multi=0 & !x.margin=[8,4] & !y.margin=[4,4]

  plot,zenlambda, dsp,title='Parameter 9!CSlope of derivative near 1000 nm',psym=-4,xtitle='Wavelength (nm)',ytitle='Derivative',xrange=[950,1150],yr=[-0.002,0.002]


nul=min(abs(zenlambda-1000.),io)
nul=min(abs(zenlambda-1077.),in)

ln=linfit(zenlambda[io:in],dsp[io:in])

  oplot, zenlambda[io:in], (ln[0]+ln[1]*zenlambda[io:in]), color=50, psym=-4

  legend,['Derivative','Linear fit'],textcolors=[0,50],box=0,/right
device, /close
spawn,'convert '+fp+'.ps '+fp+'.png'

;parameter 10
fp=dir+'mod_par10'
print, 'making plot :'+fp
set_plot, 'ps'
 loadct, 39, /silent
 device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
 device, xsize=20, ysize=20
  !p.font=1 & !p.thick=5 & !p.charsize=2.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
  !p.multi=0 & !x.margin=[8,4] & !y.margin=[4,4]

  plot,zenlambda, dsp,title='Parameter 10!CSlope of derivative near 1200 nm',psym=-4,xtitle='Wavelength (nm)',ytitle='Derivative',xrange=[1150,1350],yr=[-0.002,0.002]


nul=min(abs(zenlambda-1200.),io)
nul=min(abs(zenlambda-1300.),in)

ln=linfit(zenlambda[io:in],dsp[io:in])

  oplot, zenlambda[io:in], (ln[0]+ln[1]*zenlambda[io:in]), color=50, psym=-4

  legend,['Derivative','Linear fit'],textcolors=[0,50],box=0,/right
device, /close
spawn,'convert '+fp+'.ps '+fp+'.png'


stop
end
