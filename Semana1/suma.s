.file"suma.c"
.intel_syntax noprefix
.text
.globlsuma
.typesuma, @function
suma:
pushrbp
movrbp, rsp
movDWORD PTR [rbp-20], edi
movDWORD PTR [rbp-24], esi
movedx, DWORD PTR [rbp-20]
moveax, DWORD PTR [rbp-24]
addeax, edx
movDWORD PTR [rbp-4], eax
moveax, DWORD PTR [rbp-4]
poprbp
ret
.sizesuma, .-suma
.ident"GCC: (GNU) 14.3.1 20251022 (Red Hat 14.3.1-4)"
.section.note.GNU-stack,"",@progbits
