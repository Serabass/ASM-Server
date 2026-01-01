; Простейший HTTP сервер на x86-64 ассемблере для Linux
; Отвечает на GET запросы простым "Hello World"

section .data
    ; HTTP заголовки (Content-Length будет добавлен динамически)
    http_header1 db "HTTP/1.1 200 OK", 13, 10
                 db "Content-Type: text/html; charset=utf-8", 13, 10
                 db "Content-Length: "
    content_len_str times 12 db 0
    http_header2 db 13, 10
                 db "Connection: close", 13, 10
                 db 13, 10
    
    ; HTML тело страницы
    html_body db "<!DOCTYPE html>", 10
             db "<html lang='en'>", 10
             db "", 10
             db "<head>", 10
             db "  <meta charset='UTF-8'>", 10
             db "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>", 10
             db "  <title>Assembly Web Server</title>", 10
             db "  <style>", 10
             db "    body {", 10
             db "      font-family: 'Courier New', monospace;", 10
             db "      background: #1e1e1e;", 10
             db "      color: #d4d4d4;", 10
             db "      padding: 40px;", 10
             db "      line-height: 1.6;", 10
             db "    }", 10
             db "", 10
             db "    .container {", 10
             db "      max-width: 800px;", 10
             db "      margin: 0 auto;", 10
             db "    }", 10
             db "", 10
             db "    h1 {", 10
             db "      color: #4ec9b0;", 10
             db "      border-bottom: 2px solid #4ec9b0;", 10
             db "      padding-bottom: 10px;", 10
             db "    }", 10
             db "", 10
             db "    h2 {", 10
             db "      color: #569cd6;", 10
             db "      margin-top: 30px;", 10
             db "    }", 10
             db "", 10
             db "    .tech {", 10
             db "      background: #252526;", 10
             db "      padding: 15px;", 10
             db "      margin: 10px 0;", 10
             db "      border-left: 4px solid #4ec9b0;", 10
             db "      border-radius: 4px;", 10
             db "    }", 10
             db "", 10
             db "    .tech-name {", 10
             db "      color: #ce9178;", 10
             db "      font-weight: bold;", 10
             db "    }", 10
             db "", 10
             db "    .footer {", 10
             db "      margin-top: 40px;", 10
             db "      text-align: center;", 10
             db "      color: #858585;", 10
             db "      font-size: 0.9em;", 10
             db "    }", 10
             db "", 10
             db "    a {", 10
             db "      color: #569cd6;", 10
             db "      text-decoration: none;", 10
             db "    }", 10
             db "", 10
             db "    a:hover {", 10
             db "      text-decoration: underline;", 10
             db "      color: #4ec9b0;", 10
             db "    }", 10
             db "", 10
             db "    strong {", 10
             db "      color: #4ec9b0;", 10
             db "    }", 10
             db "  </style>", 10
             db "</head>", 10
             db "", 10
             db "<body>", 10
             db "  <div class='container'>", 10
             db "    <h1>Assembly Web Server</h1>", 10
             db "    <p>This application is written in <strong>x86-64 Assembly</strong> language.</p>", 10
             db "    <h2>Technologies Used:</h2>", 10
             db "    <div class='tech'>", 10
             db "      <span class='tech-name'>x86-64 Assembly</span> - Low-level system programming", 10
             db "    </div>", 10
             db "    <div class='tech'>", 10
             db "      <span class='tech-name'>NASM</span> (Netwide Assembler) - Assembler for x86 architecture", 10
             db "    </div>", 10
             db "    <div class='tech'>", 10
             db "      <span class='tech-name'>Linux System Calls</span> - Direct kernel interface (socket, bind, listen, accept)", 10
             db "    </div>", 10
             db "    <div class='tech'>", 10
             db "      <span class='tech-name'>Docker</span> - Containerization platform", 10
             db "    </div>", 10
             db "    <div class='tech'>", 10
             db "      <span class='tech-name'>Docker Scratch</span> - Empty base image (no OS)", 10
             db "    </div>", 10
             db "    <div class='tech'>", 10
             db "      <span class='tech-name'>Kubernetes</span> - Container orchestration (deployment ready)", 10
             db "    </div>", 10
             db "    <h2>Size Information:</h2>", 10
             db "    <div class='tech'>", 10
             db "      <span class='tech-name'>Docker Image:</span> 11.2kB<br>", 10
             db "      <span class='tech-name'>Binary:</span> 10.9KB (11152 bytes, of which ~2.7kB is the HTML page)", 10
             db "    </div>", 10
             db "    <div class='footer'>", 10
             db "      <p>No frameworks. No libraries. Just pure assembly and syscalls.</p>", 10
             db "      <p><a href='https://github.com/Serabass/ASM-Server' target='_blank'>View on GitHub</a></p>", 10
             db "    </div>", 10
             db "  </div>", 10
             db "</body>", 10
             db "", 10
             db "</html>", 10
    html_body_len equ $ - html_body
    
    error_msg db "HTTP/1.1 500 Internal Server Error", 13, 10, 13, 10
    error_len equ $ - error_msg

section .bss
    sockfd resq 1
    clientfd resq 1
    buffer resb 1024

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
    dec rdx              ; exclude null terminator from length
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
    ; Создаём сокет
    mov rax, 41          ; sys_socket
    mov rdi, 2            ; AF_INET
    mov rsi, 1            ; SOCK_STREAM
    mov rdx, 0            ; protocol
    syscall
    mov [sockfd], rax
    
    ; Настраиваем опции сокета (SO_REUSEADDR)
    mov rax, 54           ; sys_setsockopt
    mov rdi, [sockfd]
    mov rsi, 1            ; SOL_SOCKET
    mov rdx, 2            ; SO_REUSEADDR
    mov r10, 1
    mov r8, 4
    syscall
    
    ; Создаём структуру sockaddr_in
    push 0                ; sin_zero (8 bytes)
    push 0
    push word 0x901f      ; port 8080 в network byte order (0x1f90 = 8080)
    push word 2           ; AF_INET
    mov rbp, rsp          ; сохраняем указатель на структуру
    
    ; Привязываем сокет
    mov rax, 49           ; sys_bind
    mov rdi, [sockfd]
    mov rsi, rbp          ; указатель на sockaddr
    mov rdx, 16           ; размер sockaddr_in
    syscall
    
    ; Начинаем слушать
    mov rax, 50           ; sys_listen
    mov rdi, [sockfd]
    mov rsi, 5            ; backlog
    syscall

accept_loop:
    ; Принимаем соединение
    mov rax, 43           ; sys_accept
    mov rdi, [sockfd]
    mov rsi, 0            ; NULL для адреса клиента
    mov rdx, 0            ; NULL для размера
    syscall
    mov [clientfd], rax
    
    ; Проверяем ошибку accept
    cmp rax, 0
    jl accept_loop        ; если ошибка, пропускаем это соединение
    
    ; Читаем запрос (просто чтобы очистить буфер)
    mov rax, 0            ; sys_read
    mov rdi, [clientfd]
    mov rsi, buffer
    mov rdx, 1024
    syscall
    
    ; Проверяем ошибку read (rax < 0)
    cmp rax, 0
    jl .error_close
    
    ; format Content-Length
    mov rdi, html_body_len
    call itoa
    ; rax = pointer, rdx = length
    mov r14, rax          ; сохраняем указатель на строку
    mov r15, rdx          ; сохраняем длину
    
    ; send header part 1: "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: "
    mov rax, 1
    mov rdi, [clientfd]
    mov rsi, http_header1
    mov rdx, content_len_str - http_header1
    syscall
    
    ; send Content-Length number (exact length, no null bytes)
    mov rax, 1
    mov rdi, [clientfd]
    mov rsi, r14          ; pointer to number string
    mov rdx, r15          ; exact length of number
    syscall
    
    ; send header part 2: "\r\nConnection: close\r\n\r\n" (23 bytes: CRLF + "Connection: close" + CRLF + CRLF)
    mov rax, 1
    mov rdi, [clientfd]
    mov rsi, http_header2
    mov rdx, 23
    syscall
    
    ; send HTML body
    mov rax, 1
    mov rdi, [clientfd]
    mov rsi, html_body
    mov rdx, html_body_len
    syscall
    
    ; Проверяем ошибку write (rax < 0)
    cmp rax, 0
    jl .error_close
    
    ; Закрываем соединение с клиентом
    mov rax, 3            ; sys_close
    mov rdi, [clientfd]
    syscall
    
    ; Возвращаемся к ожиданию следующего соединения
    jmp accept_loop

.error_close:
    ; Отправляем ошибку клиенту
    mov rax, 1
    mov rdi, [clientfd]
    mov rsi, error_msg
    mov rdx, error_len
    syscall
    
    ; Закрываем соединение
    mov rax, 3            ; sys_close
    mov rdi, [clientfd]
    syscall
    
    ; Возвращаемся к ожиданию следующего соединения
    jmp accept_loop

