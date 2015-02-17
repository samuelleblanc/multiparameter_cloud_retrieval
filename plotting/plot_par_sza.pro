; program to plto the change in parameters due to a change in sza

pro plot_par_sza

dir='C:\Users\Samuel\Research\SSFR3\'
fp=dir+'data\par_std_sza_v1_20120525.out'
restore, fp

fp=dir+'plots\new\par_sza2'
print, 'making plot :'+fp
set_plot, 'ps'
 loadct, 39, /silent
 device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
 device, xsize=30, ysize=15
  !p.font=1 & !p.thick=7 & !p.charsize=3.0 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
  !p.multi=[0,2,1] & !x.margin=[5,1] & !y.margin=[3,1] & !y.omargin=[0,0] & !x.omargin=[0.2,0.2]

  tvlct, 0,150,0,150
  tvlct, 200,100,0,201
  tvlct, 200,0,200,202

  yr=[-1.60,-1.20]

  sl='r!De!N='+['10','30']+' !9m!Xm'

  

  plot, taus, pars[*,9,0,10,0], ytitle='!9h!X!D11!N',xtitle='Optical thickness',yr=yr,/nodata

  oplot,taus, pars[*,9,0,10,0],color=150
  oplot,taus, pars[*,9,1,10,0],linestyle=2,color=150

  oplot,taus, pars[*,9,0,10,2],color=201
  oplot,taus, pars[*,9,1,10,2],linestyle=2,color=201

  oplot,taus, pars[*,9,0,10,3],color=202
  oplot,taus, pars[*,9,1,10,3],linestyle=2,color=202

  legend,[sl[0],'sza=53!Uo!N','sza=46!Uo!N','sza=41!Uo!N'],$
   textcolor=[0,150,201,202],box=0,charsize=2.2,/bottom
  legend,['ice','liquid'],box=0,charsize=2.2,pspacing=1.2,/bottom,/right,linestyle=[2,0]

  plot, taus, pars[*,29,0,10,0], ytitle='!9h!X!D11!N',xtitle='Optical thickness',yr=yr,/nodata
  oplot,taus, pars[*,29,0,10,0] ,color=150
  oplot,taus, pars[*,29,1,10,0],linestyle=2,color=150
  
  oplot,taus, pars[*,29,0,10,2],color=201
  oplot,taus, pars[*,29,1,10,2],linestyle=2,color=201 
 
  oplot,taus, pars[*,29,0,10,3],color=202
  oplot,taus, pars[*,29,1,10,3],linestyle=2,color=202
 ; legend,[sl[1],'sza=53!Uo!N','sza=46!Uo!N','sza=41!Uo!N','ice','liquid'],color=[255,255,255,255,0,0],$
 ;  textcolor=[0,150,201,202,0,0],linestyle=[0,0,0,0,2,0],pspacing=1.2,box=0,charsize=2.0,/bottom 
  legend,[sl[1],' ',' ',' '],textcolor=[0,255,255,255],box=0,charsize=2.2,/bottom


 device, /close
 spawn, 'convert '+fp+'.ps '+fp+'.png'

stop
end
