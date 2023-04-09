TARGET = lab3

help:
		@echo Available goals:
		@echo ' run   - create and run '
		@echo ' debug - create and debug  '
		@echo ' help  - show this message '
$(TARGET): $(TARGET).asm	
		nasm -f elf64 -g -F dwarf -l $(TARGET).lst $(TARGET).asm
		ld -o $(TARGET) $(TARGET).o 
run: $(TARGET)
		./$(TARGET)
debug: $(TARGET)
		gdb $(TARGET)
