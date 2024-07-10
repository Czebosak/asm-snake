# Compiler and linker
ASM = nasm
LD = ld

# Flags
ASMFLAGS = -f elf64
LDFLAGS =

# Directories
BUILD_DIR = build
SRC_DIR = src
OBJ_DIR = $(BUILD_DIR)/obj
BIN_DIR = $(BUILD_DIR)/bin

# Targets
all: $(BIN_DIR)/snake

# Create necessary directories
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(OBJ_DIR): | $(BUILD_DIR)
	mkdir -p $(OBJ_DIR)

$(BIN_DIR): | $(BUILD_DIR)
	mkdir -p $(BIN_DIR)

# Link the final executable
$(BIN_DIR)/snake: $(OBJ_DIR)/main.o | $(BIN_DIR)
	$(LD) -o $@ $^ $(LDFLAGS)

# Assemble the object file
$(OBJ_DIR)/main.o: $(SRC_DIR)/main.asm | $(OBJ_DIR)
	$(ASM) $(ASMFLAGS) -o $@ $<

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)

# Phony targets
.PHONY: all clean
