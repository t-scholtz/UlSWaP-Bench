function(set_riscvi_config)
    message(STATUS "Setting RISC-V configuration")
    set(CMAKE_SYSTEM_NAME Generic)
    set(FRANKEN_LLVM_ROOT $ENV{HOME}/llvm-project)
    set(PICOLIBC_ROOT $ENV{HOME}/picolibc)
    set(LIB_PATH ${PICOLIBC_ROOT}/franken-install/picolibc/rv32im-unknown-elf)
    set(CC_PATH ${FRANKEN_LLVM_ROOT}/build/bin)
    set(CMAKE_C_COMPILER ${CC_PATH}/clang PARENT_SCOPE)
    set(CMAKE_ASM_COMPILER ${CC_PATH}/clang PARENT_SCOPE)
    
    # Prevent CMake from adding automatic compiler-rt linking
    set(CMAKE_C_COMPILER_FORCED TRUE PARENT_SCOPE)
    set(CMAKE_ASM_COMPILER_FORCED TRUE PARENT_SCOPE)
    
    if (VERILATOR)
        message(STATUS "Building for Verilator")
        set(OPTIONAL_FLAGS "-DVERILATOR=1")
    else()
        set(OPTIONAL_FLAGS "-DVERILATOR=0")
    endif()
    if (DEBUG)
        message(STATUS "Building with debug flags")
        list(APPEND OPTIONAL_FLAGS "-DDEBUG=1")
    else()
        list(APPEND OPTIONAL_FLAGS "-DDEBUG=0")
    endif()
    set(GENERAL_FLAGS "-Wall;-fno-builtin;-ffreestanding;-fno-optimize-sibling-calls;-fno-builtin-fma;-ffp-contract=off;-ffunction-sections")
    set(RISCV_FLAGS "--target=riscv32-unknown-elf;-mno-relax;-march=rv32i;-DPICOLIBC_FLOAT_PRINTF_SCANF")
    set(CLANG_INCLUDES "-isystem;${FRANKEN_LLVM_ROOT}/lib/clang/17/include")
    
    set(ARCH_LINK_DIRS "${LIB_PATH}/lib;${FRANKEN_LLVM_ROOT}/build-rt/lib/linux" PARENT_SCOPE)
    set(ARCH_INC_DIRS "${LIB_PATH}/include" PARENT_SCOPE)
    set(ARCH_FLAGS "${GENERAL_FLAGS};${RISCV_FLAGS};${CLANG_INCLUDES};${PICOLIBC_FLAGS};${OPTIONAL_FLAGS}" PARENT_SCOPE)
    set(ARCH_SOURCES "${ARCH_DIR}/vectors.S;${ARCH_DIR}/misc.c;${ARCH_DIR}/lib.c;${ARCH_DIR}/putget.S;${ARCH_DIR}/supportFuncs.c" PARENT_SCOPE)
    
    # Add -nodefaultlibs to prevent automatic standard library linking
    set(ARCH_LINK_FLAGS "-fuse-ld=lld;--target=riscv32-unknown-elf;-T${ARCH_DIR}/memmap.ld;-Wl,--gc-sections;-nodefaultlibs" PARENT_SCOPE)
    
endfunction()