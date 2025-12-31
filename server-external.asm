; HTTP сервер на x86-64 ассемблере для Linux
; HTML страница вынесена в отдельный файл page.html

section .data
    ; HTTP ответ с HTML страницей
    response_header db "HTTP/1.1 200 OK", 13, 10
                    db "Content-Type: text/html; charset=utf-8", 13, 10
                    db "Content-Length: 2343", 13, 10
                    db "Connection: close", 13, 10
                    db 13, 10
    header_len equ $ - response_header
    
    ; HTML страница включается из внешнего файла
    html_page: incbin "page.html"
    html_page_len equ $ - html_page
    
    response_len equ $ - response_header

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
    
    ; Отправляем полный ответ (заголовки + HTML)
    mov rax, 1            ; sys_write
    mov rdi, [clientfd]
    mov rsi, response_header
    mov rdx, response_len
    syscall
    
    ; Закрываем соединение с клиентом
    mov rax, 3            ; sys_close
    mov rdi, [clientfd]
    syscall
    
    ; Возвращаемся к ожиданию следующего соединения
    jmp accept_loop
