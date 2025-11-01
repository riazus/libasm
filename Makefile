NAME			:= libasm
LIBNAME		:= libasm.a

ASM				:= nasm
ASMFLAGS	:= -f elf64
CC				:= gcc
CFLAGS		:= -Wall -Wextra -Werror
LD      	:= gcc

SRC_DIR		:= src
OBJ_DIR		:= obj

ASM_SRCS	:= $(filter-out %_bonus.s, $(wildcard $(SRC_DIR)/*.s))
ASM_OBJS	:= $(patsubst $(SRC_DIR)/%.s,$(OBJ_DIR)/%.o,$(ASM_SRCS))

C_SRCS		:= $(SRC_DIR)/main.c
C_OBJS		:= $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(C_SRCS))

BONUS_DIR	:= src
BONUS_SRCS	:= $(wildcard $(BONUS_DIR)/*_bonus.s)
BONUS_OBJS	:= $(patsubst $(BONUS_DIR)/%_bonus.s,$(OBJ_DIR)/%_bonus.o,$(BONUS_SRCS))
BONUS_C_SRCS	:= $(wildcard $(BONUS_DIR)/*_bonus.c)
BONUS_C_OBJS	:= $(patsubst $(BONUS_DIR)/%_bonus.c,$(OBJ_DIR)/%_bonus.o,$(BONUS_C_SRCS))
BONUS_NAME	:= libasm_bonus

all: $(NAME)

bonus: $(BONUS_NAME)

$(LIBNAME): $(ASM_OBJS) | $(OBJ_DIR)
	ar rcs $@ $^

$(NAME): $(C_OBJS) $(LIBNAME)
	$(LD) -o $@ $(C_OBJS) -L. -lasm

$(BONUS_NAME): $(BONUS_C_OBJS) $(BONUS_OBJS) $(LIBNAME)
	$(LD) -o $@ $(BONUS_C_OBJS) $(BONUS_OBJS) -L. -lasm

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s | $(OBJ_DIR)
	$(ASM) $(ASMFLAGS) -o $@ $<

$(OBJ_DIR)/%_bonus.o: $(BONUS_DIR)/%_bonus.s | $(OBJ_DIR)
	$(ASM) $(ASMFLAGS) -o $@ $<

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -I$(SRC_DIR) -c $< -o $@

$(OBJ_DIR)/%_bonus.o: $(BONUS_DIR)/%_bonus.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -I$(SRC_DIR) -I$(BONUS_DIR) -c $< -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

clean:
	rm -f $(ASM_OBJS) $(C_OBJS) $(BONUS_OBJS) $(BONUS_C_OBJS)

fclean: clean
	rm -f $(NAME) $(LIBNAME) $(BONUS_NAME)

re: fclean all

.PHONY: all bonus clean fclean re