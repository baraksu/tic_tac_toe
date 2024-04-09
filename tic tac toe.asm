.model small
.stack 100h

.data   

tempColor dw ?                                 

color dw 7 

board db 2,2,2,2,2,2,2,2,2 ; 0-x, 1 - O

turn db 0
.code
    

    proc draw_column
    mov bp,sp
    pusha    
    ;INT 10h / AH = 0Ch - change color for a single pixel.
    ;AL = pixel color
    ;BX = lenght
    ;CX = column. (x)
    ;DX = row. (y)
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    
    mov dx, [bp+2]
    mov cx, [bp+4]
    mov bx, [bp+6]
    mov ax, [bp+8]
    
    columnDrawLoop:
        mov ah,0ch
        int 10h
        
        inc cx
        dec bx
        cmp bx,0
    jne columnDrawLoop
     
    popa    
    ret
    endp draw_column      
      
     
    proc draw_row
    
    mov bp,sp
    pusha    
    ;INT 10h / AH = 0Ch - change color for a single pixel.
    ;AL = pixel color
    ;BX = lenght
    ;CX = column. (x)
    ;DX = row. (y)
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    
    mov dx, [bp+2]
    mov cx, [bp+4]
    mov bx, [bp+6]
    mov ax, [bp+8]
    
    RowDrawLoop:
        mov ah,0ch
        int 10h
        
        inc dx
        dec bx
        cmp bx,0h
    jne RowDrawLoop
     
    popa    
    ret
    
    
    
    endp draw_row   
      
    
    proc draw_diagonal_r
                      
    mov bp,sp
    pusha    
    ;INT 10h / AH = 0Ch - change color for a single pixel.
    ;AL = pixel color
    ;BX = lenght
    ;CX = column. (x)
    ;DX = row. (y)
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    
    mov dx, [bp+2]
    mov cx, [bp+4]
    mov bx, [bp+6]
    mov ax, [bp+8]
    
    DiagRDrawLoop:
        mov ah,0ch
        int 10h
        
        inc cx
        inc dx
        dec bx
        cmp bx,0h
    jne DiagRDrawLoop
     
    popa    
    ret                              
    endp draw_diagonal_r
    
    proc draw_diagonal_l
                      
    mov bp,sp
    pusha    
    ;INT 10h / AH = 0Ch - change color for a single pixel.
    ;AL = pixel color
    ;BX = lenght
    ;CX = column. (x)
    ;DX = row. (y)
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    
    mov dx, [bp+2]
    mov cx, [bp+4]
    mov bx, [bp+6]
    mov ax, [bp+8]
    
    DiagLDrawLoop:
        mov ah,0ch
        int 10h
        
        dec cx
        inc dx
        dec bx
        cmp bx,0h
    jne DiagLDrawLoop
     
    popa    
    ret                              
    endp draw_diagonal_l

    proc draw_x
               
        mov bp,sp
        pusha
        xor ax,ax
        xor bx,bx
        xor cx,cx
        xor dx,dx
        
        mov dx, [bp+2]
        mov cx, [bp+4]
        mov bx, [bp+6]
        mov ax, [bp+8]
        
        push ax       
        push bx
        push cx
        push dx
        call draw_diagonal_r
        pop bx
        pop bx
        pop bx
        pop bx     
        
        mov bx, [bp+6]     
        add cx,bx      
        push ax       
        push bx
        push cx
        push dx
        call draw_diagonal_l
        pop bx
        pop bx
        pop bx
        pop bx       
              
        popa
               
    ret           
    endp draw_x        
    
    
proc circle
 mov bp,sp
 pusha

 mov bx, [bp+4]
 mov ax,2
 mul bx
 mov bx,3
 sub bx,ax ; E=3-2r
 mov [bp+2],bx
 
 mov ax,color ;color goes in al
 mov ah,0ch
 
drawcircle:
 mov ax,color ;color goes in al
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


proc winQ
mov bp,sp
      pop ax
      
      pop bx
      cmp [board+bx], 0
      jne oT
      
      pop bx
      cmp [board+bx], 0
      jne no
      
      pop bx
      cmp [board+bx], 0
      jne no
      
      mov bx, 0
      jmp end
      
      oT:
      cmp [board+bx], 1
      jne no
            
      pop bx
      cmp [board+bx], 1
      jne no
      
      pop bx
      cmp [board+bx], 1
      jne no
      mov bx,1
      jmp end

no:
mov bx,2
mov sp,100h      
end:

push ax        
ret
endp winQ   

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


    
    start:      
        mov ax, @data
        mov ds, ax
        
        mov ah,0 
        mov al, 13h
	    int 10h  
        
        ;----------------------;
        ;---------row----------;
        ;----------------------;
        ; info:                ;
        ; 1. color             ;
        ; 2. length            ;
        ; 3. X (column)        ;
        ; 4. Y (row)           ;
        ;----------------------;
        
        
        
        push color
        mov bx,000b4h ; length  
        push bx
        mov bx, 0000ah ; x
        push bx
        mov bx, 0000ah ;y
        push bx
        call draw_row
        pop bx
        pop bx
        pop bx
        pop bx
        
        push color
        mov bx,000b4h  
        push bx
        mov bx, 00046h
        push bx
        mov bx,0000ah
        push bx
        call draw_row            
        pop bx
        pop bx
        pop bx
        pop bx
        
        push color
        mov bx,000b4h  
        push bx
        mov bx, 00082h
        push bx
        mov bx,0000ah
        push bx
        call draw_row            
        pop bx
        pop bx
        pop bx
        pop bx
        
        push color
        mov bx,000b4h  
        push bx
        mov bx, 000BEh
        push bx
        mov bx,0000ah
        push bx
        call draw_row            
        pop bx
        pop bx
        pop bx
        pop bx
        
        ;----------------------;
        ;--------column--------;
        ;----------------------;
        ; info:                ;
        ; 1. color             ;
        ; 2. length            ;
        ; 3. X (column)        ;
        ; 4. Y (row)           ;
        ;----------------------;
              
        push color
        mov bx,000b4h
        push bx
        mov bx,0000ah
        push bx
        mov bx,0000ah
        push bx
        call draw_column
        pop bx
        pop bx
        pop bx
        pop bx
        
        
        push color
        mov bx,000b4h
        push bx
        mov bx,0000ah
        push bx
        mov bx,00046h
        push bx
        call draw_column
        pop bx
        pop bx
        pop bx
        pop bx
        
        
        push color
        mov bx,000b4h
        push bx
        mov bx,0000ah
        push bx
        mov bx,00082h
        push bx
        call draw_column
        pop bx
        pop bx
        pop bx
        pop bx
                  
                  
        push color
        mov bx,000b4h
        push bx
        mov bx,0000ah
        push bx
        mov bx,000BEh
        push bx
        call draw_column
        pop bx
        pop bx
        pop bx
        pop bx          
        
        ;----------------------;
        ;--------GamePlay------;
        ;----------------------;
        
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
        
        
        
        
        
        
        
        
        ;----------------------;
        ;-------Draw X---------;
        ;----------------------;
        ; info:                ;
        ; 1. color             ;
        ; 2. length            ;
        ; 3. X (column) - sp   ;
        ; 4. Y (row) - sp      ;
        ; (sp = start point)   ;
        ;----------------------;
        
        
        drawX:
        ;----------------------;
        ;  info:               ;
        ;  1. AX - X           ;
        ;  2. BX - Y           ;
        ;----------------------; 
        mov turn, 1
        push color
        mov cx, 00032h
        push cx        
        push ax
        push bx
        call draw_x
        pop bx
        pop bx
        pop bx
        pop bx
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
        
        
               
        mov bx, 0
        push bx
        mov bx, 1
        push bx
        mov bx, 2
        push bx
        call winQ
        cmp bx, 0
        je winX012
        cmp bx, 1
        je winO012
        jmp w1
        
        winX012:       
         mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,00028h
        push bx
        mov bx,0000ah
        push bx
        call draw_row
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit
        
        winO012:       
         mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,00028h
        push bx
        mov bx,0000ah
        push bx
        call draw_row
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit
         
        
        w1:
        mov bx, 3
        push bx
        mov bx, 4
        push bx
        mov bx, 5
        push bx
        call winQ
        cmp bx, 0
        je winX345
        cmp bx, 1
        je winO345   
        jmp w2
           
        winX345:       
         mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,00064h
        push bx
        mov bx,0000ah
        push bx
        call draw_row
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit
        
        winO345:       
         mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,00064h
        push bx
        mov bx,0000ah
        push bx
        call draw_row
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit   
        
        
        w2:
        mov bx, 6
        push bx
        mov bx, 7
        push bx
        mov bx, 8
        push bx
        call winQ
        cmp bx, 0
        je winX678
        cmp bx, 1
        je winO678   
        jmp w3
           
        winX678:       
         mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,000a0h
        push bx
        mov bx,0000ah
        push bx
        call draw_row
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit
        
        winO678:       
         mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,000a0h
        push bx
        mov bx,0000ah
        push bx
        call draw_row
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit 
        
        
        w3:
        mov bx, 0
        push bx
        mov bx, 3
        push bx
        mov bx, 6
        push bx
        call winQ
        cmp bx, 0
        je winX036
        cmp bx, 1
        je winO036   
        jmp w4
           
        winX036:       
         mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,0000ah
        push bx
        mov bx,00028h
        push bx
        call draw_column
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit
        
        winO036:       
         mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,0000ah
        push bx
        mov bx,00028h
        push bx
        call draw_column
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit 
        
        w4:
        mov bx, 1
        push bx
        mov bx, 4
        push bx
        mov bx, 7
        push bx
        call winQ
        cmp bx, 0
        je winX147
        cmp bx, 1
        je winO147   
        jmp w5
           
        winX147:       
         mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,0000ah
        push bx
        mov bx,00064h
        push bx
        call draw_column
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit
        
        winO147:       
         mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,0000ah
        push bx
        mov bx,00064h
        push bx
        call draw_column
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit
        
        w5:
        mov bx, 2
        push bx
        mov bx, 5
        push bx
        mov bx, 8
        push bx
        call winQ
        cmp bx, 0
        je winX258
        cmp bx, 1
        je winO258   
        jmp w6
           
        winX258:       
         mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,0000ah
        push bx
        mov bx,000a0h
        push bx
        call draw_column
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit
        
        winO258:       
         mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,0000ah
        push bx
        mov bx,000a0h
        push bx
        call draw_column
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit
        
        w6:
        mov bx, 0
        push bx
        mov bx, 4
        push bx
        mov bx, 8
        push bx
        call winQ
        cmp bx, 0
        je winX048
        cmp bx, 1
        je winO048   
        jmp w7
           
        winX048:       
         mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,0000ah
        push bx
        mov bx,0000ah
        push bx
        call draw_diagonal_r
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit
        
        winO048:       
         mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,0000ah
        push bx
        mov bx,0000ah
        push bx
        call draw_diagonal_r
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit
        
        
        
        w7:
        mov bx, 2
        push bx
        mov bx, 4
        push bx
        mov bx, 6
        push bx
        call winQ
        cmp bx, 0
        je winX246
        cmp bx, 1
        je winO246   
        jmp w8
           
        winX246:
        mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,000BEh
        push bx
        mov bx,0000ah
        push bx
        call draw_diagonal_l
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit
        
        winO246:       
         mov bx, 11       
        push bx
        mov bx,000b4h
        push bx
        mov bx,000BEh
        push bx
        mov bx,0000ah
        push bx
        call draw_diagonal_l
        pop bx
        pop bx
        pop bx
        pop bx
        jmp exit
        
        
        
        w8:
        
        call  check
        cmp bx,0
        je exit
        jmp loopp
         
        
                         
               
    exit:          
    end start
