; program to retrieve optical depth, effective radius, and phase using ki squared technique

;@get_params3.pro
;@get_params.pro
@get_params4.pro
@zensun.pro
@make_meas_std.pro
pro retrieve_kisq,model=model,date,sav=sav

indiv=0 ; use the phase seperated calculated normalization, or the entire lut
umu=1 ;use the sza defined parameters
win=1
xplot=0
if keyword_set(sav) then xplot=1
stops=1
norma=0

if n_elements(model) lt 1 then model=0 else model=1
if n_elements(date) lt 1 then date='20120525'

if date eq '20130110' then winter=1 else winter=0

vv='_v7'

if win then dir='C:\Users\Samuel\Research\SSFR3\' else $
 dir='/home/leblanc/SSFR3/'

ps=[2,3,5,6,7,11,12,14]-1

if xplot then begin
  if date eq '20120806' then nl='_3' else nl=''
  if date eq '20120824' then nl='_2'
  ;restore, 'C:\Users\Samuel\Research\SSFR3\model\hires6\sp_hires6_'+date+'_snd'+nl+'.out'
  restore, 'C:\Users\Samuel\Research\SSFR3\model\v1\sp_v1_'+date+nl+'.out'
  ;if date eq '20120523' or date eq '20120525' then sza=50.
  ;if date eq '20120816' then sp=sp*1000.  

  spm=sp
  wvlm=zenlambda
  taum=tau
  refm=ref
endif

lat=40.00
lon=-105.26
doy=julian_day(float(strmid(date,0,4)),float(strmid(date,4,2)),float(strmid(date,6,2)))


;restore files to use with make_meas_std
print, 'restoring files for make_meas_std'
restore, dir+'data\dark_sample.out'; '/home/leblanc/SSFR3/data/dark_sample.out'
dark_s={z_dk:z_dk[0:100,*],zenlambda:zenlambda} ;only a subset of all the darks
restore, dir+'data\resps.out' ;'/home/leblanc/SSFR3/data/resps.out'
resps={zenlambda:zenlambda,zresp1:zresp1,zresp2:zresp2,zresp3:zresp3,zresp4:zresp4}

load_sp,wvl,tmhrs,date,win,fl,num,model,zspectra=zspectra,spectram=spectram

if not umu then begin
  if date eq '20130110' or date eq '20130111' and 0 then sno='_snow' else sno='_snd'
  if date eq '20120806' then sno=sno+'3'
  if date eq '20120824' then sno=sno+'2'
  if win then fn='C:\Users\Samuel\Research\SSFR3\data\Pars_std_meas_lut_v6_'+date+sno+'.out' else $
  ;'C:\Users\Samuel\Research\SSFR3\data\Pars_std_meas_lut'+sno+'.out' else $
  ;'C:\Users\Samuel\Research\SSFR3\data\Pars_std_meas_lut_'+lbl+sno+'.out'
   fn='/home/leblanc/SSFR3/data/Pars_std_meas_lut'+sno+'_v4.out' ;'/argus/roof/SSFR3/model/pars_std_v3'+sno+'.out'
  print, 'restoring lut file: '+fn
  restore, fn
  taus=tau_hires[0:99] & refs=ref_hires & avg=avg[0:99,*,*,*] & std=std[0:99,*,*,*] & wp=[0,1]
endif else begin
;  fn='C:\Users\Samuel\Research\SSFR3\data\par_sza_'+date+'.out' 
   fn='C:\Users\Samuel\Research\SSFR3\data\par_sza_v1_'+date+'.out'
;  fn='/home/leblanc/SSFR3/data/Pars_std_meas_lut'+sno+'_v4.out'
    print, 'restoring SZA lut file: '+fn
   restore, fn
   ;wp=[0,1]
endelse

tau_rtm=fltarr(num)
tau_err=fltarr(num,2)
ref_rtm=fltarr(num)
ref_err=fltarr(num,2)
wp_rtm=fltarr(num)
wp_err=fltarr(num)
ki_rtm=fltarr(num)
if model then kis_rtm=fltarr(num,n_elements(taus),n_elements(refs),n_elements(wp),n_elements(pars[0,0,0,*,0]))


if not umu then begin
  ; normalize the lut so that each parameter goes from 0 to 1
  avgn=normalize(avg,co=co,ad=ad)
  stdn=normalize_std(std,co,ad)

  avgn[*,0:9,1,*]=!values.f_nan
  avgn[*,31:*,0,*]=!values.f_nan
  arr=avgn

  ; build the slopes of the lut
  slopes=laplace(arr,taus,refs)
  ;save, slopes, taus, refs, wp, filename='C:\Users\Samuel\Research\SSFR3\Data\slopes.out'
  ;stop
  
  ;build the weights
  ;sa=abs(stdn/slopes)*avgn^2
  ;wn=fltarr(15)
  ;for p=0,14 do wn[p]=max(sa[*,*,*,p])
  ;for p=0,14 do sa[*,*,*,p]=sa[*,*,*,p]/wn[p] 
endif else begin
  avgn=pars & avgnn=pars
  con=fltarr(16,n_elements(mu))
  adn=fltarr(16,n_elements(mu))
  for u=0, n_elements(mu)-1 do begin
    avgnn[*,*,*,*,u]=normalize(pars[*,*,*,*,u],co=co,ad=ad)
    avgn[*,*,*,*,u]=pars[*,*,*,*,u] 
    con[*,u]=co & adn[*,u]=ad
  endfor
  if norma then a=avgnn else a=avgn
  delt=derivt(a,taus,refs)
  delr=derivr(a,taus,refs)
;stop
endelse

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; loop start
if model then di=1 else di=30
for i=0, num-1,di do begin ;time loop

  if model then sp=reform(spectram[i,*]) else sp=zspectra[*,fl[i]]
  if model then begin
    n=where(i eq ind)
    print, array_indices(ind,n)
  endif 

 ; if date eq '20120806' then sp[194:*]=sp[194:*]*0.96
  zensun,doy,tmhrs[fl[i]],lat,lon,sza 
  mm=cos(sza*!dtor)  
  if umu then begin
    nul=min(abs(mu-mm),uu)
    co=con[*,uu] & ad=adn[*,uu]
  endif
 ;  get_params,wvl,sp,par
 ; parn=normalize_par(par,co,ad)

    ; now get the measurement uncertainty in the parameters
  make_meas_std,sp,wvl,pstd1,dark_s=dark_s,resps=resps,win=winter,par=par,norm=norma,co=co,ad=ad,weight=wmatrix
  
  parn=par & parnn=normalize_par(par,co,ad)
  if norma then parn=parnn
  if not finite(total(par)) then message, 'pars not finite'
  if not finite(total(pstd1)) then message, 'pars std not finite'

  ; run first to get phase
  if umu then begin
    if norma then arr=avgnn[*,*,*,*,uu] else arr=avgn[*,*,*,*,uu]
    stdn=arr*0. & slopes=arr*1.
  endif else arr=avgn
    ; make new pstd
  make_pstd,arr,pstd2
  pstd=sqrt(pstd1^2.+pstd2^2.)

  ki=kisq_std_all(parn,arr,stdn,slopes,weight=1./pstd);/norm);,weight=sts)
  nul=min(ki,m,/nan)
  im=array_indices(ki,m)
  wp_rtm[i]=wp[im[2]]
  ;if not finite(total(ki)) and umu then message, 'ki first run not finite'
  ;print, 'first run values, t,r:',taus[im[0]],refs[im[1]]
  ;check if ice and liquid kisq are close together
  ml=min(ki[*,*,0],/nan)
  mi=min(ki[*,*,1],/nan)

;  if im[2] eq 1 and ml lt mi*1.2 then stop
;  if im[2] eq 0 and mi lt ml*1.2 then stop

  ; now get the measurement uncertainty in the parameters
 ; make_meas_std,sp,wvl,pstd,dark_s=dark_s,resps=resps,win=winter

  if im[2] eq 0 then begin ; for liquid
    ; subset the array for liquid 
    ; only use up to 30 microns
    arrl=reform(arr[*,0:29,0,*])
    rr=refs[0:29] & rrs=rr
    arrln=arrl ;normalize(arrl,co=col,ad=adl)
    ;arrlnn=normalize(arrl,co=col,ad=adl)
    parnl=parn 
    parnln=parnn ; normalize_par(parn,col,adl)
  ;  parnln=normalize_par(parn,col,adl)
    if norma then arrl=arrln
    if norma then parnl=parnln

    if indiv then begin
      arr=arrl
      parn=parnl
    endif
    ;plims,parnl,arrl,psl
    psl=where(parnln[0:14]+pstd1[0:14] ge 0.00 and parnln[0:14]-pstd1[0:14] le 1.00,nps) 
    ;psl=where(parnln[0:14],nps)
    ;if nps lt 5 then stop

    ss=reform(stdn[*,0:29,0,*])
    sls=reform(slopes[*,0:29,0,*])
    ;ww=reform(sts[*,0:29,0,*])
    ; get the coefficient and addition values for each parameter range
    make_pstd,arrl,pstd2,cov=comat
    pstd=sqrt(pstd1^2.+pstd2^2.)
    ps1=sqrt(pstd1)/co
    pstd=ps1
    ;pstd=1./abs(co);sqrt(sqrt(arrl*arrl))
    ;pstd=comat
    ;pstd=1./sqrt(wmatrix*wmatrix)
    ;pstd=1./comat ;sqrt(comat*comat)
    ki=kisq_std(parnl,arrl,ss,sls,kis=kis,weight=1./pstd,psub=psl);,/matrix);,/ww);/norm);,weight=ww)
    ;kil=kisq_std(par,reform(avg[*,0:29,0,*]),ss,sls,weight=1.,kis=kl)
    x=get_min(kis,taus,rr,wp_rtm[i],/old,xplot=xplot,kisq_old=kl,flag=flag,kin=ki)
    ki_rtm[i]=min(ki,n)
    ;if flag then ki_rtm[i]=min(kil,n)
    tau_rtm[i]=x[0]
    ref_rtm[i]=x[1]

    ;now get uncertainties
    ;er=get_err(parnl,arrl,pstd,taus,rr,co,ad,psub=[1,2,3,4,11,12,13,14]-1)
    ;er=uncert(reform(delr[x[0]-1,x[1]-1,0,*,uu]),reform(delt[x[0]-1,x[1]-1,0,*,uu]),pstd1,psub=psl)
    er=kisq_err(parnl,arrl,pstd1,taus,rr,psub=psl,weight=1./pstd)
    if model then kis_rtm[i,*,0:29,0,*]=kis
  endif else begin  ;for ice
    ; subset the array for ice
    ; only use from 10 microns
    arri=reform(arr[*,9:*,1,*])
    rri=refs[9:*] & rrs=rri

    arrin=normalize(arri,co=coi,ad=adi)
    parni=parn & parnin=normalize_par(parn,coi,adi)
    if norma then arri=arrin
    if norma then parni=parnin

    if indiv then begin
      arr=arri
      arni=parn
    endif
;    psl=where(parni[0:14],nps) ;where(parni ge 0.02 and parni le 0.98,nps)
;    psl=[0,1,2,3,4,5,6,8,9,10,11,12,13,14]
    ;plims,parni,arri,psl
    psl=where(parnin[0:14]+pstd1[0:14] ge 0.00 and parnin[0:14]-pstd1[0:14] le 1.00,nps)
    ;psl=where(parnin[0:14], nps)
    ;if nps lt 5 then stop
;stop
    ;ss=reform(std[*,9:*,1,*,uu]) 
    ss=reform(stdn[*,9:*,1,*])
    sls=reform(slopes[*,9:*,1,*])
    ;ww=reform(sts[*,5:*,1,*])
    make_pstd,arri,pstd2,cov=comat
    pstd=sqrt(pstd1^2.+pstd2^2.)
   ; pstd=(pstd1^0.5+pstd2)^2.
    ;pstd=comat
    ;pstd=1./abs(co)
    ps1=sqrt(pstd1)/co
    pstd=ps1
    ki=kisq_std(parni,arri,ss,sls,kis=kis,weight=1./pstd,psub=psl);,/matrix);,/ww);/norm);,weight=ww)
    ;kil=kisq_std(par,reform(avg[*,5:*,1,*]),ss,sls,weight=1.,kis=kl)
    x=get_min(kis,taus,rri,wp_rtm[i],/old,xplot=xplot,kisq_old=kl,flag=flag,kin=ki)
    ki_rtm[i]=min(ki,n)
    ;if flag then ki_rtm[i]=min(kil,n)
    tau_rtm[i]=x[0]
    ref_rtm[i]=x(1) 
   
    ;now get uncertainties
    ;er=get_err(parni,arri,pstd,taus,rri,co,ad,psub=[1,2,3,4,11,12,13,14]-1)
    ;er=uncert(reform(delr[x[0]-1,x[1]-1,1,*,uu]),reform(delt[x[0]-1,x[1]-1,1,*,uu]),pstd1,psub=psl)
    er=kisq_err(parni,arri,pstd1,taus,rri,psub=psl,weight=1./pstd)
   if model then kis_rtm[i,*,9:*,1,*]=kis
  endelse
if flag then stops=1 else stops=0
  ; for error
;  nul=min(kierp,nrp)
;  inp=array_indices(kierp,nrp) 
;  nul=min(kierm,nrm)
;  inm=array_indices(kierm,nrm)

  tau_err[i,*]=er[0] ;[taus[min([inp[0],inm[0]])],taus[max([inp[0],inm[0]])]]
  ref_err[i,*]=er[1] ;[refs[min([inp[1],inm[1]])],refs[max([inp[1],inm[1]])]]
  wp_err[i]=0. ;total(ki[*,*,1],/nan)/total(ki,/nan)

  if umu then print, i,'/',num,ki_rtm[i],tau_rtm[i],ref_rtm[i],wp_rtm[i],mu[uu],n_elements(psl),er else $
   print, i,'/',num,ki_rtm[i],tau_rtm[i],ref_rtm[i],wp_rtm[i],n_elements(psl),er

  doy=julian_day(strmid(date,0,4),strmid(date,4,2),strmid(6,2))
  zensun,doy,tmhrs[fl[i]],40.0,-105.15,szat
if keyword_set(sav) then begin
;  if abs(szat-sza) lt 0.4 or stops and i gt 750 then begin
    tau=tau_rtm[i] & ref=ref_rtm[i] & w=wp_rtm[i]
     ki=kisq_std_all(parn,avgn,stdn,slopes,weight=1./pstd,/nophase)
     ut=tmhrs[fl[i]]
stop
    print, 'saving'
    save, ki, sp, ut,i,par,wvl,taus,refs,tau,ref,w,wvlm,taum,refm,spm,filename=dir+'data\sample_kisq5_'+date+'.out'
    xplot=1
;  endif else xplot=0
endif


  if xplot then begin
    if umu then avg=pars[*,*,*,*,uu]
    window,1
    plot, zenlambda, sp
    nul=min(abs(taum-x[0]),tt)
    nul=min(abs(refm-x[1]),rr)
    doy=julian_day(strmid(date,0,4),strmid(date,4,2),strmid(6,2))
    zensun,doy,tmhrs[fl[i]],40.0,-105.15,szat
    ff=cos(szat*!dtor)/cos(sza*!dtor)
    oplot, wvlm,smooth(spm[tt,rr,*,wp_rtm[i]]*ff,2),color=250
    window,3
    spp=interpol(smooth(spm[tt,rr,*,wp_rtm[i]]*ff,2), wvlm,zenlambda)
    plot, zenlambda, (sp-spp)/sp*100. ,yr=[-50,50],title='i:'+strtrim(i/30,2)+' utc:'+strtrim(tmhrs[fl[i]],2)
    oplot,zenlambda, zenlambda*0.,linestyle=2
  if 0 then begin
    window, 2, xsiz=900,ysiz=800
    !p.multi=[0,4,4]
    for p=0,15 do begin
      plot, taus,avg[*,9,im[2],p], xtit='tau',yr=[min(avg[*,*,im[2],p],/nan),max(avg[*,*,im[2],p],/nan)],/ysty
      oplot,taus,avg[*,14,im[2],p],color=50
      oplot,taus,avg[*,19,im[2],p],color=100
      oplot,taus,avg[*,24,im[2],p],color=180
      oplot,taus,avg[*,29,im[2],p],color=240
      oplot,taus,avg[*,40,im[2],p],color=220
      oplot,taus,avg[*,14,0,p],color=50,linestyle=2
      oplot,taus,avg[*,19,0,p],color=100,linestyle=2
      oplot,taus,avg[*,24,0,p],color=180,linestyle=2
      oplot,taus,avg[*,29,0,p],color=240,linestyle=2
      oplot,taus,avg[*,40,0,p],color=220,linestyle=2

      oplot,[0,100],[par[p],par[p]],linestyle=2
      oplot,[tau_rtm[i],tau_rtm[i]],[min(avg[*,*,im[2],p],/nan),max(avg[*,*,im[2],p],/nan)],linestyle=2
      oplot,taus,avg[*,x[1]-1,im[2],p],thick=2
    endfor   
  endif
    wait,0.5
    ;stop
  endif
if model then stop
endfor ;end of time loop

if not model then begin
  is=indgen(num)
  kl=where(is mod 30 eq 0)
  ki_rtm=ki_rtm[kl] & tau_rtm=tau_rtm[kl] & ref_rtm=ref_rtm[kl] & wp_rtm=wp_rtm[kl] & tmhrs=tmhrs[fl[kl]]
  tau_err=tau_err[kl,*] & ref_err=ref_err[kl,*] & wp_err=wp_err[kl]
endif


if model then begin
  set_plot, 'win'
  device, decomposed=0
  loadct,39
  window, 0,xsize=900,ysize=800
  !p.multi=[0,2,2]
  plot, tau,tau_rtm[ind[*,0,0]],tit='liquid',xtit='tau',ytit='retrieved tau',yr=[0,100]
  for t=1,19 do oplot, tau,tau_rtm[ind[*,t,0]],color=t*12
  plot, tau,tau_rtm[ind[*,0,1]],tit='ice',xtit='tau',ytit='retrieved tau',yr=[0,100]
  for t=1,19 do oplot, tau,tau_rtm[ind[*,t,1]],color=t*12
  plot, ref,ref_rtm[ind[0,*,0]],tit='liquid',xtit='ref',ytit='retrieved ref',yr=[0,50]
  for t=1,18 do oplot, ref,ref_rtm[ind[t,*,0]],color=t*12
  plot, ref,ref_rtm[ind[0,*,1]],tit='ice',xtit='ref',ytit='retrieved ref',yr=[0,50]
  for t=1,18 do oplot, ref,ref_rtm[ind[t,*,1]],color=t*12
stop
endif

vv='_v9'
if model then md='model' else md=date
if win then fn=dir+'data\retrieved_kisq_'+md+vv+'.out' else $
 fn=dir+'data/retrieved_kisq_'+md+vv+'.out'
print, 'saving data to: '+fn
if model then save, tau_rtm, ref_rtm, wp_rtm, ki_rtm, tau,ref,wp,ind, kis_rtm, ref_err,tau_err,wp_err,filename=fn else $
 save, tau_rtm, ref_rtm, wp_rtm, ki_rtm, tmhrs, ref_err,tau_err,wp_err,filename=fn

stop
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; function to get the tau and ref associated with the minimum kisq
function get_min,kisq,tau,ref,wp,old=old,xplot=xplot,kisq_old=kisq_old,flag=flag,kin=ki
  liq=0 & ice=0
  if n_elements(ref) eq 30 then liq=1 else ice=1
  if n_elements(xplot) lt 1 then xplot=0
  if n_elements(ki) lt 1 then ki=total(kisq,3)
  if n_elements(old) lt 1 then begin
    ts=fltarr(15) & rs=fltarr(15)
    for p=0,14 do begin
      z=min(kisq[*,*,p],n)
      in=array_indices(kisq[*,*,p],n)
      ts[p]=tau[in[0]]
      rs[p]=ref[in[1]]
    endfor
    if wp eq 0 then pp=[0,2,4,5,6,7,8,9,10,11,12,13,14] else pp=indgen(15)
    t=mean(ts[pp])
    r=mean(rs[pp])
  endif else begin
    z=min(ki,n,/nan)
    in=array_indices(ki,n)
    t=tau[in[0]]
    r=ref[in[1]]
  endelse
if 0 then begin
if liq then begin
if r eq 30. or r eq 1. then begin
  ki=total(kisq[*,*,[0,2,4,5,7,10,11,14]],3)
  z=min(ki,n,/nan)
  in=array_indices(ki,n)
  t=tau[in[0]]
  r=ref[in[1]]
  flag=1
endif else flag=0
endif else flag=0

if ice then begin
flag=0
if r eq 50. or t lt 5. then begin
  ki=total(kisq[*,*,[0,1,2,3,7,8,11,14]],3)
  z=min(ki,n,/nan)
  in=array_indices(ki,n)
  t=tau[in[0]]
  r=ref[in[1]]
  flag=1 
endif
if r le 10. then begin
  kk=ki*0.
  for ir=0,5 do kk[*,ir]=0.1-float(ir)/5.*0.05
  ki=ki+kk
    z=min(ki,n,/nan) 
  in=array_indices(ki,n)
  t=tau[in[0]] 
  r=ref[in[1]] 
  flag=1  
endif
endif
endif else flag=0

  if xplot then begin
    set_plot,'win'
    !p.multi=0
    window,0
    device, decomposed=0
    loadct, 39,/silent
    contour, ki, tau, ref,nlevels=30,c_colors=findgen(30)*8.4,min_value=0.,max_value=0.8
    plots, t,r,psym=6 
    
    kk=ki
    z=min(kk,n)
    kk[n]=0.5
    z=min(kk,n)
    in=array_indices(kk,n)
    plots, tau[in[0]],ref[in[1]], psym=2
    kk[n]=0.5 
    z=min(kk,n)
    in=array_indices(kk,n)
    plots, tau[in[0]],ref[in[1]], psym=2

    ;stop
  endif

return, [t,r]
end


; function that does the ki squared calculation, returns array, size of lut, of ki square values
function kisq, par, pars_lut,kis=kis,psub=psub,coef=coef,add=add,std=std
  ss=n_elements(size(pars_lut,/dimensions))
  if ss eq 4 then npar=n_elements(pars_lut[0,0,0,*]) else npar=n_elements(pars_lut[0,0,*])
if n_elements(coef) lt 1 and n_elements(add) lt 1 then begin
    coef=fltarr(npar) & add=fltarr(npar) & ca=1
endif else ca=0

  if ss eq 4 then ki=pars_lut[*,*,*,0]*0. else ki=pars_lut[*,*,0]*0.
  kis=pars_lut*0.
  s=fltarr(npar)
  for p=0, npar-2 do begin ; loop through the parameters
    if n_elements(psub) gt 0 then if where(p eq psub) lt 0 then continue
    if ss eq 4 then begin
      if ca then begin
        coef[p]=1./(max(pars_lut[*,*,*,p],/nan)-min(pars_lut[*,*,*,p],/nan))
        add[p]=min(pars_lut[*,*,*,p]*coef[p])
      endif

      ps=pars_lut[*,*,*,p]*coef[p]-add[p]
      pp=par[p]*coef[p]-add[p]
      kis[*,*,*,p]=(pp-ps)^2./std[*,*,*,p]^2.
      ki=ki+kis[*,*,*,p]
    endif else begin
      if ca then begin
        coef[p]=1./(max(pars_lut[*,*,p],/nan)-min(pars_lut[*,*,p],/nan))
        add[p]=min(pars_lut[*,*,p]*coef[p])
      endif

      ps=pars_lut[*,*,p]*coef[p]-add[p]
      pp=par[p]*coef[p]-add[p]
      kis[*,*,p]=(pp-ps)^2.
      ki=ki+kis[*,*,p]
    endelse
  
  endfor ; end of parameter loop
return, ki
end



; function that does the ki squared calculation, returns array, size of lut, of ki square values
function kisq_std, par, pars_lut,std,slopes,kis=kis,psub=psub,weight=weight,norm=norm,ww=ww,matrix=matrix
  npar=n_elements(pars_lut[0,0,*])
  if n_elements(ww) lt 1 then ww=0
  if n_elements(matrix) lt 1 then matrix=0
  if matrix then begin
    ki=total(pars_lut,3)*0.
    for t=0, n_elements(pars_lut[*,0,0])-1 do begin
      for r=0, n_elements(pars_lut[0,*,0])-1 do begin    
        rv=par-reform(pars_lut[t,r,*])
        ki[t,r]=transpose(rv)#weight#rv
      endfor
    endfor
    ki=abs(ki)
    ;stop
  endif else begin
  ki=pars_lut[*,*,0]*0.
  kis=pars_lut*0.
  s=fltarr(npar)
  coef=fltarr(npar) & add=fltarr(npar)
  for p=0, npar-2 do begin ; loop through the parameters
    if n_elements(psub) gt 0 then if where(p eq psub) lt 0 then continue
    if n_elements(norm) gt 0 then begin
      if 0 then begin
        coef[p]=max(abs(pars_lut[*,*,p]))
        ps=pars_lut[*,*,p]/coef[p]
        pp=par[p]/coef[p]
      endif else begin
        coef[p]=1./(max(pars_lut[*,*,p],/nan)-min(pars_lut[*,*,p],/nan))
        add[p]=min(pars_lut[*,*,p]*coef[p],/nan)
 
        ps=pars_lut[*,*,p]*coef[p]-add[p]
        pp=par[p]*coef[p]-add[p]
      endelse   
      w=1.
    endif else begin
      ps=pars_lut[*,*,p];*coef[p]-add[p]
      pp=par[p];*coef[p]-add[p]
      ; the weights
      ;w=slopes[*,*,p]*slopes[*,*,p]/(std[*,*,p]*std[*,*,p])
      if n_elements(weight) lt 1 then w=1.*slopes[*,*,p]/(abs(std[*,*,p])) else $
       w=weight[p]
      ;w=1.
      ;stop
      ;if p eq 4 or p eq 5 then w=2. else w=1.
    endelse
    if ww then kis[*,*,p]=weight[*,*,p]*(pp-ps)^2. $
    else kis[*,*,p]=w*(pp-ps)^2.
    ;stop
    ki=ki+kis[*,*,p]
  endfor ; end of parameter loop
endelse
return, ki
end



; function that does the ki squared calculation, returns array, size of lut, of ki square values
function kisq_err, par, pars_lut,pstd,taus,refs,psub=psub,weight=weight
  npar=n_elements(pars_lut[0,0,*])
  if n_elements(ww) lt 1 then ww=0

  pars=[[par-pstd],[par],[par+pstd]] ; setup the derivative set
  pluts=fltarr(n_elements(pars_lut[*,0,0]),n_elements(pars_lut[0,*,0]),npar,3)
  kis=pluts*0.
  delki=pars_lut*0.
  for p=0, npar-2 do begin
    for i=0, 2 do kis[*,*,p,i]=weight[p]*(pars[p,i]-pars_lut[*,*,p])^2.
    kis[*,*,p,1]=weight[p]*(pars[p,1]-pars_lut[*,*,p])^2.    
    ; make the deriv chi with deriv parameter * del parameter
    delki[*,*,p]=((kis[*,*,p,2]-kis[*,*,p,0])/2.)^2.
  endfor
  dki=sqrt(total(delki,3))
  ki=sqrt(total(kis[*,*,*,1],3))
  nulp=min(ki+dki,np)
  nulm=min(ki-dki,nm)
  ip=array_indices(ki,np)
  im=array_indices(ki,nm)
  
  delr=abs(refs[ip[1]]-refs[im[1]])/2.
  delt=abs(taus[ip[0]]-taus[im[0]])/2.
  if delr eq 0. then delr=0.5
  if delt eq 0. then delt=0.5
  er=[delt,delr]
;stop
return, er
end



; function that does the ki squared calculation, returns array, size of lut, of ki square values
function kisq_std_all, par, pars_lut,std,slopes,kis=kis,psub=psub,weight=weight,norm=norm,nophase=nophase
  ic=0 & li=0
  npar=n_elements(pars_lut[0,0,0,*])

  ki=pars_lut[*,*,*,0]*0.
  kis=pars_lut*0.
  s=fltarr(npar)
  coef=fltarr(npar) & add=fltarr(npar) 
  for p=0, npar-2 do begin ; loop through the parameters
    if n_elements(psub) gt 0 then if where(p eq psub) lt 0 then continue
    if n_elements(norm) gt 0 then begin
      coef[p]=1./(max(pars_lut[*,*,*,p],/nan)-min(pars_lut[*,*,*,p],/nan))
      add[p]=min(pars_lut[*,*,*,p]*coef[p],/nan)

      ps=pars_lut[*,*,*,p]*coef[p]-add[p] 
      pp=par[p]*coef[p]-add[p]
      w=1.
    endif else begin
      ps=pars_lut[*,*,*,p];*coef[p]-add[p]
      pp=par[p];*coef[p]-add[p]
      ; the weights
      ;w=slopes[*,*,p]*slopes[*,*,p]/(std[*,*,p]*std[*,*,p])
      if n_elements(weight) lt 1 then w=1.*slopes[*,*,*,p]/abs(std[*,*,*,p]) else $
       w=weight[p]
      ;w=1.
      ; stop
    endelse
    kis[*,*,*,p]=w*(pp-ps)^2.
    ki=ki+kis[*,*,*,p]
  endfor ; end of parameter loop

if not keyword_set(nophase) then begin
;  if par[1] gt max(pars_lut[*,5:*,1,1]+std[*,5:*,1,1],/nan) then ki[*,*,1]=ki[*,*,1]*2.
;  if par[1] lt min(pars_lut[*,0:29,0,1]-std[*,0:29,0,1],/nan) then ki[*,*,0]=ki[*,*,0]*2.
if par[1] gt max(pars_lut[*,5:*,1,1],/nan) then li=1
if par[1] lt min(pars_lut[*,0:29,0,1],/nan) then ic=1

if par[0] lt min(pars_lut[*,0:29,0,0],/nan) then ic=1
if par[8] gt max(pars_lut[*,0:29,0,8],/nan) then ic=1
if par[9] gt max(pars_lut[*,0:29,0,9],/nan) then ic=1

if ic then ki[*,*,0]=ki[*,*,0]*5.
if li then ki[*,*,1]=ki[*,*,1]*5.
endif

;if ic then stop
return, ki
end 



; function to build the slopes at each point of the lut
; makes a laplace value for each point of the lut
function laplace, arr,x1,x2
slo=arr
slot=arr
slor=arr
slow=arr
 for p=0, n_elements(arr[0,0,0,*])-2 do begin
   ;for w=0, 1 do begin  
     for t=0, n_elements(x1)-1 do $
       slor[t,0:29,0,p]=deriv(x2[0:29],arr[t,0:29,0,p]);,x2)
     if not finite(total(slor[*,0:29,0,p])) then $
      stop ;for t=0, n_elements(x1)-1 do slor[t,*,
     for t=0, n_elements(x1)-1 do $
       slor[t,5:*,1,p]=deriv(x2[5:*],arr[t,5:*,1,p]);,x2)
     if not finite(total(slor[*,5:*,1,p])) then $
      stop ;for t=0, n_elements(x1)-1 do slor[t,*,       


     for r=0, n_elements(x2[0:29])-1 do $
       slot[*,r,0,p]=deriv(x1,arr[*,r,0,p]);,x1)
       if not finite(total(slot[*,0:29,0,p])) then stop
     for r=0, n_elements(x2[5:*])-1 do $   
       slot[*,r,1,p]=deriv(x1,arr[*,r,1,p]);,x1)
       if not finite(total(slot[*,5:*,1,p])) then stop
   ;endfor

   for t=0, n_elements(x1)-1 do for r=0, n_elements(x2)-1 do $
     slow[t,r,*,p]=[arr[t,r,1,p]-arr[t,r,0,p],arr[t,r,0,p]-arr[t,r,1,p]]
 endfor
;stop
slo=abs(slot*slot+slor*slor+slow*slow)
;slo= slor;(slor+slot);/10.
; normalized the slopes?
;stop

return, slo
end


; function to return the normalized lut
function normalize, arr,co=co,ad=ad
if n_elements(size(arr,/dimension)) eq 4 then begin
np=n_elements(arr[0,0,0,*])
coef=fltarr(np)
add=fltarr(np)
arrn=arr

for p=0, np-2 do begin
  coef[p]=1./(max(arr[*,*,*,p],/nan)-min(arr[*,*,*,p],/nan))
  add[p]=min(arr[*,*,*,p]*coef[p])
  arrn[*,*,*,p]=arr[*,*,*,p]*coef[p]-add[p]
endfor
endif else begin
np=n_elements(arr[0,0,*]) 
coef=fltarr(np) 
add=fltarr(np) 
arrn=arr  
 
for p=0, np-2 do begin 
  coef[p]=1./(max(arr[*,*,p],/nan)-min(arr[*,*,p],/nan))
  add[p]=min(arr[*,*,p]*coef[p]) 
  arrn[*,*,p]=arr[*,*,p]*coef[p]-add[p] 
endfor 
endelse
co=coef
ad=add
return, arrn
end


;funtcion to return the normalized parameter values
; uses output of normalize
function normalize_par,par,co,ad
parn=par*co-ad
return, parn
end


;funtcion to return the normalized standard deviation of parameter values
; uses output of normalize
function normalize_std,std,co,ad
stdn=std
for t=0, n_elements(std[*,0,0,0])-1 do begin
  for r=0,n_elements(std[0,*,0,0])-1 do begin
    for w=0,1 do begin
      for p=0, n_elements(co)-1 do begin  
        stdn[t,r,w,p]=std[t,r,w,p]*co[p]-ad[p]
      endfor
    endfor
  endfor
endfor
return, stdn
end


;function to return the sign of the value
function sign, x
  n=abs(x)/x
return, n
end



;;;; function to return the half-width half-max value of the peak in a pdf
function hwhm, kisq, taus, refs
  post=(15.-kisq)/15. ; change to 'probability'

  if n_elements(post[0,*]) eq 51 then ice=1 else ice=0

  ; get the min kisq max likelihood
  nn=max(post,n,/nan)
  in=array_indices(post,n)
  tmax=taus[in[0]]
  if ice then rmax=refs[in[1]+9] else rmax=refs[in[1]]
  if ice then ref=refs[9:*] else ref=refs[0:29]

  pt=total(post,2)
  if ice then pr=total(post[*,9:*],1) else pr=total(post[*,0:29],1)
  ter=sqrt(total(pt*taus^2)-total(pt*taus)^2)
  if ice then $
   rer=sqrt(total(pr*refs[9:*]^2)-total(pr*refs[9:*])^2) else $
    rer=sqrt(total(pr*refs[0:29]^2)-total(pr*refs[0:29])^2)
  
  ; get the half max point in tau direction
  if in[0] ge n_elements(taus)-1 then dtp=taus[n_elements(taus)-1] else dtp=interpol(taus[in[0]:*],post[in[0]:*,in[1]],nn/2.)
  if in[0] eq 0 then dtm=0. else dtm=interpol(taus[0:in[0]],post[0:in[0],in[1]],nn/2.)
  htp=dtp-tmax & htm=tmax-dtm
  tfr=(htp+htm)/2.
  ; get the half max point in ref direction
  if in[1] ge n_elements(ref)-1 then drp=ref[n_elements(ref)-1] else drp=interpol(ref[in[1]:*],post[in[0],in[1]:*],nn/2.)
  if in[1] eq 0 then drm=0. else drm=interpol(ref[0:in[1]],post[in[0],0:in[1]],nn/2.)
  hrp=drp-rmax & hrm=rmax-drm
  rfr=(hrp+hrm)/2.
stop
return, [ter,rer]
end



; function to get the values of uncertainty of tau and ref, due to the standard deviation of each parameter
function get_err,par,arr,std,tau,ref,co,ad,psub=psub
    pp=par+std ;normalize_par(par+std,co,ad)
    kip=kisq_std(pp,arr,arr,arr,kis=kis,weight=1./std,psub=psub);/norm);,weight=ww)
    xp=get_min(kis,tau,ref,1,/old,kin=kip)
    taup=xp[0]
    refp=xp[1]

    pm=par-std ;normalize_par(par-std,co,ad)
    kim=kisq_std(pm,arr,arr,arr,kis=kis,weight=1./std,psub=psub);/norm);,weight=ww)
    xm=get_min(kis,tau,ref,1,/old,kin=kim)
    taum=xm[0]
    refm=xm[1]

    ter=(max([taup,taum])-min([taup,taum]))/2.
    rer=(max([refp,refm])-min([refp,refm]))/2.
;stop
return,[ter,rer]
end


;procedure to make the standard deviation of the entire subspace of parameters
pro make_pstd,par,pstd,cov=cov
if n_elements(size(par,/dimension)) eq 4 then begin
  np=n_elements(par[0,0,0,*])
  nn=n_elements(par[*,*,*,0])
  pstd=fltarr(np)
  for p=0, np-1 do pstd[p]=stddev(par[*,*,*,p],/nan)
  pz=fltarr(16,nn)
  for p=0,15 do pz[p,*]=reform(par[*,*,*,p],nn) 
endif else begin
  np=n_elements(par[0,0,*]) 
  nn=n_elements(par[*,*,0])
  pstd=fltarr(np) 
  for p=0, np-1 do pstd[p]=stddev(par[*,*,p],/nan)
  pz=fltarr(16,nn)
  for p=0,15 do pz[p,*]=reform(par[*,*,p],nn) 
endelse
cov=sqrt(abs(correlate(pz,/covariance)))
;
;cov=1./cov
end


;procedure to check in the parameters are within the limits of the modeled range
pro plims, par,arr,psl
if n_elements(size(arr,/dimension)) ne 3 then message, 'sum tin wong'
np=n_elements(par)
psl=0
for p=0, np-1 do begin
plo=min(arr[*,*,p],/nan) 
phi=max(arr[*,*,p],/nan)
if plo lt 0 then plo=plo*0.95 else plo=plo*1.05
if phi lt 0 then phi=phi*1.05 else phi=phi*0.95
if par[p] gt plo and par[p] lt phi then psl=[psl,p]
endfor
psl=psl[1:*]
if n_elements(psl) lt 5 then stop
end


; procedure to load up the spectra
pro load_sp,wvl,tmhrs,date,win,fl,num,model,zspectra=zspectra,spectram=spectram

if model then begin
  print, 'restoring modeled out file'
  ;if win then restore, 'C:\Users\Samuel\Research\SSFR3\model\hires6\sp_hires6_20120523_snd.out' else $
  if win then restore, 'C:\Users\Samuel\Research\SSFR3\model\v1\sp_v1_20120525.out' else $
   restore, '/argus/roof/SSFR3/model/sp_hires5_20120524.out'
  wvl=zenlambda
  fl=findgen(n_elements(sp[*,*,0,*]))
  spectram=fltarr(n_elements(fl),n_elements(wvl))
  print, 'building the set of spectra'
  j=0
  wp=[0,1]
  ind=intarr(n_elements(tau),n_elements(ref),n_elements(wp))
  for w=0, n_elements(wp)-1 do begin
    for t=0, n_elements(tau)-1 do begin
      for r=0, n_elements(ref)-1 do begin
        spectram[j,*]=reform(sp[t,r,*,w],1,n_elements(wvl))
        print, w,t,r,max(spectram[j-1,*]),max(sp[t,r,*,w])
        ind[t,r,w]=j
        j=j+1
      endfor ; ref loop
    endfor ;tau loop
  endfor ; wp loop
  refo=ref
  num=n_elements(fl)
  tmhrs=fltarr(num)+15.5
endif else begin
  if win then fn='C:\Users\Samuel\Research\SSFR3\data\'+date+'_calibspcs.out' else $
   fn='/argus/roof/SSFR3/data/'+date+'/out/'+date+'_calibspcs.out'
  print, 'restoring '+fn
  restore, fn
  wvl=zenlambda
  case date of
;    '20120602':fl=where(tmhrs gt 21.  and tmhrs lt 23.);  and area2a gt 10  and areaa  gt -2)
;    '20120813':fl=where(tmhrs gt 16.  and tmhrs lt 19.);  and area2b gt 10)
;    '20120525':fl=where(tmhrs gt 15.  and tmhrs lt 16.);  and tauc   lt 200 and area2c gt 10.)
;    '20120523':fl=where(tmhrs gt 21.  and tmhrs lt 24.);  and taud   lt 200 and area2d gt 30.)
;    '20120912':fl=where(tmhrs gt 15.5 and tmhrs lt 18.5); and area2e gt 40  and area2e lt 100. and areae gt 5)
;    '20120806':fl=where(tmhrs gt 22.  and tmhrs lt 24.5); used to be 20 to 24.5
;    '20120816':fl=where(tmhrs gt 14.  and tmhrs lt 17.)
;    '20120820':fl=where(tmhrs gt 16.  and tmhrs lt 19.);  and area2h gt 10. and areah  lt 4.)
;    '20120824':fl=where(tmhrs gt 20.  and tmhrs lt 23.);  and area2i gt 25)
;    '20130110':fl=where(tmhrs gt 16.  and tmhrs lt 21.)
;    '20130111':fl=where(tmhrs gt 21.  and tmhrs lt 23.)
    '20120602':fl=where(tmhrs gt 21.  and tmhrs lt 23.);  and area2a gt 10  and areaa  gt -2)
    '20120813':fl=where(tmhrs gt 16.5 and tmhrs lt 18.5);  and area2b gt 10)
    '20120525':fl=where(tmhrs gt 15.  and tmhrs lt 16.);  and tauc   lt 200 and area2c gt 10.)
    '20120523':fl=where(tmhrs gt 21.5 and tmhrs lt 23.5);  and taud   lt 200 and area2d gt 30.)
    '20120912':fl=where(tmhrs gt 16.  and tmhrs lt 18.); and area2e gt 40  and area2e lt 100. and areae gt 5)
    '20120806':fl=where(tmhrs gt 22.  and tmhrs lt 23.); used to be 20 to 24.5
    '20120816':fl=where(tmhrs gt 15.  and tmhrs lt 16)
    '20120820':fl=where(tmhrs gt 16.5 and tmhrs lt 18.5);  and area2h gt 10. and areah  lt 4.)
    '20120824':fl=where(tmhrs gt 21.  and tmhrs lt 22.);  and area2i gt 25)
    '20130110':fl=where(tmhrs gt 17.5 and tmhrs lt 19.5)
    '20130111':fl=where(tmhrs gt 21.  and tmhrs lt 23.)
    else: message, 'wrong date'
  endcase
  num=n_elements(tmhrs[fl]) ; the total number of points to go through
endelse
end


; function to calculate the derivative of tau and ref 
function derivt, arr,taus,refs
der=arr*0.
nmu=n_elements(arr[0,0,0,0,*])
np=n_elements(arr[0,0,0,*,0])
for u=0,nmu-1 do begin
  for p=0,np-1 do begin
    for r=0,29 do der[*,r,0,p,u]=deriv(arr[*,r,0,p,u],taus)
    for r=9,59 do der[*,r,1,p,u]=deriv(arr[*,r,1,p,u],taus)
  endfor
endfor
return, der
end

function derivr, arr,taus,refs
der=arr*0. 
nmu=n_elements(arr[0,0,0,0,*])
np=n_elements(arr[0,0,0,*,0])
nt=n_elements(arr[*,0,0,0,0])
for u=0,nmu-1 do begin
  for p=0,np-1 do begin 
    for t=0,nt-1 do der[t,0:29,0,p,u]=deriv(arr[t,0:29,0,p,u],refs[0:29])
    for t=0,nt-1 do der[t,9:59,1,p,u]=deriv(arr[t,9:59,1,p,u],refs[9:59]) 
  endfor 
endfor   
return, der 
end 


;function to calculate the uncertainty from the derivatives
function uncert,dr,dt,pstd,psub=psl
np=n_elements(pstd)
ert=fltarr(np) & err=fltarr(np)
for p=0,np-1 do begin
  if n_elements(psub) gt 0 then if where(p eq psub) lt 0 then continue  
  ert[p]=(dt[p]*pstd[p])^2.
  err[p]=(dr[p]*pstd[p])^2.
endfor
rt=sqrt(total(ert))
rr=sqrt(total(err))
er=[rt,rr]
stop
return,er
end
