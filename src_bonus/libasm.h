#ifndef LIBASM_BONUS_H
#define LIBASM_BONUS_H

#include <stddef.h>

typedef struct s_list {
    void *data;
    struct s_list *next;
} t_list;

int	ft_atoi_base(char *str, char *base);
void ft_list_push_front(t_list **begin_list, void *data);
int ft_list_size(t_list *begin_list);


#endif

