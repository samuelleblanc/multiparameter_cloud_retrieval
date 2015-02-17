; program to plot the contours of ki squared fitting resulting from each iteration of the parameters
; presents the information for each parameter for one sample case

pro plot_kis

dir='/home/leblanc/SSFR3/plots/kisq/'
restore, '/home/leblanc/SSFR3/data/retrieved_kisq_model.out'
kp=kis_rtm
for p=1,14 do kp[*,*,*,*,p]=total(kis_rtm[*,*,*,*,0:p],5)

ii=ind[2,5,1] ; set reference index tau of 3 and ref of 15 for ice cloud

kk=reform(kp[ii,*,*,*,*])
taus=findgen(100)+1.
refs=findgen(50)+1.


; now set up plotting
if 0 then begin
fp=dir+'kis_sample'
print, 'making plot :'+fp
set_plot, 'ps'
 loadct, 39, /silent
 device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
 device, xsize=40, ysize=26
  !p.font=1 & !p.thick=5 & !p.charsize=4.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
  !p.multi=[0,4,4] & !x.margin=[6,1.5] & !y.margin=[0.155555,0.4] & !y.omargin=[3,1]

 for p=0, 14 do begin

  if p gt 10 then plot, findgen(10),xtitle='!9t!X',xrange=[1,100],ytitle='r!De!N (!9m!Xm)', xticklen=0.1,yr=[1,50],/nodata else $
   plot, findgen(10),xtickname=[' ',' ',' ',' ',' ',' '],xrange=[1,100],ytitle='r!De!N (!9m!Xm)', xticklen=0.1,yr=[1,50],/nodata

  lvls=10.^((findgen(5)-2.5)) ;6.^((findgen(15)-8.)/3.)
  lvls=[0.,lvls]
  lvls=[0.,0.01,0.05,0.1,1.0,5.0,15.,38.]
  clv=findgen(n_elements(lvls))*254/(n_elements(lvls)-1.)

  contour, kk[*,*,0,p], taus, refs, /overplot,levels=lvls,c_colors=clv
  contour, kk[*,*,1,p], taus, refs, /overplot,levels=lvls,c_linestyle=[2,2,2,2],c_colors=clv

  z=min(kk[*,*,*,p],m)
  im=array_indices(kk[*,*,*,p],m)
  if im[2] eq 0. then plots, taus[im[0]],refs[im[1]],psym=7,symsize=3 else plots, taus[im[0]],refs[im[1]],psym=1,symsize=3

  xyouts, 70,40,'!9h!X!D'+string(p+1,format='(I2)')+'!N',/data,charsize=2.4
  

 endfor

 legend,['Liquid','Ice'],textcolors=[0,0],color=[0,0],linestyle=[0,2],pspacing=1.2,box=0,position=[0.82,0.22],/normal,charsize=2.6
 legend,[' ',' '],textcolors=[0,0],color=[0,0],psym=[7,1],pspacing=1.2,box=0,position=[0.8,0.22],/normal,charsize=2.6
 
 contour, [[lvls],[lvls]],lvls,[0,1],/fill,levels=lvls,c_colors=clv,position=[0.78,0.1,0.97,0.12],/normal,xtitle='!9c!X!U2!N',ytickname=[' ',' ',' '],yticks=1,/noerase,/xlog,xr=[0.001,50],xticks=3


 device, /close
 spawn, 'convert '+fp+'.ps '+fp+'.png'
endif


if 1 then begin
fp=dir+'kis_bias'
print, 'making plot :'+fp
set_plot, 'ps'
 loadct, 39, /silent
 device, /encapsulated, /tt_font, set_font='Helvetica Bold',/color,bits_per_pixel=8., filename=fp+'.ps'
 device, xsize=40, ysize=40
  !p.font=1 & !p.thick=5 & !p.charsize=4.8 & !x.style=1 & !y.style=1 & !z.style=1 & !y.thick=1.8 & !x.thick=1.8
  !p.multi=[0,2,2] & !x.margin=[4,1] & !y.margin=[3,1] & !y.omargin=[0,0] & !x.omargin=[0,5]

diftau=float(ind)
difref=float(ind)
for t=0, 23 do diftau[t,*,*]=(tau_rtm[ind[t,*,*]]-tau[t])/tau[t]*100.
for r=0, 14 do difref[*,r,*]=(ref_rtm[ind[*,r,*]]-ref[r])/ref[r]*100.
lvls=[-100.-50.-10.-7.5,-5,-2.5,0,2.5,5.,7.5,10.,50.,100.]
clv=findgen(n_elements(lvls))*254/(n_elements(lvls)-1)
p=indgen(128)*2
s=intarr(128)+255
r=[s,reverse(p)] & g=[p,reverse(p)] & b=[p,s]
r[0]=0 & r[255]=255 & g[255]=255
tvlct,r,g,b

lvls=findgen(31)/30.*40.-20.

contour, diftau[0:17,*,0],tau[0:17],ref,/fill,levels=lvls, xtitle='!9t!X',ytitle='r!De!N (!9m!Xm)';,title='Liquid - !9Dt!X'
contour, diftau[0:17,*,1],tau[0:17],ref,/fill,levels=lvls, xtitle='!9t!X',ytitle='r!De!N (!9m!Xm)';,title='Ice - !9Dt!X'
contour, difref[0:17,*,0],tau[0:17],ref,/fill,levels=lvls, xtitle='!9t!X',ytitle='r!De!N (!9m!Xm)';,title='Liquid - !9D!Xr!De!N'
contour, difref[0:17,*,1],tau[0:17],ref,/fill,levels=lvls, xtitle='!9t!X',ytitle='r!De!N (!9m!Xm)';,title='Ice - !9D!Xr!De!N'

 contour,transpose([[lvls],[lvls]]),[0,1],lvls,levels=lvls,/cell_fill,ystyle=9,yticks=10,$
  ytickname=replicate(' ',11),position=[0.87,0.1,0.89,0.95],/normal,/noerase,xticks=1,xtickname=[' ',' ']
 axis,yaxis=1,ytitle='Difference (%)',yrange=[min(lvls),max(lvls)],yticks=10

 device, /close
 spawn, 'convert '+fp+'.ps '+fp+'.png'
endif


stop
end
