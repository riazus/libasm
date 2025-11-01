#include <string.h>
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
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
}

void test_ft_write() {
    printf("Testing ft_write...\n");
    
    // Test writing to stdout
    char *msg_main = "Testing ft_write function from main...\n";
    char *msg_test = "Testing ft_write function from test...\n";
    ssize_t result_main = ft_write(1, msg_main, strlen(msg_main));
    ssize_t result_test = write(1, msg_test, strlen(msg_test));
  
    assert(result_main == result_test);
}

static ssize_t read_all_with(int fd, char *buffer, size_t capacity,
                             ssize_t (*reader)(int, void *, size_t)) {
    size_t totalBytesRead = 0;

    while (1) {
        size_t remainingCapacity = capacity - totalBytesRead;
        if (remainingCapacity == 0) {
            break;
        }

        ssize_t bytesRead = reader(fd, buffer + totalBytesRead, remainingCapacity);
        if (bytesRead < 0) {
            return bytesRead;
        }
        if (bytesRead == 0) {
            break;
        }
        totalBytesRead += (size_t)bytesRead;
    }

    return (ssize_t)totalBytesRead;
}

static ssize_t libc_read_shim(int fd, void *buf, size_t nbyte) {
    return read(fd, buf, nbyte);
}

void test_ft_read() {
    printf("Testing ft_read...\n");

    // 1) Read a real file fully and compare to libc read
    {
        const char *path = "src/ft_read.s";
        int fdA = open(path, O_RDONLY);
        int fdB = open(path, O_RDONLY);
        assert(fdA >= 0 && fdB >= 0);

        struct stat st;
        assert(fstat(fdA, &st) == 0);
        size_t fileSize = (size_t)st.st_size;
        char *bufferA = (char *)malloc(fileSize + 1);
        char *bufferB = (char *)malloc(fileSize + 1);
        assert(bufferA != NULL && bufferB != NULL);

        ssize_t bytesReadA = read_all_with(fdA, bufferA, fileSize, ft_read);
        ssize_t bytesReadB = read_all_with(fdB, bufferB, fileSize, libc_read_shim);
        assert(bytesReadA == bytesReadB);
        assert(bytesReadA >= 0);
        bufferA[bytesReadA] = '\0';
        bufferB[bytesReadB] = '\0';
        assert(memcmp(bufferA, bufferB, (size_t)bytesReadA) == 0);

        // EOF should return 0
        char tmp;
        assert(ft_read(fdA, &tmp, 1) == 0);
        assert(read(fdB, &tmp, 1) == 0);

        free(bufferA);
        free(bufferB);
        close(fdA);
        close(fdB);
    }

    // 2) Chunked 1-byte reads
    {
        const char *path = "src/ft_read.s";
        int fdA = open(path, O_RDONLY);
        int fdB = open(path, O_RDONLY);
        assert(fdA >= 0 && fdB >= 0);

        enum { CAPACITY = 4096 };
        char bufferA[CAPACITY];
        char bufferB[CAPACITY];
        ssize_t totalA = 0;
        ssize_t totalB = 0;
        for (;;) {
            ssize_t nA = ft_read(fdA, bufferA + totalA, 1);
            ssize_t nB = read(fdB, bufferB + totalB, 1);
            assert(nA == nB);
            if (nA <= 0) break;
            totalA += nA;
            totalB += nB;
            assert(totalA < CAPACITY && totalB < CAPACITY);
        }
        assert(totalA == totalB);
        assert(memcmp(bufferA, bufferB, (size_t)totalA) == 0);

        close(fdA);
        close(fdB);
    }

    // 3) Read from a pipe: known data
    {
        int pipeA[2];
        int pipeB[2];
        assert(pipe(pipeA) == 0);
        assert(pipe(pipeB) == 0);
        const char *message = "Hello from ft_read pipe test!";
        size_t messageLength = strlen(message);
        assert(write(pipeA[1], message, messageLength) == (ssize_t)messageLength);
        assert(write(pipeB[1], message, messageLength) == (ssize_t)messageLength);
        close(pipeA[1]);
        close(pipeB[1]);

        char bufferA[128] = {0};
        char bufferB[128] = {0};
        ssize_t readA = read_all_with(pipeA[0], bufferA, sizeof(bufferA), ft_read);
        ssize_t readB = read_all_with(pipeB[0], bufferB, sizeof(bufferB), libc_read_shim);
        assert(readA == readB);
        assert(memcmp(bufferA, bufferB, (size_t)readA) == 0);
        close(pipeA[0]);
        close(pipeB[0]);
    }

    // 4) Zero-length read returns 0 and does not modify buffer
    {
        const char *path = "src/ft_read.s";
        int fd = open(path, O_RDONLY);
        assert(fd >= 0);
        char buffer[8] = { 'X','X','X','X','X','X','X','X' };
        errno = 0;
        ssize_t n = ft_read(fd, buffer, 0);
        assert(n == 0);
        for (int i = 0; i < 8; i++) {
            assert(buffer[i] == 'X');
        }
        close(fd);
    }

    // 5) Error: invalid fd sets errno like libc (EBADF)
    {
        char a, b;
        errno = 0;
        ssize_t ra = ft_read(-1, &a, 1);
        int ea = errno;
        errno = 0;
        ssize_t rb = read(-1, &b, 1);
        int eb = errno;
        assert(ra == -1 && rb == -1);
        assert(ea == eb);
    }

    // 6) Large file: create, write, then read back with both
    {
        char pathTemplate[] = "/tmp/ftreadXXXXXX";
        int writeFd = mkstemp(pathTemplate);
        assert(writeFd >= 0);
        size_t numBytes = 1 << 20; // 1 MiB
        char *source = (char *)malloc(numBytes);
        assert(source != NULL);
        for (size_t i = 0; i < numBytes; i++) {
            source[i] = (char)(i * 1315423911u);
        }
        assert(write(writeFd, source, numBytes) == (ssize_t)numBytes);
        close(writeFd);

        int fdA = open(pathTemplate, O_RDONLY);
        int fdB = open(pathTemplate, O_RDONLY);
        assert(fdA >= 0 && fdB >= 0);

        char *bufferA = (char *)malloc(numBytes);
        char *bufferB = (char *)malloc(numBytes);
        assert(bufferA != NULL && bufferB != NULL);
        ssize_t readA = read_all_with(fdA, bufferA, numBytes, ft_read);
        ssize_t readB = read_all_with(fdB, bufferB, numBytes, libc_read_shim);
        assert(readA == (ssize_t)numBytes && readB == (ssize_t)numBytes);
        assert(memcmp(bufferA, bufferB, numBytes) == 0);

        free(source);
        free(bufferA);
        free(bufferB);
        close(fdA);
        close(fdB);
        unlink(pathTemplate);
    }
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
}

int main() {
    printf("=== libasm Test Suite ===\n\n");
    
    test_ft_strlen();
    test_ft_strcpy();
    test_ft_strcmp();
    test_ft_write();
    test_ft_read();
    test_ft_strdup();

    printf("\n=== All tests completed! ===\n");
    return 0;
}