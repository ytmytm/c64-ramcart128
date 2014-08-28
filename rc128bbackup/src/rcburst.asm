

;rcburst.src 
;RamCartBurstBackup by YTM/Alliance
;07.08.1997

;kopiowanie:
;I tura
;1-7, 8-14, 15-19 - z przeniesieniem
;20-28            - do ram
;II tura
;28-35            - do ram

drcode   = $1100
drv      = $0400

buff     = $1500

tl       = $22
th       = $23

mb       = $24
sb       = $25

lb       = $27
hb       = $28

tr       = $29

lb2      = $fe
hb2      = $ff

pr       .macro
         lda #<\1
         ldy #>\1
         jsr $ab1e
         .endm
key      .macro
         jsr $ffe4
         beq *-3
         .endm

         *= $0850

         lda #$17
         sta $d018
         lda #0
         sta $d020
         sta $d021
         lda #$0f
         sta $0286
         jsr $e544

test     lda #0
         sta $de00
         sta $de01

         lda $df00
         sta memx

         lda #"m"
         sta $df00

         lda $df00
         sta memx+1
         lda memx
         sta $df00

         lda memx+1
         cmp #"m"
         beq tcont

tfault   #pr przelacz
         #key
         jmp test

tcont

start    lda #8
         sta $ba
         lda #<nmi
         sta $0318
         lda #>nmi
         sta $0319

         #pr initext
         ldx #0
         ldy #0
cll      txa
         ora #$30
         sta sectext+1
         tya
         ora #$30
         sta sectext+2
         stx memx
         sty memy
         #pr sectext
         ldy memy
         ldx memx
         iny
         cpy #10
         bne cll
         ldy #0
         inx
         cpx #2
         bne cll
         ldy #0
         txa
         ora #$30
         sta sectext+1
         tya
         ora #$30
         sta sectext+2
         #pr sectext
         lda #"v"
         sta $0400+(21*40)+20+2
         lda #"e"
         sta $0400+(21*40)+21+2
         lda #"r"
         sta $0400+(21*40)+22+2
         lda #"."
         sta $0400+(21*40)+23+2
         lda #" "
         sta $0400+(21*40)+24+2
         sta $0400+(21*40)+27+2
         lda #"o"
         sta $0400+(21*40)+25+2
         lda #"n"
         sta $0400+(21*40)+26+2
         lda #$2c
         sta byte
         #pr opcje
main     #key
         cmp #135
         bne niever
         jsr chngver
         jmp main
niever   cmp #133
         bne niecopy
         jsr copyfull
         jmp main
niecopy  cmp #134
         bne niescan
         jsr fastscan
         jmp main
niescan  cmp #136
         bne niedir
         jsr dir
         jmp start
niedir   jmp main

nmi      rti

memx     .byte 0
memy     .byte 0
;---------------------------------------
dir      jsr $e544
         lda #1
         ldx $ba
         ldy #0
         jsr $ffba
dlen     lda #1
         ldx #<tyt
         ldy #>tyt
         jsr $ffbd
         lda #1
         jsr $ffc0
         ldx #1
         lda #1
         jsr $ffc6
         jsr $ffcf
         jsr $ffcf
liczba   jsr $ffcf
         jsr $ffcf
         lda $90
         and #%01000000
         bne knc
         jsr $ffcf
         tax
         lda $91
         bpl knc
         jsr $ffcf
         jsr $bdcd
         lda #" "
         jsr $ffd2
czytaj   jsr $ffcf
         bne bom
         lda #13
         jsr $ffd2
         jmp liczba
bom      jsr $ffd2
         lda $d6
         beq czytaj
         lda $d3
         cmp #24
         bmi czytaj
         jmp czytaj
knc      lda #1
         jsr $ffc3
         jsr $ffcc
         #pr dend
dwai     #key
         cmp #" "
         bne dwai
         rts

tyt      .text "$"
dend     .byte 13,18
         .text " press space "
         .byte 146,0
;---------------------------------------
sourceon jsr textoff
         clc
         ldy #0
         ldx #24
         jsr $fff0
         #pr source
         lda #$0b
         sta $d020
         clc
         #key
         ldx #0
         stx $d020
         cmp #3
         rts

targeton jsr textoff
         clc
         ldy #0
         ldx #24
         jsr $fff0
         #pr target
         lda #$0b
         sta $d020
         #key
         ldx #0
         stx $d020
         cmp #3
         rts

textoff  lda #" "
         ldx #0
clrlp    sta $0400+(24*40),x
         inx
         cpx #40
         bne clrlp
         rts
;---------------------------------------
fastscan lda #$24
         sta here1
         sta here2
         jsr sourceon
         beq fscend
         ldx #1
         ldy #35
         jsr readtracks
fscend   lda #$91
         sta here1
         sta here2
         jsr textoff
         rts
;---------------------------------------
chngver  lda byte
         eor #$60
         sta byte
         cmp #$2c
         beq veron
         lda #"f"
         sta $0400+(21*40)+26+2
         sta $0400+(21*40)+27+2
         rts
veron    lda #"n"
         sta $0400+(21*40)+26+2
         lda #" "
         sta $0400+(21*40)+27+2
         rts

;---------------------------------------
copyfull lda #0
         sta lb2
         sta hb2
         jsr sourceon
         beq cfend
         ldx #1
         ldy #7
         jsr readtracks
         jsr copy2rc
         ldx #8
         ldy #14
         jsr read2
         jsr copy2rc
         ldx #15
         ldy #19
         jsr read2
         jsr copy2rc
         ldx #20
         ldy #28
         jsr read2

         jsr targeton
         beq cfend

         ldx #20
         ldy #28
         jsr writetracks
         lda #0
         sta lb2
         sta hb2
         jsr copyfromrc
         ldx #1
         ldy #7
         jsr write2
         jsr copyfromrc
         ldx #8
         ldy #14
         jsr write2
         jsr copyfromrc
         ldx #15
         ldy #19
         jsr write2

         jsr sourceon
         beq cfend

         ldx #29
         ldy #35
         jsr readtracks

         jsr targeton
         beq cfend

         ldx #29
         ldy #35
         jsr writetracks
cfend    jsr textoff
         rts
;---------------------------------------
copy2rc  sei
         lda #$35
         sta $01
         lda #<buff
         ldx #>buff
         sta tl
         stx th
         inc sb
lplp0    lda lb2
         sta $de00
         lda hb2
         sta $de01
         ldy #0
lplp     lda (tl),y
         sta $df00,y
         iny
         bne lplp
         inc th
         inc lb2
         bne *+4
         inc hb2
         lda th
         cmp sb
         bne lplp0
         lda #$37
         sta $01
         cli
         rts

copyfromrc sei
         lda #$35
         sta $01
         lda #<buff
         ldx #>buff
         sta tl
         stx th
lp2lp0   lda lb2
         sta $de00
         lda hb2
         sta $de01
         ldy #0
lp2lp    lda $df00,y
         sta (tl),y
         iny
         bne lp2lp
         inc th
         inc lb2
         bne *+4
         inc hb2
         lda th
         cmp #$cf
         bne lp2lp0
         lda #$37
         sta $01
         cli
         rts

read2    tya
         pha
         txa
         sta tr
         ldx #<(drv+$018b)
         ldy #>(drv+$018b)
         jsr trrr
         pla
         ldx #<(drv+$0154)
         ldy #>(drv+$0154)
         jsr trrr
         jmp read2tr

write2   tya
         pha
         txa
         sta tr
         ldx #<(drv+$03ba-$01ba)
         ldy #>(drv+$03ba-$01ba)
         jsr trrr
         pla
         ldx #<(drv+$037e-$01ba)
         ldy #>(drv+$037e-$01ba)
         jsr trrr
         jmp write2tr

trrr     sta what
         stx addd
         sty addd+1
         lda $ba
         jsr $ffb1
         lda #$6f
         jsr $ff93
         ldx #0
trrrlp   lda order,x
         jsr $ffa8
         inx
         cpx #8
         bne trrrlp
         jmp $ffae

;---------------------------------------
readtracks
         stx drcode+$018b
         stx tr
         sty drcode+$0154

         ldx #<drcode
         ldy #>drcode
         lda #2
         jsr fastmw

read2tr  lda $dd0d
         ldx #$78
         ldy #$05
         jsr drexec
         jsr init
         lda #<buff
         sta mb
         lda #>buff
         sta sb

         lda $dd0d
         beq *-3
         lda $dd01
         cmp #$02
         bcs fin

mainread lda $dd0d
         beq *-3
         ldx $dd01
         bne notend
fin      jmp done

notend   lda tr
         clc
         adc #$52
         sta lb
         lda #$04
         sta hb
         inc tr

rdlp0    lda $dd0d
         beq *-3
         lda $dd01
         bne fault

         ldy #$00
rdlp1    lda $dd0d
         beq *-3
         lda $dd01
here1    sta (mb),y
         iny
         bne rdlp1

         inc sb

rdlp2    lda $dd0d
         beq *-3
         lda $dd01
here2    sta (mb),y
         iny
         cpy #$43
         bne rdlp2

         lda $dd0d
         beq *-3

         lda $dd01

fault    php
         lda #$3f
         plp
         bne err
         lda #$2a
err      ldy #$00
         sta (lb),y
         lda lb
         clc
         adc #$28
         sta lb
         bcc rdlp4
         inc hb
rdlp4    lda mb
         clc
         adc #$43
         sta mb
         lda sb
         adc #$00
         cmp #$ff
         bcc rdlp5

         lda #$80       ;^
         sta mb         ;^

         lda #$12
         bne rdnext
rdlp5    cmp #$e0
         bcs rdnext
         cmp #$cf
         bcc rdnext
         lda #$00
         sta mb
         lda #$e0
rdnext   sta sb
         dex
         bne rdlp0
         jmp mainread
;---------------------------------------
writetracks

         stx drcode+$03ba
         stx tr
         sty drcode+$037e

         lda byte
         sta drcode+$029b

         ldx #<(drcode+$01ba)
         ldy #>(drcode+$01ba)
         lda #3
         jsr fastmw

write2tr lda $dd0d
         ldx #$e8
         ldy #$05
         jsr drexec

         jsr init

         lda #<buff
         sta mb
         lda #>buff
         sta sb

         lda $dd0d
         beq *-3
         lda $dd01

mainwrite
         lda $dd0d
         beq *-3
         ldx $dd01
         bne notend2
         jmp done

notend2  lda #$ff
         sta $dd03
         lda tr
         clc
         adc #$52
         sta lb
         lda #$04
         sta hb
         inc tr
wrlp0    ldy #$00
         lda (mb),y
         sta $dd01
         iny
wrlp1    lda $dd0d
         beq *-3
         lda (mb),y
         sta $dd01
         iny
         bne wrlp1
         inc sb
wrlp2    lda $dd0d
         beq *-3
         lda (mb),y
         sta $dd01
         iny
         cpy #$43
         bne wrlp2
         lda mb
         clc
         adc #$43
         sta mb
         lda sb
         adc #$00
         cmp #$ff
         bcc wrlp3

         lda #$80     ;^
         sta mb       ;^

         lda #$12
         bne wrlp4
wrlp3    cmp #$e0
         bcs wrlp4
         cmp #$cf
         bcc wrlp4
         lda #$00
         sta mb
         lda #$e0
wrlp4    sta sb

         lda $dd0d
         beq *-3
         dex
         bne wrlp0

         lda #$00
         sta $dd03
byte     bit mainwrite
         lda $dd0d
         beq *-3
         ldx $dd01
wrlp5    lda $dd0d
         beq *-3
         lda $dd01
         php
         lda #$3f
         plp
         bne wrlp6
         lda #$2a
wrlp6    ldy #$00
         sta (lb),y
         lda lb
         clc
         adc #$28
         sta lb
         bcc wrlp7
         inc hb
wrlp7    dex
         bne wrlp5
         jmp mainwrite
;---------------------------------------
init     sei
         lda #$35
         sta $01
inlp     lda $d012
         bne inlp
         sta $d015
         lda #$0b
         sta $d011
         rts

done     lda #$1b
         sta $d011
         lda #$00
         sta $dd03
         lda #$37
         sta $01
         cli
         rts

;---------------------------------------
fastmw   sta x0+1
         sta drhow2+1
         lda #$50
         sta mb
         lda #<drvcd
         sta tl
         lda #$01
         sta sb
         lda #$00
         sta $d015
         lda #>drvcd
         sta th
         stx x3+1
         sty x3+2
         jsr mew
         bcc *+7
drerror  cli
         sec
         lda #$80
         rts
         lda #$23
         sta $dd00
         bit $dd00
         bvs *-3
x0       lda #$02
         sta $02
x1       bit $dd00
         bvc *-3
         ldy #$00
x3       lda $1000,y
         pha
         lsr a
         lsr a
         lsr a
         lsr a
         tax
         sec
x4       lda $d012
         sbc #$32
         bcc x5
         and #$07
         beq x4
x5       lda #$03
         sta $dd00
         lda tabkon,x
         sta $dd00
         lsr a
         lsr a
         and #$f7
         sta $dd00
         pla
         and #$0f
         tax
         lda tabkon,x
         sta $dd00
         lsr a
         lsr a
         and #$f7
         sta $dd00
         lda #$23
         nop
         nop
         iny
         sta $dd00
         bne x3
         inc x3+2
         dec $02
         bne x1
         lda #$20
         cmp $d012
         bne *-3
         ldx #$1b
         stx $d011
         lda $dd00
         and #%11111100
         ora #%00000011
         sta $dd00
         clc
         rts
;---------------------------------------
tabkon   .byte $07,$87,$27,$a7,$47,$c7
         .byte $67,$e7
         .byte $17,$97,$37,$b7,$57,$d7
         .byte $77,$f7
;---------------------------------------
drvcd    sei
         jsr $019c
         lda #$7a
         sta $1802
         jsr $f5e9
drhow2   lda #$03
         sta $06
drv1     jsr $0173
         inc $0198
         dec $06
         bne drv1
         lda #$10
         sta $1c07
         nop
         nop
         nop
         rts
         ldy #$00
         sty $1800
drv2     lda $1800
         bne *-3
         php
         lda $1800
         asl a
         plp
         eor $1800
         asl a
         asl a
         asl a
         nop
         nop
         nop
         eor $1800
         asl a
         nop
         nop
         nop
         eor $1800
         sta $0400,y
         iny
         bne drv2
         lda #$08
         sta $1800
         rts
;---------------------------------------
mew      ldx #3
loop     lda $ba
         jsr $ffb1
         lda #$00
         sta $90
         lda #$6f
         jsr $ff93
         bit $90
         bpl dalej
         sec
         rts
dalej    lda #$4d
         jsr $ffa8
         lda #$2d
         jsr $ffa8
         lda #$57
         jsr $ffa8
         lda mb
         jsr $ffa8
         lda sb
         jsr $ffa8
         lda #$20
         jsr $ffa8
         ldy #$00
loop1    lda (tl),y
         jsr $ffa8
         iny
         cpy #$20
         bne loop1
         jsr $ffae
         lda mb
         clc
         adc #$20
         sta mb
         bcc *+4
         inc sb
         lda tl
         clc
         adc #$20
         sta tl
         bcc *+4
         inc th
         dex
         bne loop
         ldx #$50
         ldy #$01
         jsr draddy

mex      lda $ba
         jsr $ffb1
         lda #$6f
         jsr $ff93
         ldx #$00
         lda mex1,x  ;zm3
         jsr $ffa8
         inx
         cpx #$05
         bne *-9
         jsr $ffae
         sei
         clc
         rts

draddy   stx trans
         sty trans+1
         rts

drexec   jsr draddy
         jmp mex
;---------------------------------------
mex1     .text "m-e"
trans    .byte $50,$01

order    .text "m-w"
addd     .byte 0,4,1
what     .byte 1

initext  .byte 147
         .text "R-CBac/YTM  "
         .text "1111111111"
         .text "2222222222333333"
         .byte 13
         .text "   1234567890123456789"
         .text "0123456789012345"
         .byte 13
         .byte 0

sectext  .text " 00.................."
         .text "................."
         .byte 13,0

opcje    .text " F1 - Copy F3 - Scan "
         .text "F5 - Ver. F7 - Dir"
         .byte 0

source   .text "     Insert source disk"
         .byte 0
target   .text "     Insert target disk"
         .byte 0
przelacz .byte 147
         .null "    przelacz w zapis!"


