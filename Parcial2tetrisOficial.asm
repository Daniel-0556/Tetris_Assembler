; multi-segment executable file template.

data segment
    
    
    ; 1. Semicruz (3x3, Cian: 3h)
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
                                
                                
    ; 2. Cuadrado (2x2, Rojo: 4h)
    figura11 db 4h, 4h
             db 4h, 4h
                                 
                                 
                              
                                 
    ; 3. Línea (4x4, Amarillo: 0Eh)
    figura12 db 0h, 0h, 0h, 0h
             db 0h, 0h, 0h, 0h
             db 0Eh, 0Eh, 0Eh, 0Eh
             db 0h, 0h, 0h, 0h

    figura22 db 0h, 0Eh, 0h, 0h
             db 0h, 0Eh, 0h, 0h
             db 0h, 0Eh, 0h, 0h
             db 0h, 0Eh, 0h, 0h
                          
                          
                          
    ; 4. Z (3x3, Verde: 2h)
    ; rot 0 (figura13): Horizontal
    figura13 db 2h, 2h, 0h
             db 0h, 2h, 2h
             db 0h, 0h, 0h

    ; rot 1 (figura23): Vertical
    figura23 db 0h, 2h, 0h
             db 2h, 2h, 0h
             db 2h, 0h, 0h
             
             
             
             

    ; Variables de estado
    figura_actual db 1   ; 1 = Semicruz, 2 = Cuadrado, 3 = Linea, 4 = Z
    numaleatorio   db 0   ; Guardar el valor aleatorio (0 a 3)
    contador_rot  db 0   ; Rotacion de la figura
    
    bloque_col    db 0
    bloque_fil    db 0
    tam_matriz    db 3   ; Dimension N de la matriz (2, 3 o 4)
    
    pos_y         dw 20
    pos_x         dw 100
    tics_esperar  dw 0
    color         db 7h
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    mov ah, 0h  ; set video mode
    mov al, 13h ; mode 13h (320x200)
    int 10h

;------------------------------------------------------------------------------------------------------------
;                                     PINTADO DE PANTALLA
;------------------------------------------------------------------------------------------------------------
    pintar_pantalla_inicial:
        mov dx, 0
        mov cx, 0

    pintar_arriba:
        mov ah, 0Ch
        mov al, color
        mov bh, 0
        int 10h

        inc cx
        cmp cx, 320
        je sig_fila_arriba
        jmp pintar_arriba

    sig_fila_arriba:
        inc dx
        mov cx, 0
        cmp dx, 10
        je inicio_lados
        jmp pintar_arriba

    inicio_lados:
        mov dx, 10

    preparar_izq:
        mov cx, 0

    pintar_izq:
        mov ah, 0Ch
        mov al, color
        mov bh, 0
        int 10h

        inc cx
        cmp cx, 10
        je preparar_der
        jmp pintar_izq

    preparar_der:
        mov cx, 310

    pintar_der:
        mov ah, 0Ch
        mov al, color
        mov bh, 0
        int 10h

        inc cx
        cmp cx, 320
        je sig_fila_lados
        jmp pintar_der

    sig_fila_lados:
        inc dx
        cmp dx, 200
        je num_aleatorio
        jmp preparar_izq

;------------------------------------------------------------------------------------------------------------
;                                         NUMERO ALEATORIO
;------------------------------------------------------------------------------------------------------------    
    num_aleatorio:    
        mov ah, 00h
        int 1Ah             ; Lee los tics del reloj en CX:DX
    
        mov al, dl
        mov bl, 4
        div bl              ; Divide entre 4 (resto en AH = 0, 1, 2, 3)
    
        mov al, ah
        mov ah, 00h
        mov numaleatorio, al

    elegir_figura:
        cmp numaleatorio, 0
        je set_figura0
        cmp numaleatorio, 1
        je set_figura1
        cmp numaleatorio, 2
        je set_figura2
        cmp numaleatorio, 3
        je set_figura3

    set_figura0:
        mov [figura_actual], 1
        jmp fase0
    set_figura1:
        mov [figura_actual], 2
        jmp fase0
    set_figura2:
        mov [figura_actual], 3
        jmp fase0
    set_figura3:
        mov [figura_actual], 4
        jmp fase0

;------------------------------------------------------------------------------------------------------------
;                                     PINTADO DE LA FIGURA
;------------------------------------------------------------------------------------------------------------       

    fase0:
        cmp [figura_actual], 1
        je sel_figura0
        cmp [figura_actual], 2
        je sel_figura1
        cmp [figura_actual], 3
        je sel_figura2
        cmp [figura_actual], 4
        je sel_figura3

    sel_figura0:
        mov [tam_matriz], 3
        cmp [contador_rot], 0
        je rot_fig0_0
        cmp [contador_rot], 1
        je rot_fig0_1
        cmp [contador_rot], 2
        je rot_fig0_2
        mov si, offset figura40
        jmp inicio_dibujo
    rot_fig0_0:
        mov si, offset figura10
        jmp inicio_dibujo
    rot_fig0_1:
        mov si, offset figura20
        jmp inicio_dibujo
    rot_fig0_2:
        mov si, offset figura30
        jmp inicio_dibujo

    sel_figura1:
        mov [tam_matriz], 2
        mov si, offset figura11
        jmp inicio_dibujo

    sel_figura2:
        mov [tam_matriz], 4
        cmp [contador_rot], 0
        je rot_fig2_0
        mov si, offset figura22
        jmp inicio_dibujo
    rot_fig2_0:
        mov si, offset figura12
        jmp inicio_dibujo

    sel_figura3:
        mov [tam_matriz], 3
        cmp [contador_rot], 0
        je rot_fig3_0
        mov si, offset figura23
        jmp inicio_dibujo
    rot_fig3_0:
        mov si, offset figura13

    inicio_dibujo:
        call dib_figura
        jmp preparar_delay

    dib_figura:
        mov di, 0       ; Fila de la matriz
    loop_fil_matriz:
        mov bp, 0       ; Columna de la matriz
    loop_col_matriz:
        mov al, [si]
        cmp al, 0h
        je siguiente_bloque_dibujo

        push ax

        ; Calcular Y del bloque: pos_y + (di * 10)
        mov ax, di
        mov bl, 10
        mul bl
        add ax, [pos_y]
        mov dx, ax      ; DX = Y inicial del bloque 10x10

        ; Calcular X del bloque: pos_x + (bp * 10)
        mov ax, bp
        mov bl, 10
        mul bl
        add ax, [pos_x]
        mov cx, ax      ; CX = X inicial del bloque 10x10

        pop ax          ; Recuperar el color

        ; Pintar el bloque de 10x10
        mov [bloque_fil], 0
    fil_dib:
        cmp [bloque_fil], 10
        je siguiente_bloque_dibujo
        mov [bloque_col], 0
    col_dib:
        cmp [bloque_col], 10
        je sig_fil_dib
    
        mov ah, 0Ch
        mov bh, 0
        int 10h
    
        inc cx
        inc [bloque_col]
        jmp col_dib

    sig_fil_dib:
        sub cx, 10
        inc dx
        inc [bloque_fil]
        jmp fil_dib

    siguiente_bloque_dibujo:
        inc si
        inc bp
        mov al, [tam_matriz]
        cbw
        cmp bp, ax
        jb loop_col_matriz

        inc di
        mov al, [tam_matriz]
        cbw
        cmp di, ax
        jb loop_fil_matriz

        ret

;------------------------------------------------------------------------------------------------------------
;                                      CAIDA Y MOVIMIENTO
;------------------------------------------------------------------------------------------------------------

    preparar_delay:
        mov ah, 00h
        int 1Ah
        add dx, 4
        mov [tics_esperar], dx
    
    delay:
        mov ah, 01h
        int 16h
        jz verificar_tiempo
    
        mov ah, 00h
        int 16h
    
        cmp al, 20h
        je cambiar_fase
    
        cmp al, 'A'
        je mover_izq
        cmp al, 'a'
        je mover_izq
    
        cmp al, 'D'
        je mover_der
        cmp al, 'd'
        je mover_der
    
        jmp verificar_tiempo
    
    mover_izq:
        cmp [pos_x], 10
        jbe verificar_tiempo
        call ejecutar_borrado
        call verificar_colision_izq
        jc cancelar_izq
        sub [pos_x], 10
        jmp fase0
    cancelar_izq:
        call re_pintar_figura
        jmp verificar_tiempo
    
    mover_der:
        cmp [pos_x], 280
        jae verificar_tiempo
        call ejecutar_borrado
        call verificar_colision_der
        jc cancelar_der
        add [pos_x], 10
        jmp fase0
    cancelar_der:
        call re_pintar_figura
        jmp verificar_tiempo
        
    cambiar_fase:
        cmp [figura_actual], 2       ; El cuadrado no rota
        je verificar_tiempo

        call ejecutar_borrado
        inc [contador_rot]

        cmp [figura_actual], 1
        je limite_rot_4

        cmp [contador_rot], 2
        jb fase0
        mov [contador_rot], 0
        jmp fase0

    limite_rot_4:
        cmp [contador_rot], 4
        jb fase0
        mov [contador_rot], 0
        jmp fase0
        
    verificar_tiempo:
        mov ah, 00h
        int 1Ah
        cmp dx, [tics_esperar]
        jl delay
    
        call ejecutar_borrado
        call verificar_colision_abajo
        jc fijar_y_nuevo
    
        add [pos_y], 10
        jmp fase0

;------------------------------------------------------------------------------------------------------------
;                                  FIJAR FIGURA O REINICIAR JUEGO
;------------------------------------------------------------------------------------------------------------
    fijar_y_nuevo:
        call re_pintar_figura

        cmp [pos_y], 20
        jbe reiniciar_juego

        mov [pos_y], 20
        mov [pos_x], 100
        mov [contador_rot], 0
        jmp num_aleatorio

    reiniciar_juego:
        mov ah, 06h
        mov al, 0
        mov bh, 00h        
        mov cx, 0000h      
        mov dx, 184Fh      
        int 10h

        mov [pos_y], 20
        mov [pos_x], 100
        mov [contador_rot], 0

        jmp pintar_pantalla_inicial

    re_pintar_figura:
        cmp [figura_actual], 1
        je rep_fig0
        cmp [figura_actual], 2
        je rep_fig1
        cmp [figura_actual], 3
        je rep_fig2
        cmp [figura_actual], 4
        je rep_fig3

    rep_fig0:
        mov [tam_matriz], 3
        cmp [contador_rot], 0
        je r_f0_0
        cmp [contador_rot], 1
        je r_f0_1
        cmp [contador_rot], 2
        je r_f0_2
        mov si, offset figura40
        call dib_figura
        ret
    r_f0_0:
        mov si, offset figura10
        call dib_figura
        ret
    r_f0_1:
        mov si, offset figura20
        call dib_figura
        ret
    r_f0_2:
        mov si, offset figura30
        call dib_figura
        ret

    rep_fig1:
        mov [tam_matriz], 2
        mov si, offset figura11
        call dib_figura
        ret

    rep_fig2:
        mov [tam_matriz], 4
        cmp [contador_rot], 0
        je rep_fig2_0
        mov si, offset figura22
        call dib_figura
        ret
    rep_fig2_0:
        mov si, offset figura12
        call dib_figura
        ret

    rep_fig3:
        mov [tam_matriz], 3
        cmp [contador_rot], 0
        je rep_fig3_0
        mov si, offset figura23
        call dib_figura
        ret
    rep_fig3_0:
        mov si, offset figura13
        call dib_figura
        ret

;------------------------------------------------------------------------------------------------------------
;                                        BORRADO INTELIGENTE
;------------------------------------------------------------------------------------------------------------

    ejecutar_borrado:
        cmp [figura_actual], 1
        je borrado_fig0
        cmp [figura_actual], 2
        je borrado_fig1
        cmp [figura_actual], 3
        je borrado_fig2
        cmp [figura_actual], 4
        je borrado_fig3

    borrado_fig0:
        mov [tam_matriz], 3
        cmp [contador_rot], 0
        je borr_f0_0
        cmp [contador_rot], 1
        je borr_f0_1
        cmp [contador_rot], 2
        je borr_f0_2
        mov si, offset figura40
        jmp inicio_borrado
    borr_f0_0:
        mov si, offset figura10
        jmp inicio_borrado
    borr_f0_1:
        mov si, offset figura20
        jmp inicio_borrado
    borr_f0_2:
        mov si, offset figura30
        jmp inicio_borrado

    borrado_fig1:
        mov [tam_matriz], 2
        mov si, offset figura11
        jmp inicio_borrado

    borrado_fig2:
        mov [tam_matriz], 4
        cmp [contador_rot], 0
        je borr_f2_0
        mov si, offset figura22
        jmp inicio_borrado
    borr_f2_0:
        mov si, offset figura12
        jmp inicio_borrado

    borrado_fig3:
        mov [tam_matriz], 3
        cmp [contador_rot], 0
        je borr_f3_0
        mov si, offset figura23
        jmp inicio_borrado
    borr_f3_0:
        mov si, offset figura13

    inicio_borrado:
        mov di, 0       ; Fila matriz
    loop_fil_borr:
        mov bp, 0       ; Columna matriz
    loop_col_borr:
        mov al, [si]
        cmp al, 0h
        je siguiente_bloque_borrado

        ; Calcular Y absoluto: pos_y + (di * 10)
        mov ax, di
        mov bl, 10
        mul bl
        add ax, [pos_y]
        mov dx, ax

        ; Calcular X absoluto: pos_x + (bp * 10)
        mov ax, bp
        mov bl, 10
        mul bl
        add ax, [pos_x]
        mov cx, ax

        ; Borrar bloque de 10x10 con color Negro (0h)
        mov [bloque_fil], 0
    fil_borr:
        cmp [bloque_fil], 10
        je siguiente_bloque_borrado
        mov [bloque_col], 0
    col_borr:
        cmp [bloque_col], 10
        je sig_fil_borr
    
        mov ah, 0Ch
        mov al, 0h      ; Color negro
        mov bh, 0
        int 10h
    
        inc cx
        inc [bloque_col]
        jmp col_borr

    sig_fil_borr:
        sub cx, 10
        inc dx
        inc [bloque_fil]
        jmp fil_borr

    siguiente_bloque_borrado:
        inc si
        inc bp
        mov al, [tam_matriz]
        cbw
        cmp bp, ax
        jb loop_col_borr

        inc di
        mov al, [tam_matriz]
        cbw
        cmp di, ax
        jb loop_fil_borr

        ret

;------------------------------------------------------------------------------------------------------------
;                                     VERIFICAR COLISION INFERIOR
;------------------------------------------------------------------------------------------------------------
    verificar_colision_abajo:
        cmp [figura_actual], 1
        je chk_down_fig0
        cmp [figura_actual], 2
        je chk_down_fig1
        cmp [figura_actual], 3
        je chk_down_fig2
        cmp [figura_actual], 4
        je chk_down_fig3
        jmp no_colision

    chk_down_fig0: ; Semicruz 3x3
        cmp [contador_rot], 0
        je chk_down_f0_0
        cmp [contador_rot], 1
        je chk_down_f0_1
        cmp [contador_rot], 2
        je chk_down_f0_2

        ; Rotacion 3
        mov dx, [pos_y]
        add dx, 30
        cmp dx, 200
        jge colision_detectada
        mov cx, [pos_x]
        add cx, 14
        call leer_pixel_colision
        jc colision_detectada
        mov dx, [pos_y]
        add dx, 20
        mov cx, [pos_x]
        add cx, 4
        call leer_pixel_colision
        jc colision_detectada
        jmp no_colision

    chk_down_f0_0:
        mov dx, [pos_y]
        add dx, 20
        cmp dx, 200
        jge colision_detectada
        mov cx, [pos_x]
        add cx, 4
        call leer_pixel_colision
        jc colision_detectada
        mov cx, [pos_x]
        add cx, 14
        call leer_pixel_colision
        jc colision_detectada
        mov cx, [pos_x]
        add cx, 24
        call leer_pixel_colision
        jc colision_detectada
        jmp no_colision

    chk_down_f0_1:
        mov dx, [pos_y]
        add dx, 30
        cmp dx, 200
        jge colision_detectada
        mov cx, [pos_x]
        add cx, 4
        call leer_pixel_colision
        jc colision_detectada
        mov dx, [pos_y]
        add dx, 20
        mov cx, [pos_x]
        add cx, 14
        call leer_pixel_colision
        jc colision_detectada
        jmp no_colision

    chk_down_f0_2:
        mov dx, [pos_y]
        add dx, 20
        cmp dx, 200
        jge colision_detectada
        mov dx, [pos_y]
        add dx, 10
        mov cx, [pos_x]
        add cx, 4
        call leer_pixel_colision
        jc colision_detectada
        mov cx, [pos_x]
        add cx, 24
        call leer_pixel_colision
        jc colision_detectada
        mov dx, [pos_y]
        add dx, 20
        mov cx, [pos_x]
        add cx, 14
        call leer_pixel_colision
        jc colision_detectada
        jmp no_colision

    chk_down_fig1: ; Cuadrado 2x2
        mov dx, [pos_y]
        add dx, 20
        cmp dx, 200
        jge colision_detectada
        mov cx, [pos_x]
        add cx, 4
        call leer_pixel_colision
        jc colision_detectada
        mov cx, [pos_x]
        add cx, 14
        call leer_pixel_colision
        jc colision_detectada
        jmp no_colision

    chk_down_fig2: ; Linea 4x4
        cmp [contador_rot], 0
        je chk_down_fig2_h

        ; Linea Vertical
        mov dx, [pos_y]
        add dx, 40
        cmp dx, 200
        jge colision_detectada
        mov cx, [pos_x]
        add cx, 14
        call leer_pixel_colision
        jc colision_detectada
        jmp no_colision

    chk_down_fig2_h:
        ; Linea Horizontal
        mov dx, [pos_y]
        add dx, 30
        cmp dx, 200
        jge colision_detectada
        mov cx, [pos_x]
        add cx, 4
        call leer_pixel_colision
        jc colision_detectada
        mov cx, [pos_x]
        add cx, 14
        call leer_pixel_colision
        jc colision_detectada
        mov cx, [pos_x]
        add cx, 24
        call leer_pixel_colision
        jc colision_detectada
        mov cx, [pos_x]
        add cx, 34
        call leer_pixel_colision
        jc colision_detectada
        jmp no_colision

    chk_down_fig3: ; Z 3x3
        cmp [contador_rot], 0
        je chk_down_fig3_h

        ; Z Vertical (figura23): [0,2,0 / 2,2,0 / 2,0,0]
        mov dx, [pos_y]
        add dx, 30          ; Fila 3
        cmp dx, 200
        jge colision_detectada
        mov cx, [pos_x]
        add cx, 4           ; Columna 0
        call leer_pixel_colision
        jc colision_detectada

        mov dx, [pos_y]
        add dx, 20          ; Fila 2
        mov cx, [pos_x]
        add cx, 14          ; Columna 1
        call leer_pixel_colision
        jc colision_detectada
        jmp no_colision

    chk_down_fig3_h:
        ; Z Horizontal (figura13): [2,2,0 / 0,2,2 / 0,0,0]
        mov dx, [pos_y]
        add dx, 20          ; Fila 2
        cmp dx, 200
        jge colision_detectada
        mov cx, [pos_x]
        add cx, 14          ; Columna 1
        call leer_pixel_colision
        jc colision_detectada
        mov cx, [pos_x]
        add cx, 24          ; Columna 2
        call leer_pixel_colision
        jc colision_detectada

        mov dx, [pos_y]
        add dx, 10          ; Fila 1
        mov cx, [pos_x]
        add cx, 4           ; Columna 0
        call leer_pixel_colision
        jc colision_detectada
        jmp no_colision

    no_colision:
        clc
        ret

    colision_detectada:
        stc
        ret

    leer_pixel_colision:
        mov ah, 0Dh
        mov bh, 0
        int 10h
    
        cmp al, 0h
        jne es_solido
        clc
        ret

    es_solido:
        stc
        ret

;------------------------------------------------------------------------------------------------------------
;                                    VERIFICAR COLISION IZQUIERDA
;------------------------------------------------------------------------------------------------------------
    verificar_colision_izq:
        cmp [figura_actual], 1
        je chk_izq_fig0
        cmp [figura_actual], 2
        je chk_izq_fig1
        cmp [figura_actual], 3
        je chk_izq_fig2
        cmp [figura_actual], 4
        je chk_izq_fig3
        jmp no_colision_izq

    chk_izq_fig0: ; Semicruz
        cmp [contador_rot], 0
        je chk_izq_f0_0
        cmp [contador_rot], 1
        je chk_izq_f0_1
        cmp [contador_rot], 2
        je chk_izq_f0_2

        ; Rotacion 3
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        add cx, 9
        call leer_pixel_colision
        jc colision_izq_det
        mov dx, [pos_y]
        add dx, 14
        mov cx, [pos_x]
        sub cx, 1
        call leer_pixel_colision
        jc colision_izq_det
        mov dx, [pos_y]
        add dx, 24
        mov cx, [pos_x]
        add cx, 9
        call leer_pixel_colision
        jc colision_izq_det
        jmp no_colision_izq

    chk_izq_f0_0:
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        add cx, 9
        call leer_pixel_colision
        jc colision_izq_det
        mov dx, [pos_y]
        add dx, 14
        mov cx, [pos_x]
        sub cx, 1
        call leer_pixel_colision
        jc colision_izq_det
        jmp no_colision_izq

    chk_izq_f0_1:
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        sub cx, 1
        call leer_pixel_colision
        jc colision_izq_det
        mov dx, [pos_y]
        add dx, 14
        call leer_pixel_colision
        jc colision_izq_det
        mov dx, [pos_y]
        add dx, 24
        call leer_pixel_colision
        jc colision_izq_det
        jmp no_colision_izq

    chk_izq_f0_2:
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        sub cx, 1
        call leer_pixel_colision
        jc colision_izq_det
        mov dx, [pos_y]
        add dx, 14
        mov cx, [pos_x]
        add cx, 9
        call leer_pixel_colision
        jc colision_izq_det
        jmp no_colision_izq

    chk_izq_fig1: ; Cuadrado
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        sub cx, 1
        call leer_pixel_colision
        jc colision_izq_det
        mov dx, [pos_y]
        add dx, 14
        call leer_pixel_colision
        jc colision_izq_det
        jmp no_colision_izq

    chk_izq_fig2: ; Linea
        cmp [contador_rot], 0
        je chk_izq_fig2_h

        ; Linea Vertical
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        add cx, 9
        call leer_pixel_colision
        jc colision_izq_det
        mov dx, [pos_y]
        add dx, 14
        call leer_pixel_colision
        jc colision_izq_det
        mov dx, [pos_y]
        add dx, 24
        call leer_pixel_colision
        jc colision_izq_det
        mov dx, [pos_y]
        add dx, 34
        call leer_pixel_colision
        jc colision_izq_det
        jmp no_colision_izq

    chk_izq_fig2_h:
        ; Linea Horizontal
        mov dx, [pos_y]
        add dx, 24
        mov cx, [pos_x]
        sub cx, 1
        call leer_pixel_colision
        jc colision_izq_det
        jmp no_colision_izq

    chk_izq_fig3: ; Z 3x3
        cmp [contador_rot], 0
        je chk_izq_fig3_h

        ; Z Vertical: [0,2,0 / 2,2,0 / 2,0,0]
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        add cx, 9
        call leer_pixel_colision
        jc colision_izq_det

        mov dx, [pos_y]
        add dx, 14
        mov cx, [pos_x]
        sub cx, 1
        call leer_pixel_colision
        jc colision_izq_det

        mov dx, [pos_y]
        add dx, 24
        mov cx, [pos_x]
        sub cx, 1
        call leer_pixel_colision
        jc colision_izq_det
        jmp no_colision_izq

    chk_izq_fig3_h:
        ; Z Horizontal: [2,2,0 / 0,2,2 / 0,0,0]
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        sub cx, 1
        call leer_pixel_colision
        jc colision_izq_det

        mov dx, [pos_y]
        add dx, 14
        mov cx, [pos_x]
        add cx, 9
        call leer_pixel_colision
        jc colision_izq_det
        jmp no_colision_izq

    no_colision_izq:
        clc
        ret
    colision_izq_det:
        stc
        ret

;------------------------------------------------------------------------------------------------------------
;                                    VERIFICAR COLISION DERECHA
;------------------------------------------------------------------------------------------------------------
    verificar_colision_der:
        cmp [figura_actual], 1
        je chk_der_fig0
        cmp [figura_actual], 2
        je chk_der_fig1
        cmp [figura_actual], 3
        je chk_der_fig2
        cmp [figura_actual], 4
        je chk_der_fig3
        jmp no_colision_der

    chk_der_fig0: ; Semicruz
        cmp [contador_rot], 0
        je chk_der_f0_0
        cmp [contador_rot], 1
        je chk_der_f0_1
        cmp [contador_rot], 2
        je chk_der_f0_2

        ; Rotacion 3
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        add cx, 20
        call leer_pixel_colision
        jc colision_der_det
        mov dx, [pos_y]
        add dx, 14
        mov cx, [pos_x]
        add cx, 20
        call leer_pixel_colision
        jc colision_der_det
        mov dx, [pos_y]
        add dx, 24
        mov cx, [pos_x]
        add cx, 20
        call leer_pixel_colision
        jc colision_der_det
        jmp no_colision_der

    chk_der_f0_0:
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        add cx, 20
        call leer_pixel_colision
        jc colision_der_det
        mov dx, [pos_y]
        add dx, 14
        mov cx, [pos_x]
        add cx, 30
        call leer_pixel_colision
        jc colision_der_det
        jmp no_colision_der

    chk_der_f0_1:
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        add cx, 10
        call leer_pixel_colision
        jc colision_der_det
        mov dx, [pos_y]
        add dx, 14
        mov cx, [pos_x]
        add cx, 20
        call leer_pixel_colision
        jc colision_der_det
        mov dx, [pos_y]
        add dx, 24
        mov cx, [pos_x]
        add cx, 10
        call leer_pixel_colision
        jc colision_der_det
        jmp no_colision_der

    chk_der_f0_2:
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        add cx, 30
        call leer_pixel_colision
        jc colision_der_det
        mov dx, [pos_y]
        add dx, 14
        mov cx, [pos_x]
        add cx, 20
        call leer_pixel_colision
        jc colision_der_det
        jmp no_colision_der

    chk_der_fig1: ; Cuadrado
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        add cx, 20
        call leer_pixel_colision
        jc colision_der_det
        mov dx, [pos_y]
        add dx, 14
        call leer_pixel_colision
        jc colision_der_det
        jmp no_colision_der

    chk_der_fig2: ; Linea
        cmp [contador_rot], 0
        je chk_der_fig2_h
        
        ; Linea Vertical
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        add cx, 20
        call leer_pixel_colision
        jc colision_der_det
        mov dx, [pos_y]
        add dx, 14
        call leer_pixel_colision
        jc colision_der_det
        mov dx, [pos_y]
        add dx, 24
        call leer_pixel_colision
        jc colision_der_det
        mov dx, [pos_y]
        add dx, 34
        call leer_pixel_colision
        jc colision_der_det
        jmp no_colision_der

    chk_der_fig2_h:
        ; Linea Horizontal
        mov dx, [pos_y]
        add dx, 24
        mov cx, [pos_x]
        add cx, 40
        call leer_pixel_colision
        jc colision_der_det
        jmp no_colision_der

    chk_der_fig3: ; Z 3x3
        cmp [contador_rot], 0
        je chk_der_fig3_h

        ; Z Vertical: [0,2,0 / 2,2,0 / 2,0,0]
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        add cx, 20
        call leer_pixel_colision
        jc colision_der_det

        mov dx, [pos_y]
        add dx, 14
        mov cx, [pos_x]
        add cx, 20
        call leer_pixel_colision
        jc colision_der_det

        mov dx, [pos_y]
        add dx, 24
        mov cx, [pos_x]
        add cx, 10
        call leer_pixel_colision
        jc colision_der_det
        jmp no_colision_der

    chk_der_fig3_h:
        ; Z Horizontal: [2,2,0 / 0,2,2 / 0,0,0]
        mov dx, [pos_y]
        add dx, 4
        mov cx, [pos_x]
        add cx, 20
        call leer_pixel_colision
        jc colision_der_det

        mov dx, [pos_y]
        add dx, 14
        mov cx, [pos_x]
        add cx, 30
        call leer_pixel_colision
        jc colision_der_det
        jmp no_colision_der

    no_colision_der:
        clc
        ret
    colision_der_det:
        stc
        ret

    ends

end start