# Aerouant 

# Vérificiation politique mot de passe
  `nasm -f elf64 V1-V2.asm -o V1-V2.o`

  `ld V1-V2.o -o V1-V2`

  `./V1-V2`

# Générateur mot de passe 

  `ènasm -f elf32 passwordGen.asm -o passwordGen.o`

  `èld -m elf_i386 passwordGen.o -o passwordGen`
