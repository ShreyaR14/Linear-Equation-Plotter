; Linear Equation
; An 8086 based assembly program to plot linear equations

.model huge      ;both code and data can exceed 64 bytes
org 100h         ;for origin, from where machine code starts
start:
    jmp program
    	
    pr1 db 10,13,10,10,10,"                     Linear Equation Plotter$"                     
    pr4 db 10,10,13, "                     Description :$"  
    pr5 db 10,10,13, "                     This program plots linear equations$"              ;10- line feed (next line)
    pr6 db 10,13, "                     using 8086 assembly language$"                        ;13- carriage return (start of line)
    pr7 db 10,10,13, "                     _______________________________________$"      
    pr10 db 10,10,13, "                     [Enter] Continue     [Esc] Back$"
    pr11 db 10,10,13, "                     Choose type of equation: $"
    pr12 db 10,10,13, "                     [1] y = b $"    
    pr13 db 10,13, "                     [2] y = -b $" 
    pr14 db 10,13, "                     [3] y = -mx + b $"
    pr15 db 10,13, "                     [4] y = mx - b $"
    pr16 db 10,13, "                     [5] y = -mx - b $"
    pr17 db 10,13, "                     [6] y = mx + b $"
    pr18 db 10,10,13, "                     Equation Type: y = b$"
    pr19 db 10,10,13, "                     Enter the equation: y = $"
    pr20 db 10,10,13, "                     Equation Type: y = -b$"
    pr21 db 10,10,13, "                     Enter the equation: y = -$"
    pr22 db 10,10,13, "                     Equation Type: y = -mx + b$"
    pr23 db 10,10,13, "                     Enter the slope (m): -$"
    pr24 db 10,13, "                     Enter the constant (b): $"
    pr25 db 10,10,13, "                     The equation is: y = $" 
    pr26 db 10,10,13, "                     [g] Graph [esc] Back $"
    pr27 db 10,10,13, "                     [Esc] Back $"  
    pr28 db 10,10,13, "                     Enter the slope (m): $"
    pr29 db 10,10,13, "                     Equation Type: y = mx - b$" 
    pr30 db 10,10,13, "                     Equation Type: y = -mx - b$"
    pr31 db 10,13, "                     Enter the constant (b): -$"        
    pr32 db 10,10,13, "                     Equation Type: y = mx + b$"
    q db 10,10,13, "                     Select: $"                                     ;user input
    x db "X-axis$"
    y db " Y-axis$"
exit: int 20h                           ;terminate program

program proc near                
    call clear
    mov dx, offset pr1  ;print
    call print
    mov dx, offset pr4  ;print
    call print
    mov dx, offset pr5  ;print
    call print
    mov dx, offset pr6  ;print
    call print
    mov dx, offset pr7  ;print
    call print       
    mov dx, offset pr10  ;print
    call print 
    
    mov ah, 01h         ;read character 
    int 21h
    cmp al, 0dh         ;next line - 0d in hex (carriage return)
    je step_1
    cmp al, 1bh         ;esc - 1b in hex
    je exit
    jne program         
    ret 
program endp            

step_1 proc near
        call clear
        mov dx, offset pr1   ;print
        call print
        mov dx, offset pr11  ;print
        call print
        mov dx, offset pr12  ;print
        call print
        mov dx, offset pr13  ;print
        call print
        mov dx, offset pr14  ;print
        call print
        mov dx, offset pr15  ;print
        call print
        mov dx, offset pr16  ;print
        call print
        mov dx, offset pr17  ;print
        call print
        mov dx, offset q     ;print Select
        call print
        mov ah, 01h          ;read input
        int 21h 
        cmp al, 31h             ;if 1 is pressed proceed to y = b program        ;hex code for 1
        je bpos
        cmp al, 32h             ;if 2 is pressed proceed to y = -b program
        je bneg
        cmp al, 33h             ;if 3 is pressed proceed to y = -mx + b
        je mnegbpos
        cmp al, 34h             ;if 4 is pressed proceed to y = mx - b
        je mposbneg
        cmp al, 35h             ;if 5 is pressed proceed to y = -mx - b
        je mnegbneg
        cmp al, 36h             ;if 6 is pressed proceed to y = mx + b
        je mposbpos
        jne step_1              ;restart this page
        
        bpos: ; input is y = b 
        call clear
        mov dx, offset pr1   ;print
        call print
        mov dx, offset pr18  ;print Equation Type: y = b$"
        call print
        mov dx, offset pr19  ;print Enter the equation: y = $"
        call print
        mov ah, 01h          ;read character
        int 21h 
        mov bl, al           ;transfer the b(al) to bl    ;Character read is returned in AL in ASCII value       
        mov dx, offset pr25  
        call print
        mov ah, 02h          ;Display single character
        mov dl, bl           ;Sends the characters in DL to display
        int 21h
        mov dx, offset pr26  ;print [g] Graph [esc] Back $"
        call print
        mov dx, offset q
        call print           ;print Select
        mov ah, 01h
        int 21h
        cmp al, 67h          ;enter g
        je graph_bpos        ;jump to graph
        cmp al, 1bh          ;enter esc
        je program           ;esc input - program
        jne bpos             ;wrong
             
        bneg:
        call clear
        mov dx, offset pr1   ;print
        call print
        mov dx, offset pr20  ;print
        call print
        mov dx, offset pr21  ;print
        call print
        mov ah, 01h
        int 21h
        mov bl, al           ;transfer al to bl
        mov dx, offset pr25
        call print
        mov dl, '-'
        mov ah, 2
        int 21h
        mov dl, bl
        mov ah, 2
        int 21h
        mov dx, offset pr26
        call print
        mov dx, offset q
        call print
        mov ah, 01h
        int 21h
        cmp al, 67h
        je graph_bneg
        cmp al, 1bh
        je program
        jne bneg        
        
        mnegbpos:
        call clear
        mov dx, offset pr1   
        call print
        mov dx, offset pr22  
        call print
        mov dx, offset pr23  
        call print
        mov ah, 01h
        int 21h
        mov cl, al              ;the slope is stored to cl
        mov dx, offset pr24     ;print
        call print
        mov ah, 01h
        int 21h 
        mov bl, al              ;the constant is stored to bl 
        mov dx, offset pr25
        call print
        jmp eqmnegbpos
          
        rtrn:
        mov dx, offset pr26
        call print
        mov dx, offset q
        call print
        mov ah, 01h
        int 21h
        cmp al, 67h
        je graph_mnegbpos
        cmp al, 1bh
        je program
        jne mnegbpos 
        
        mposbneg:
        call clear
        mov dx, offset pr1  
        call print
        mov dx, offset pr29 
        call print
        mov dx, offset pr28 
        call print
        mov ah, 01h
        int 21h
        mov cl, al                 ;the slope is stored to cl
        mov dx, offset pr24        ;print
        call print
        mov ah, 01h
        int 21h 
        mov bl, al                 ;the constant is stored to bl 
        mov dx, offset pr25
        call print
        call eqmposbneg
        
        rtrn2:
        mov dx, offset pr26
        call print
        mov dx, offset q
        call print
        mov ah, 01h
        int 21h
        cmp al, 67h
        je graph_mposbneg
        cmp al, 1bh
        je program
        jne mposbneg 
    
        mnegbneg:
        call clear
        mov dx, offset pr1 
        call print
        mov dx, offset pr30
        call print
        mov dx, offset pr23
        call print
        mov ah, 01h
        int 21h
        mov cl, al                   ;the slope is stored to cl
        mov dx, offset pr31          ;print
        call print
        mov ah, 01h
        int 21h 
        mov bl, al                   ;the constant is stored to bl 
        mov dx, offset pr25
        call print
        call eqmnegbneg
        
        rtrn3:
        mov dx, offset pr26
        call print
        mov dx, offset q
        call print
        mov ah, 01h
        int 21h
        cmp al, 67h
        je graph_mnegbneg
        cmp al, 1bh
        je program
        jne mnegbneg 
        
        mposbpos:    
        call clear
        mov dx, offset pr1
        call print
        mov dx, offset pr32
        call print
        mov dx, offset pr28 
        call print
        mov ah, 01h
        int 21h
        mov cl, al                ;the slope is stored to cl
        mov dx, offset pr24  
        call print
        mov ah, 01h
        int 21h 
        mov bl, al                ;the constant is stored to bl 
        mov dx, offset pr25
        call print
        call eqmposbpos
        
        rtrn4:
        mov dx, offset pr26
        call print
        mov dx, offset q
        call print
        mov ah, 01h
        int 21h
        cmp al, 67h
        je graph_mposbpos
        cmp al, 1bh
        je program
        jne mposbpos     
        
        
        ;for making equations    
        eqmnegbpos:
        mov ah, 2
        mov dl, '-'
        int 21h
        mov ah, 2
        mov dl, cl
        int 21h
        mov ah, 2
        mov dl, 'x'
        int 21h
        mov ah, 2
        mov dl, ' '
        int 21h
        mov ah, 2
        mov dl, '+'
        int 21h
        mov ah, 2
        mov dl, ' '
        int 21h
        mov ah, 2
        mov dl, bl
        int 21h   
        jmp rtrn
        ret   
        
        eqmposbneg:
        mov ah, 2
        mov dl, cl
        int 21h
        mov ah, 2
        mov dl, 'x'
        int 21h
        mov ah, 2
        mov dl, ' '
        int 21h
        mov ah, 2
        mov dl, '-'
        int 21h
        mov ah, 2
        mov dl, ' '
        int 21h
        mov ah, 2
        mov dl, bl
        int 21h   
        jmp rtrn2
        ret  
        
        eqmnegbneg:
        mov ah, 2
        mov dl, '-'
        int 21h
        mov ah, 2
        mov dl, cl
        int 21h
        mov ah, 2
        mov dl, 'x'
        int 21h
        mov ah, 2
        mov dl, ' '
        int 21h
        mov ah, 2
        mov dl, '-'
        int 21h
        mov ah, 2
        mov dl, ' '
        int 21h
        mov ah, 2
        mov dl, bl
        int 21h   
        jmp rtrn3  
        ret
        
        eqmposbpos:
        mov ah, 2
        mov dl, cl
        int 21h
        mov ah, 2
        mov dl, 'x'
        int 21h
        mov ah, 2
        mov dl, ' '
        int 21h
        mov ah, 2
        mov dl, '+'
        int 21h
        mov ah, 2
        mov dl, ' '
        int 21h
        mov ah, 2
        mov dl, bl
        int 21h   
        jmp rtrn4          
        ret         
step_1 endp

print proc near
    mov ah, 09h            ;writing string to standard output
    int 21h              
    ret
print endp

clear proc near
    mov ax, 03h            ;set video to text
    int 10h                ;clear screen
    ret
clear endp

graph_bpos proc near   
; now since the constant is stored in bl we need to multiply it by 10 to get the proper intervals
sub bl, '0'      ;ascii to decimal
mov ax, 10
mul bl
mov bl, al       ;transfer the contents of al to bl
mov bh, 0        
call plane  
mov al, 10       ;light green
mov cx, 5        ;start of eq line
mov dx, 100      ;b 0-100
sub dx, bx       ;sub  dx(100 pix-y axis) - bx(user input)   ;eg 100-60=40 from top

equation:
inc cx           ;+1 increment
int 10h
cmp cx, 315      ;end of eq line
jne equation    
call xandy
mov dh, 22       ;row position
mov dl, 2        ;col position
mov bh, 0        ;select page 0
mov ah, 2        ;sets cursor at specific location
int 10h 
mov dx, offset pr27     ;esc back line
call print
mov ah, 01h          ;read char
int 21h
cmp al, 1bh          ;hex esc
je program
jne program      
call program
graph_bpos endp 

graph_bneg proc near
sub bl, '0'
mov ax, 10              
mul bl
mov bl, al          ;transfer the contents of al to bl
mov bh, 0
call plane  
mov al, 10          ;light green
mov cx, 5
mov dx, 100
add dx, bx          ;add  100+ bl*10
        
equation2:
inc cx
int 10h
cmp cx, 315
JNE equation2  
call xandy 
mov dh, 22
mov dl, 1
mov bh, 0  
mov ah, 2  
int 10h 
mov dx, offset pr27     ;esc
call print
mov ah, 01h
int 21h
cmp al, 1bh
je program
jne program  
call program 
ret 
graph_bneg endp

graph_mnegbpos proc near      ;y = -mx+b
sub bl, '0'         ;b
sub cl, '0'         ;m
cmp bl, cl          ;cl(m) to bl
je inith 
mov bh, cl
mov ax, 10
mul bl
mov bl, al          ;transfer the contents of al to bl  (bl*10)
call plane    
mov al, bl 
mov ah, 0 
mov bl, bh
mov cx, 160
add cx, ax 
jmp ashe
        
inith: 
mov bh, cl      ;cl to bh (m)
call plane    
mov al, bl      ;bl to al (b)
mov ah, 0       ;ah=0
mov bl, bh      ;bh to bl
mov ax, 10
mov cx, 160     ;x axis mid
add cx, ax      ;origin+ax      (1,0)
jmp draven          

ashe: 
mov cx, 160     ;x axis reach
add cx, ax      ;origin+ax      (1,0)

draven:     
mov bh, al         
mov dx, 101     ;y below axis    
mov al, 10      
mov ah, 0ch    

equation3:          ;above origin
mov al, bl

loop1:
dec dx
dec bl
int 10h
cmp dx, 1                                                       
jbe reinit
cmp bl, 0 
jne loop1
dec cx
cmp dx, 0           ;end
mov bl, al
jne equation3 

reinit:
xchg al, bl 
mov ah, 0
mov al, bh
mov ah, 0
mov cx, 160
add cx, ax
mov dx, 99          ;start
mov al, 10
mov ah, 0ch         ;put pixels

equation3b:         ;below origin
mov al, bl

loop2:
inc dx
dec bl
int 10h
cmp dx, 199          ;end                                             
je continue
cmp bl, 0 
jne loop2
inc cx               ;increment 
cmp dx, 200 
mov bl, al
jne equation3b

continue:
call xandy 
mov dh, 22
mov dl, 1
mov bh, 0  
mov ah, 2  
int 10h 
mov dx, offset pr27
call print
mov ah, 01h
int 21h
cmp al, 1bh
je program
jne program      
call program 
ret
graph_mnegbpos endp 

graph_mposbneg proc near  
sub bl, '0'
sub cl, '0'
cmp bl, cl
je inith1 
mov bh, cl
mov ax, 10
mul bl
mov bl, al          ;transfer the contents of al to bl  
call plane    
mov al, bl 
mov ah, 0 
mov bl, bh 
jmp ashe1

inith1: 
mov bh, cl
call plane    
mov al, bl 
mov ah, 0           ;set video mode
mov bl, bh 
mov ax, 10
mov cx, 160
add cx, ax
jmp draven1          

ashe1: 
mov cx, 160
add cx, ax 

draven1:     
mov bh, al         
mov dx, 101         
mov al, 10
mov ah, 0ch          ;write graphics pixel

equation4: 
mov al, bl

loop3:
dec dx
dec bl
int 10h
cmp dx, 1                                                       
jbe reinit1
cmp bl, 0 
jne loop3
inc cx
cmp dx, 320 
mov bl, al
jne equation4 

reinit1:
xchg al, bl 
mov ah, 0
mov al, bh
mov ah, 0
mov cx, 160
add cx, ax
mov dx, 99
mov al, 10
mov ah, 0ch               ;write graphic pixel

equation4b: 
mov al, bl

loop3a:
inc dx
dec bl
int 10h
cmp dx, 199                                                       
ja continue1
cmp bl, 0 
jne loop3a
dec cx
cmp dx, 0 
mov bl, al
JNE equation4b

continue1:  
call xandy 
mov dh, 22
mov dl, 1
mov bh, 0  
mov ah, 2  
int 10h 
mov dx, offset pr27
call print
mov ah, 01h
int 21h
cmp al, 1bh
je program
jne program      
call program 
ret
graph_mposbneg endp

graph_mnegbneg proc near  
sub bl, '0'         
sub cl, '0'         
cmp bl, cl
je inith2 
mov bh, cl
mov ax, 10
mul bl
mov bl, al              ;transfer the contents of al to bl  
call plane    
mov al, bl 
mov ah, 0 
mov bl, bh 
jmp ashe2

inith2: 
mov bh, cl
call plane    
mov al, bl 
mov ah, 0 
mov bl, bh 
mov ax, 10
mov cx, 160
sub cx, ax
jmp draven2         

ashe2: 
mov cx, 160
sub cx, ax 

draven2:     
mov bh, al         
mov dx, 101         
mov al, 10
mov ah, 0ch                ;write graphic pixels

equation4a:                
mov al, bl

loopxy:
dec dx
dec bl
int 10h
cmp dx, 1                                                       
jbe reenet
cmp bl, 0 
jne loopxy
dec cx
cmp dx, 0 
mov bl, al
jne equation4a 
reenet:
xchg al, bl 
mov ah, 0
mov al, bh
mov ah, 0
mov cx, 160
sub cx, ax
mov dx, 99
mov al, 10
mov ah, 0ch        ;write graphic pixels

equation5b: 
mov al, bl
jmp loop2

loopyx:
inc dx
dec bl
int 10h
cmp dx, 199                                                       
ja continuex
cmp bl, 0 
jne loopyx
inc cx
cmp dx, 200 
mov bl, al
jne equation5b

continuex:
call xandy 
mov dh, 22
mov dl, 1
mov bh, 0  
mov ah, 2  
int 10h 
mov dx, offset pr27
call print
mov ah, 01h
int 21h
cmp al, 1bh
je mnegbneg
jne program      
ret
graph_mnegbneg endp

graph_mposbpos proc near  
sub bl, '0'
sub cl, '0'
cmp bl, cl
je inith3 
mov bh, cl
mov ax, 10
mul bl
mov bl, al           ;transfer the contents of al to bl  
call plane    
mov al, bl 
mov ah, 0 
mov bl, bh 
jmp ashe3

inith3: 
mov bh, cl
call plane    
mov al, bl 
mov ah, 0 
mov bl, bh 
mov ax, 10
mov cx, 160
sub cx, ax
jmp draven3         

ashe3: 
mov cx, 160
sub cx, ax 

draven3:     
mov bh, al         
mov dx, 101         
mov al, 10
mov ah, 0ch         ;writing graphic pixel

equation7ab:
mov al, bl
jmp loopxyz

loopxyz:
dec dx
dec bl
int 10h
cmp dx, 1                                                       
jbe reenete
cmp bl, 0 
jne loopxyz
inc cx
cmp dx, 320 
mov bl, al
jne equation7ab 

reenete:
xchg al, bl 
mov ah, 0
mov al, bh
mov ah, 0
mov cx, 160
sub cx, ax
mov dx, 99
mov al, 10
mov ah, 0ch         ;writing graphic pixel

equation5bx: 
mov al, bl
loopyxxx:
inc dx
dec bl
int 10h
cmp dx, 199                                                       
ja continuexx
cmp bl, 0 
jne loopyxxx
dec cx
cmp dx, 0 
mov bl, al
jne equation5bx
continuexx: 
call xandy 
mov dh, 22
mov dl, 1
mov bh, 0  
mov ah, 2  
int 10h 
mov dx, offset pr27
call print
mov ah, 01h
int 21h
cmp al, 1bh
je program
jne program      
ret
graph_mposbpos endp   

plane proc near
    mov ah, 0   ; set display mode function.
    mov al, 13h ; mode 13h = 320x200 pixels, 256 colors.
    int 10h     ; set it
   
    mov al, 15                  ;intense white color
    mov cx, 0                   ;col       number of times to write character
    mov dx, 100                 ;row
    mov ah, 0ch                 ;put pixel   
    
    colcountconst:              ;x
    inc cx
    int 10h                     ;draw line hor
    cmp cx, 320                 ; 0 - 320 pixel line
    jne colcountconst   
    
    mov al, 15                  ;intense white color
    mov cx, 160
    mov dx, 0
    rowcountconst:              ;y - ver
    inc dx
    int 10h
    cmp dx, 200
    jne rowcountconst
    
    ;; drawing the separators
    ;hor seperators on ver line
    mov al, 14              ;yellow
    mov cx, 157             ;col
    mov dx, 10              ;row start of y
    mov ah, 0ch             ;put pixel
    reconst:
    mov cx, 157  
    sepconst:     ;hor line on vertical
    inc cx
    int 10h
    cmp cx, 162         ;157-162 (5 pix) small lines
    jne sepconst
    add dx, 10              
    cmp dx, 200
    jne reconst  
    ;vertical seperators on horizontal line
    mov al, 14
    mov cx, 10 
    mov dx, 97              
    rexconst:
    mov dx, 97
    sep2const:         ;ver line on hor
    inc dx
    int 10h
    cmp dx, 102        ;97-102 small lines
    jne sep2const
    add cx, 10
    cmp cx, 320
    jne rexconst
    ret
plane endp 

xandy proc near   
mov dh, 11
mov dl, 1  
mov ah, 2         ;display
mov bh, 0 
int 10h 
mov dx, offset x        ;print x axis
mov ah, 9
int 21h  
mov dh, 1
mov dl, 20
mov ah, 2
mov bh, 0   
int 10h 
mov dx, offset y        ;print y axis
mov ah, 9
int 21h 
ret
xandy endp 	
		
end start