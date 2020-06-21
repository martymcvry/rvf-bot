; ####################################
; #            MATCHMAKER            #
; # mIRC-script (c) 2004 - Tinke_lat #
; #   Contact: tinke_lat@skynet.be   #
; ####################################

on *:TEXT:!match*:#:{
  if ($1 == !match) {
    if (!$3 || $2 !ison $chan || $3 !ison $chan) { notice $nick Je moet twee nicks opgeven die op het kanaal zijn. (Gebruik: !match <nick1> <nick2>) }
    else {
      var %eerste $upper($2)
      var %eerste.lengte $len(%eerste)
      var %tweede $upper($3)
      var %tweede.lengte $len(%tweede)
      var %LoveCount 0
      var %Count1 0
      while (%Count1 < %eerste.lengte) {
        var %letter1 $mid(%eerste,$calc(%Count1 + 1),1)
        if (%letter1 == I) { var %LoveCount $calc(%LoveCount + 2) }
        if (%letter1 == L) { var %LoveCount $calc(%LoveCount + 2) }
        if (%letter1 == O) { var %LoveCount $calc(%LoveCount + 2) }
        if (%letter1 == V) { var %LoveCount $calc(%LoveCount + 2) }
        if (%letter1 == E) { var %LoveCount $calc(%LoveCount + 2) }
        if (%letter1 == Y) { var %LoveCount $calc(%LoveCount + 3) }
        if (%letter1 == O) { var %LoveCount $calc(%LoveCount + 1) }
        if (%letter1 == U) { var %LoveCount $calc(%LoveCount + 3) }
        inc %Count1
      }
      var %Count2 0
      while (%Count2 < %tweede.lengte) {
        var %letter2 $mid(%tweede,$calc(%Count2 + 1),1)
        if (%letter2 == I) { var %LoveCount $calc(%LoveCount + 2) }
        if (%letter2 == L) { var %LoveCount $calc(%LoveCount + 2) }
        if (%letter2 == O) { var %LoveCount $calc(%LoveCount + 2) }
        if (%letter2 == V) { var %LoveCount $calc(%LoveCount + 2) }
        if (%letter2 == E) { var %LoveCount $calc(%LoveCount + 2) }
        if (%letter2 == Y) { var %LoveCount $calc(%LoveCount + 3) }
        if (%letter2 == O) { var %LoveCount $calc(%LoveCount + 1) }
        if (%letter2 == U) { var %LoveCount $calc(%LoveCount + 3) }
        inc %Count2
      }
      if (%LoveCount > 0) { var %amount $calc(5 - ((%eerste.lengte + %tweede.lengte) / 2)) }
      if (%LoveCount > 2) { var %amount $calc(10 - ((%eerste.lengte + %tweede.lengte) / 2)) }
      if (%LoveCount > 4) { var %amount $calc(20 - ((%eerste.lengte + %tweede.lengte) / 2)) }
      if (%LoveCount > 6) { var %amount $calc(30 - ((%eerste.lengte + %tweede.lengte) / 2)) }
      if (%LoveCount > 8) { var %amount $calc(40 - ((%eerste.lengte + %tweede.lengte) / 2)) }
      if (%LoveCount > 10) { var %amount $calc(50 - ((%eerste.lengte + %tweede.lengte) / 2)) }
      if (%LoveCount > 12) { var %amount $calc(60 - ((%eerste.lengte + %tweede.lengte) / 2)) }
      if (%LoveCount > 14) { var %amount $calc(70 - ((%eerste.lengte + %tweede.lengte) / 2)) }
      if (%LoveCount > 16) { var %amount $calc(80 - ((%eerste.lengte + %tweede.lengte) / 2)) }
      if (%LoveCount > 18) { var %amount $calc(90 - ((%eerste.lengte + %tweede.lengte) / 2)) }
      if (%LoveCount > 20) { var %amount $calc(100 - ((%eerste.lengte + %tweede.lengte) / 2)) }
      if (%LoveCount > 22) { var %amount $calc(110 - ((%eerste.lengte + %tweede.lengte) / 2)) }
      if (%amount < 0) { var %amount 0 }
      if (%amount > 99) { var %amount 99 }
      msg $chan De match tussen $2 en $3 is %amount $+ $chr(37) $+ !
    }
  }
}
