NAME		:= libasm

ASM			:= nasm
ASMFLAGS	:= -f elf64
LD      	:= ld

SRC_DIR		:= src
OBJ_DIR		:= obj

SRCS		:= $(wildcard $(SRC_DIR)/*.asm)
OBJS		:= $(patsubst $(SRC_DIR)/%.asm,$(OBJ_DIR)/%.o,$(SRCS))

all: $(NAME)

# Link step
$(NAME): $(OBJS)
	$(LD) -o $@ $^

# Assembly step
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm | $(OBJ_DIR)
	$(ASM) $(ASMFLAGS) -o $@ $<

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f $(NAME)

# Rebuild everything
re: fclean all

.PHONY: all clean fclean re