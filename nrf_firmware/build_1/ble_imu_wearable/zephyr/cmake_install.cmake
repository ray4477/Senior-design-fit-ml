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
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/zephyr/arch/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/zephyr/lib/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/zephyr/soc/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/zephyr/boards/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/zephyr/subsys/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/zephyr/drivers/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/nrf/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/mcuboot/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/mbedtls/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/trusted-firmware-m/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/cjson/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/azure-sdk-for-c/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/cirrus-logic/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/openthread/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/suit-processor/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/memfault-firmware-sdk/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/canopennode/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/chre/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/lz4/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/nanopb/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/zscilib/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/cmsis/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/cmsis-dsp/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/cmsis-nn/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/fatfs/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/hal_nordic/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/hal_st/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/hal_wurthelektronik/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/hostap/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/libmetal/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/liblc3/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/littlefs/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/loramac-node/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/lvgl/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/mipi-sys-t/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/nrf_wifi/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/open-amp/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/picolibc/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/segger/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/tinycrypt/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/uoscore-uedhoc/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/zcbor/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/nrfxlib/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/nrf_hw_models/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/modules/connectedhomeip/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/zephyr/kernel/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/zephyr/cmake/flash/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/zephyr/cmake/usage/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/raymo/Documents/GitHub/Senior-design-fit-ml/wearable_v2_nrf_firmware/ble_imu_wearable/build_1/ble_imu_wearable/zephyr/cmake/reports/cmake_install.cmake")
endif()

