999 'data
1000 key off:rec=5: 'recorde
1010 O$="<o=o>": for b=1 to len(O$): NO$=NO$+" ": next: 'nave
1020 B$="~~~~": for b=1 to len(B$): NB$=NB$+" ": next: 'tiro
1030 I$="-oIo-": for b=1 to len(I$): NI$=NI$+" ": next:'inimigo
1040 R$="i": for b=1 to len(R$): NR$=NR$+" ": next: 'objeto
1050 G$="__/[==]\____/[==]\__": TT$="": T$=G$: ' terreno
1055 E$="*": 'explosao
1060 defint x: defint y

1069 'apresentacao
1090 gosub 1380: 'tela de apresentacao do jogo

1091 'inicia
1092 pt=0:fa=1: vi=3:'variaveis de inicio de jogo
1095 fim=0: ci=0:rg=0: x=10: y=10: xi=rnd(1)*40:yi=rnd(1)*20:xi=xi+30:yi=yi+1: ' variaveis durante o jogo
1096 oe=0: oi=0: ir=0: bo=0:xb=0:yb=0:xy=0:yr=0:si=0: ' variaveis durante o jogo

1110 gosub 1290: 'tela prepare-se

1119 'loop
1120 if vi <> 0 then gosub 1160 : 'looping enquanto jogo funcionando
1130 if vi=0 then gosub 1320:  goto 1090: 'morreu ultima vida. volta para tela inicial
1140 if fim=1 then gosub 1350: goto 1090: 'chegou ao fim. volta para tela inicial 
1145 if fim=0 and rg=3 then gosub 1350: goto 1095: ' passou de fase
1150 goto 1120

1159 'bloco principal lopping
1160 ci=ci+1: if ci=50 then ci=0:  'contagem de ciclos
1180 gosub 1620: 'captura movimentos
1190 gosub 1490: 'testa colisao
1200 gosub 1830: 'atualiza tela
1210 gosub 1230: 'atualiza status do jogo
1220 return


1229 'bloco atualizacao de variaveis
1230 if pt > rec then rec = pt: 'bateu o recorde
1240 if oe=1 then vi = vi -1: x=10: y=10: yi=rnd(1)*20:xi=80-len(I$): oe=0:if vi>0 then gosub 1290: 'perdeu uma vida e chama tela prepara-se
1250 if oi=1 then pt=pt +1: xi=80-len(I$): yi=rnd(1)*20:yi=yi+1: oi=0:' matou o inimigo. soma pontos
1260 if ir=2 then rg=rg+1: ir=0: 'resgatou inimigo. atualiza contador de resgate
1270 if rg=3 then if fa=4 then fim=1 else fa=fa+1: 'chegou ao fim da fase. Se chegou ao total de fases, acaba o jogo
1280 return

1289 'tela prepare-se
1290 cls:locate 2,2: print "Vidas: "; vi; " Fase: ";fa:locate 2,4: print "Prepare-se. [SPC] para continuar"
1300 A$=inkey$: if a$ <> " " then goto 1300
1310 cls:return

1319 'tela game over
1320 cls:locate 20,10: print "Fim. Pontos: ";pt; "[SPC]";
1330 A$=inkey$: if a$ <> CHR$(32) then goto 1330
1340 cls:return

1349 'tela final
1350 cls:locate 5,10: print "Parabens! Objetivo Atingido! Pontos:";pt; " Vidas:";vi:Locate 5,12: print "[SPC] para continuar"
1360 A$=inkey$: if a$ <> CHR$(32) then goto 1360
1370 cls:return

1379 'tela princial
1380 cls:color 15,1,1: width 80:print "JOGO":print:print "2018-2021 Daniel Vicentini"
1385 print:print:print "Resgate os objetos ' ";R$;" '"
1386 print:print "Use o teclado para guiar sua nave ' ";O$;" '"
1387 print:print "e [SPC] para atingir os inimigos ' ";I$;" '"
1388 print:print:print "Recorde:";rec
1389 print:print "[SPC] para comecar"
1390 A$=inkey$: if a$ <> CHR$(32) then goto 1390
1400 cls:return


1409 'tela explosao
1410 for b=1 to 5 step .2:z=x-b: if z => 1 then locate x-b,y:print E$
1420 z=y-b: if z => 1 then locate x,y-b:print E$
1430 z=x+b: if z <= 79 then locate x+b,y:print E$
1440 z=y+b: if z <=21 then locate x,y+b: print E$
1450 next
1460 return

1489 'colisao
1490 if y => 20 then 1570
1500 si = xi+len(I$)
1510 if y=yi then if  x => xi and x <= si then 1570
1520 if bo=1 and yb = yi then if xb=>xi and xb<=si then 1550
1530 if ir=1 and yr = y then if x = xr then 1600
1540 return
1550 bo=2:oi=1
1560 return
1570 if bo=1 then bo=2
1580 oe=1
1590 return
1600 ir=2
1610 return

1619 'movimentos
1620 px=x: py=y: M=stick(0)
1624 if bo=1 then xb=xb+len(b$): 'movimenta o tiro tiro
1625 if strig(0)=-1 and bo=0 then bo=1: xb=x+len(O$):yb=y: 'dispara se nao tiver tiro em curso
1630 f=1: 'fator de velocidade
1640 if M=7 then x=x-f else if M=3 then x=x+f else if M=1 then y=y-f else if M=5 then y=y+f:'direcionais
1650 if M=2 then y=y-f:x=x+f else if M=4 then y=y+f:x=x+f else if M=6 then y=y+f:x=x-f else if M=8 then y=y-f:x=x-f:'direcionais
1660 if x<1 then x=2 else if x>76 then x=76:'limite vertical
1670 if y<=2 then y=2 else if y>=20 then y=20:'limite horizonta
1680 if xb=>78-len(B$) then bo=3:'tiro chegou no final da tela
1700 sxi = xi: syi = yi
1710 if xi <= 1 then xi=75:yi=y
1720 if yi < 2 then yi = 2 else if yi > 21 then yi  = 21: 'limites do inimigo
1740 xi = xi - 1:' move inimigo
1750 if y > yi then yi=yi+1 else if y < yi then yi=yi-1: 'inimigo segue nave
1760 if pt > 5 and ir=0 and rg = 0 then gosub 1800:  'chama 1o objeto para resgatar
1770 if ir=0 and rg>0 and ci=49 then gosub 1800: 'chama novo objeto para resgatar a cada 50 ciclos
1780 TT$=mid$(T$,2,len(T$)-1):TT$=TT$+left$(T$,1):T$=TT$:  'roda terreno
1790 return
1800 yr=rnd(1)*18:yr=yr+2: xr=rnd(1)*30:xr=xr+10: 'coordenadas do objeto a resgatar
1810 ir=1: 'objeto na tela
1820 return

1829 'atualiza tela jogo
1830 locate 1,1: print "Pts: ";pt:locate 13,1: print "Vidas:";vi:locate 26,1: print "Rec: "; rec:locate 39,1: print "Salvos:"; rg:locate 52,1: print "Ciclos:"; ci: locate 65,1:print "Fase:";fa
1840 for b=0 to 79 step len(T$):locate b,20:print T$: next: 'imprime terreno
1850 locate sxi,syi:print NI$: locate xi,yi:print I$: 'imprime inimigo
1860 locate px,py: print NO$: locate x,y: print O$: 'imprime nave
1880 if bo=1 then locate xb,yb: print B$:locate xb-(len(b$)),yb: print NB$
1890 if bo=2 then locate xb-(len(b$)),yb: print NB$:locate xi,yi:print NI$: bo=0: 'tiro atingi inimigo. Deve ser apagado
1900 if bo=3 then locate xb,yb:print NB$: bo=0: 'tiro chegou no final da tela. deve ser apagado
1910 if ir=1 then locate xr,yr: print R$: 'imprime objeto de resgate
1920 if ir=2 then locate xr,yr: print NR$: 'apaga objeto
1930 if oe=1 then gosub 1410:  'chama explosao da nave
1940 return
