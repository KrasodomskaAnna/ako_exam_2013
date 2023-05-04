x86asm
.686
.model flat
extern __write : PROC ; (dwa znaki podkreślenia)
public _wysw_mieszane

.code

wyswietl_EAX    PROC
        PUSHAD
        ; aby wyświetlić maksymalną wartość potrzebujemy 10 bitów
        ; do tego kod nowego wiersza *2
        ; i kropka
        sub esp, 10+2+1
        mov edi, esp
        
        MOV    ESI, 10    ; index w tablicy znaki
        MOV    EBX, 10    ; dzielnik
        konwersja:
            MOV    EDX, 0
            DIV        EBX    ; dzielenie EDX:EAX przez EBX -> iloraz w EAX, reszta w EDX
            ADD    DL, 30H    ; zmiana reszty na ASCII
            MOV    [edi][ESI], DL
            DEC    ESI
            CMP    EAX, 0    ; czy iloraz = 0 ?
            JNE        konwersja
        wypeln:
            OR        ESI, ESI    ; czy index tablicy = 0 ?
            JZ        wyswietl 
            MOV    byte PTR [edi][ESI], 20H
            DEC    ESI
            JMP        wypeln
        wyswietl:
            ; cyfry zajmują miejsca od 1 do 10
            ; a powinny zajmować 1-8 [kropka] 10-11
            ; zatem trzeba przesunąć ostatnie 2 cyfry
            ; .... A B ?
            mov eax, [edi][10]
            mov [edi][11], eax
            ; .... A B B
            mov eax, [edi][9]
            mov [edi][10], eax
            ; .... A A B
            mov byte PTR [edi][9], '.'
            
            MOV    byte PTR [edi][0], 0AH    ; kod nowego wiersza
            MOV    byte PTR [edi][12], 0AH
            
            PUSH    dword PTR 13
            PUSH    dword PTR edi
            PUSH    dword PTR 1
            CALL    __write
            ADD    ESP,12
        
        add esp, 10+2+1
        POPAD
        RET
wyswietl_EAX ENDP

_wysw_mieszane PROC
    push ebp
    mov ebp, esp
    
    push ebx
    push esi
    push edi
    
    mov eax, [ebp+8]

    mov eax, 0FFFFFFFEh

    mov ebx, 100
    mul ebx
    
    ; przesunięcie o 7 bitów w prawo
    ; for(ecx = 0; ecx < 7; ecx++) {
    ;         przesuń edx o 1 bit w prawo
    ;        przesuń eax o 1 bit w prawo z carry
    ; }
    mov ecx, 7
    ptl:
        shr edx, 1
        rcr eax, 1
        loop ptl
    
    call wyswietl_EAX
    
    pop edi
    pop esi
    pop ebx
    
    pop ebp
    ret
_wysw_mieszane ENDP
end