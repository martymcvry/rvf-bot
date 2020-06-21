; ######################################
; # TOP 10 & SCORE-SCRIPT VOOR SPELLEN #
; #  mIRC-script (c) 2005 - Tinke_lat  #
; #    Contact: tinke_lat@skynet.be    #
; ######################################
; # Vernieuwd op 13/11/2010            #
; ######################################

on *:text:!export:#:{
  if $isop($nick) {
    _export.scores
    .notice $nick Scores ge-exporteerd naar %scorefile.exp $+ .
  }
  else {
    .notice $nick Onvoldoende rechten om de scores te exporteren.
  }
}

alias _export.scores {
  clearall
  top.create
  write -c %scorefile.exp
  write %scorefile.exp <html>
  write %scorefile.exp <head>
  write %scorefile.exp <title> $+ $me - Scoretabel</title>
  write %scorefile.exp <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
  if (%scorefile.autoexp) { write %scorefile.exp <meta http-equiv="Refresh" content=" $+ $calc(60 * %scorefile.autoexp) $+ ; $+ $nopath(%scorefile.exp) $+ "> }
  write %scorefile.exp </head>
  write %scorefile.exp <body bgcolor="#CCCCCC">
  write %scorefile.exp <p><img src="scores.gif" width="258" height="60"></p>
  write %scorefile.exp <p>Scores op $asctime(dd/mm/yyyy) om $asctime(HH:nn:ss) $+ . $+ $iif(%scorefile.autoexp,<br>De scores die je hier ziet worden iedere %scorefile.autoexp minuten automatisch ververst.) $+ </p>
  write %scorefile.exp <table width="300" border="1">
  write %scorefile.exp <tr> 
  write %scorefile.exp <td width="50"><div align="center"><strong>Plaats</strong></div></td>
  write %scorefile.exp <td width="150"><strong>Nick</strong></td>
  write %scorefile.exp <td width="100"><div align="center"><strong>Score</strong></div></td>
  write %scorefile.exp </tr>
  set %linenum 1
  while (%linenum <= $lines(top1.gmb)) {
    write %scorefile.exp <tr> 
    write %scorefile.exp <td><div align="center"> $+ %linenum $+ </div></td>
    write %scorefile.exp <td> $+ $gettok($read(top1.gmb,%linenum),2,32) $iif($gettok($read(top1.gmb,%linenum),2,32) ison %main.channel,<font color="#008800"><strong>[online]</strong></font>,<font color="#FF0000">[offline]</font>) $+ </td>
    write %scorefile.exp <td><div align="center"> $+ $gettok($read(top1.gmb,%linenum),1,32) euro</div></td>
    write %scorefile.exp </tr>
    inc %linenum
  }
  write %scorefile.exp </table>
  write %scorefile.exp <p>&nbsp;</p>
  write %scorefile.exp <p>Deze lijst is gecre&euml;erd met het &quot;Score Export Script&quot;, gemaakt door Tinke_lat.</p>
  write %scorefile.exp <p><img src="copy.gif" width="163" height="34"></p>
  write %scorefile.exp </body>
  write %scorefile.exp </html>
  if (%scorefile.autoexp) { _ftp.sendfile }
}

on *:text:!merge*:#:{
  if ($1 == !merge) {
    if $isop($nick) {
      if (!$4) { .notice $nick Onvoldoende parameters.  Gebruik !merge <nick1> <nick2> <bestemming> }
      else {
        if (!$getscore($2) && !$getscore($3)) {
          .notice $nick Er zijn geen scores voor $2 en $3 $+ .
        }
        elseif (!$getscore($2) && $getscore($3)) {
          .notice $nick Er is geen score voor $2 $+ .
        }
        elseif ($getscore($2) && !$getscore($3)) {
          .notice $nick Er is geen score voor $3 $+ .
        }
        else {
          set %tmpscore $getscore($2)
          inc %tmpscore $getscore($3)
          remini %scorefile scores $2
          remini %scorefile scores $3
          writeini %scorefile scores $4 %tmpscore
          .notice $nick Scores van $2 en $3 zijn samengevoegd naar $4. (Nieuw totaal: %tmpscore euro)
          unset %tmpscore
        }
      }
    }
    else {
      .notice $nick Onvoldoende rechten om de scores samen te voegen.
    }
  }
}

on *:text:%score.commando:#:{
  .notice $nick Je hebt nu  $+ $iif($getscore($nick),$getscore($nick),$chr(48)) $+  euro.
}

on *:text:%top10.commando:#:{
  /top.create
  .msg $nick De topscorers zijn:
  .msg $nick #1 $top.read(1,n) ( $+ $top.read(1,p) $+ )  #2 $top.read(2,n) ( $+ $&
    $top.read(2,p) $+ )  #3 $top.read(3,n) ( $+ $top.read(3,p) $+ )  #4 $top.read(4,n) ( $+ $&
    $top.read(4,p) $+ )  #5 $top.read(5,n) ( $+ $top.read(5,p) $+ )
  .msg $nick #6 $top.read(6,n) ( $+ $top.read(6,p) $+ )  #7 $top.read(7,n) ( $+ $&
    $top.read(7,p) $+ )  #8 $top.read(8,n) ( $+ $top.read(8,p) $+ )  #9 $top.read(9,n) ( $+ $&
    $top.read(9,p) $+ )  #10 $top.read(10,n) ( $+ $top.read(10,p) $+ )
}

alias _ftp.sendfile {
  write -c mirc-fun\export\cmd.ftp
  write mirc-fun\export\cmd.ftp open %ftp.host %curport
  write mirc-fun\export\cmd.ftp %ftp.username
  write mirc-fun\export\cmd.ftp %ftp.password
  write mirc-fun\export\cmd.ftp cd %ftp.dir
  write mirc-fun\export\cmd.ftp put $nopath(%scorefile.exp)
  write mirc-fun\export\cmd.ftp quit
  .run -n mirc-fun\export\newftp.bat
}

alias _message.scores {
  top.create
  if (%scoremsg.counter == 2) {
    .msg %main.channel 2Top 6-10: 5#6: $top.read(6,n) 10 $top.read(6,p) euro 5#7: $top.read(7,n) 10 $top.read(7,p) euro 5#8: $top.read(8,n) 10 $top.read(8,p) euro 5#9: $top.read(9,n) 10 $top.read(9,p) euro 5#10: $top.read(10,n) 10 $top.read(10,p) euro
    dec %scoremsg.counter
  }
  else {
    .msg %main.channel 2Top 1-5: 5#1: $top.read(1,n) 10 $top.read(1,p) euro 5#2: $top.read(2,n) 10 $top.read(2,p) euro 5#3: $top.read(3,n) 10 $top.read(3,p) euro 5#4: $top.read(4,n) 10 $top.read(4,p) euro 5#5: $top.read(5,n) 10 $top.read(5,p) euro
    inc %scoremsg.counter
  }
}

alias _radmessage.start {
  if (%rad.active != yes) {
    msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ ] Om te spelen, typ  [ $+ [ %start.rad ] $+ ] 
  }
}
