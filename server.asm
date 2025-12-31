; Простейший HTTP сервер на x86-64 ассемблере для Linux
; Отвечает на GET запросы простым "Hello World"

section .data
    ; HTTP ответ с HTML страницей
    ; Content-Length: 1234 (будет вычислено автоматически)
    response db "HTTP/1.1 200 OK", 13, 10
             db "Content-Type: text/html; charset=utf-8", 13, 10
             db "Content-Length: 2286", 13, 10
             db "Connection: close", 13, 10
             db 13, 10
             db "<!DOCTYPE html>", 10
             db "<html lang='en'>", 10
             db "<head>", 10
             db "  <meta charset='UTF-8'>", 10
             db "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>", 10
             db "  <title>Assembly Web Server</title>", 10
             db "  <style>", 10
             db "    body { font-family: 'Courier New', monospace; background: #1e1e1e; color: #d4d4d4; padding: 40px; line-height: 1.6; }", 10
             db "    .container { max-width: 800px; margin: 0 auto; }", 10
             db "    h1 { color: #4ec9b0; border-bottom: 2px solid #4ec9b0; padding-bottom: 10px; }", 10
             db "    h2 { color: #569cd6; margin-top: 30px; }", 10
             db "    .tech { background: #252526; padding: 15px; margin: 10px 0; border-left: 4px solid #4ec9b0; border-radius: 4px; }", 10
             db "    .tech-name { color: #ce9178; font-weight: bold; }", 10
             db "    .footer { margin-top: 40px; text-align: center; color: #858585; font-size: 0.9em; }", 10
             db "    a { color: #569cd6; text-decoration: none; }", 10
             db "    a:hover { text-decoration: underline; color: #4ec9b0; }", 10
             db "    strong { color: #4ec9b0; }", 10
             db "  </style>", 10
             db "</head>", 10
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
             db "      <span class='tech-name'>Docker Image:</span> 11.7kB<br>", 10
             db "      <span class='tech-name'>Binary:</span> 11.4KB (11664 bytes, of which 2kB is the HTML page)", 10
             db "    </div>", 10
             db "    <div class='footer'>", 10
             db "      <p>No frameworks. No libraries. Just pure assembly and syscalls.</p>", 10
             db "      <p><a href='https://github.com/Serabass/ASM-Server' target='_blank'>View on GitHub</a></p>", 10
             db "    </div>", 10
             db "  </div>", 10
             db "</body>", 10
             db "</html>", 10
    response_len equ $ - response
    
    ; Сообщения для отладки
    bind_msg db "Binding to port 8080...", 10
    bind_msg_len equ $ - bind_msg
    
    listen_msg db "Listening for connections...", 10
    listen_msg_len equ $ - listen_msg
    
    accept_msg db "Connection accepted!", 10
    accept_msg_len equ $ - accept_msg

section .bss
    sockfd resq 1
    clientfd resq 1
    buffer resb 4096

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
    
    ; Выводим сообщение о привязке
    mov rax, 1            ; sys_write
    mov rdi, 1            ; stdout
    mov rsi, bind_msg
    mov rdx, bind_msg_len
    syscall
    
    ; Начинаем слушать
    mov rax, 50           ; sys_listen
    mov rdi, [sockfd]
    mov rsi, 5            ; backlog
    syscall
    
    ; Выводим сообщение о прослушивании
    mov rax, 1            ; sys_write
    mov rdi, 1            ; stdout
    mov rsi, listen_msg
    mov rdx, listen_msg_len
    syscall

accept_loop:
    ; Принимаем соединение
    mov rax, 43           ; sys_accept
    mov rdi, [sockfd]
    mov rsi, 0            ; NULL для адреса клиента
    mov rdx, 0            ; NULL для размера
    syscall
    mov [clientfd], rax
    
    ; Выводим сообщение о принятии соединения
    mov rax, 1            ; sys_write
    mov rdi, 1            ; stdout
    mov rsi, accept_msg
    mov rdx, accept_msg_len
    syscall
    
    ; Читаем запрос (просто чтобы очистить буфер)
    mov rax, 0            ; sys_read
    mov rdi, [clientfd]
    mov rsi, buffer
    mov rdx, 4096
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

