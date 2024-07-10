# Compiler and linker
ASM = nasm
LD = ld

# Flags
ASMFLAGS = -f elf64 -gdwarf
LDFLAGS =

# Directories
BUILD_DIR = build
SRC_DIR = src
OBJ_DIR = $(BUILD_DIR)/obj
BIN_DIR = $(BUILD_DIR)/bin
QR_DIR = $(BUILD_DIR)/qr

# Targets
all: $(BIN_DIR)/snake

# Create necessary directories
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(OBJ_DIR): | $(BUILD_DIR)
	mkdir -p $(OBJ_DIR)

$(BIN_DIR): | $(BUILD_DIR)
	mkdir -p $(BIN_DIR)

$(QR_DIR): | $(BUILD_DIR)
	mkdir -p $(QR_DIR)

# Link the final executable
$(BIN_DIR)/snake: $(OBJ_DIR)/main.o $(OBJ_DIR)/render.o | $(BIN_DIR)
	$(LD) -o $@ $^ $(LDFLAGS)

# Assemble the object file
$(OBJ_DIR)/main.o: $(SRC_DIR)/main.asm | $(OBJ_DIR)
	$(ASM) $(ASMFLAGS) -o $@ $<

$(OBJ_DIR)/render.o: $(SRC_DIR)/render.asm | $(OBJ_DIR)
	$(ASM) $(ASMFLAGS) -o $@ $<

clean:
	rm -rf $(BUILD_DIR)

into_qr: $(BIN_DIR)/snake | $(QR_DIR)
	@echo "Splitting the binary file..."
	@split -b 2953 $(BIN_DIR)/snake $(QR_DIR)/part_
	@echo "Generating QR codes..."
	@for part in $(shell ls $(QR_DIR)/part_*); do \
	    qrencode -o $$part.png -8 -r $$part; \
	done

# Phony targets
.PHONY: all clean
