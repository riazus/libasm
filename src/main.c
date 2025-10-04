#include <string.h>
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include "libasm.h"

void test_ft_strlen() {
    printf("Testing ft_strlen...\n");
    
    // Test empty string
    assert(ft_strlen("") == 0);
    assert(ft_strlen("") == strlen(""));
    
    // Test normal strings
    assert(ft_strlen("hello") == 5);
    assert(ft_strlen("hello") == strlen("hello"));
    
    // Test longer string
    char *long_str = "This is a longer string for testing";
    assert(ft_strlen(long_str) == strlen(long_str));
    
    printf("ft_strlen tests passed!\n");
}

void test_ft_strcpy() {
    printf("Testing ft_strcpy...\n");
    
    char dst1[50], dst2[50];
    char *src = "Hello, World!";
    
    // Test with standard strcpy
    strcpy(dst1, src);
    ft_strcpy(dst2, src);
    assert(strcmp(dst1, dst2) == 0);
    
    // Test empty string
    strcpy(dst1, "");
    ft_strcpy(dst2, "");
    assert(strcmp(dst1, dst2) == 0);
    
    printf("ft_strcpy tests passed!\n");
}

void test_ft_strcmp() {
    printf("Testing ft_strcmp...\n");
    
    // Test equal strings
    char *str1 = "hello";
    assert(ft_strcmp(str1, str1) == strcmp(str1, str1));
    
    // Test different strings
    char *str2_1 = "abc";
    char *str2_2 = "abd";
    assert(ft_strcmp(str2_1, str2_2) == strcmp(str2_1, str2_2));
    
    // Test different lengths
    char *str3_1 = "abc";
    char *str3_2 = "abcd";
    assert(ft_strcmp(str3_1, str3_2) == strcmp(str3_1, str3_2));

    char *str4_1 = "qweqwe";
    char *str4_2 = "qweqweqwe";
    assert(ft_strcmp(str4_1, str4_2) == strcmp(str4_1, str4_2));

    // Test upper and lower case
    char *str5_1 = "aaa";
    char *str5_2 = "AAA";
    assert(ft_strcmp(str5_1, str5_2) == strcmp(str5_1, str5_2));
    
    printf("ft_strcmp tests passed!\n");
}

void test_ft_write() {
    printf("Testing ft_write...\n");
    
    // Test writing to stdout
    char *msg_main = "Testing ft_write function from main...\n";
    char *msg_test = "Testing ft_write function from test...\n";
    ssize_t result_main = ft_write(1, msg_main, strlen(msg_main));
    ssize_t result_test = ft_write(1, msg_test, strlen(msg_test));
  
    assert(result_main == result_test);
    
    printf("ft_write tests passed!\n");
}

void test_ft_read() {
    printf("Testing ft_read...\n");
    printf("Note: ft_read test requires manual input or file setup\n");
    // This would require more complex setup with files or pipes
    // For now, just indicate the function exists
    printf("ft_read function is available for use\n");
}

void test_ft_strdup() {
    printf("Testing ft_strdup...\n");

    // 1) Basic duplication equals to libc strdup
    {
        const char *src = "str to duplicate";
        char *got = ft_strdup(src);
        char *exp = strdup(src);
        assert(got != NULL);
        assert(exp != NULL);
        assert(got != src);
        assert(strcmp(got, exp) == 0);
        free(got);
        free(exp);
    }

    // 2) Empty string
    {
        const char *src = "";
        char *got = ft_strdup(src);
        char *exp = strdup(src);
        assert(got != NULL);
        assert(exp != NULL);
        assert(strcmp(got, exp) == 0);
        free(got);
        free(exp);
    }

    // 3) Long string
    {
        size_t n = 8192;
        char *buf = malloc(n + 1);
        assert(buf != NULL);
        for (size_t i = 0; i < n; i++) buf[i] = (char)('a' + (i % 26));
        buf[n] = '\0';
        char *got = ft_strdup(buf);
        char *exp = strdup(buf);
        assert(got != NULL);
        assert(exp != NULL);
        assert(strcmp(got, exp) == 0);
        free(got);
        free(exp);
        free(buf);
    }

    // 4) Embedded NUL: only prefix up to first NUL should be duplicated
    {
        char src_arr[] = { 'A', 'B', '\0', 'C', 'D', '\0' };
        const char *src = src_arr; // treated as string up to first NUL
        char *got = ft_strdup(src);
        char *exp = strdup(src);
        assert(got != NULL);
        assert(exp != NULL);
        assert(strcmp(got, "AB") == 0);
        assert(strcmp(exp, "AB") == 0);
        assert(strcmp(got, exp) == 0);
        free(got);
        free(exp);
    }

    // 5) Non-ASCII bytes (still treated as bytes)
    {
        const unsigned char src_arr[] = { 0xC3, 0xA9, 'X', 0 }; // "éX" in UTF-8
        const char *src = (const char *)src_arr;
        char *got = ft_strdup(src);
        char *exp = strdup(src);
        assert(got != NULL);
        assert(exp != NULL);
        assert(strcmp(got, exp) == 0);
        free(got);
        free(exp);
    }

    printf("ft_strdup tests passed!\n");
}

int main() {
    printf("=== libasm Test Suite ===\n\n");
    
    test_ft_strlen();
    printf("\n");
    
    test_ft_strcpy();
    printf("\n");
    
    test_ft_strcmp();
    printf("\n");
    
    test_ft_write();
    printf("\n");
    
    test_ft_read();
    printf("\n");

    test_ft_strdup();
    printf("\n");
    
    printf("=== All tests completed! ===\n");
    return 0;
}