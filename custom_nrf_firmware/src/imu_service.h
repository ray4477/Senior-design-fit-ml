#ifndef BT_IMU_H_
#define BT_IMU_H_

#include <zephyr/drivers/sensor.h>

#define BT_UUID_IMU_SERVICE_VAL BT_UUID_128_ENCODE(0x00001523, 0x1212, 0xefde, 0x1523, 0x785feabcd123)

#define BT_UUID_IMU_SERVICE BT_UUID_DECLARE_128(BT_UUID_IMU_SERVICE_VAL)

// IMU charactersitic UUID
#define BT_UUID_IMU_VAL                                                                   \
	BT_UUID_128_ENCODE(0x00001526, 0x1212, 0xefde, 0x1523, 0x785feabcd123)

#define BT_UUID_IMU BT_UUID_DECLARE_128(BT_UUID_IMU_VAL)

/*old code*/
#define BT_UUID_LBS_BUTTON_VAL                                                                     \
	BT_UUID_128_ENCODE(0x00001524, 0x1212, 0xefde, 0x1523, 0x785feabcd123)

/** @brief LED Characteristic UUID. */
#define BT_UUID_LBS_LED_VAL BT_UUID_128_ENCODE(0x00001525, 0x1212, 0xefde, 0x1523, 0x785feabcd123)
#define BT_UUID_LBS_BUTTON BT_UUID_DECLARE_128(BT_UUID_LBS_BUTTON_VAL)
#define BT_UUID_LBS_LED BT_UUID_DECLARE_128(BT_UUID_LBS_LED_VAL)


/** @brief Callback type for when an LED state change is received. */
typedef void (*led_cb_t)(const bool led_state);

/** @brief Callback type for when the button state is pulled. */
typedef bool (*button_cb_t)(void);

struct my_lbs_cb {
	/** LED state change callback. */
	led_cb_t led_cb;
	/** Button read callback. */
	button_cb_t button_cb;
};
/*end*/

// struct for per device data
struct imu_sensor_value {
  int32_t integer;
  int32_t fraction;
};

struct imu_data {
  struct imu_sensor_value acc[3];
  struct imu_sensor_value gyr[3];
};
struct wearable_packet {
  struct imu_data data;
  uint16_t foot_voltage;
  uint8_t pos;
};

int imu_send_notify(struct sensor_value *acc, struct sensor_value *gyr);
int imu_service_init(struct my_lbs_cb *callbacks);
void max_mtu_on_conn(struct bt_conn *current_conn);
#endif





