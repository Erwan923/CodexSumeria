;------------------------------------------------------------
; Introduction au langage assembleur et aux microprocesseurs
; 
; Auteur: Erwan Billard
;
; Source: https://syscalls.w3challs.com/?arch=x86
;------------------------------------------------------------


;SECTION .DATA
;Définition de la section contenant les données initialisées et les constantes: la section .DATA
section .data
    msg: db "Enter a password: ", 0x0A     ; Insertion de plusieurs octets avec le message
    ok: db "Your password is good", 0x0A   ; Insertion de plusieurs octets avec l'entrée de l'utilisateur
    errorShortMsg: db "Password is too short, need to be more than 18", 0x0A ; Insertion de plusieurs octets Message d'erreur dnas le cas ou le message est inférieur à 18
    errorLongMsg: db "Password is too long, need to be less than 21", 0x0A ; Insertion de plusieurs octets Message d'erreur dnas le cas ou le message est supérieur à 21
    errorAsciiMsg: db "Password need to contain only letter", 0x0A ; Insertion de plusieurs octets Message d'erreur si le message contient des chiffres
    wrongPasswordMsg: db "wrong Password" ; Affichage du message d'erreur pour le mauvais mot de passe
    matchingPasswordMsg: db "matching Password" ;Si le mot de passe correspond un message apparait
    passwordMsg: db "deuxpointspourmoyenne" ; mot de passe prédéfini
;SECTION .BSS
;Définition de la section contenant les données non initialisées la section .BSS
section .bss
    userTxt: resb 40 ; alloue 40 byte
    lenTxt: resb 1   ; alloue 1 byte 
    
;SECTION .TEXT
;Définition de la section contenant les instructions de code à faire exécuter au processeur
section .text

;SECTION _START
;Bloc d'instruction de la fonction principale _start
global _start ;Définition point d'entrée du programme

_start: ;label _start indiquant l'adresse de la première instruction du programme

    mov eax, 4                  ; On copie la valeur 4 dans le registre eax
    mov ebx, 1                  ; On copie la valeur 1 dans le registre ebx
    mov ecx, msg                ; On copie le message dans le counter register
    mov edx, 18+1               ; On alloue 18 byte + la backslash end
    int 0x80                    ; Interruption

    ;Appel de la fonction système read(unsigned int fd, char *buf, size_t count)
    mov eax, 3           ; On copie la valeur 3 dans le registre eax
    mov ebx, 0           ; On copie la valeur 0 dans le registre ebx
    mov ecx, userTxt     ; On copie userTxt dans le counter register
    mov edx, 40          ; 40 byte
    int 0x80             ; Interruption
    
    mov ecx, 0           ; On copie la valeur 0 dans le registre ecx
    mov ebx, 0           ; On copie la valeur 0 dans le registre ebx
loop_nextChar:
 
    cmp byte [userTxt + ecx], 0x0A ; Incrémentation d'une Boucle qui vérifie les caractères les un après les autres
    je end ; Fin de la boucle
    inc ecx ; Incrémentation d'ecx
    jmp loop_nextChar ; Jump au prochain caractère
end:
    mov byte [lenTxt], cl ; 

mov al, byte [userTxt]

cmp byte [lenTxt], 18 ;incrémentation de la valeur minimanl de la longueur du texte
jl tooShortMsg
cmp byte [lenTxt], 21 ; incrémentation de la valeur maximal de la longueur du texte
jg tooLongMsg ; output de l'erreur de taille
jmp goodLengthMsg ; output du message de réussite

tooLongMsg:
; Incrémentation de l'erreur de taille (message trop long)

    mov eax, 4  ; Copie de la valeur 4 dans eax
    mov ebx, 1;  Copie de la valeur 1 dans ebx
    mov ecx, errorLongMsg ; Incrémentation message d'erreur
    mov edx, 45+1 ; 
    int 0x80 ; Interruption du programme
    ;Jump au début du programme
    jmp _start

tooShortMsg:
; Incrémentation de l'erreur de taille (message trop court)
    mov eax, 4             
    mov ebx, 1             
    mov ecx, errorShortMsg ; Incrémentation du message d'erreur 
    mov edx, 46+1
    int 0x80
    ;Jump au début du programme
    jmp _start

notLetterMsg:
    ; Incrémentation d'une erreur concernant les chiffres
    mov eax, 4
    mov ebx, 1
    mov ecx, errorAsciiMsg ; Incrémentation du message d'erreur concernant les chiffres
    mov edx, 36+1
    int 0x80
    ;Jump au début du programme
    jmp _start

goodLengthMsg: ;Bonne longueur pour le message
    mov ecx, 0
    mov ebx, 0
    loop_CheckAsciiChar:
        ;On compare si le caractère est une Majuscule
            mov al, byte [userTxt+ecx]
            cmp al, 0x0A ; Caractère de fin de chaine
            je matchMsg
            cmp al, 0x41 ; A 
            jl errorAscii 
            cmp al, 0x7A ;z
            jg errorAscii
            cmp al, 0x5A ;Z
            jle nextAscii 
            cmp al, 0x61 ; a
            jl errorAscii
            nextAscii:
                ;Sinon on incrémente ebx pour passer au prochain caractère de la chaine
                inc ecx
                ;On revient au début de la boucle
                jmp loop_CheckAsciiChar

        errorAscii:
            ;Affichage d'un message d'erreur de caractères
            mov eax, 4 
            mov ebx, 1
            mov ecx, errorAsciiMsg
            mov edx, 36+1
            int 0x80
            ;Jump au début du programme
            jmp _start

        matchMsg:
            mov eax, 4 
            mov ebx, 1
            mov ecx, ok
            mov edx, 21+1
            int 0x80

        

loop_CheckChar:
            mov ecx, 0
        loop_CheckChar2:;Incrémentation d'une boucle qui vérifie que chaque caractère correspond au mot de passe défini
                mov al, byte [userTxt+ecx]
                cmp al, byte [passwordMsg+ecx] ;Incrémentation du mot de passe prédéfini
                jne passwordNotMatching 
                inc ecx
                cmp byte [userTxt+ecx], 0x0A
                je passwordMatching
                jmp loop_CheckChar2

        passwordNotMatching:
                ;Affichage d'un message d'erreur de caractères
                mov eax, 4
                mov ebx, 1
                mov ecx, wrongPasswordMsg ; Affichage du message d'erreur pour le mauvais mot de passe 
                mov edx, 24+1
                int 0x80
                ;Jump au début du programme
                jmp _start

        passwordMatching:
                ;Affichage d'un message de réussite
                mov eax, 4
                mov ebx, 1
                mov ecx, matchingPasswordMsg ;Si le mot de passe correspond un message apparait
                mov edx, 20+1
                int 0x80

;===================FIN PROGRAMME=============================
;Appel à la fonction système exit(int error_code)
mov eax, 1
mov ebx, 0
int 0x80 ; Interruption du programme
