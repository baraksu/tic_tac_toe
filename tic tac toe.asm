.model small
.stack 100h

.data   
                                 

color dw 7


Xcolor dw 6
Ocolor dw 1 

board db 2,2,2,2,2,2,2,2,2 ; 0-x, 1 - O

turn db 0

logo db 13,10, " _____ _        _____     _      _____          ",13,10, "|_   _(_) ___  |_   _|_ _| | __ |_   _|__   ___ ",13,10, "  | | | |/ __|   | |/ _` | |/ /   | |/ _ \ / _ \",13,10, "  | | | | (__    | | (_| |   <    | | (_) |  __/",13,10, "  |_| |_|\___|   |_|\__,_|_|\_\   |_|\___/ \___|",13,10,"$"

turnTxt db "Turn: X$ "
              

pressKeyToStart db 13,10,"Enter any key to start the game!$"


.code
    
    
    draw_column macro tcolor length x y 
        local columnDrawLoop
    pusha 
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    
    mov dx, y
    mov cx, x
    mov bx, length
    mov ax, tcolor
    
    columnDrawLoop:
        mov ah,0ch
        int 10h
        
        inc cx
        dec bx
        cmp bx,0
    jne columnDrawLoop
     
    popa    
    endm draw_column
    
         
      
     
    draw_row macro tcolor length x y
        local RowDrawLoop  
    pusha  
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    
    mov dx, y
    mov cx, x
    mov bx, length
    mov ax, tcolor
    
    RowDrawLoop:
        mov ah,0ch
        int 10h
        
        inc dx
        dec bx
        cmp bx,0h
    jne RowDrawLoop
    popa
    endm draw_row   
      
    
    draw_diagonal_r macro tcolor length x y
        local DiagRDrawLoop 
    pusha  
    mov dx, y
    mov cx, x
    mov bx, length
    mov ax, tcolor
    
    DiagRDrawLoop:
        mov ah,0ch
        int 10h
        
        inc cx
        inc dx
        dec bx
        cmp bx,0h
    jne DiagRDrawLoop
     
    popa                                 
    endm draw_diagonal_r
    
    draw_diagonal_l macro tcolor length x y
        local DiagLDrawLoop 
            
    pusha   
    mov dx, y
    mov cx, x
    mov bx, length
    mov ax, tcolor
    
    DiagLDrawLoop:
        mov ah,0ch
        int 10h
        
        dec cx
        inc dx
        dec bx
        cmp bx,0h
    jne DiagLDrawLoop
     
    popa                                  
    endm draw_diagonal_l
       
    
    
proc circle 
 mov bp,sp
 pusha

 mov bx, [bp+4]
 mov ax,2
 mul bx
 mov bx,3
 sub bx,ax ; E=3-2r
 mov [bp+2],bx
 
 mov ax,Ocolor ;color goes in al
 mov ah,0ch
 
drawcircle:
 mov ax,Ocolor ;color goes in al
 mov ah,0ch
 
 mov cx, [bp+4] ;Octonant 1
 add cx, [bp+10] ;( x_value + x_center,  y_value + y_center)
 mov dx, [bp+6]
 add dx, [bp+8]
 int 10h
 
 mov cx, [bp+4] ;Octonant 4
 neg cx
 add cx, [bp+10] ;( -x_value + x_center,  y_value + y_center)
 int 10h
; 
 mov cx, [bp+6] ;Octonant 2
 add cx, [bp+10] ;( y_value + x_center,  x_value + y_center)
 mov dx, [bp+4]
 add dx, [bp+8]
 int 10h
; 
 mov cx, [bp+6] ;Octonant 3
 neg cx
 add cx, [bp+10] ;( -y_value + x_center,  x_value + y_center)
 int 10h
 
 mov cx, [bp+4] ;Octonant 8
 add cx, [bp+10] ;( x_value + x_center,  -y_value + y_center)
 mov dx, [bp+6]
 neg dx
 add dx, [bp+8]
 int 10h
; 
 mov cx, [bp+4] ;Octonant 5
 neg cx
 add cx, [bp+10] ;( -x_value + x_center,  -y_value + y_center)
 int 10h

 mov cx, [bp+6] ;Octonant 7
 add cx, [bp+10] ;( y_value + x_center,  -x_value + y_center)
 mov dx, [bp+4]
 neg dx
 add dx, [bp+8]
 int 10h
; 
 mov cx, [bp+6] ;Octonant 6
 neg cx
 add cx, [bp+10] ;( -y_value + x_center,  -x_value + y_center)
 int 10h
 
condition1:
 cmp [bp+2],0
 jg condition2      
 mov cx, [bp+6]
 mov ax, 2
 imul cx ;2y
 add ax, 3 ;ax=2y+3
 mov bx, 2
 mul bx  ; ax=2(2y+3)
 add [bp+2], ax
 mov bx, [bp+6]
 mov dx, [bp+4]
 cmp bx, dx  
 inc [bp+6]
 jmp drawcircle

condition2:
 ;e>0
 mov cx, [bp+6] 
 mov ax,2
 mul cx  ;cx=2y
 mov bx,ax
 mov cx, [bp+4]
 mov ax, -2
 imul cx ;cx=-2x
 add bx,ax
 add bx,5;bx=5-2z+2y
 mov ax,2
 imul bx ;ax=2(5-2z+2y)       
 add [bp+2],ax
 mov bx, [bp+6]
 mov dx, [bp+4]
 cmp bx, dx
 ja donedrawing
 dec [bp+4]    
 inc [bp+6]
 jmp drawcircle

donedrawing:
popa
ret
endp circle


winQ macro x y z
    local oT no end
      cmp [board+x], 0
      jne oT
      cmp [board+y], 0
      jne no
      cmp [board+z], 0
      jne no
      mov bx, 0
      jmp end
      
      oT:
      cmp [board+x], 1
      jne no
      cmp [board+y], 1
      jne no
      cmp [board+z], 1
      jne no
      mov bx,1
      jmp end

no:
mov bx,2
mov sp,100h      
end:
endm winQ  
proc check
      xor bx,bx
      loopcheck:
        cmp [board+bx],2        
        je e       
        
        inc bx
        cmp bx, 9
        je b
        
        jmp loopcheck      
      
    b:
      mov bx, -1
    e:
      inc bx    
ret
endp check 


writeTextMode macro page location ; page - y,x
    local print
    pusha
    mov dx, page
    xor bx,bx
    mov ax, 0200h
    int 10h
    mov dl,location 
    xor bx,bx
    print:
    
    mov al, [location+bx]
    inc bx
    push bx
    
    mov bx,000ch
    mov ah, 0eh
    int 10h 
    pop bx

    cmp [location+bx],'$'
    jne print
    popa
endm writeTextMode
    start:      
        mov ax, @data
        mov ds, ax
        pusha 
        lea dx,logo
        mov ah, 09h
        int 21h   
        lea dx,pressKeyToStart
        mov ah, 09h
        int 21h   
        mov ah,01h
        int 21h
        popa      
        mov ah,0 
        mov al, 13h
	    int 10h  
        
                                     
        draw_row color 000b4h 0000ah 0000ah 
        draw_row color 000b4h 00046h 0000ah 
        draw_row color 000b4h 00082h 0000ah 
        draw_row color 000b4h 000BEh 0000ah 
        draw_column color 000b4h 0000ah 0000ah
        draw_column color 000b4h 0000ah 00046h
        draw_column color 000b4h 0000ah 00082h
        draw_column color 000b4h 0000ah 000BEh
        writeTextMode 0a1ah [turnTxt]
        
        mov ax,0001h
        int 33h
        loopp:
        
        mov ax, 0003h
        int 33h
        
        cmp bx,1
        jne loopp
        
        shr cx,1 
         
         
        mov bl,turn
        
        cmp cx,10
        jb loopp
        
        cmp cx,70
        jb x1
        
        cmp cx,130
        jb x2
        
        cmp cx,190
        jb x3
        jmp loopp
                 
                 
        x1:
        mov cx,15
        cmp dx,10
        jb loopp
        
        cmp dx,70
        jb x1y1
        
        cmp dx,130
        jb x1y2
        
        cmp dx,190
        jb x1y3
        jmp loopp         
        
        x2:
        mov cx,75
        cmp dx,10
        jb loopp
        
        cmp dx,70
        jb x2y1
        
        cmp dx,130
        jb x2y2
        
        cmp dx,190
        jb x2y3         
        jmp loopp
        
        x3:
        mov cx,135
        cmp dx,10
        jb loopp
        
        cmp dx,70
        jb x3y1
        
        cmp dx,130
        jb x3y2
        
        cmp dx,190
        jb x3y3         
        jmp loopp
        
        x1y1:
         cmp [board], 2
         jne loopp
         mov [board],bl
         mov dx,15
         jmp endd
        x1y2:
         cmp [board+1], 2
         jne loopp
         mov [board+1],bl
         
         mov dx,75
         jmp endd
        x1y3:
         cmp [board+2], 2
         jne loopp
         mov [board+2],bl
         mov dx,135
         jmp endd
        x2y1:
         cmp [board+3], 2
         jne loopp
         mov [board+3],bl
         mov dx,15
         jmp endd
        x2y2:
         cmp [board+4], 2
         jne loopp
         mov [board+4],bl
         mov dx,75
         jmp endd
        x2y3:
         cmp [board+5], 2
         jne loopp
         mov [board+5],bl
         mov dx,135
         jmp endd
        x3y1:
         cmp [board+6], 2
         jne loopp
         mov [board+6],bl
         mov dx,15
         jmp endd
        x3y2:
         cmp [board+7], 2
         jne loopp
         mov [board+7],bl
         mov dx,75
         jmp endd
        x3y3:
         cmp [board+8], 2
         jne loopp
         mov [board+8],bl
         mov dx,135
         jmp endd
        
        endd:
         mov ax,cx
         mov bx,dx
         xor cx,cx
         mov dx, 00019h
          
         cmp turn,0
         je drawX
         jne drawO
        
        drawX:
        mov [turnTxt+6], 'O' 
        mov turn, 1
         
        
        push ax
        draw_diagonal_r Xcolor 00032h ax bx 
        add ax, 00032h
        draw_diagonal_l Xcolor 00032h ax bx
        pop ax
        
        
        
        
        jmp endTurn
        
        ;----------------------;
        ;-------Draw O---------;
        ;----------------------;
        ; info:                ;
        ; 1. ax - X center     ;
        ; 2. bx - Y center     ;
        ; 3. cx - Y value (0)  ;
        ; 4. dx - X value (r)  ;
        ; set color (in color) ;
        ;----------------------;        
        
        
        drawO:
        mov [turnTxt+6], 'X'
        mov turn, 0
        add ax,dx
        add bx,dx
        
        push ax
        push bx
        push cx
        push dx
        push color
        call circle
        pop bx
        pop bx
        pop bx
        pop bx
        pop bx
        jmp endTurn  
        
        
        endTurn:
        
        mov al, 0 
        winQ 0 1 2
        cmp bx, 0
        je winX012
        cmp bx, 1
        je winO012
        jmp w1
        
        winX012: 
        draw_row 11 000b4h 00028h 0000ah 
        jmp exit
        
        winO012:       
        draw_row 11 000b4h 00028h 0000ah
        jmp exit
         
        
        w1:
        winQ 3 4 5
        cmp bx, 0
        je winX345
        cmp bx, 1
        je winO345   
        jmp w2
           
        winX345:       
        draw_row 11 000b4h 00064h 0000ah
        jmp exit
        
        winO345:       
        draw_row 11 000b4h 00064h 0000ah
        jmp exit   
        
        
        w2:
        winQ 6 7 8
        cmp bx, 0
        je winX678
        cmp bx, 1
        je winO678   
        jmp w3
           
        winX678:       
        draw_row 11 000b4h 000a0h 0000ah
        jmp exit
        
        winO678:       
        draw_row 11 000b4h 000a0h 0000ah
        jmp exit 
        
        
        w3:
        winQ 0 3 6
        cmp bx, 0
        je winX036
        cmp bx, 1
        je winO036   
        jmp w4
           
        winX036:       
        draw_column 11 000b4h 0000ah 00028h
        
        jmp exit
        
        winO036:       
        draw_column 11 000b4h 0000ah 00028h
        jmp exit 
        
        w4:
        winQ 1 4 7
        cmp bx, 0
        je winX147
        cmp bx, 1
        je winO147   
        jmp w5
           
        winX147:       
        draw_column 11 000b4h 0000ah 00064h
        jmp exit
        
        winO147:       
        draw_column 11 000b4h 0000ah 00064h
        jmp exit
        
        w5:
        winQ 2 5 8
        cmp bx, 0
        je winX258
        cmp bx, 1
        je winO258   
        jmp w6
           
                   winX258:       
        draw_column 11 000b4h 0000ah 000a0h
        jmp exit
        
        winO258:       
        draw_column 11 000b4h 0000ah 000a0h
        jmp exit
        
        w6:
        winQ 0 4 8
        cmp bx, 0
        je winX048
        cmp bx, 1
        je winO048   
        jmp w7
           
        winX048:              
        draw_diagonal_r 11 000b4h 0000ah 0000ah 
        jmp exit
        
        winO048:       
        draw_diagonal_r 11 000b4h 0000ah 0000ah 
        jmp exit
        
        w7: 
        winQ 2 4 6
        cmp bx, 0
        je winX246
        cmp bx, 1
        je winO246   
        jmp w8
           
        winX246:        
        draw_diagonal_l 11 000b4h 000BEh 0000ah 
        jmp exit
        
        winO246:       
        draw_diagonal_l 11 000b4h 000BEh 0000ah
        jmp exit
        
        w8:
        call  check
        cmp bx,0
        je exit
        
        writeTextMode 0a1ah [turnTxt] 
        
        
        jmp loopp
    exit:          
    end start
    
    
