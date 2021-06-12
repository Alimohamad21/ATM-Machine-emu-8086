; you may customize this and other start-up templates; 
; the location of this template is c:\emu8086\inc\0_com_template.txt
include 'emu8086.inc'

; you may customize this and other start-up templates; 
; the location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
.model small
      .stack 64
    .data
card_numbers dw 0ABCH,2EF0H,1ACDH,1FEDH,0DEFH,5AEDH,3EADH,4FD7H,1238H,1234H,5678H,89AEH,54C2H,123DH,129EH,2222H,2310H,2131H,6969H,6268H
passwords dw 0000H,0001H,0002H,0003H,0004H,0005H,0006H,0007H,0008H,0009H,000AH,000BH,000CH,000DH,000EH,000FH,0000H,0001H,0002H,0003H    
card_prompt db 'Enter Your Card Number:$'
password_prompt db 'Enter Your Password:$'
output1 db '1 (ACCESS GRANTED>$' 
output0 db '0 <ACCESS DENIED>$'   
card_input db  5,?,5 dup (?)
password_input db  2,?,2 dup (?)
offset db 00h
        .code
main    proc 
        mov ax,@data
        mov ds,ax
        mov es,ax
        mov dh,00h
        call input_card_no
        call prepCardNoInAX
        call search_card_no
        call input_password
        call prepPassInAX
        call search_password
        call exit
main    endp          
         
        
        
input_card_no    proc
                 printn     
                 mov ah,09h
                 lea dx,card_prompt
                 int 21h
                 printn 
                 mov ah,0ah
                 mov dx,offset card_input
                 int 21h
                 mov si,offset card_input+2 
                 ret
input_card_no    endp 






prepCardNoInAX   proc                  
                 mov cx,04h
label_1:         cmp [si],39h
                 jz  label_2
                 jb  label_2         
                 ja  label_3    
label_2:         sub [si],30h
                 jmp label_6        
label_3:         cmp [si],70
                 jz  label_4
                 jb  label_4
                 ja  label_5
label_4:         sub [si],55
                 jmp label_6 
label_5:         sub [si],87
                 jmp label_6       
label_6:         inc si 
                 dec cx   
                 jnz label_1       
                 sub si,4
                 mov ah,[si]
                 mov al,[si+2]
                 mov bh,[si+1]
                 mov bl,[si+3]
                 shl ax,4
                 or  ax,bx  
                 ret
prepCardNoInAX   endp 


search_card_no   proc
                 mov cx,21            
                 lea di,card_numbers                      
                 cld                  
                 repne scasw          
                 cmp cx,0000h         
                 jz invalid_card_no          
                 ret          
search_card_no   endp





invalid_card_no  proc
                 printn 
                 printn
                 mov ah,09h
                 lea dx,output0
                 int 21h
                 printn 
                 call main
invalid_card_no  endp





input_password   proc
                 printn
                 printn
                 lea dx,password_prompt
                 mov ah,09h
                 int 21h
                 printn 
                 mov ah,0Ah
                 mov dx,offset password_input
                 int 21h 
                 sub [password_input],30h 
                 mov si,offset password_input+2 
                 ret
input_password   endp



prepPassInAX     proc                  
                 cmp [si],39h                 
                 jz  label_a
                 jb  label_a         
                 ja  label_b    
label_a:         sub [si],30h
                 jmp label_e        
label_b:         cmp [si],70
                 jz  label_c
                 jb  label_c
                 ja  label_d
label_c:         sub [si],55
                 jmp label_e 
label_d:         sub [si],87
        
label_e:     
                 mov ah,00
                 mov al,[si]
                 ret
prepPassInAX     endp 
                     
                     
 
search_password  proc                           
                 mov bx,ax
                 add di,38           
                 cmp bx,[di]                       
                 jnz invalid_password   
                 printn
                 mov ah,09h
                 printn
                 lea dx,output1
                 int 21h
                 printn 
                 ret 
search_password  endp 




invalid_password proc
                 printn 
                 printn
                 mov ah,09h
                 lea dx,output0
                 int 21h
                 printn
                 ret
invalid_password endp
   
                      
exit proc          
     mov ax, 4c00h ; exit to operating system.
     int 21h  
exit endp                   
ret
