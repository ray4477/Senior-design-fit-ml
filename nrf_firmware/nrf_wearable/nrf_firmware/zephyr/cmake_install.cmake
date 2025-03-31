# Install script for directory: C:/ncs/v2.9.0/zephyr

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files/Zephyr-Kernel")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "MinSizeRel")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "C:/ncs/toolchains/b620d30767/opt/zephyr-sdk/arm-zephyr-eabi/bin/arm-zephyr-eabi-objdump.exe")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/zephyr/arch/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/zephyr/lib/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/zephyr/soc/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/zephyr/boards/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/zephyr/subsys/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/zephyr/drivers/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/nrf/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/mcuboot/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/mbedtls/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/trusted-firmware-m/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/cjson/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/azure-sdk-for-c/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/cirrus-logic/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/openthread/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/suit-processor/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/memfault-firmware-sdk/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/canopennode/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/chre/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/lz4/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/nanopb/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/zscilib/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/cmsis/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/cmsis-dsp/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/cmsis-nn/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/fatfs/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/hal_nordic/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/hal_st/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/hal_wurthelektronik/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/hostap/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/libmetal/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/liblc3/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/littlefs/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/loramac-node/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/lvgl/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/mipi-sys-t/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/nrf_wifi/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/open-amp/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/picolibc/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/segger/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/tinycrypt/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/uoscore-uedhoc/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/zcbor/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/nrfxlib/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/nrf_hw_models/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/modules/connectedhomeip/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/zephyr/kernel/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/zephyr/cmake/flash/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/zephyr/cmake/usage/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/nrf_firmware/nrf_wearable/nrf_firmware/zephyr/cmake/reports/cmake_install.cmake")
endif()

