100 ' meu primeiro jogo v5 - Daniel Vicentini - 2018-2021
110 ' linha 500: dados fixos, inclui 'graficos'
120 ' bloco 1000-1200: 'core' do jogo
130 ' blocos 1200-1800: logica do gameplay - movimentos, colisao, tela e status
140 ' bloco 2000-2500 : telas prontas
150 ' historico: v1-v3 - primeira versao. v4 - revisao do codigo/cleanup/novas rotinas

500 'data
510 key off: screen0,,0:width 40:  ' ajuste da tela
520 O$="[]-o": for b=1 to len(O$): NO$=NO$+" ": next: 'nave
530 B$="~~~": for b=1 to len(B$): NB$=NB$+" ": next: 'tiro
540 I$="-o-": for b=1 to len(I$): NI$=NI$+" ": next: 'inimigo
550 R$="i": for b=1 to len(R$): NR$=NR$+" ": next: 'objeto
560 G$="/[==]\____/[ooooooooooo]\______/[==]\___": TT$="": T$=G$: ' terreno
570 E$="*": ' sinais da explosao
580 P$="############": ' plataforma de pouso
590 defint x: defint y: mxtela=39: rec=5:' rec:recorde. mxtela: tamanho da tela (screen0)

1000 gosub 2400: 'tela de apresentacao do jogo
1010 'inicia
1020 pt=0:fa=1: vi=3:'variaveis de inicio de jogo
1030 gosub 2100: 'tela prepare-se
1040 ' ci: ciclos de loop, x,y e derivados posicoes dos objetos
1050 fim=0: ci=0:rg=0: x=10: y=10: xi=mxtela:yi=rnd(1)*20:yi=yi+1:xb=0:yb=0:xy=0:yr=0: ' variaveis durante o jogo em curso
1055 ' fim: gameplay ativo. rg: registra a qtde de resgates por fase
1060 oe=0: oi=0: ir=0: bo=0:ii=0 ' variaveis durante o jogo em curso
1070 ' ii: inimigo na tela, oi = colisao tiro+inimigo, oe: colisao nave, ir: status do objeto de resgate, bo: status do tiro
1080 cls:color 15,1

1100 'loop
1110 if vi <> 0 then gosub 1170 : 'rotinas durante o gameplay
1120 if oe=1 and vi>0 then goto 1030: ' morreu e ainda tem vidas
1130 if vi=0 then gosub 2200: goto 1000: 'morreu ultima vida. volta para tela inicial
1140 if fim=1 then gosub 2500: goto 1000: 'chegou ao fim. volta para tela inicial 
1150 if fim=0 and rg=3 then gosub 2300: goto 1030: ' passou de fase por ter realizado o resgate
1160 goto 1100

1169 'rotinas
1170 gosub 1600: 'captura movimentos
1180 gosub 1400: 'testa colisao
1190 gosub 1800: 'atualiza tela
1195 gosub 1200: 'atualiza status do jogo
1199 return


1200 'atualiza status do jogo
1210 if pt > rec then rec = pt: 'bateu o recorde
1220 if oe=1 then vi = vi -1: ' perdeu 1 vida
1230 if oi=1 then pt=pt +1: xi=mxtela-len(I$): yi=rnd(1)*20:yi=yi+1: oi=0: ii=0:' matou o inimigo. soma pontos. zero colisao e inimigo na tela
1240 if ir=2 then rg=rg+1: ir=0: 'resgatou objeto. atualiza contador de resgate
1250 if rg=3 then if fa=4 then fim=1 else fa=fa+1: 'chegou ao fim da fase. Se chegou ao total de fases (4), acaba o jogo
1260 ci=ci+1: if ci=50 then ci=0:  'contagem de ciclos
1270 if bo=2 or bo=3 then bo=0: ' retorna status de tela sem tiro
1280 if ii=0 and ci<25 then ii=1: ' colocar novo inimigo na tela a cada final de ciclo
1290 return

1400 'colisao
1410 if y => 20 then oe=1: if bo=1 then bo=2: ' colisao com o terreno
1431 if y=yi then if  xi-x =< len(O$)-1 and xi-x =>-len(O$)-1 then oe=1: if bo=1 then bo=2: ' colisao nave e inimigo
1441 if bo=1 and yb=yi then if xi-xb =< len(O$)-1 and xi-xb >=-len(O$)-1 then oi=1:bo=2: ' colisao tiro e inimigo
1450 if ir=1 and yr = y then if xr-x => 0 and xr-x =< len(O$)-1 then ir=2:  ' nave colidiu com objeto
1460 return


1600 'movimentos
1610 X$=inkey$:px=x: py=y: M=stick(0): 'captura direcionais
1620 f=1: ' velocidade
1630 if M=7 then x=x-f else if M=3 then x=x+f else if M=1 then y=y-f else if M=5 then y=y+f: ' movimentacao nave
1640 if M=2 then y=y-f:x=x+f else if M=4 then y=y+f:x=x+f else if M=6 then y=y+f:x=x-f else if M=8 then y=y-f:x=x-f: ' mov nave
1650 if x<0 then x=0 else if x=>mxtela-len(O$) then x=mxtela-len(O$): 'limites horizontais da nave 
1660 if y<=3 then y=3 else if y>=20 then y=20: 'limites verticais da nave
1670 if bo=1 and xb=>mxtela-len(B$) then bo=3: 'tiro chegou ao final da tela e deve ser removido
1680 if bo=1 then xb=xb+len(b$):' movimenta o tiro se estiver em curso
1690 if strig(0)=-1 and bo=0 then bo=1: xb=x+len(O$):yb=y: 'dispara se tiro nao estiver em curso
1700 sxi = xi: syi = yi: ' posicao anterior do inimigo
1710 if ii=1 then if xi <= 1 then xi=mxtela-len(I$):yi=y: 'inimigo chegou até a esquerda da tela e deve aparecer novamente a direita
1720 if ii=1 then if yi < 3 then yi = 3 else if yi > 21 then yi  = 21: 'limites do inimigo
1730 if ii=1 then xi = xi - 1: ' inimigo move para esquerda
1740 if ii=1 then if y > yi then yi=yi+1 else if y < yi then yi=yi-1: ' inimigo acompanha altura da nave
1750 if pt > 5 and ir=0 and rg = 0 then ir=1:yr=rnd(1)*17:yr=yr+3: xr=rnd(1)*10:xr=xr+10:  'chama 1o objeto para resgatar apos 5 primeiros pontos
1780 if ir=0 and rg>0 and ci=49 then ir=1: yr=rnd(1)*17:yr=yr+3: xr=rnd(1)*10:xr=xr+10:'chama novo objeto para resgatar a cada 50 ciclos
1790 TT$=mid$(T$,2,len(T$)-1):TT$=TT$+left$(T$,1):T$=TT$:  'roda figura do terreno para direita
1798 return

1799 'atualiza tela jogo
1800 locate 1,1: print "Pts: ";pt:locate 10,1: print "Vidas:";vi:locate 20,1: print "Rec: "; rec:locate 30,1: print "Salvos:"; rg:locate 1,22: print "Ciclos:"; ci: locate 30,22:print "Fase:";fa: ' painel
1810 for b=0 to mxtela step len(T$):locate b,20:print T$: locate b,21: print T$: locate b,2:print T$:next:' terreno
1820 if ii=1 then locate sxi,syi:print NI$: locate xi,yi:print I$: ' imprime inimigo se estiver na tela
1830 if bo=1 then locate xb,yb: print B$:locate xb-(len(b$)),yb: print NB$: 'imprime tiro se estiver na tela
1840 if bo=2 then locate xb-(len(b$)),yb: print NB$:locate xi,yi:print NI$: 'apaga tiro e inimigo
1850 if bo=3 then locate xb,yb:print NB$: 'remove tiro final da telas
1860 if ir=1 then locate xr,yr: print R$: 'objeto
1870 if ir=2 then locate xr,yr: print NR$: ' remove objeto
1880 locate px,py: print NO$: locate x,y: print O$: ' nave
1890 if oe=1 then gosub 2000:  'chama explosao da nave
1900 return

1950 '----TELAS PRONTAS----

2000 'explosao da nave
2005 nx=x+(len(O$)/2): 'centro da nave
2010 for b=1 to 5 step .2:z=nx-b: if z => 1 then locate nx-b,y:print E$
2020 z=y-b: if z => 1 then locate nx,y-b:print E$
2030 z=nx+b: if z <= 79 then locate nx+b,y:print E$
2040 z=y+b: if z <=21 then locate nx,y+b: print E$
2050 next
2060 return

2100 'tela prepare-se
2110 cls:color 15,4: locate 3,2: print "Vidas: "; vi; " Fase: ";fa:locate 3,4: print "Prepare-se. [SPC] para continuar"
2120 A$=inkey$: if a$ <> CHR$(32) then goto 2120
2130 return

2200 'tela game over
2210 cls:color 15,4: locate 3,15: print "Fim. Pontos:";pt; "[SPC]";
2220 A$=inkey$: if a$ <> CHR$(32) then goto 2220
2230 return

2300 'tela final de fase
2310 cls:color 15,4: locate 3,2: print "Parabens! Objetivo Atingido!": locate 3,4: print "Pontos:";pt;" Vidas:";vi: Locate 3,12:print "[SPC] para continuar"
2320 A$=inkey$: if a$ <> CHR$(32) then goto 2320
2330 return

2400 'tela principal
2410 cls:color 15,4: locate 3,1: print "JOGO":locate 3,3:print "2018-2021 Daniel Vicentini"
2420 locate 3,5:print "Resgate os objetos ' ";R$;" '"
2430 locate 3,6:print "Use o teclado para guiar sua nave"
2440 locate 3,7:print "e [SPC] para atingir os inimigos"
2450 locate 3,10:print "Recorde:";rec
2460 locate 3,12:print "[SPC] para comecar"
2470 A$=inkey$: if a$ <> CHR$(32) then goto 2470
2480 return

2500 ' tela missa cumprida - final de todas as fases
2510 cls: color 15,4
2520 y=10: locate 7,21:print P$: ' desenha a plataforma
2530 for x=10 to 20: px=x-1: locate y,px: print NO$: locate y,x: print O$: next: ' pousa a nave
2540 locate 3,5: print "Parabens! Missao Concluida"
2550 locate 3,7: print "Total de pontos: "; pt
2560 A$=inkey$: if a$ <> CHR$(32) then goto 2560
2570 return
 