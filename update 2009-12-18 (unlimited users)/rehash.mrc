; ####################################
; #              REHASH              #
; # mIRC-script (c) 2005 - Tinke_lat #
; #   Contact: tinke_lat@skynet.be   #
; ####################################

on *:text:!rehash:*:{
  if ($nick !isop %main.channel) { notice $nick Sorry, maar je hebt onvoldoende rechten om de bot te rehashen. }
  else {
    msg %main.channel Beginnen met rehash...
    .timers off
    .unsetall
    .reload -rs mirc-fun\rad-core.mrc
    .reload -rs mirc-fun\match-core.mrc
    .reload -rs mirc-fun\top10-score.mrc
    .reload -rs mirc-fun\help.mrc
    .reload -rs mirc-fun\overall.mrc
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
    set %radkand.max $config(rad,maximumkandidaten)
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
    .timer_r_nick 1 5 tnick %main.nick
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
    msg %main.channel Rehash voltooid!
  }
}
