; Простейший HTTP сервер на x86-64 ассемблере для Linux
; Отвечает на GET запросы простым "Hello World"

section .data
    ; HTTP ответ с HTML страницей
    ; Content-Length: 1234 (будет вычислено автоматически)
    response db "HTTP/1.1 200 OK", 13, 10
             db "Content-Type: text/html; charset=utf-8", 13, 10
             db "Content-Length: 2714", 13, 10
             db "Connection: close", 13, 10
             db 13, 10
             db "<!DOCTYPE html>", 10
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
    response_len equ $ - response

section .bss
    sockfd resq 1
    clientfd resq 1
    buffer resb 1024

section .text
    global _start

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
    
    ; Читаем запрос (просто чтобы очистить буфер)
    mov rax, 0            ; sys_read
    mov rdi, [clientfd]
    mov rsi, buffer
    mov rdx, 1024
    syscall
    
    ; Отправляем ответ
    mov rax, 1            ; sys_write
    mov rdi, [clientfd]
    mov rsi, response
    mov rdx, response_len
    syscall
    
    ; Закрываем соединение с клиентом
    mov rax, 3            ; sys_close
    mov rdi, [clientfd]
    syscall
    
    ; Возвращаемся к ожиданию следующего соединения
    jmp accept_loop

