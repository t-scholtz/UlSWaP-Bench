function (set_msp430_config)
    message(STATUS "Setting MSP430 configuration")
    set(PICOLIBC_ROOT $ENV{HOME}/picolibc/install-msp430)
    set(MSP430_ROOT $ENV{HOME}/ti/msp430-gcc)
    set(LIB_PATH ${PICOLIBC_ROOT})
    set(CC_PATH ${MSP430_ROOT}/bin)
    set(CMAKE_C_COMPILER ${CC_PATH}/msp430-elf-gcc PARENT_SCOPE)
    set(CMAKE_ASM_COMPILER ${CC_PATH}/msp430-elf-gcc PARENT_SCOPE)
    
    set(GENERAL_FLAGS "-Wall;-fno-builtin;-ffreestanding;-fno-optimize-sibling-calls;-fno-builtin-fma;-ffp-contract=off;-ffunction-sections")
    
    # Fixed MSP430 flags for basic 16-bit MSP430 (not MSP430X)
    set(MSP430_FLAGS 
        "-mmcu=msp430f1611"             # 48KB Flash, 10KB RAM (not MSP430X)
        # Remove -mlarge (enables MSP430X)
        # Remove -mdata-region=upper (20-bit addressing) 
        "-mhwmult=none"                 # No hardware multiplier
        "-specs=picolibc.specs"         # Keep picolibc
        "-T${ARCH_DIR}/memmap.ld"       # Custom linker script
        "-DCUSTOM_ARCH_STARTUP"         # Custom startup
        "-Wl,--gc-sections"             # Garbage collection
    )
    
    set(ARCH_OBJDUMP "${CC_PATH}/msp430-elf-objdump" PARENT_SCOPE)
    set(ARCH_INC_DIRS "${MSP430_ROOT}/include" PARENT_SCOPE)
    set(ARCH_FLAGS "${GENERAL_FLAGS};${MSP430_FLAGS}" PARENT_SCOPE)
    set(ARCH_LINK_FLAGS "${GENERAL_FLAGS};${MSP430_FLAGS}" PARENT_SCOPE)
    set(ARCH_SOURCES "${ARCH_DIR}/supportFuncs.c;${ARCH_DIR}/vectors.S;${ARCH_DIR}/" PARENT_SCOPE)
endfunction()