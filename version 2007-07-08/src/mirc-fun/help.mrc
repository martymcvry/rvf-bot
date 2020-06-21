; ####################################
; #    HELP BIJ DE IRC-SPELLETJES    #
; # mIRC-script (c) 2005 - Tinke_lat #
; #   Contact: tinke_lat@skynet.be   #
; ####################################

on *:text:help*:?:{
  if ($1 == help) {
    if (!$2) {
      .notice $nick Welkom bij het helpsysteem van $me $+ !
      .notice $nick Volgende items zijn beschikbaar:
      .notice $nick * Rad Van Fortuin (/msg $me help rad)
      .notice $nick * MatchMaker (/msg $me help match)
      .notice $nick * Scoresysteem (/msg $me help score)
    }
    elseif ($2 == rad) {
      .notice $nick SPEL: RAD VAN FORTUIN
      .notice $nick Om een ronde te starten:  $+ %start.rad $+  (verdere instructies volgen op het scherm)
      .notice $nick REGELS:
      .notice $nick Wanneer je aan de beurt bent mag je draaien, een klinker kopen (als je voldoende geld hebt) of de oplossing raden.  Eens je gedraaid hebt mag je GEEN klinker meer kopen, of de beurt gaat over.
      .notice $nick Als alle medeklinkers geraden zijn, rest er enkel de mogelijkheid om een klinker te kopen of de oplossing te geven.
      .notice $nick Een klinker kopen kost je 100 euro.  Voor elke goede letter die je raad, krijg je het gedraaide bedrag.  De extra prijs bedraagt 500 euro.
      .notice $nick Enkel de persoon die de oplossing geeft krijgt zijn/haar gewonnen bedrag bijgeschreven in de scoretabel.
    }
    elseif ($2 == match) {
      .notice $nick FUN: MATCHMAKER
      .notice $nick Wil je weten hoe goed je past bij een andere chatter?  Typ !match <nick1> <nick2> en je zal het zien.  Beide personen moeten op het kanaal zijn!
    }
    elseif ($2 == score) {
      .notice $nick HET SCORESYSTEEM
      .notice $nick Je kan je eigen score raadplegen m.b.v.  $+ %score.commando $+ .
      .notice $nick Een Top10 kan je bekijken door  $+ %top10.commando $+  in te typen.
      if $isop($nick) {
        .notice $nick Als operator kan je ook de scores van twee nicks samenvoegen.  Gebruik hiervoor !merge <nick1> <nick2> <bestemming>.
        .notice $nick Je kan ook een html-bestand van de scores maken met !export.
      }
      if (%scorefile.autoexp) { .notice $nick Een html-bestand met de scores kan je bekijken op 12 $+ %html.scorefile $+  }
    }
  }
}

ctcp *:version:*:{
  .ctcpreply $nick VERSION Rad Van Fortuin en MatchMaker versiecode 1112717840 - mIRC Scripting door Tinke_lat (tinke_lat@skynet.be)
}
