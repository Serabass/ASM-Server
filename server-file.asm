; HTTP сервер на x86-64 ассемблере для Linux
; HTML страница читается с диска из файла /page.html во время выполнения

section .data
    html_file db "/page.html", 0
    
    ; HTTP заголовки (Content-Length будет добавлен динамически)
    http_header1 db "HTTP/1.1 200 OK", 13, 10
                 db "Content-Type: text/html; charset=utf-8", 13, 10
                 db "Content-Length: "
    content_len_str resb 12
    http_header2 db 13, 10
                 db "Connection: close", 13, 10
                 db 13, 10

section .bss
    sockfd resq 1
    clientfd resq 1
    htmlfd resq 1
    buffer resb 1024
    html_buffer resb 8192
    html_size resq 1

section .text
    global _start

; Преобразование числа в строку
; rdi = число, возвращает длину в rdx, указатель в rax
itoa:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    push rbx
    push r12
    
    mov rax, rdi
    mov rbx, 10
    mov r12, rsp
    add r12, 31
    mov byte [r12], 0
    
    cmp rax, 0
    je .zero
    
.loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec r12
    mov [r12], dl
    test rax, rax
    jnz .loop
    
    mov rax, r12
    mov rdx, rsp
    add rdx, 32
    sub rdx, r12
    jmp .done
    
.zero:
    dec r12
    mov byte [r12], '0'
    mov rax, r12
    mov rdx, 1
    
.done:
    pop r12
    pop rbx
    add rsp, 32
    pop rbp
    ret

_start:
    ; socket
    mov rax, 41
    mov rdi, 2
    mov rsi, 1
    mov rdx, 0
    syscall
    mov [sockfd], rax
    
    ; setsockopt
    mov rax, 54
    mov rdi, [sockfd]
    mov rsi, 1
    mov rdx, 2
    mov r10, 1
    mov r8, 4
    syscall
    
    ; sockaddr_in
    push 0
    push 0
    push word 0x901f
    push word 2
    mov rbp, rsp
    
    ; bind
    mov rax, 49
    mov rdi, [sockfd]
    mov rsi, rbp
    mov rdx, 16
    syscall
    
    ; listen
    mov rax, 50
    mov rdi, [sockfd]
    mov rsi, 5
    syscall

accept_loop:
    ; accept
    mov rax, 43
    mov rdi, [sockfd]
    mov rsi, 0
    mov rdx, 0
    syscall
    mov [clientfd], rax
    
    ; read request
    mov rax, 0
    mov rdi, [clientfd]
    mov rsi, buffer
    mov rdx, 1024
    syscall
    
    ; open HTML file
    mov rax, 2
    mov rdi, html_file
    mov rsi, 0
    mov rdx, 0
    syscall
    mov [htmlfd], rax
    
    cmp rax, 0
    jl .error
    
    ; read HTML file
    mov rax, 0
    mov rdi, [htmlfd]
    mov rsi, html_buffer
    mov rdx, 8192
    syscall
    mov [html_size], rax
    
    ; close HTML file
    mov rax, 3
    mov rdi, [htmlfd]
    syscall
    
    ; format Content-Length
    mov rdi, [html_size]
    call itoa
    ; rax = pointer, rdx = length
    mov r15, rdx          ; сохраняем длину
    
    ; copy to content_len_str
    mov rdi, content_len_str
    mov rsi, rax
    mov rcx, r15
    rep movsb
    
    ; send header part 1
    mov rax, 1
    mov rdi, [clientfd]
    mov rsi, http_header1
    mov rdx, content_len_str - http_header1
    syscall
    
    ; send Content-Length
    mov rax, 1
    mov rdi, [clientfd]
    mov rsi, content_len_str
    mov rdx, r15          ; длина из сохранённого значения
    syscall
    
    ; send header part 2 (CRLF + "Connection: close" + CRLF + CRLF = 22 байта)
    mov rax, 1
    mov rdi, [clientfd]
    mov rsi, http_header2
    mov rdx, 22
    syscall
    
    ; send HTML
    mov rax, 1
    mov rdi, [clientfd]
    mov rsi, html_buffer
    mov rdx, [html_size]
    syscall
    
    jmp .close
    
.error:
    mov rax, 1
    mov rdi, [clientfd]
    mov rsi, error_msg
    mov rdx, error_len
    syscall
    
.close:
    mov rax, 3
    mov rdi, [clientfd]
    syscall
    
    jmp accept_loop

section .data
error_msg db "HTTP/1.1 500 Internal Server Error", 13, 10, 13, 10
error_len equ $ - error_msg
