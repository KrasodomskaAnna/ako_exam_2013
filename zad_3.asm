x86asm
.686
.model flat
public _srednia_kwadratowa

.code
_srednia_kwadratowa PROC
    push ebp
    mov ebp, esp
    
    push ebx
    push esi
    push edi
    
    finit
    
    fld [ebp+8]
    fmul st(0), st(0)
    
    fld [ebp+12]
    fmul st(0), st(0)
    
    fld [ebp+16]
    fmul st(0), st(0)
    ; st(0) c^2, st(1) b^2, st(2) a^2
    
    faddp
    faddp
    ; st(0) a^2+b^2+c^2
    
    push dword PTR 3
    fild dword PTR [esp]
    add esp, 4
    ; st(0) := 3, st(1) := a^2+b^2+c^2
    
    fdivp
    ; st(0) := (a^2+b^2+c^2) /3
    
    fsqrt
    
    pop edi
    pop esi
    pop ebx
    
    pop ebp
    ret
_srednia_kwadratowa ENDP
end