x86asm
.686
.model flat
public _szyfrowanie

.code
_szyfrowanie PROC
    push ebp
    mov ebp, esp
    
    push ebx
    push edi
    push esi
    
    ; soid szyfrowanie(
    ; 8        char t_jawny[],
    ; 12    char t_zaszyfrowany[], 
    ; 16    char klucz[], 
    ; 20    int rozmiar_tekstu, 
    ; 24    int rozmiar_klucza);
    mov esi, [ebp+8]
    mov edi, [ebp+12]
    
    ; skopiujmy tekst jawny do pola tekstu zaszyfrowanego
    mov ecx, [ebp+20]
    cld
    rep movsb
    
    ; dodajmy klucz
    mov edi, [ebp+12]
    mov esi, [ebp+16]
    xor ebx, ebx
    ; for(ecx = 0; ecx < rozmiar_tekstu; ecx++) {
    ;         eax := edi[ecx]
    ;         eax += esi[ebx]
    ;        eax %= 26
    ;         edi[ecx] := reszta_modulo
    ;        ecx++
    ;         ebx++
    ;         if(ebx >= rozmiar_klucza)
    ;            ebx := 0
    ; }
    ptl:
        xor eax, eax
        mov al, [edi][ecx]
            push edx
            xor edx, edx
            mov dl, byte PTR [esi][ebx]
            add eax, edx
            pop edx
        ; w eax znajduje się suma liter ale w ASCII
        ; zatem trzeba odjąć 2x'A'
        sub eax, 2*'A'
        xor edx, edx
            push ebx
            mov ebx, 26
            div ebx
            pop ebx
        ; edx := reszta (tj. eax%26)
        mov [edi][ecx], dl
        add byte PTR [edi][ecx], 'A'
        
        inc ebx
        cmp ebx, [ebp+24]
        jb continue
            mov ebx, 0
        
        continue:
        inc ecx
        cmp ecx, [ebp+20]
        jbe ptl
        
        
    pop esi
    pop edi
    pop ebx

    pop ebp
    ret
_szyfrowanie ENDP
end