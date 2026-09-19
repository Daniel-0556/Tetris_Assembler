; multi-segment executable file template.

data segment
    ; add your data here!
    numaleatorio db 0h
    
    
    
    
    ;figura0 = semicruz color cyan
    figura10 db 0h, 3h, 0h
             db 3h, 3h, 3h
             db 0h, 0h, 0h
            
    figura20 db 3h, 0h, 0h
             db 3h, 3h, 0h
             db 3h, 0h, 0h
            
    figura30 db 3h, 3h, 3h
             db 0h, 3h, 0h
             db 0h, 0h, 0h
            
    figura40 db 0h, 3h, 0h
             db 3h, 3h, 0h
             db 0h, 3h, 0h
    
    ;figura1 = cuadrado color rojo
    figura11 db 4h, 4h
             db 4h, 4h
             
    ;figura2 = linea color amarillo
    figura12 db 0h, 0h, 0h, 0h
             db 0h, 0h, 0h, 0h
             db 0xEh, 0xEh, 0xEh, 0xEh
             db 0h, 0h, 0h, 0h
             
    figura22 db 0h, 0xEh, 0h, 0h
             db 0h, 0xEh, 0h, 0h
             db 0h, 0xEh, 0h, 0h
             db 0h, 0xEh, 0h, 0h
             
    ;figura3 = z color verde
    
    
    figura13 db 0h, 0h, 2h, 0h
             db 0h, 2h, 2h, 0h
             db 0h, 2h, 0h, 0h
             db 0h, 0h, 0h, 0h
             
             
    figura23 db 0h, 0h, 0h, 0h
             db 2h, 2h, 0h, 0h
             db 0h, 2h, 2h, 0h
             db 0h, 0h, 0h, 0h
             
                
            
    ;Matrices de pixeles de color escalados        
            
    pixelblack5    db 0h, 0h, 0h, 0h, 0h
                   db 0h, 0h, 0h, 0h, 0h
                   db 0h, 0h, 0h, 0h, 0h
                   db 0h, 0h, 0h, 0h, 0h
                   db 0h, 0h, 0h, 0h, 0h
                   
    pixelcyan5     db 3h, 3h, 3h, 3h, 3h
                   db 3h, 3h, 3h, 3h, 3h
                   db 3h, 3h, 3h, 3h, 3h
                   db 3h, 3h, 3h, 3h, 3h
                   db 3h, 3h, 3h, 3h, 3h
                   
                   
    pixelred5      db 4h, 4h, 4h, 4h, 4h
                   db 4h, 4h, 4h, 4h, 4h
                   db 4h, 4h, 4h, 4h, 4h
                   db 4h, 4h, 4h, 4h, 4h
                   db 4h, 4h, 4h, 4h, 4h
                   
                   
    pixelyellow5   db 0xEh, 0xEh, 0xEh, 0xEh, 0xEh
                   db 0xEh, 0xEh, 0xEh, 0xEh, 0xEh
                   db 0xEh, 0xEh, 0xEh, 0xEh, 0xEh
                   db 0xEh, 0xEh, 0xEh, 0xEh, 0xEh
                   
    pixelgreen5    db 2h, 2h, 2h, 2h, 2h
                   db 2h, 2h, 2h, 2h, 2h
                   db 2h, 2h, 2h, 2h, 2h
                   db 2h, 2h, 2h, 2h, 2h
                   db 2h, 2h, 2h, 2h, 2h
                   
    contador0 db 0h
    contador2 db 0h
    contador3 db 0h
    
    
    
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

     mov ah, 0h  ;set video mode
    mov al, 13h ;desire video mode
    int 10h     ;llamando interrupcion 10h
    
    
    
    num_aleatorio:    
    mov ah, 00h
    int 1Ah
    
    mov al, dl
    mov bl, 4
    div bl
    
    mov al, ah
    mov ah, 00h
    mov numaleatorio, al
    
    jmp dibujo13
    
    
    
    elegir_figura:
        cmp numaleatorio, 0
        je figura0
        cmp numaleatorio, 1
        je figura1
        cmp numaleatorio, 2
        je figura2
        cmp numaleatorio, 3
        je figura3
    
    
    
    
        



    figura0:
        jmp dibujo10
        
    figura1:
        jmp dibujo11
    
    figura2:
        jmp dibujo12
    figura3:
        jmp dibujo13
    

    
    ;Pintar figura0
    
    dibujo10:
    ;mov ah, 0h  ;set video mode
    ;mov al, 13h ;desire video mode
    ;int 10h     ;llamando interrupcion 10h
    mov si, offset figura10
    mov bp, 0 ;contador columnas alien
    mov di, 0 ;contador filas alien
    mov al,[si]
    mov dx, 0  ;fila
    mov cx, 150 ;columna
    push si
    
    jmp comparar0
    
    dibujo20:
        ;mov ah, 0h  ;set video mode
        ;mov al, 13h ;desire video mode
        ;int 10h     ;llamando interrupcion 10h
        mov si, offset figura20
        mov bp, 0 ;contador columnas alien
        mov di, 0 ;contador filas alien
        mov al,[si]
        mov dx, 0  ;fila
        mov cx, 150 ;columna
        push si
        
        jmp comparar0
    
    
    
    dibujo30:
        ;mov ah, 0h  ;set video mode
        ;mov al, 13h ;desire video mode
        ;int 10h     ;llamando interrupcion 10h
        mov si, offset figura30
        mov bp, 0 ;contador columnas alien
        mov di, 0 ;contador filas alien
        mov al,[si]
        mov dx, 0  ;fila
        mov cx, 150 ;columna
        push si
        
        jmp comparar0
        
        
        
    dibujo40:
        
        ;mov ah, 0h  ;set video mode
        ;mov al, 13h ;desire video mode
        ;int 10h     ;llamando interrupcion 10h
        mov si, offset figura40
        mov bp, 0 ;contador columnas alien
        mov di, 0 ;contador filas alien
        mov al,[si]
        mov dx, 0  ;fila
        mov cx, 150 ;columna
        push si
        
        jmp comparar0    
        
    
    
    
    
          
    comparar0:
    mov al, [si]    
    cmp al, 0h
    je black0
    jmp cyan
     
    black0:
    mov si, offset pixelblack5
    mov bh, 0   ;columnas
    mov bl, 0   ;filas
    jmp fila0
    
    
    cyan:
    mov si, offset pixelcyan5
    mov bh, 0   ;columnas
    mov bl, 0   ;filas
    
    
    fila0:
        mov al,[si]
        cmp bl,5
        je fin_bloque0
    columna0:

        cmp bh,5               
        je nueva_fila0                                 
    
    pintar0:    
        mov ah,0Ch              
        int 10h
        inc cx
        inc bh
        jmp fila0    
    
    nueva_fila0:

        mov bh, 0
        sub cx, 5
        inc bl
        inc si
        inc dx                          
        jmp fila0    
    

    fin_bloque0:
        sub dx, 5
        add cx, 5
        pop si
        inc si
        push si
        inc bp
        cmp bp, 3
        je masfila0
        jmp comparar0
        
    masfila0:
        mov cx, 150
        add dx, 5
        inc di
        mov bp, 0
        cmp di, 3
        je incrementar0
        jmp comparar0  
        
        
    incrementar0:
        cmp contador0,3
        je resetear0
        inc contador0
        jmp rotar0
        
    resetear0:
        mov contador0, 0h
        
        
        
   rotar0:
    mov ah, 1
    int 21h
    cmp al, 20h
    je fase0
    
   fase0:
    cmp contador0, 0
    je dibujo10
    cmp contador0, 1
    je dibujo20
    cmp contador0, 2
    je dibujo30
    cmp contador0, 3
    je dibujo40
    
    
    
    
    ;Pintar figura1
    
    
    dibujo11:
    ;mov ah, 0h  ;set video mode
    ;mov al, 13h ;desire video mode
    ;int 10h     ;llamando interrupcion 10h
    mov si, offset figura11
    mov bp, 0 ;contador columnas alien
    mov di, 0 ;contador filas alien
    mov al,[si]
    mov dx, 0  ;fila
    mov cx, 150 ;columna
    push si
    
    jmp comparar1
    
    
    comparar1:
    mov al, [si]    
    cmp al, 0h
    je black1
    jmp red
    
    black1:
    mov si, offset pixelblack5
    mov bh, 0   ;columnas
    mov bl, 0   ;filas
    jmp fila1
    
    red:
    mov si, offset pixelred5
    mov bh, 0   ;columnas
    mov bl, 0   ;filas
    
    
    
    fila1:
        mov al,[si]
        cmp bl,5
        je fin_bloque1
    columna1:

        cmp bh,5               
        je nueva_fila1                                 
    
    pintar1:    
        mov ah,0Ch              
        int 10h
        inc cx
        inc bh
        jmp fila1    
    
    nueva_fila1:

        mov bh, 0
        sub cx, 5
        inc bl
        inc si
        inc dx                          
        jmp fila1    
    

    fin_bloque1:
        sub dx, 5
        add cx, 5
        pop si
        inc si
        push si
        inc bp
        cmp bp, 2
        je masfila1
        jmp comparar1
        
    masfila1:
        mov cx, 150
        add dx, 5
        inc di
        mov bp, 0
        cmp di, 2
        je rotar1
        jmp comparar1         
        
   rotar1:
    mov ah, 1
    int 21h
    cmp al, 20h
    jmp dibujo11
    
    
    
    ;pintar figura2
    
    
    dibujo12:
        ;mov ah, 0h  ;set video mode
        ;mov al, 13h ;desire video mode
        ;int 10h     ;llamando interrupcion 10h
        mov si, offset figura12
        mov bp, 0 ;contador columnas alien
        mov di, 0 ;contador filas alien
        mov al,[si]
        mov dx, 0  ;fila
        mov cx, 150 ;columna
        push si
    
        jmp comparar2
    
    dibujo22:
        ;mov ah, 0h  ;set video mode
        ;mov al, 13h ;desire video mode
        ;int 10h     ;llamando interrupcion 10h
        mov si, offset figura22
        mov bp, 0 ;contador columnas alien
        mov di, 0 ;contador filas alien
        mov al,[si]
        mov dx, 0  ;fila
        mov cx, 150 ;columna
        push si
        
        jmp comparar2
        
        
        
    comparar2:
    mov al, [si]    
    cmp al, 0h
    je black2
    jmp yellow
     
    black2:
    mov si, offset pixelblack5
    mov bh, 0   ;columnas
    mov bl, 0   ;filas
    jmp fila2
    
    
    yellow:
    mov si, offset pixelyellow5
    mov bh, 0   ;columnas
    mov bl, 0   ;filas
    
    
    fila2:
        mov al,[si]
        cmp bl,5
        je fin_bloque2
    columna2:

        cmp bh,5               
        je nueva_fila2                                 
    
    pintar2:    
        mov ah,0Ch              
        int 10h
        inc cx
        inc bh
        jmp fila2    
    
    nueva_fila2:

        mov bh, 0
        sub cx, 5
        inc bl
        inc si
        inc dx                          
        jmp fila2    
    

    fin_bloque2:
        sub dx, 5
        add cx, 5
        pop si
        inc si
        push si
        inc bp
        cmp bp, 4
        je masfila2
        jmp comparar2
        
    masfila2:
        mov cx, 150
        add dx, 5
        inc di
        mov bp, 0
        cmp di, 4
        je incrementar2
        jmp comparar2  
        
        
    incrementar2:
        cmp contador2,1
        je resetear2
        inc contador2
        jmp rotar2
        
    resetear2:
        mov contador2, 0h
        
        
        
   rotar2:
    mov ah, 1
    int 21h
    cmp al, 20h
    je fase2
    
   fase2:
    cmp contador2, 0
    je dibujo12
    cmp contador2, 1
    je dibujo22
               
               
               
               
   ;pintar figura3
   
   dibujo13:
    ;mov ah, 0h  ;set video mode
    ;mov al, 13h ;desire video mode
    ;int 10h     ;llamando interrupcion 10h
    mov si, offset figura13
    mov bp, 0 ;contador columnas alien
    mov di, 0 ;contador filas alien
    mov al,[si]
    mov dx, 0  ;fila
    mov cx, 150 ;columna
    push si
    
    jmp comparar3
    
    dibujo23:
        ;mov ah, 0h  ;set video mode
        ;mov al, 13h ;desire video mode
        ;int 10h     ;llamando interrupcion 10h
        mov si, offset figura23
        mov bp, 0 ;contador columnas alien
        mov di, 0 ;contador filas alien
        mov al,[si]
        mov dx, 0  ;fila
        mov cx, 150 ;columna
        push si
        
        jmp comparar3
    
    comparar3:
    mov al, [si]    
    cmp al, 0h
    je black3
    jmp green
     
    black3:
    mov si, offset pixelblack5
    mov bh, 0   ;columnas
    mov bl, 0   ;filas
    jmp fila3
    
    
    green:
    mov si, offset pixelgreen5
    mov bh, 0   ;columnas
    mov bl, 0   ;filas
    
    
    fila3:
        mov al,[si]
        cmp bl,5
        je fin_bloque3
    columna3:

        cmp bh,5               
        je nueva_fila3                                 
    
    pintar3:    
        mov ah,0Ch              
        int 10h
        inc cx
        inc bh
        jmp fila3    
    
    nueva_fila3:

        mov bh, 0
        sub cx, 5
        inc bl
        inc si
        inc dx                          
        jmp fila3    
    

    fin_bloque3:
        sub dx, 5
        add cx, 5
        pop si
        inc si
        push si
        inc bp
        cmp bp, 4
        je masfila3
        jmp comparar3
        
    masfila3:
        mov cx, 150
        add dx, 5
        inc di
        mov bp, 0
        cmp di, 4
        je incrementar3
        jmp comparar3  
        
        
    incrementar3:
        cmp contador3,1
        je resetear3
        inc contador3
        jmp rotar3
        
    resetear3:
        mov contador3, 0h
        
        
        
   rotar3:
    mov ah, 1
    int 21h
    cmp al, 20h
    je fase3
    
   fase3:
    cmp contador3, 0
    je dibujo13
    cmp contador3, 1
    je dibujo23
        
         
   
    


         
ends

end start ; set entry point and stop the assembler.
