global container_init
global container_clear
global container_in
global container_in_random
global container_out
global container_straigh_sort
global random_int
global random_string
global language_in
global language_in_random
global language_out
global language_calculation
global file_read_string
global file_read_int
global procedural_in
global procedural_inrnd
global procedural_out
global procedural_calculation
global functional_in
global functional_inrnd
global functional_out
global functional_calculation
global objectoriented_out
global objectoriented_calculation
global incorrect_command_line
global incorrect_qualifier_value
global incorrect_number_of_items
global incorrect_files
global main

extern fwrite                                           
extern fclose                                           
extern fopen                                            
extern memset                                           
extern exit                                             
extern srand                                            
extern time                                             
extern printf                                           
extern feof                                             
extern puts                                             
extern __isoc99_fscanf                                  
extern strcmp                                           
extern strlen                                           
extern fprintf                                          
extern free                                             
extern atoi                                             
extern strcpy                                           
extern fgetc                                            
extern malloc                                           
extern rand


SECTION .text                             

random_int:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 16                                 
        mov     dword [rbp-4H], edi                     
        mov     dword [rbp-8H], esi                     
        call    rand                                    
        mov     edx, dword [rbp-8H]                     
        mov     ecx, edx                                
        sub     ecx, dword [rbp-4H]                     
        cdq                                             
        idiv    ecx                                     
        mov     eax, dword [rbp-4H]                     
        add     eax, edx                                
        inc     eax                                     
        leave                                           
        ret                                             


random_string:                              ; Рандомизация строки
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 16                                 
        mov     esi, 10                                 
        mov     edi, 5                                  
        call    random_int                              
        mov     dword [rbp-8H], eax                     
        mov     eax, dword [rbp-8H]                     
        inc     eax                                     
        cdqe                                            
        mov     rdi, rax                                
        call    malloc                                  
        mov     qword [rbp-10H], rax                    
        mov     dword [rbp-4H], 0                       
        jmp     random_string_loop

random_string_loop_end:                     ; Рандомизация строки
        mov     esi, 62
        mov     edi, 0                                  
        call    random_int                              
        mov     edx, dword [rbp-4H]                     
        movsxd  rdx, edx                                
        mov     rcx, qword [rbp-10H]                    
        add     rdx, rcx                                
        cdqe                                            
        lea     rcx, [rel alphabet]                        
        movzx   eax, byte [rax+rcx]                     
        mov     byte [rdx], al                          
        inc     dword [rbp-4H]                          
random_string_loop:
        mov     eax, dword [rbp-4H]
        cmp     eax, dword [rbp-8H]                     
        jl      random_string_loop_end
        mov     eax, dword [rbp-8H]                     
        cdqe                                            
        mov     rdx, qword [rbp-10H]                    
        add     rax, rdx                                
        mov     byte [rax], 0                           
        mov     rax, qword [rbp-10H]                    
        leave                                           
        ret                                             


file_read_string:                            ; Чтение строки
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 144                                
        mov     qword [rbp-88H], rdi                    
        mov     qword [rbp-80H], 0                      
        mov     qword [rbp-78H], 0                      
        mov     qword [rbp-70H], 0                      
        mov     qword [rbp-68H], 0                      
        mov     qword [rbp-60H], 0                      
        mov     qword [rbp-58H], 0                      
        mov     qword [rbp-50H], 0                      
        mov     qword [rbp-48H], 0                      
        mov     qword [rbp-40H], 0                      
        mov     qword [rbp-38H], 0                      
        mov     qword [rbp-30H], 0                      
        mov     qword [rbp-28H], 0                      
        mov     dword [rbp-20H], 0                      
        mov     dword [rbp-4H], 0                       
        mov     rax, qword [rbp-88H]                    
        mov     rdi, rax                                
        call    fgetc                                   
        mov     dword [rbp-8H], eax                     
        jmp     file_read_string_loop_2
file_read_string_loop_1:                    ; Чтение строки
        mov     eax, dword [rbp-4H]
        lea     edx, [rax+1H]                           
        mov     dword [rbp-4H], edx                     
        mov     edx, dword [rbp-8H]                     
        cdqe                                            
        mov     byte [rbp+rax-80H], dl                  
        mov     rax, qword [rbp-88H]                    
        mov     rdi, rax                                
        call    fgetc                                   
        mov     dword [rbp-8H], eax                     
file_read_string_loop_2:                    ; Чтение строки
        cmp     dword [rbp-8H], -1
        jz      file_read_string_loop_3
        cmp     dword [rbp-8H], 10                      
        jz      file_read_string_loop_3
        cmp     dword [rbp-8H], 32                      
        jnz     file_read_string_loop_1
file_read_string_loop_3:                    ; Чтение строки
        mov     eax, dword [rbp-4H]
        lea     edx, [rax+1H]                           
        mov     dword [rbp-4H], edx                     
        cdqe                                            
        mov     byte [rbp+rax-80H], 0                   
        mov     eax, dword [rbp-4H]                     
        cdqe                                            
        mov     rdi, rax                                
        call    malloc                                  
        mov     qword [rbp-10H], rax                    
        lea     rax, [rbp-80H]                          
        mov     rdx, qword [rbp-10H]                    
        mov     rsi, rax                                
        mov     rdi, rdx                                
        call    strcpy                                  
        mov     rax, qword [rbp-10H]                    
        leave                                           
        ret                                             


file_read_int:                              ; Чтение цифры
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 32                                 
        mov     qword [rbp-18H], rdi                    
        mov     rax, qword [rbp-18H]                    
        mov     rdi, rax                                
        call    file_read_string                        
        mov     qword [rbp-8H], rax                     
        mov     rax, qword [rbp-8H]                     
        mov     rdi, rax                                
        call    atoi                                    
        mov     dword [rbp-0CH], eax                    
        mov     rax, qword [rbp-8H]                     
        mov     rdi, rax                                
        call    free                                    
        mov     eax, dword [rbp-0CH]                    
        leave                                           
        ret                                             


procedural_in:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 16                                 
        mov     qword [rbp-8H], rdi                     
        mov     qword [rbp-10H], rsi                    
        mov     rax, qword [rbp-10H]                    
        mov     rdi, rax                                
        call    file_read_string                        
        mov     rdx, qword [rbp-8H]                     
        mov     qword [rdx], rax                        
        mov     rax, qword [rbp-10H]                    
        mov     rdi, rax                                
        call    file_read_int                           
        mov     rdx, qword [rbp-8H]                     
        mov     dword [rdx+8H], eax                     
        mov     rax, qword [rbp-10H]                    
        mov     rdi, rax                                
        call    file_read_int                           
        mov     rdx, qword [rbp-8H]                     
        mov     dword [rdx+0CH], eax                    
        nop                                             
        leave                                           
        ret                                             


procedural_inrnd:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 16                                 
        mov     qword [rbp-8H], rdi                     
        mov     eax, 0                                  
        call    random_string                           
        mov     rdx, qword [rbp-8H]                     
        mov     qword [rdx], rax                        
        mov     esi, 2021                               
        mov     edi, 1950                               
        call    random_int                              
        mov     rdx, qword [rbp-8H]                     
        mov     dword [rdx+8H], eax                     
        mov     esi, 10                                 
        mov     edi, 1                                  
        call    random_int                              
        mov     rdx, qword [rbp-8H]                     
        mov     dword [rdx+0CH], eax                    
        nop                                             
        leave                                           
        ret                                             


procedural_out:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 16                                 
        mov     qword [rbp-8H], rdi                     
        mov     qword [rbp-10H], rsi                    
        mov     rax, qword [rbp-8H]                     
        mov     esi, dword [rax+0CH]                    
        mov     rax, qword [rbp-8H]                     
        mov     ecx, dword [rax+8H]                     
        mov     rax, qword [rbp-8H]                     
        mov     rdx, qword [rax]                        
        mov     rax, qword [rbp-10H]                    
        mov     r8d, esi                                
        lea     rsi, [rel procedural_output]                        
        mov     rdi, rax                                
        mov     eax, 0                                  
        call    fprintf                                 
        nop                                             
        leave                                           
        ret                                             


procedural_calculation:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 16                                 
        mov     qword [rbp-8H], rdi                     
        mov     rax, qword [rbp-8H]                     
        mov     eax, dword [rax+8H]                     
        vcvtsi2sd xmm1, xmm1, eax            ; Преобразует целое число со знаком из двух слов 
                                             ; (или целое число из четырех слов со знаком, если размер операнда 64 бита)
                                             ; в исходном операнде “преобразовать из” в значение с плавающей запятой 
                                             ; двойной точности в целевом операнде.                             
        vmovsd  qword [rbp-10H], xmm1        ; Перемещает значение с плавающей запятой скалярной двойной 
                                             ; точности из исходного операнда (второй операнд) 
                                             ; в операнд назначения (первый операнд).                   
        mov     rax, qword [rbp-8H]                     
        mov     rax, qword [rax]                        
        mov     rdi, rax                                
        call    strlen                                  
        test    rax, rax                                
        js      procedural_calculation_1
        vcvtsi2sd xmm0, xmm0, rax            ; Преобразует целое число со знаком из двух слов 
                                             ; (или целое число из четырех слов со знаком, если размер операнда 64 бита)
                                             ; в исходном операнде “преобразовать из” в значение с плавающей запятой 
                                             ; двойной точности в целевом операнде.                             
        jmp     procedural_calculation_2
procedural_calculation_1:
        mov     rdx, rax
        shr     rdx, 1                                  
        and     eax, 01H                                
        or      rdx, rax                                
        vcvtsi2sd xmm0, xmm0, rdx            ; Преобразует целое число со знаком из двух слов 
                                             ; (или целое число из четырех слов со знаком, если размер операнда 64 бита)
                                             ; в исходном операнде “преобразовать из” в значение с плавающей запятой 
                                             ; двойной точности в целевом операнде.                             
        vaddsd  xmm0, xmm0, xmm0             ; Добавляет значения с плавающей запятой низкой двойной точности из второго 
                                             ; исходного операнда и первого исходного операнда и сохраняет результат 
                                             ; с плавающей запятой двойной точности в целевом операнде.           
procedural_calculation_2:
        vmovsd  xmm2, qword [rbp-10H]        ; Перемещает значение с плавающей запятой скалярной двойной 
                                             ; точности из исходного операнда (второй операнд) 
                                             ; в операнд назначения (первый операнд).
        vdivsd  xmm0, xmm2, xmm0             ; Делит значение с плавающей запятой низкой двойной точности 
                                             ; в первом исходном операнде на значение с плавающей запятой
                                             ; низкой двойной точности во втором исходном операнде
                                             ; и сохраняет результат с плавающей запятой двойной точности в целевом операнде.           
        vmovq   rax, xmm0                    ; Копирует четырехсловие из исходного операнда
                                             ; (второй операнд) в операнд назначения (первый операнд).
                                             ; Исходными и целевыми операндами могут быть регистры
                                             ; технологии MMX, регистры XMM или 64-разрядные ячейки памяти.                                
        vmovq   xmm0, rax                    ; Копирует четырехсловие из исходного операнда
                                             ; (второй операнд) в операнд назначения (первый операнд).
                                             ; Исходными и целевыми операндами могут быть регистры
                                             ; технологии MMX, регистры XMM или 64-разрядные ячейки памяти.                                 
        leave                                           
        ret                                             


functional_in:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 32                                 
        mov     qword [rbp-18H], rdi                    
        mov     qword [rbp-20H], rsi                    
        mov     rax, qword [rbp-20H]                    
        mov     rdi, rax                                
        call    file_read_string                        
        mov     rdx, qword [rbp-18H]                    
        mov     qword [rdx], rax                        
        mov     rax, qword [rbp-20H]                    
        mov     rdi, rax                                
        call    file_read_int                           
        mov     rdx, qword [rbp-18H]                    
        mov     dword [rdx+8H], eax                     
        mov     rax, qword [rbp-20H]                    
        mov     rdi, rax                                
        call    file_read_string                        
        mov     qword [rbp-8H], rax                     
        mov     rax, qword [rbp-8H]                     
        lea     rdx, [rel dynamic_lw]                        
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    strcmp                                  
        test    eax, eax                                
        jnz     func_type_strict
        mov     rax, qword [rbp-18H]                    
        mov     byte [rax+0CH], 1                       
        jmp     functional_in_end_2
func_type_strict:
        mov     rax, qword [rbp-8H]
        lea     rdx, [rel strict_lw]                        
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    strcmp                                  
        test    eax, eax                                
        jnz     func_type_error
        mov     rax, qword [rbp-18H]                    
        mov     byte [rax+0CH], 2                       
        jmp     functional_in_end_2
func_type_error:
        mov     rax, qword [rbp-8H]
        lea     rdx, [rel error_lw]                        
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    strcmp                                  
        test    eax, eax                                
        jnz     functional_in_end_1
        mov     rax, qword [rbp-18H]                    
        mov     byte [rax+0CH], 3                       
        jmp     functional_in_end_2
functional_in_end_1:
        mov     rax, qword [rbp-18H]
        mov     byte [rax+0CH], 1                       
functional_in_end_2:
        mov     rax, qword [rbp-8H]
        mov     rdi, rax                                
        call    free                                    
        nop                                             
        leave                                           
        ret                                             


functional_inrnd:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 16                                 
        mov     qword [rbp-8H], rdi                     
        mov     eax, 0                                  
        call    random_string                           
        mov     rdx, qword [rbp-8H]                     
        mov     qword [rdx], rax                        
        mov     esi, 2021                               
        mov     edi, 1950                               
        call    random_int                              
        mov     rdx, qword [rbp-8H]                     
        mov     dword [rdx+8H], eax                     
        mov     esi, 3                                  
        mov     edi, 1                                  
        call    random_int                              
        mov     edx, eax                                
        mov     rax, qword [rbp-8H]                     
        mov     byte [rax+0CH], dl                      
        nop                                             
        leave                                           
        ret       
        
           
functional_out:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 32                                 
        mov     qword [rbp-18H], rdi                    
        mov     qword [rbp-20H], rsi                    
        mov     rax, qword [rbp-18H]                    
        movzx   eax, byte [rax+0CH]                     
        movsx   eax, al                                 
        cmp     eax, 3                                  
        jz      functional_out_dynamic
        cmp     eax, 3                                  
        jg      functional_out_end
        cmp     eax, 1                                  
        jz      functional_out_strict
        cmp     eax, 2                                  
        jz      functional_out_error
        jmp     functional_out_end
functional_out_strict:
        lea     rax, [rel dynamic_up]
        mov     qword [rbp-8H], rax                     
        jmp     functional_out_end
functional_out_error:
        lea     rax, [rel strict_up]
        mov     qword [rbp-8H], rax                     
        jmp     functional_out_end
functional_out_dynamic:  lea     rax, [rel error_up]
        mov     qword [rbp-8H], rax                     
        nop                                             
functional_out_end:  mov     rax, qword [rbp-18H]
        mov     ecx, dword [rax+8H]                     
        mov     rax, qword [rbp-18H]                    
        mov     rdx, qword [rax]                        
        mov     rsi, qword [rbp-8H]                     
        mov     rax, qword [rbp-20H]                    
        mov     r8, rsi                                 
        lea     rsi, [rel functional_output]                        
        mov     rdi, rax                                
        mov     eax, 0                                  
        call    fprintf                                 
        nop                                             
        leave                                           
        ret                                             


functional_calculation:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 16                                 
        mov     qword [rbp-8H], rdi                     
        mov     rax, qword [rbp-8H]                     
        mov     eax, dword [rax+8H]                     
        vcvtsi2sd xmm1, xmm1, eax            ; Преобразует целое число со знаком из двух слов 
                                             ; (или целое число из четырех слов со знаком, если размер операнда 64 бита)
                                             ; в исходном операнде “преобразовать из” в значение с плавающей запятой 
                                             ; двойной точности в целевом операнде.                       
        vmovsd  qword [rbp-10H], xmm1        ; Перемещает значение с плавающей запятой скалярной двойной 
                                             ; точности из исходного операнда (второй операнд) 
                                             ; в операнд назначения (первый операнд).                   
        mov     rax, qword [rbp-8H]                     
        mov     rax, qword [rax]                        
        mov     rdi, rax                                
        call    strlen                                  
        test    rax, rax                                
        js      functional_calculation_1
        vcvtsi2sd xmm0, xmm0, rax            ; Преобразует целое число со знаком из двух слов 
                                             ; (или целое число из четырех слов со знаком, если размер операнда 64 бита)
                                             ; в исходном операнде “преобразовать из” в значение с плавающей запятой 
                                             ; двойной точности в целевом операнде.                        
        jmp     functional_calculation_2
functional_calculation_1:
        mov     rdx, rax
        shr     rdx, 1                                  
        and     eax, 01H                                
        or      rdx, rax                                
        vcvtsi2sd xmm0, xmm0, rdx            ; Преобразует целое число со знаком из двух слов 
                                             ; (или целое число из четырех слов со знаком, если размер операнда 64 бита)
                                             ; в исходном операнде “преобразовать из” в значение с плавающей запятой 
                                             ; двойной точности в целевом операнде.                             
        vaddsd  xmm0, xmm0, xmm0             ; Добавляет значения с плавающей запятой низкой двойной точности из второго 
                                             ; исходного операнда и первого исходного операнда и сохраняет результат 
                                             ; с плавающей запятой двойной точности в целевом операнде.                            
functional_calculation_2:
        vmovsd  xmm2, qword [rbp-10H]        ; Перемещает значение с плавающей запятой скалярной двойной 
                                             ; точности из исходного операнда (второй операнд) 
                                             ; в операнд назначения (первый операнд).
        vdivsd  xmm0, xmm2, xmm0             ; Делит значение с плавающей запятой низкой двойной точности 
                                             ; в первом исходном операнде на значение с плавающей запятой
                                             ; низкой двойной точности во втором исходном операнде
                                             ; и сохраняет результат с плавающей запятой двойной точности в целевом операнде.                         
        vmovq   rax, xmm0                    ; Копирует четырехсловие из исходного операнда
                                             ; (второй операнд) в операнд назначения (первый операнд).
                                             ; Исходными и целевыми операндами могут быть регистры
                                             ; технологии MMX, регистры XMM или 64-разрядные ячейки памяти.                                 
        vmovq   xmm0, rax                    ; Копирует четырехсловие из исходного операнда
                                             ; (второй операнд) в операнд назначения (первый операнд).
                                             ; Исходными и целевыми операндами могут быть регистры
                                             ; технологии MMX, регистры XMM или 64-разрядные ячейки памяти.                                 
        leave                                           
        ret         
        
                                           
objectoriented_in:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 32                                 
        mov     qword [rbp-18H], rdi                    
        mov     qword [rbp-20H], rsi                    
        mov     rax, qword [rbp-20H]                    
        mov     rdi, rax                                
        call    file_read_string                        
        mov     rdx, qword [rbp-18H]                    
        mov     qword [rdx], rax                        
        mov     rax, qword [rbp-20H]                    
        mov     rdi, rax                                
        call    file_read_int                           
        mov     rdx, qword [rbp-18H]                    
        mov     dword [rdx+8H], eax                     
        mov     rax, qword [rbp-20H]                    
        mov     rdi, rax                                
        call    file_read_string                        
        mov     qword [rbp-8H], rax                     
        mov     rax, qword [rbp-8H]                     
        lea     rdx, [rel dynamic_lw]                        
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    strcmp                                  
        test    eax, eax                                
        jnz     objectoriented_type_interface
        mov     rax, qword [rbp-18H]                    
        mov     byte [rax+0CH], 1                       
        jmp     functional_in_end_2
objectoriented_type_interface:
        mov     rax, qword [rbp-8H]
        lea     rdx, [rel strict_lw]                        
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    strcmp                                  
        test    eax, eax                                
        jnz     objectoriented_type_multiple
        mov     rax, qword [rbp-18H]                    
        mov     byte [rax+0CH], 2                       
        jmp     functional_in_end_2
objectoriented_type_multiple:
        mov     rax, qword [rbp-8H]
        lea     rdx, [rel error_lw]                        
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    strcmp                                  
        test    eax, eax                                
        jnz     objectoriented_in_end_1
        mov     rax, qword [rbp-18H]                    
        mov     byte [rax+0CH], 3                       
        jmp     objectoriented_in_end_2
objectoriented_in_end_1:
        mov     rax, qword [rbp-18H]
        mov     byte [rax+0CH], 1                       
objectoriented_in_end_2:
        mov     rax, qword [rbp-8H]
        mov     rdi, rax                                
        call    free                                    
        nop                                             
        leave                                           
        ret                                             


objectoriented_inrnd:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 16                                 
        mov     qword [rbp-8H], rdi                     
        mov     eax, 0                                  
        call    random_string                           
        mov     rdx, qword [rbp-8H]                     
        mov     qword [rdx], rax                        
        mov     esi, 2021                               
        mov     edi, 1950                               
        call    random_int                              
        mov     rdx, qword [rbp-8H]                     
        mov     dword [rdx+8H], eax                     
        mov     esi, 3                                  
        mov     edi, 1                                  
        call    random_int                              
        mov     edx, eax                                
        mov     rax, qword [rbp-8H]                     
        mov     byte [rax+0CH], dl                      
        nop                                             
        leave                                           
        ret                                    


objectoriented_out:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 32                                 
        mov     qword [rbp-18H], rdi                    
        mov     qword [rbp-20H], rsi                    
        mov     rax, qword [rbp-18H]                    
        movzx   eax, byte [rax+0CH]                     
        movsx   eax, al                                 
        cmp     eax, 3                                  
        jz      objectoriented_out_multiple
        cmp     eax, 3                                  
        jg      objectoriented_out_end
        cmp     eax, 1                                  
        jz      objectoriented_out_single
        cmp     eax, 2                                  
        jz      objectoriented_out_interface
        jmp     objectoriented_out_end
objectoriented_out_single:
        lea     rax, [rel dynamic_up]
        mov     qword [rbp-8H], rax                     
        jmp     objectoriented_out_end
objectoriented_out_interface:
        lea     rax, [rel strict_up]
        mov     qword [rbp-8H], rax                     
        jmp     objectoriented_out_end
objectoriented_out_multiple:  lea     rax, [rel error_up]
        mov     qword [rbp-8H], rax                     
        nop                                             
objectoriented_out_end:  mov     rax, qword [rbp-18H]
        mov     ecx, dword [rax+8H]                     
        mov     rax, qword [rbp-18H]                    
        mov     rdx, qword [rax]                        
        mov     rsi, qword [rbp-8H]                     
        mov     rax, qword [rbp-20H]                    
        mov     r8, rsi                                 
        lea     rsi, [rel objectoriented_output]                        
        mov     rdi, rax                                
        mov     eax, 0                                  
        call    fprintf                                 
        nop                                             
        leave                                           
        ret                                             


objectoriented_calculation:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 16                                 
        mov     qword [rbp-8H], rdi                     
        mov     rax, qword [rbp-8H]                     
        mov     eax, dword [rax+8H]                     
        vcvtsi2sd xmm1, xmm1, eax            ; Преобразует целое число со знаком из двух слов 
                                             ; (или целое число из четырех слов со знаком, если размер операнда 64 бита)
                                             ; в исходном операнде “преобразовать из” в значение с плавающей запятой 
                                             ; двойной точности в целевом операнде.                        
        vmovsd  qword [rbp-10H], xmm1        ; Перемещает значение с плавающей запятой скалярной двойной 
                                             ; точности из исходного операнда (второй операнд) 
                                             ; в операнд назначения (первый операнд).                   
        mov     rax, qword [rbp-8H]                     
        mov     rax, qword [rax]                        
        mov     rdi, rax                                
        call    strlen                                  
        test    rax, rax                                
        js      objectoriented_calculation_1
        vcvtsi2sd xmm0, xmm0, rax            ; Преобразует целое число со знаком из двух слов 
                                             ; (или целое число из четырех слов со знаком, если размер операнда 64 бита)
                                             ; в исходном операнде “преобразовать из” в значение с плавающей запятой 
                                             ; двойной точности в целевом операнде.                             
        jmp     objectoriented_calculation_2
objectoriented_calculation_1:
        mov     rdx, rax
        shr     rdx, 1                                  
        and     eax, 01H                                
        or      rdx, rax                                
        vcvtsi2sd xmm0, xmm0, rdx            ; Преобразует целое число со знаком из двух слов 
                                             ; (или целое число из четырех слов со знаком, если размер операнда 64 бита)
                                             ; в исходном операнде “преобразовать из” в значение с плавающей запятой 
                                             ; двойной точности в целевом операнде.                             
        vaddsd  xmm0, xmm0, xmm0             ; Добавляет значения с плавающей запятой низкой двойной точности из второго 
                                             ; исходного операнда и первого исходного операнда и сохраняет результат 
                                             ; с плавающей запятой двойной точности в целевом операнде.                            
objectoriented_calculation_2:
        vmovsd  xmm2, qword [rbp-10H]        ; Перемещает значение с плавающей запятой скалярной двойной 
                                             ; точности из исходного операнда (второй операнд) 
                                             ; в операнд назначения (первый операнд).
        vdivsd  xmm0, xmm2, xmm0             ; Делит значение с плавающей запятой низкой двойной точности 
                                             ; в первом исходном операнде на значение с плавающей запятой
                                             ; низкой двойной точности во втором исходном операнде
                                             ; и сохраняет результат с плавающей запятой двойной точности в целевом операнде.                         
        vmovq   rax, xmm0                    ; Копирует четырехсловие из исходного операнда
                                             ; (второй операнд) в операнд назначения (первый операнд).
                                             ; Исходными и целевыми операндами могут быть регистры
                                             ; технологии MMX, регистры XMM или 64-разрядные ячейки памяти.                                 
        vmovq   xmm0, rax                    ; Копирует четырехсловие из исходного операнда
                                             ; (второй операнд) в операнд назначения (первый операнд).
                                             ; Исходными и целевыми операндами могут быть регистры
                                             ; технологии MMX, регистры XMM или 64-разрядные ячейки памяти.                                 
        leave                                           
        ret                                                                                    


language_in:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 32                                 
        mov     qword [rbp-18H], rdi                    
        mov     edi, 32                                 
        call    malloc                                  
        mov     qword [rbp-8H], rax                     
        lea     rax, [rbp-0CH]                          
        mov     rcx, qword [rbp-18H]                    
        mov     rdx, rax                                
        lea     rax, [rel number_format]                        
        mov     rsi, rax                                
        mov     rdi, rcx                                
        mov     eax, 0                                  
        call    __isoc99_fscanf                         
        mov     eax, dword [rbp-0CH]                    
        cmp     eax, 3                                  
        jz      language_in_functional
        cmp     eax, 3                                  
        jg      language_in_end_1
        cmp     eax, 1                                  
        jz      language_in_objectoriented
        cmp     eax, 2                                  
        jz      language_in_procedural
        jmp     language_in_end_1
language_in_objectoriented:
        mov     rax, qword [rbp-8H]
        mov     byte [rax], 1                           
        mov     rax, qword [rbp-8H]                     
        add     rax, 8                                  
        mov     rdx, qword [rbp-18H]                    
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    objectoriented_in                              
        mov     rax, qword [rbp-8H]                     
        jmp     language_in_end_2
language_in_procedural:
        mov     rax, qword [rbp-8H]
        mov     byte [rax], 2                           
        mov     rax, qword [rbp-8H]                     
        add     rax, 8                                  
        mov     rdx, qword [rbp-18H]                    
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    procedural_in                              
        mov     rax, qword [rbp-8H]                     
        jmp     language_in_end_2
language_in_functional:
        mov     rax, qword [rbp-8H]
        mov     byte [rax], 3                           
        mov     rax, qword [rbp-8H]                     
        add     rax, 8                                  
        mov     rdx, qword [rbp-18H]                    
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    functional_in                          
        mov     rax, qword [rbp-8H]                     
        jmp     language_in_end_2
language_in_end_1:
        mov     eax, 0
language_in_end_2:
        leave
        ret                                             


language_in_random:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 16                                 
        mov     edi, 32                                 
        call    malloc                                  
        mov     qword [rbp-8H], rax                     
        mov     esi, 3                                  
        mov     edi, 1                                  
        call    random_int                              
        mov     dword [rbp-0CH], eax                    
        cmp     dword [rbp-0CH], 3                      
        jz      language_rnd_objectoriented
        cmp     dword [rbp-0CH], 3                      
        jg      language_rnd_end
        cmp     dword [rbp-0CH], 1                      
        jz      language_rnd_procedural
        cmp     dword [rbp-0CH], 2                      
        jz      language_rnd_functional
        jmp     language_rnd_end
language_rnd_objectoriented:
        mov     rax, qword [rbp-8H]
        mov     byte [rax], 1                           
        mov     rax, qword [rbp-8H]                     
        add     rax, 8                                  
        mov     rdi, rax                                
        call    objectoriented_inrnd                       
        jmp     language_rnd_end
language_rnd_functional:
        mov     rax, qword [rbp-8H]
        mov     byte [rax], 2                           
        mov     rax, qword [rbp-8H]                     
        add     rax, 8                                  
        mov     rdi, rax                                
        call    functional_inrnd                       
        jmp     language_rnd_end
language_rnd_procedural:
        mov     rax, qword [rbp-8H]
        mov     byte [rax], 3                           
        mov     rax, qword [rbp-8H]                     
        add     rax, 8                                  
        mov     rdi, rax                                
        call    procedural_inrnd                   
        nop                                             
language_rnd_end:
        mov     rax, qword [rbp-8H]
        leave                                           
        ret                                             


language_out:                               ; Вывод
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 16                                 
        mov     qword [rbp-8H], rdi                     
        mov     qword [rbp-10H], rsi                    
        mov     rax, qword [rbp-8H]                     
        movzx   eax, byte [rax]                         
        movsx   eax, al                                 
        cmp     eax, 3                                  
        jz      language_out_procedural         ; Идём к выбранному классу, например к процедурной
        cmp     eax, 3                                  
        jg      language_out_end_1
        cmp     eax, 1                                  
        jz      language_out_functional         ; Или к функциональной
        cmp     eax, 2                                  
        jz      language_out_objectoriented     ; или в ООП
        jmp     language_out_end_1
language_out_functional:
        mov     rax, qword [rbp-8H]
        add     rax, 8                                  
        mov     rdx, qword [rbp-10H]                    
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    functional_out       ; Вызов функции                             
        jmp     language_out_end_2
language_out_objectoriented:
        mov     rax, qword [rbp-8H]
        add     rax, 8                                  
        mov     rdx, qword [rbp-10H]                    
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    objectoriented_out   ; Вызов функции                                
        jmp     language_out_end_2
language_out_procedural:
        mov     rax, qword [rbp-8H]
        add     rax, 8                                  
        mov     rdx, qword [rbp-10H]                    
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    procedural_out   ; Вызов функции                            
        jmp     language_out_end_2
language_out_end_1:  lea     rax, [rel incorrect_language]
        mov     rdi, rax                                
        call    puts                                    
        nop                                             
language_out_end_2:  nop
        leave                                           
        ret                                             


language_calculation:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 16                                 
        mov     qword [rbp-8H], rdi                     
        mov     rax, qword [rbp-8H]                     
        movzx   eax, byte [rax]                         
        movsx   eax, al                                 
        cmp     eax, 3                                  
        jz      language_calc_procedural
        cmp     eax, 3                                  
        jg      language_calculation_end_1
        cmp     eax, 1                                  
        jz      language_calculation_functional
        cmp     eax, 2                                  
        jz      language_calculation_objectoriented
        jmp     language_calculation_end_1
language_calculation_functional:
        mov     rax, qword [rbp-8H]
        add     rax, 8                                  
        mov     rdi, rax                                
        call    functional_calculation                      
        vmovq   rax, xmm0                    ; Копирует четырехсловие из исходного операнда
                                             ; (второй операнд) в операнд назначения (первый операнд).
                                             ; Исходными и целевыми операндами могут быть регистры
                                             ; технологии MMX, регистры XMM или 64-разрядные ячейки памяти.                                 
        jmp     language_calculation_end_2
language_calculation_objectoriented:
        mov     rax, qword [rbp-8H]
        add     rax, 8                                  
        mov     rdi, rax                                
        call    objectoriented_calculation                        
        vmovq   rax, xmm0                    ; Копирует четырехсловие из исходного операнда
                                             ; (второй операнд) в операнд назначения (первый операнд).
                                             ; Исходными и целевыми операндами могут быть регистры
                                             ; технологии MMX, регистры XMM или 64-разрядные ячейки памяти.                                 
        jmp     language_calculation_end_2
language_calc_procedural:
        mov     rax, qword [rbp-8H]
        add     rax, 8                                  
        mov     rdi, rax                                
        call    procedural_calculation                    
        vmovq   rax, xmm0                    ; Копирует четырехсловие из исходного операнда
                                             ; (второй операнд) в операнд назначения (первый операнд).
                                             ; Исходными и целевыми операндами могут быть регистры
                                             ; технологии MMX, регистры XMM или 64-разрядные ячейки памяти.                                 
        jmp     language_calculation_end_2
language_calculation_end_1:
        mov     rax, qword [rel zero]
language_calculation_end_2:
        vmovq   xmm0, rax                    ; Копирует четырехсловие из исходного операнда
                                             ; (второй операнд) в операнд назначения (первый операнд).
                                             ; Исходными и целевыми операндами могут быть регистры
                                             ; технологии MMX, регистры XMM или 64-разрядные ячейки памяти.  
        leave                                           
        ret                                             


container_init:
        push    rbp                                     
        mov     rbp, rsp                                
        mov     qword [rbp-8H], rdi                     
        mov     rax, qword [rbp-8H]                     
        mov     dword [rax], 0                          
        nop                                             
        pop     rbp                                     
        ret                                             


container_clear:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 32                                 
        mov     qword [rbp-18H], rdi                    
        mov     dword [rbp-4H], 0                       
        jmp     container_clear_loop_2
container_clear_loop_1:
        mov     rdx, qword [rbp-18H]
        mov     eax, dword [rbp-4H]                     
        cdqe                                            
        mov     rax, qword [rdx+rax*8+8H]               
        mov     rdi, rax                                
        call    free                                    
        inc     dword [rbp-4H]                          
container_clear_loop_2:
        mov     rax, qword [rbp-18H]
        mov     eax, dword [rax]                        
        cmp     dword [rbp-4H], eax                     
        jl      container_clear_loop_1
        mov     rax, qword [rbp-18H]                    
        mov     dword [rax], 0                          
        nop                                             
        leave                                           
        ret                                             


container_in:
        push    rbp                                     
        mov     rbp, rsp                                
        push    rbx                                     
        sub     rsp, 24                                 
        mov     qword [rbp-18H], rdi                    
        mov     qword [rbp-20H], rsi                    
        jmp     container_in_loop_2
container_in_loop_1:
        mov     rax, qword [rbp-18H]
        mov     ebx, dword [rax]                        
        mov     rax, qword [rbp-20H]                    
        mov     rdi, rax                                
        call    language_in                                
        mov     rcx, qword [rbp-18H]                    
        movsxd  rdx, ebx                                
        mov     qword [rcx+rdx*8+8H], rax               
        mov     rdx, qword [rbp-18H]                    
        movsxd  rax, ebx                                
        mov     rax, qword [rdx+rax*8+8H]               
        test    rax, rax                                
        jz      container_in_loop_2
        mov     rax, qword [rbp-18H]                    
        mov     eax, dword [rax]                        
        lea     edx, [rax+1H]                           
        mov     rax, qword [rbp-18H]                    
        mov     dword [rax], edx                        
container_in_loop_2:
        mov     rax, qword [rbp-20H]
        mov     rdi, rax                                
        call    feof                                    
        test    eax, eax                                
        jz      container_in_loop_1
        nop                                             
        nop                                             
        mov     rbx, qword [rbp-8H]                     
        leave                                           
        ret                                             


container_in_random:
        push    rbp                                     
        mov     rbp, rsp                                
        push    rbx                                     
        sub     rsp, 24                                 
        mov     qword [rbp-18H], rdi                    
        mov     dword [rbp-1CH], esi                    
        jmp     container_in_random_2
container_in_random_1:
        mov     rax, qword [rbp-18H]
        mov     ebx, dword [rax]                        
        mov     eax, 0                                  
        call    language_in_random                         
        mov     rcx, qword [rbp-18H]                    
        movsxd  rdx, ebx                                
        mov     qword [rcx+rdx*8+8H], rax               
        mov     rdx, qword [rbp-18H]                    
        movsxd  rax, ebx                                
        mov     rax, qword [rdx+rax*8+8H]               
        test    rax, rax                                
        jz      container_in_random_2
        mov     rax, qword [rbp-18H]                    
        mov     eax, dword [rax]                        
        lea     edx, [rax+1H]                           
        mov     rax, qword [rbp-18H]                    
        mov     dword [rax], edx                        
container_in_random_2:
        mov     rax, qword [rbp-18H]
        mov     eax, dword [rax]                        
        cmp     dword [rbp-1CH], eax                    
        jg      container_in_random_1
        nop                                             
        nop                                             
        mov     rbx, qword [rbp-8H]                     
        leave                                           
        ret                                             


container_out:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 32                                 
        mov     qword [rbp-18H], rdi                    
        mov     qword [rbp-20H], rsi                    
        mov     rax, qword [rbp-18H]                    
        mov     edx, dword [rax]                        
        mov     rax, qword [rbp-20H]                    
        lea     rcx, [rel container_contains_string]                        
        mov     rsi, rcx                                
        mov     rdi, rax                                
        mov     eax, 0                                  
        call    fprintf                                 
        mov     dword [rbp-4H], 0                       
        jmp     container_out_1
container_out_2:
        mov     eax, dword [rbp-4H]
        lea     edx, [rax+1H]                           
        mov     rax, qword [rbp-20H]                    
        lea     rcx, [rel number_format_with_colon]                        
        mov     rsi, rcx                                
        mov     rdi, rax                                
        mov     eax, 0                                  
        call    fprintf                                 
        mov     rdx, qword [rbp-18H]                    
        mov     eax, dword [rbp-4H]                     
        cdqe                                            
        mov     rax, qword [rdx+rax*8+8H]               
        mov     rdx, qword [rbp-20H]                    
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    language_out                               
        inc     dword [rbp-4H]                          
container_out_1:
        mov     rax, qword [rbp-18H]
        mov     eax, dword [rax]                        
        cmp     dword [rbp-4H], eax                     
        jl      container_out_2
        nop                                             
        nop                                             
        leave                                           
        ret                                             


container_straigh_sort:
        push    rbp                                     
        mov     rbp, rsp                                
        push    rbx                                     
        sub     rsp, 72                                 
        mov     qword [rbp-48H], rdi                    
        mov     rax, qword [rbp-48H]                    
        mov     eax, dword [rax]                        
        dec     eax                                     
        mov     dword [rbp-14H], eax                    
        mov     dword [rbp-18H], 0                      
        mov     rax, qword [rbp-48H]                    
        mov     eax, dword [rax]                        
        dec     eax                                     
        mov     dword [rbp-1CH], eax                    
container_straigh_sort_loop_1:
        mov     eax, dword [rbp-18H]
        mov     dword [rbp-20H], eax                    
        jmp     container_straigh_sort_loop_4
container_straigh_sort_loop_2:
        mov     rdx, qword [rbp-48H]
        mov     eax, dword [rbp-20H]                    
        cdqe                                            
        mov     rax, qword [rdx+rax*8+8H]               
        mov     rdi, rax                                
        call    language_calculation                          
        vmovq   rbx, xmm0                    ; Копирует четырехсловие из исходного операнда
                                             ; (второй операнд) в операнд назначения (первый операнд).
                                             ; Исходными и целевыми операндами могут быть регистры
                                             ; технологии MMX, регистры XMM или 64-разрядные ячейки памяти.                                 
        mov     eax, dword [rbp-20H]                    
        inc     eax                                     
        mov     rdx, qword [rbp-48H]                    
        cdqe                                            
        mov     rax, qword [rdx+rax*8+8H]               
        mov     rdi, rax                                
        call    language_calculation                          
        vmovq   rax, xmm0                    ; Копирует четырехсловие из исходного операнда
                                             ; (второй операнд) в операнд назначения (первый операнд).
                                             ; Исходными и целевыми операндами могут быть регистры
                                             ; технологии MMX, регистры XMM или 64-разрядные ячейки памяти.                                 
        vmovq   xmm1, rbx                               
        vmovq   xmm2, rax                               
        vcomisd xmm1, xmm2                      ; Сравнивает значения с плавающей запятой двойной точности в 
                                                ; младших четырехсловиях операнда 1 (первый операнд) и 
                                                ; операнда 2 (второй операнд) и устанавливает флаги ZF, PF и CF 
                                                ; в регистре EFLAGS в соответствии с результатом 
                                                ; (неупорядоченный, больше, меньше или равен)                              
        jbe     container_straigh_sort_loop_3
        mov     rdx, qword [rbp-48H]                    
        mov     eax, dword [rbp-20H]                    
        cdqe                                            
        mov     rax, qword [rdx+rax*8+8H]               
        mov     qword [rbp-38H], rax                    
        mov     eax, dword [rbp-20H]                    
        inc     eax                                     
        mov     rdx, qword [rbp-48H]                    
        cdqe                                            
        mov     rcx, qword [rdx+rax*8+8H]               
        mov     rdx, qword [rbp-48H]                    
        mov     eax, dword [rbp-20H]                    
        cdqe                                            
        mov     qword [rdx+rax*8+8H], rcx               
        mov     eax, dword [rbp-20H]                    
        inc     eax                                     
        mov     rdx, qword [rbp-48H]                    
        cdqe                                            
        mov     rcx, qword [rbp-38H]                    
        mov     qword [rdx+rax*8+8H], rcx               
        mov     eax, dword [rbp-20H]                    
        mov     dword [rbp-14H], eax                    
container_straigh_sort_loop_3:
        inc     dword [rbp-20H]
container_straigh_sort_loop_4:
        mov     eax, dword [rbp-20H]
        cmp     eax, dword [rbp-1CH]                    
        jl      container_straigh_sort_loop_2
        mov     eax, dword [rbp-14H]                    
        mov     dword [rbp-1CH], eax                    
        mov     eax, dword [rbp-1CH]                    
        mov     dword [rbp-24H], eax                    
        jmp     container_straigh_sort_loop_7
container_straigh_sort_loop_5:
        mov     rdx, qword [rbp-48H]
        mov     eax, dword [rbp-24H]                    
        cdqe                                            
        mov     rax, qword [rdx+rax*8+8H]               
        mov     rdi, rax                                
        call    language_calculation                          
        vmovq   rbx, xmm0                    ; Копирует четырехсловие из исходного операнда
                                             ; (второй операнд) в операнд назначения (первый операнд).
                                             ; Исходными и целевыми операндами могут быть регистры
                                             ; технологии MMX, регистры XMM или 64-разрядные ячейки памяти.                                 
        mov     eax, dword [rbp-24H]                    
        dec     eax                                     
        mov     rdx, qword [rbp-48H]                    
        cdqe                                            
        mov     rax, qword [rdx+rax*8+8H]               
        mov     rdi, rax                                
        call    language_calculation                          
        vmovq   rax, xmm0                    ; Копирует четырехсловие из исходного операнда
                                             ; (второй операнд) в операнд назначения (первый операнд).
                                             ; Исходными и целевыми операндами могут быть регистры
                                             ; технологии MMX, регистры XMM или 64-разрядные ячейки памяти.                                 
        vmovq   xmm3, rax                               
        vmovq   xmm4, rbx                               
        vcomisd xmm3, xmm4                      ; Сравнивает значения с плавающей запятой двойной точности в 
                                                ; младших четырехсловиях операнда 1 (первый операнд) и 
                                                ; операнда 2 (второй операнд) и устанавливает флаги ZF, PF и CF 
                                                ; в регистре EFLAGS в соответствии с результатом 
                                                ; (неупорядоченный, больше, меньше или равен)                                
        jbe     container_straigh_sort_loop_6
        mov     rdx, qword [rbp-48H]                    
        mov     eax, dword [rbp-24H]                    
        cdqe                                            
        mov     rax, qword [rdx+rax*8+8H]               
        mov     qword [rbp-30H], rax                    
        mov     eax, dword [rbp-24H]                    
        dec     eax                                     
        mov     rdx, qword [rbp-48H]                    
        cdqe                                            
        mov     rcx, qword [rdx+rax*8+8H]               
        mov     rdx, qword [rbp-48H]                    
        mov     eax, dword [rbp-24H]                    
        cdqe                                            
        mov     qword [rdx+rax*8+8H], rcx               
        mov     eax, dword [rbp-24H]                    
        dec     eax                                     
        mov     rdx, qword [rbp-48H]                    
        cdqe                                            
        mov     rcx, qword [rbp-30H]                    
        mov     qword [rdx+rax*8+8H], rcx               
        mov     eax, dword [rbp-24H]                    
        mov     dword [rbp-14H], eax                    
container_straigh_sort_loop_6:
        dec     dword [rbp-24H]
container_straigh_sort_loop_7:
        mov     eax, dword [rbp-24H]
        cmp     eax, dword [rbp-18H]                    
        jg      container_straigh_sort_loop_5
        mov     eax, dword [rbp-14H]                    
        mov     dword [rbp-18H], eax                    
        mov     eax, dword [rbp-18H]                    
        cmp     eax, dword [rbp-1CH]                    
        jl      container_straigh_sort_loop_1
        nop                                             
        nop                                             
        mov     rbx, qword [rbp-8H]                     
        leave                                           
        ret                                             


incorrect_command_line:
        push    rbp                                     
        mov     rbp, rsp                                
        lea     rax, [rel incorrect_command_line_string]                        
        mov     rdi, rax                                
        call    puts                                    
        nop                                             
        pop     rbp                                     
        ret                                             


incorrect_qualifier_value:
        push    rbp                                     
        mov     rbp, rsp                                
        lea     rax, [rel incorrect_qualifier_value_string]                        
        mov     rdi, rax                                
        call    puts                                    
        nop                                             
        pop     rbp                                     
        ret                                             


incorrect_number_of_items:
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 16                                 
        mov     dword [rbp-4H], edi                     
        mov     eax, dword [rbp-4H]                     
        mov     esi, eax                                
        lea     rax, [rel incorrect_number_of_items_string]                        
        mov     rdi, rax                                
        mov     eax, 0                                  
        call    printf                                  
        nop                                             
        leave                                           
        ret                                             


incorrect_files:
        push    rbp                                     
        mov     rbp, rsp                                
        lea     rax, [rel incorrect_files_string]                        
        mov     rdi, rax                                
        mov     eax, 0                                  
        call    printf                                  
        nop                                             
        pop     rbp                                     
        ret                                             


main:   
        push    rbp                                     
        mov     rbp, rsp                                
        sub     rsp, 80096                              
        mov     dword [rbp-138D4H], edi                 
        mov     qword [rbp-138E0H], rsi                 
        mov     edi, 0                                  
        call    time                                    
        mov     edi, eax                                
        call    srand                                   
        mov     rax, qword [rbp-138E0H]                 
        mov     rax, qword [rax+8H]                     
        mov     qword [rbp-8H], rax                     
        mov     rax, qword [rbp-138E0H]                 
        mov     rax, qword [rax+10H]                    
        mov     qword [rbp-10H], rax                    
        mov     rax, qword [rbp-138E0H]                 
        mov     rax, qword [rax+18H]                    
        mov     qword [rbp-18H], rax                    
        mov     rax, qword [rbp-138E0H]                 
        mov     rax, qword [rax+20H]                    
        mov     qword [rbp-20H], rax                    
        cmp     dword [rbp-138D4H], 5                   
        jz      start_case
        mov     eax, 0                                  
        call    incorrect_command_line                  
        mov     edi, 1                                  
        call    exit                                    
start_case:
        lea     rax, [rel start]
        mov     rdi, rax                                
        call    puts                                    
        lea     rax, [rbp-138D0H]                       
        mov     edx, 80008                              
        mov     esi, 0                                  
        mov     rdi, rax                                
        call    memset                                  
        lea     rax, [rbp-138D0H]                       
        mov     rdi, rax                                
        call    container_init                          
        mov     rax, qword [rbp-8H]                     
        lea     rdx, [rel file_qualifier]                        
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    strcmp                                  
        test    eax, eax                                
        jnz     number_qualifier_case
        mov     rax, qword [rbp-10H]                    
        lea     rdx, [rel read_write_access]                        
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    fopen                                   
        mov     qword [rbp-30H], rax                    
        mov     rdx, qword [rbp-30H]                    
        lea     rax, [rbp-138D0H]                       
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    container_in                            
        mov     rax, qword [rbp-30H]                    
        mov     rdi, rax                                
        call    fclose                                  
        jmp     open_files
number_qualifier_case:
        mov     rax, qword [rbp-8H]
        lea     rdx, [rel number_qualifier]                        
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    strcmp                                  
        test    eax, eax                                
        jnz     incorrect_qualifier_value_case
        mov     rax, qword [rbp-10H]                    
        mov     rdi, rax                                
        call    atoi                                    
        mov     dword [rbp-24H], eax                    
        cmp     dword [rbp-24H], 0                      
        jle     incorrect_number_of_items_case
        cmp     dword [rbp-24H], 10000                  
        jle     in_random_case
incorrect_number_of_items_case:
        mov     eax, dword [rbp-24H]
        mov     edi, eax                                
        call    incorrect_number_of_items               
        mov     edi, 3                                  
        call    exit                                    
in_random_case:  mov     edx, dword [rbp-24H]
        lea     rax, [rbp-138D0H]                       
        mov     esi, edx                                
        mov     rdi, rax                                
        call    container_in_random                     
        jmp     open_files
incorrect_qualifier_value_case:
        mov     eax, 0
        call    incorrect_qualifier_value               
        mov     edi, 2                                  
        call    exit                                    
open_files:
        mov     rax, qword [rbp-18H]
        lea     rdx, [rel write_plus_access]                        
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    fopen                                   
        mov     qword [rbp-38H], rax                    
        mov     rax, qword [rbp-20H]                    
        lea     rdx, [rel write_plus_access]                        
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    fopen                                   
        mov     qword [rbp-40H], rax                    
        cmp     qword [rbp-38H], 0                      
        jz      incorrect_files_case
        cmp     qword [rbp-40H], 0                      
        jnz     output_container_end
incorrect_files_case:
        mov     eax, 0
        call    incorrect_files                         
        mov     edi, 4                                  
        call    exit                                    
output_container_end:
        mov     rax, qword [rbp-38H]
        mov     rcx, rax                                
        mov     edx, 17                                 
        mov     esi, 1                                  
        lea     rax, [rel container_input]                        
        mov     rdi, rax                                
        call    fwrite                                  
        mov     rdx, qword [rbp-38H]                    
        lea     rax, [rbp-138D0H]                       
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    container_out                           
        lea     rax, [rbp-138D0H]                       
        mov     rdi, rax                                
        call    container_straigh_sort                    
        mov     rax, qword [rbp-40H]                    
        mov     rcx, rax                                
        mov     edx, 30                                 
        mov     esi, 1                                  
        lea     rax, [rel container_sorted]                        
        mov     rdi, rax                                
        call    fwrite                                  
        mov     rdx, qword [rbp-40H]                    
        lea     rax, [rbp-138D0H]                       
        mov     rsi, rdx                                
        mov     rdi, rax                                
        call    container_out                           
        lea     rax, [rbp-138D0H]                       
        mov     rdi, rax                                
        call    container_clear                         
        mov     rax, qword [rbp-38H]                    
        mov     rdi, rax                                
        call    fclose                                  
        mov     rax, qword [rbp-40H]                    
        mov     rdi, rax                                
        call    fclose                                  
        lea     rax, [rel stop]                        
        mov     rdi, rax                                
        call    puts                                    
        mov     edi, 0                                  

        call    exit

SECTION .rodata

procedural_output: db "This is Procedural: name = %s, year = %d, popularity = %d", 10, 0
objectoriented_output: db "This is Object Oriented: name = %s, year = %d, type = %s", 10, 0
functional_output: db "This is Functional: name = %s, year = %d, type = %s", 10, 0
dynamic_lw: db "dynamic", 0
strict_lw: db "strict", 0
error_lw: db "error", 0
dynamic_up: db "DYNAMIC", 0
strict_up: db "STRICT", 0
error_up: db "ERROR", 0
single_lw: db "single", 0
interface_lw: db "interface", 0
multiple_lw: db "multiple", 0
single_up: db "SINGLE", 0
interface_up: db "INTERFACE", 0
multiple_up: db "MULTIPLE", 0
number_format: db "%d", 0
number_format_with_colon: db "%d: ", 0
incorrect_language: db "Language error! Incorrect input!", 10, 0
container_contains_string: db "Container contains %d elements.", 10, 0
incorrect_command_line_string: db "incorrect command line!", 10, "  Waited:", 10, "     command -f infile outfile01 outfile02", 10, "  Or:", 10, "     command -n number outfile01 outfile02", 10, 0
incorrect_qualifier_value_string: db "incorrect qualifier value!", 10, "  Waited:", 10, "     command -f infile outfile01 outfile02", 10, "  Or:", 10, "     command -n number outfile01 outfile02", 10, 0
incorrect_number_of_items_string: db "incorrect number of items = %d. Set 0 < number <= 10000", 10, 0
incorrect_files_string: db "passed files not found (or broken)", 10, 0
start: db "Start", 0
stop: db "Stop", 0
file_qualifier: db "-f", 0
number_qualifier: db "-n", 0
read_write_access: db "rw", 0
write_plus_access: db "w+", 0
container_input: db "Input container:", 10, 0
container_sorted: db "Sorted container (ascending):", 10, 0
alphabet: db "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", 0
zero:  dq 0