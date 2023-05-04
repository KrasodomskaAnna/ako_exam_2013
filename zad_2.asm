x86asm
.686
.model flat
extern _ExitProcess@4    : PROC
public _main

.code
_main PROC
    mov eax, 5

    ; fragment programu
    ; eax <- bez znaku
    ; wynik = a*100 = a*64 + a*32 + a*4
    push ebx
    
    ; 1 2 3 4  5   6   7  8   9   10
    ; 2 4 8 16 32 64 128 256 512 1024
    mov ebx, eax
    shl ebx, 2                ; a*4
    push ebx
    
    mov ebx, eax
    shl ebx, 5                ; a*32
    
    shl eax, 6                ; a*64
    
    ; eax := a*64, ebx := a*32, [esp] := a*4
    add eax, ebx            ; eax := a*64 + a*32
    
    pop ebx                    ; ebx := a*4
    add eax, ebx            ; eax := a*64 + a*32 + a*4
    
    pop ebx                    ; przywrócenie początkowej wartości
    
    ; koniec fragmentu
    push 0
    call _ExitProcess@4
_main ENDP
end