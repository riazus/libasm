NAME			:= libasm
LIBNAME		:= libasm.a

ASM				:= nasm
ASMFLAGS	:= -f elf64
CC				:= gcc
CFLAGS		:= -Wall -Wextra -Werror
LD      	:= gcc

SRC_DIR		:= src
OBJ_DIR		:= obj

ASM_SRCS	:= $(filter-out $(SRC_DIR)/main.c, $(wildcard $(SRC_DIR)/*.asm))
ASM_OBJS	:= $(patsubst $(SRC_DIR)/%.asm,$(OBJ_DIR)/%.o,$(ASM_SRCS))

C_SRCS		:= $(SRC_DIR)/main.c
C_OBJS		:= $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(C_SRCS))

BONUS_DIR	:= src_bonus
BONUS_SRCS	:= $(wildcard $(BONUS_DIR)/*.asm)
BONUS_OBJS	:= $(patsubst $(BONUS_DIR)/%.asm,$(OBJ_DIR)/%.o,$(BONUS_SRCS))
BONUS_C_SRCS	:= $(wildcard $(BONUS_DIR)/*.c)
BONUS_C_OBJS	:= $(patsubst $(BONUS_DIR)/%.c,$(OBJ_DIR)/bonus_%.o,$(BONUS_C_SRCS))
BONUS_NAME	:= libasm_bonus

all: $(NAME)

bonus: $(BONUS_NAME)

$(LIBNAME): $(ASM_OBJS) | $(OBJ_DIR)
	ar rcs $@ $^

$(NAME): $(C_OBJS) $(LIBNAME)
	$(LD) -o $@ $(C_OBJS) -L. -lasm

$(BONUS_NAME): $(BONUS_C_OBJS) $(BONUS_OBJS) $(LIBNAME)
	$(LD) -o $@ $(BONUS_C_OBJS) $(BONUS_OBJS) -L. -lasm

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm | $(OBJ_DIR)
	$(ASM) $(ASMFLAGS) -o $@ $<

$(OBJ_DIR)/%.o: $(BONUS_DIR)/%.asm | $(OBJ_DIR)
	$(ASM) $(ASMFLAGS) -o $@ $<

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -I$(SRC_DIR) -c $< -o $@

$(OBJ_DIR)/bonus_%.o: $(BONUS_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -I$(SRC_DIR) -I$(BONUS_DIR) -c $< -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

clean:
	rm -f $(ASM_OBJS) $(C_OBJS) $(BONUS_OBJS) $(BONUS_C_OBJS)

fclean: clean
	rm -f $(NAME) $(LIBNAME) $(BONUS_NAME)

re: fclean all

.PHONY: all bonus clean fclean re