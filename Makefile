NAME			:= libasm
LIBNAME		:= libasm.a

ASM				:= nasm
ASMFLAGS	:= -f elf64
CC				:= gcc
CFLAGS		:= -Wall -Wextra -Werror
LD      	:= gcc

SRC_DIR		:= src
OBJ_DIR		:= obj

# ASM source files (exclude main.c)
ASM_SRCS	:= $(filter-out $(SRC_DIR)/main.c, $(wildcard $(SRC_DIR)/*.asm))
ASM_OBJS	:= $(patsubst $(SRC_DIR)/%.asm,$(OBJ_DIR)/%.o,$(ASM_SRCS))

# C source files
C_SRCS		:= $(SRC_DIR)/main.c
C_OBJS		:= $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(C_SRCS))

all: $(NAME)

# Create static library from ASM objects
$(LIBNAME): $(ASM_OBJS) | $(OBJ_DIR)
	ar rcs $@ $^

# Link final executable
$(NAME): $(C_OBJS) $(LIBNAME)
	$(LD) -o $@ $(C_OBJS) -L. -lasm

# Assembly compilation
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm | $(OBJ_DIR)
	$(ASM) $(ASMFLAGS) -o $@ $<

# C compilation
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -I$(SRC_DIR) -c $< -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

clean:
	rm -f $(ASM_OBJS) $(C_OBJS)

fclean: clean
	rm -f $(NAME) $(LIBNAME)

# Rebuild everything
re: fclean all

.PHONY: all clean fclean re