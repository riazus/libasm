#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include "libasm.h"
 
void ft_list_clear(t_list **head) {
	t_list *curr = *head;

	while (curr) {
		t_list *tmp = curr->next;
		free(curr);
		curr = tmp;
	}

	*head = NULL;
}

void test_ft_list_push_front() {
    printf("Testing ft_list_push_front...\n");

    t_list *first_node = malloc(sizeof(t_list));
    first_node->data = "3";
    first_node->next = NULL;
    ft_list_push_front(&first_node, "2");
	ft_list_push_front(&first_node, "1");
	ft_list_push_front(&first_node, "0");

    t_list *curr = first_node;
	for (int i = 0; i < 4 && curr; i++) {
		int node_data = atoi((char *)curr->data);
		assert(i == node_data);
		curr = curr->next;
	}

	ft_list_clear(&first_node);
}

void test_ft_atoi_base() {
    printf("Testing ft_atoi_base...\n");

    int res;

    // 1) Decimal with leading whitespace and plus sign
    res = ft_atoi_base("   +42", "0123456789");
    assert(res == 42);
    
    // 2) Negative binary with leading tab
    res = ft_atoi_base("\t-101", "01");
    assert(res == -5);
    
    // 3) Invalid base (duplicate characters) must return 0
    res = ft_atoi_base("42", "0123456789012");
    assert(res == 0);
}

int main() {
    printf("=== libasm_bonus Test Suite ===\n\n");

    test_ft_atoi_base();
    test_ft_list_push_front();

    printf("\n=== All tests completed! ===\n");
    return 0;
}
