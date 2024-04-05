.model small
.stack 100h

.data   

tempColor dw ?                                 

color dw 7 

board db 0,0,0,0,0,0,0,0,0 ; 1-x, 2 - O

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
       
    
    start:      
        mov ax, @data
        mov ds, ax
        
        mov ah,0 
        mov al, 13h
	    int 10h  
        
        
        push color
        mov bx,000c8h  
        push bx
        mov bx, 0006ah
        push bx
        mov bx,0
        push bx
        call draw_row
        pop bx
        pop bx
        pop bx
        pop bx
        
        push color
        mov bx,000c8h  
        push bx
        mov bx, 000d4h
        push bx
        mov bx,0
        push bx
        call draw_row            
        pop bx
        pop bx
        pop bx
        pop bx
        
        
              
        push color
        mov bx,140h
        push bx
        mov bx,0h
        push bx
        mov bx,43h
        push bx
        call draw_column
        pop bx
        pop bx
        pop bx
        pop bx
        
        
        push color
        mov bx,140h
        push bx
        mov bx,0h
        push bx
        mov bx,86h
        push bx
        call draw_column
        pop bx
        pop bx
        pop bx
        pop bx
            
              
        
        
        push color       
        mov bx,33
        push bx
        mov bx, 20
        push bx
        mov bx, 10
        push bx
        call draw_x 
        pop bx
        pop bx
        pop bx
        pop bx
        
        
                            
               
    exit:          
    end start
