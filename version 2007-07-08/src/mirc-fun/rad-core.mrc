; ####################################
; #    RAD VAN FORTUIN (IRC-SPEL)    #
; #  Gebaseerd op het televisiespel  #
; #        "Wheel of Fortune"        #
; # mIRC-script (c) 2005 - Tinke_lat #
; #   Contact: tinke_lat@skynet.be   #
; ####################################

on *:text:%start.rad:%main.channel:{
  if (%rad.active != yes && %rad.deact != yes) {
    set %rad.active yes
    .timer 1 2 _rad.activeer $chan
  }
}

on *:text:$(%start.rad stop):%main.channel:{
  if (%rad.active == yes) {
    if $isop($nick) { _rad.deactiveer }
    else {
      .notice $nick Onvoldoende rechten om de bewerking uit te voeren.
      .notice $nick Vraag aan één van de ops om het spel te beëindigen!
    }
  }
}

alias -l _rad.kand {
  msg %main.channel  [ $+ [ %kleuren-rad.kandidaat_stellen ] $+ ] Er zijn 60 seconden om je kandidaat te stellen voor deze ronde. Typ !kandidaat.
  set %rad.numkand 0
  set %rad.tmp 24
  set %rad.seq kand
  .timer_rad_kand.disable 1 60 _rad_kand.disable
}

alias _rad.activeer {
  if (!$1) { echo -a *** ERROR: No channel given! }
  else {
    set %main.channel $1
    set %rad.mode $rand(1,3)
    while ($decode(MjAwNSAtIFRpbmtlX2xhdA==,m) !isin $read($script,5)) { echo -s *** ERROR IN FILE | file.error }
    msg %main.channel  [ $+ [ %kleuren-rad.welkom ] $+ ] Welkom bij Rad Van Fortuin! (!rad stop om te stoppen)
    msg %main.channel  [ $+ [ %kleuren-rad.copyright ] $+ ] (c) 2005 - Tinke_lat (tinke_lat@skynet.be)
    msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ ] In deze ronde spelen we voor bedragen gaande van $iif(%rad.mode == 3,50,25) tot $iif(%rad.mode == 3,2500,1000) euro.
    msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ ] Vergeet vooral niet: er staat ook een verliesbeurt en $iif(%rad.mode == 3,twee maal bankroet,een bankroet) op ons rad.
    .timer_rad.kand 1 7 _rad.kand
  }
}

alias _rad.deactiveer {
  if (%rad.active == yes) {
    msg %main.channel  [ $+ [ %kleuren-rad.stopberichten ] $+ ] Tot zover deze ronde van Rad Van Fortuin!
    if (%voice.rad == on) { .mode %main.channel -vvv %rad.voice.1 %rad.voice.2 %rad.voice.3 }
    msg %main.channel  [ $+ [ %kleuren-rad.copyright ] $+ ] (c) 2005 - Tinke_lat (tinke_lat@skynet.be)
    msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ ] Geef me eventjes om alles terug op orde te zetten voor een volgend spel...
    unset %rad.active
    ._reset.timers
    .timer_rad.deact 1 $rand(15,21) _deact2
    set %rad.deact yes
  }
}

alias -l _deact2 {
  msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ ] Voor een nieuwe ronde, typ  [ $+ [ %start.rad ] $+ ] 
  unset %rad.*
  unset %rad_*
}

on *:text:!kandidaat:%main.channel:{
  if (%rad.seq == kand) {
    while ($decode(MjAwNSAtIFRpbmtlX2xhdA==,m) !isin $read($script,5)) { echo -s *** ERROR IN FILE | file.error }
    if (%rad.kand. [ $+ [ $nick ] ] == yes) {
      .notice $nick Je hebt je al kandidaat gesteld voor deze ronde!
    }
    elseif (%rad.kand-host. [ $+ [ $gettok($address($nick,5),2,64) ] ] == yes) {
      .notice $nick Je hebt je al met een clone kandidaat gesteld voor deze ronde!
    }
    elseif (%rad.numkand < %radkand.max)  {
      inc %rad.numkand
      set %rad.kand. [ $+ [ $nick ] ] yes
      set %rad.kand-host. [ $+ [ $gettok($address($nick,5),2,64) ] ] yes
      msg %main.channel  [ $+ [ %kleuren-rad.kandidaat_gesteld ] $+ [ $nick ] ] heeft zich kandidaat gesteld voor deze ronde!
      set %rad.kandidaat. [ $+ [ %rad.numkand ] ] $nick
      if (%rad.numkand == 3) {
        msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ ] 60 seconden was blijkbaar te veel.
        .timer_rad_kand.disable off
        _rad_kand.disable
      }
    }
    else {
      .notice $nick Er kunnen maar %radkand.max kandidaten zijn!  Probeer nog eens in de volgende ronde.
    }
  }
}

alias -l _rad_kand.disable {
  msg %main.channel  [ $+ [ %kleuren-rad.stopberichten ] $+ ] De inschrijvingen zijn gestopt...
  if (%rad.numkand == 0) {
    msg %main.channel  [ $+ [ %kleuren-rad.extrainfo ] $+ ] Er zijn geen kandidaten.
    _rad.deactiveer
  }
  else {
    msg %main.channel  [ $+ [ %kleuren-rad.welkom ] $+ ] We hebben %rad.numkand kandida [ $+ [ $iif(%rad.numkand > 1,ten,at) ] $+ ] .
    msg %main.channel  [ $+ [ %kleuren-rad.kandidatenlijst ] $+ ] Kandidaat 1:  [ $+ [ %rad.kandidaat.1 ] $+ ] 
    if (%rad.kandidaat.2) { msg %main.channel  [ $+ [ %kleuren-rad.kandidatenlijst ] $+ ] Kandidaat 2:  [ $+ [ %rad.kandidaat.2 ] $+ ]  }
    if (%rad.kandidaat.3) { msg %main.channel  [ $+ [ %kleuren-rad.kandidatenlijst ] $+ ] Kandidaat 3:  [ $+ [ %rad.kandidaat.3 ] $+ ]  }
    if (%rad.numkand < 2) {
      msg %main.channel  [ $+ [ %kleuren-rad.extrainfo ] $+ ] Er moeten minstens 2 kandidaten zijn... Alleen zou het wat makkelijk zijn om te winnen!
      _rad.deactiveer
    }
    else {
      if (%voice.rad == on) {
        set %voice.counter 1
        set %voice.count 1
        while (%voice.counter <= %rad.numkand) {
          if (%rad.kandidaat. [ $+ [ %voice.counter ] ] !isvoice %main.channel) {
            set %rad.voice. [ $+ [ %voice.count ] ] %rad.kandidaat. [ $+ [ %voice.counter ] ]
            inc %voice.count
          }
          inc %voice.counter
        }
        .mode %main.channel +vvv %rad.voice.1 %rad.voice.2 %rad.voice.3
      }
      .timer_rad.opgave 1 7 _rad_opgave.get
    }
  }
}

alias -l _rad_opgave.get {
  if (!$exists(%datafile.rad-woorden)) { echo -a *** ERROR: Datafile could not be found. | _rad.deactiveer }
  else {
    set %rad_opgave.line $read(%datafile.rad-woorden)
    while ($decode(MjAwNSAtIFRpbmtlX2xhdA==,m) !isin $read($script,5)) { echo -s *** ERROR IN FILE | file.error }
    set %rad_opgave.tip $upper($gettok(%rad_opgave.line,1,124))
    set %rad_opgave.tekst $upper($gettok(%rad_opgave.line,2,124))
    set %rad_opgave.lengte $len(%rad_opgave.tekst)
    set %rad_opgave.leeg $replace(%rad_opgave.tekst,a,$chr(150),b,$chr(150),c,$chr(150),d,$chr(150),e,$chr(150),f,$chr(150),g,$chr(150),h,$chr(150),i,$chr(150),j,$chr(150),k,$chr(150),l,$chr(150),m,$chr(150),n,$chr(150),o,$chr(150),p,$chr(150),q,$chr(150),r,$chr(150),s,$chr(150),t,$chr(150),u,$chr(150),v,$chr(150),w,$chr(150),x,$chr(150),y,$chr(150),z,$chr(150),$chr(32),$chr(149))
    set %rad.continue_play yes
    unset %rad_opgave.line
    msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ ] We zoeken [ $numtok(%rad_opgave.tekst,32) ] woord [ $+ [ $iif($numtok(%rad_opgave.tekst,32) > 1,en) ] $+ ] , uit de categorie " [ $+ [ %rad_opgave.tip ] $+ ] ".
    set %rad.opgave  [ $+ [ %kleuren-rad.opgave_vakje ] $+ [ $replace(%rad_opgave.leeg,$chr(149),$chr(160)) ] $+ ] 
    .timer_rad.beurt 1 7 _rad_beurt.next
    .timer_rad.categorie 0 120 msg %main.channel  [ $+ [ %kleuren-rad.extrainfo ] $+ ] Vergeet niet dat de categorie voor deze opgave " [ $+ [ %rad_opgave.tip ] $+ ] " is!
  }
}

alias -l _rad_beurt.next {
  if (%rad.opgave) { msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ ] Opgave: $replace(%rad.opgave,$chr(149),$chr(160)) }
  inc %rad.beurt.num
  if (%rad.beurt.num > %rad.numkand) { dec %rad.beurt.num %rad.numkand }
  set %rad.beurt %rad.kandidaat. [ $+ [ %rad.beurt.num ] ]
  if (%rad.continue_play == yes) {
    msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ ] Het is de beurt aan %rad.beurt om te draaien $iif(%rad.score. [ $+ [ %rad.beurt ] ] >= 100,of een klinker te kopen)
    .notice %rad.beurt Typ !draai $iif(%rad.score. [ $+ [ %rad.beurt ] ] >= 100,of !klinker <letter>)
    .notice %rad.beurt Wil je de oplossing geven, typ dan !raad <oplossing>
    set %rad.seq draai
  }
  else {
    msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ ] Alle medeklinkers zijn er uit.  Het is de beurt aan %rad.beurt om te spelen.
    .notice %rad.beurt Typ $iif(%rad.score. [ $+ [ %rad.beurt ] ] >= 100,!klinker <letter> of $+ $chr(32)) $+ !raad <oplossing>
    set %rad.seq klinkers
  }
  .timer9999 1 30 _rad.telaat
}

on *:text:!draai:%main.channel:{
  if (%rad.seq == draai) {
    if (%rad.kand. [ $+ [ $nick ] ] == yes) {
      if (%rad.beurt == $nick) {
        .timer9999 off
        inc %rad.tmp $rand(25,120)
        while (%rad.tmp > 24) { dec %rad.tmp 24 }
        if ($radwaarde(%rad.tmp) == bankroet) {
          msg %main.channel  [ $+ [ %kleuren-rad.stopberichten ] $+ ] Ai, $nick draait BANKROET!
          msg %main.channel  [ $+ [ %kleuren-rad.stopberichten ] $+ ] De beurt gaat over en $nick verliest al zijn/haar geld uit deze ronde.
          set %rad.score. [ $+ [ %rad.beurt ] ] 0
          set %rad.seq wacht
          .timer_rad.beurt 1 7 _rad_beurt.next
        }
        elseif ($radwaarde(%rad.tmp) == verliesbeurt) {
          msg %main.channel  [ $+ [ %kleuren-rad.stopberichten ] $+ ] Spijtig voor $nick $+ , maar het is VERLIESBEURT geworden.
          msg %main.channel  [ $+ [ %kleuren-rad.stopberichten ] $+ ] De beurt gaat over.
          set %rad.seq wacht
          .timer_rad.beurt 1 7 _rad_beurt.next
        }
        elseif ($radwaarde(%rad.tmp) == extra) {
          msg %main.channel  [ $+ [ %kleuren-rad.extraprijs ] $+ ] Als $nick nu nog een goeie letter geeft, krijgt hij/zij de EXTRA PRIJS!
          .notice $nick Typ !letter <letter>
          set %rad.seq letter
          .timer9998 1 30 _rad.telaat
        }
        else {
          msg %main.channel  [ $+ [ %kleuren-rad.kiesletter ] $+ [ $nick ] ] mag voor $radwaarde(%rad.tmp) euro een letter kiezen.
          .notice $nick Typ !letter <letter>
          set %rad.seq letter
          .timer9998 1 30 _rad.telaat
        }
      }
      else {
        .notice $nick Je bent niet aan de beurt!
      }
    }
    else {
      .notice $nick Je bent geen kandidaat in deze ronde.
    }
  }
}

on *:text:!klinker*:%main.channel:{
  if ((%rad.seq == draai) || (%rad.seq == klinkers)) {
    if ($1 == !klinker) {
      if (%rad.kand. [ $+ [ $nick ] ] == yes) {
        if (%rad.beurt == $nick) {
          if (!$2 || $len($2) > 1) { .notice $nick Geef een klinker op! }
          elseif ($2 !isalpha) { .notice $nick Je zal wel een geldig teken moeten opgeven! }
          else {
            .timer9999 off
            if (%rad.score. [ $+ [ %rad.beurt ] ] >= 100) {
              if ($2 !isletter aAeEiIoOuU) {
                msg %main.channel  [ $+ [ %kleuren-rad.stopberichten ] $+ ] Ai... Dat is een medeklinker! (Die moet je niet kopen.)
                msg %main.channel  [ $+ [ %kleuren-rad.stopberichten ] $+ ] Door deze stommiteit gaat de beurt over.
                set %rad.seq wacht
                .timer_rad.beurt 1 7 _rad_beurt.next
              }
              else {
                dec %rad.score. [ $+ [ %rad.beurt ] ] 100
                msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ [ %rad.beurt ] ] koopt voor 100 euro een klinker.
                checkletter $upper($2)
              }
            }
            else {
              msg %main.channel  [ $+ [ %kleuren-rad.stopberichten ] $+ ] Je hebt niet genoeg geld om een klinker te kopen... De beurt gaat over!
              set %rad.seq wacht
              .timer_rad.beurt 1 7 _rad_beurt.next
            }
          }
        }
        else {
          .notice $nick Je bent niet aan de beurt!
        }
      }
      else {
        .notice $nick Je bent geen kandidaat in deze ronde.
      }
    }
  }
}

on *:text:!raad*:%main.channel:{
  if ((%rad.seq == draai) || (%rad.seq == klinkers)) {
    if ($1 == !raad) {
      if (%rad.kand. [ $+ [ $nick ] ] == yes) {
        if (%rad.beurt == $nick) {
          if (!$2) { .notice $nick Geef de oplossing op! }
          else {
            .timer9999 off
            if ($2- == %rad_opgave.tekst) {
              set %rad.seq wacht
              msg %main.channel  [ $+ [ %kleuren-rad.oplossing_goed ] $+ ] " [ $+ [ %rad_opgave.tekst ] $+ ] " is de goeie oplossing! Proficiat, [ [ %rad.beurt ] $+ ] !
              msg %main.channel  [ $+ [ %kleuren-rad.oplossing_goed ] $+ ] Je wint $iif(%rad.score. [ $+ [ %rad.beurt ] ],%rad.score. [ $+ [ %rad.beurt ] ],$chr(48)) euro.
              if (%rad.score. [ $+ [ %rad.beurt ] ]) {
                set %tmp.score $readini(%scorefile,scores,%rad.beurt)
                inc %tmp.score %rad.score. [ $+ [ %rad.beurt ] ]
                writeini %scorefile scores $nick %tmp.score
                unset %tmp.score
              }
              _rad.deactiveer
            }
            else {
              msg %main.channel  [ $+ [ %kleuren-rad.oplossing_fout ] $+ ] Jammer, maar " [ $+ [ $upper($2-) ] $+ ] " is niet goed. De beurt gaat over.
              set %rad.seq wacht
              .timer 1 7 _rad_beurt.next
            }
          }
        }
        else {
          .notice $nick Je bent niet aan de beurt!
        }
      }
      else {
        .notice $nick Je bent geen kandidaat in deze ronde.
      }
    }
  }
}

alias radwaarde {
  return $readini(mirc-fun\rad.dat,rad [ $+ [ %rad.mode ] ],$1)
}

on *:text:!letter*:%main.channel:{
  if (%rad.seq == letter) {
    if ($1 == !letter) {
      if (%rad.kand. [ $+ [ $nick ] ] == yes) {
        if (%rad.beurt == $nick) {
          if ((!$2) || ($len($2) > 1)) { .notice $nick Geef een letter op! }
          elseif ($2 !isalpha) { .notice $nick Je zal wel een geldig teken moeten opgeven! }
          else {
            .timer9998 off
            if ($2 !isletter aAeEiIoOuU) {
              checkletter $upper($2)
            }
            else {
              msg %main.channel  [ $+ [ %kleuren-rad.stopberichten ] $+ ] Ai... Dat is een klinker! (Die moet je kopen.)
              msg %main.channel  [ $+ [ %kleuren-rad.stopberichten ] $+ ] Door deze stommiteit gaat de beurt over.
              set %rad.seq wacht
              .timer_rad.beurt 1 7 _rad_beurt.next
            }
          }
        }
        else {
          .notice $nick Je bent niet aan de beurt!
        }
      }
      else {
        .notice $nick Je bent geen kandidaat in deze ronde.
      }
    }
  }
}

alias checkletter {
  if ($1 isletter %rad.gevraagde_letters) {
    msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ ] De $1 is al een keertje gevraagd. De beurt gaat over.
    set %rad.seq wacht
    .timer_rad.beurt 1 7 _rad_beurt.next
  }
  else {
    if ($1 isletter %rad_opgave.tekst) {
      msg %main.channel  [ $+ [ %kleuren-rad.oplossing_goed ] $+ ] De $1 zit $pos(%rad_opgave.tekst,$1,0) keer in de opgave.
      set %rad.gevraagde_letters %rad.gevraagde_letters $+ $1
      if ($radwaarde(%rad.tmp) != extra) {
        if (!$pos(aeiou,$1,0)) { inc %rad.score. [ $+ [ %rad.beurt ] ] $calc($radwaarde(%rad.tmp) * $pos(%rad_opgave.tekst,$1,0)) }
      }
      elseif (!$pos(aeiou,$1,0)) {
        msg %main.channel  [ $+ [ %kleuren-rad.extraprijs ] $+ [ %rad.beurt ] ] wint een EXTRA PRIJS!!! (500 euro)
        inc %rad.score. [ $+ [ %rad.beurt ] ] 500
      }
      unset %rad.opgave
      set %rad_opgave.lengte 1
      set %rad.check.klinkers yes
      set %rad.continue_play no
      while (%rad_opgave.lengte <= $len(%rad_opgave.tekst)) {
        set %rad.checkletter $mid(%rad_opgave.tekst,%rad_opgave.lengte,1)
        if (%rad.check.klinkers == yes) {
          if ($pos(aeiou,%rad.checkletter,0)) { set %rad.check.klinkers yes }
          elseif (!$pos(abcdefghijklmnopqrstuvwxyz,%rad.checkletter,0)) { set %rad.check.klinkers yes }
          elseif (($pos(bcdfghjklmnpqrstvwxyz,%rad.checkletter,0)) && ($pos(%rad.gevraagde_letters,%rad.checkletter,0))) { set %rad.check.klinkers yes }
          elseif (($pos(bcdfghjklmnpqrstvwxyz,%rad.checkletter,0)) && (!$pos(%rad.gevraagde_letters,%rad.checkletter,0))) { set %rad.check.klinkers no | set %rad.continue_play yes }
        }
        if (%rad.checkletter isletter %rad.gevraagde_letters) {
          set %rad.opgave [ [ [ %rad.opgave ] $+ ]  [ $+ [ %kleuren-rad.opgave_letter ] $+ [ %rad.checkletter ] $+ ]  ]
        }
        else {
          set %rad.opgave [ [ [ %rad.opgave ] $+ ]  [ $+ [ %kleuren-rad.opgave_vakje ] $+ [ $mid(%rad_opgave.leeg,%rad_opgave.lengte,1) ] $+ ]  ]
        }
        inc %rad_opgave.lengte
      }
      set %rad.seq wacht
      .timer_rad.beurt 1 7 _rad.houbeurt
    }
    else {
      msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ ] De $1 zit niet in de opgave! De beurt gaat over.
      set %rad.gevraagde_letters %rad.gevraagde_letters $+ $1
      set %rad.seq wacht
      unset %rad.opgave
      set %rad_opgave.lengte 1
      set %rad.check.klinkers yes
      set %rad.continue_play no
      while (%rad_opgave.lengte <= $len(%rad_opgave.tekst)) {
        set %rad.checkletter $mid(%rad_opgave.tekst,%rad_opgave.lengte,1)
        if (%rad.check.klinkers == yes) {
          if ($pos(aeiou,%rad.checkletter,0)) { set %rad.check.klinkers yes }
          elseif (!$pos(abcdefghijklmnopqrstuvwxyz,%rad.checkletter,0)) { set %rad.check.klinkers yes }
          elseif (($pos(bcdfghjklmnpqrstvwxyz,%rad.checkletter,0)) && ($pos(%rad.gevraagde_letters,%rad.checkletter,0))) { set %rad.check.klinkers yes }
          elseif (($pos(bcdfghjklmnpqrstvwxyz,%rad.checkletter,0)) && (!$pos(%rad.gevraagde_letters,%rad.checkletter,0))) { set %rad.check.klinkers no | set %rad.continue_play yes }
        }
        if (%rad.checkletter isletter %rad.gevraagde_letters) {
          set %rad.opgave [ [ [ %rad.opgave ] $+ ]  [ $+ [ %kleuren-rad.opgave_letter ] $+ [ %rad.checkletter ] $+ ]  ]
        }
        else {
          set %rad.opgave [ [ [ %rad.opgave ] $+ ]  [ $+ [ %kleuren-rad.opgave_vakje ] $+ [ $mid(%rad_opgave.leeg,%rad_opgave.lengte,1) ] $+ ]  ]
        }
        inc %rad_opgave.lengte
      }
      .timer_rad.beurt 1 7 _rad_beurt.next
    }
  }
}

alias -l _rad.houbeurt {
  msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ ] Opgave: $replace(%rad.opgave,$chr(149),$chr(160))
  if (%rad.continue_play == yes) {
    msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ ] Het is de beurt aan %rad.beurt om te draaien $iif(%rad.score. [ $+ [ %rad.beurt ] ] >= 100,of een klinker te kopen)
    .notice %rad.beurt Typ !draai $iif(%rad.score. [ $+ [ %rad.beurt ] ] >= 100,of !klinker <letter>)
    .notice %rad.beurt Wil je de oplossing geven, typ dan !raad <oplossing>
    set %rad.seq draai
    .timer9999 1 30 _rad.telaat
  }
  else {
    msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ ] Alle medeklinkers zijn er uit.  Het is de beurt aan %rad.beurt om te spelen.
    .notice %rad.beurt Typ $iif(%rad.score. [ $+ [ %rad.beurt ] ] >= 100,!klinker <letter> of $+ $chr(32)) $+ !raad <oplossing>
    set %rad.seq klinkers
    .timer9999 1 30 _rad.telaat
  }
}

alias -l _rad.telaat {
  set %rad.seq wacht
  msg %main.channel  [ $+ [ %kleuren-rad.ronde_info ] $+ [ %rad.beurt ] ] reageerde te laat... Slaapwel, [ [ %rad.beurt ] $+ ] !  De beurt gaat over.
  .timer_rad.beurt 1 7 _rad_beurt.next
}
