#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include "libasm_bonus.h"
 
void ft_list_clear(t_list **head) {
	t_list *curr = *head;

	while (curr) {
		t_list *tmp = curr->next;
		free(curr);
		curr = tmp;
	}

	*head = NULL;
}

int string_cmp(void *data1, void *data2) {
    return strcmp((char *)data1, (char *)data2);
}

void free_string(void *data) {
    free(data);
}

void test_ft_list_sort() {
    printf("Testing ft_list_sort...\n");

    t_list *first_node = malloc(sizeof(t_list));
	first_node->data = "3";
    first_node->next = NULL;
    ft_list_push_front(&first_node, "2");
	ft_list_push_front(&first_node, "1");
	ft_list_push_front(&first_node, "0");
    ft_list_sort(&first_node, &strcmp);

	t_list *curr = first_node;
	for (int i = 0; i < 4 && curr; i++) {
		int node_data = atoi((char *)curr->data);
		assert(i == node_data);
		curr = curr->next;
	}

    ft_list_clear(&first_node);
}

void test_ft_list_size() {
	printf("Testing ft_list_size...\n");

	t_list *first_node = malloc(sizeof(t_list));
	first_node->data = "3";
    first_node->next = NULL;
    ft_list_push_front(&first_node, "2");
	ft_list_push_front(&first_node, "1");
	ft_list_push_front(&first_node, "0");

	int list_size = ft_list_size(first_node);
	assert(list_size == 4);

	ft_list_clear(&first_node);
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

void test_ft_list_remove_if() {
    printf("Testing ft_list_remove_if...\n");

    // Test 1: Remove elements from the middle of the list
    t_list *list = NULL;
    
    // Create a list with duplicated strings: "apple", "banana", "apple", "cherry", "apple"
    ft_list_push_front(&list, strdup("apple"));
    ft_list_push_front(&list, strdup("cherry"));
    ft_list_push_front(&list, strdup("apple"));
    ft_list_push_front(&list, strdup("banana"));
    ft_list_push_front(&list, strdup("apple"));
    
    // Remove all "apple" elements
    char *to_remove = "apple";
    ft_list_remove_if(&list, to_remove, &string_cmp, &free_string);
    
    // Verify only "banana" and "cherry" remain
    assert(ft_list_size(list) == 2);
    assert(strcmp((char *)list->data, "banana") == 0);
    assert(strcmp((char *)list->next->data, "cherry") == 0);
    
    ft_list_clear(&list);
    
    // Test 2: Remove all elements (empty list)
    ft_list_push_front(&list, strdup("same"));
    ft_list_push_front(&list, strdup("same"));
    ft_list_push_front(&list, strdup("same"));
    
    char *remove_all = "same";
    ft_list_remove_if(&list, remove_all, &string_cmp, &free_string);
    
    // List should be empty
    assert(list == NULL);
    assert(ft_list_size(list) == 0);
    
    // Test 3: Remove nothing (no matches)
    ft_list_push_front(&list, strdup("keep1"));
    ft_list_push_front(&list, strdup("keep2"));
    ft_list_push_front(&list, strdup("keep3"));
    
    char *not_found = "remove_me";
    ft_list_remove_if(&list, not_found, &string_cmp, &free_string);
    
    // All elements should remain
    assert(ft_list_size(list) == 3);
    
    ft_list_clear(&list);
}

int main() {
    printf("=== libasm_bonus Test Suite ===\n\n");

    test_ft_atoi_base();
    test_ft_list_push_front();
	test_ft_list_size();
    test_ft_list_sort();
    test_ft_list_remove_if();

    printf("\n=== All tests completed! ===\n");
    return 0;
}
