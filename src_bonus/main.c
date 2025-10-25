#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include "libasm_bonus.h"

// Helper function to test ft_atoi_base with expected result
void test_atoi_base(char *str, char *base, int expected, const char *description) {
    printf("Testing: %s\n", description);
    printf("  Input: str=\"%s\", base=\"%s\"\n", str, base);
    
    int result = ft_atoi_base(str, base);
    printf("  Expected: %d, Got: %d\n", expected, result);
    
    if (result == expected) {
        printf("  ✅ PASS\n");
    } else {
        printf("  ❌ FAIL\n");
        assert(0); // Fail the test
    }
    printf("\n");
}
 
void test_ft_atoi_base() {
    printf("=== Testing ft_atoi_base (essential cases) ===\n");
    
    // 1) Decimal with leading whitespace and plus sign
    test_atoi_base("  +42", "0123456789", 42, "Decimal with whitespace and '+'");
    
    // 2) Negative binary with leading tab
    test_atoi_base("\t-101", "01", -5, "Binary with tab and '-' => -5");
    
    // 3) Invalid base (duplicate characters) must return 0
    test_atoi_base("42", "0123456789012", 0, "Invalid base (duplicate) => 0");
}

int main() {
    printf("=== ft_atoi_base Test Suite ===\n\n");
    test_ft_atoi_base();
    printf("=== All ft_atoi_base tests completed successfully! ===\n");
    return 0;
}
