#include <zephyr/kernel.h>
#include <zephyr/logging/log.h>
#include <zephyr/bluetooth/bluetooth.h>
#include <zephyr/bluetooth/gap.h>
#include <zephyr/bluetooth/uuid.h>
#include <zephyr/bluetooth/conn.h>
// #include <dk_buttons_and_leds.h>

#include "main.h"
#include "imu_service.h"
#include "imu_driver.h"
LOG_MODULE_REGISTER(ble_imu_wearable, LOG_LEVEL_INF);

#define LED0_NODE DT_ALIAS(led0)

static uint32_t app_sensor_value = 100;

static bool app_button_state;

static struct sensor_value acc[3], gyr[3];

static void on_connected(struct bt_conn *conn, uint8_t err) {
	if (err) {
		printk("Connection failed (err %u)\n", err);
		return;
	}

  max_mtu_on_conn(conn);

	printk("Connected\n");

	// dk_set_led_on(CON_STATUS_LED);
}

static void on_disconnected(struct bt_conn *conn, uint8_t reason) {
	printk("Disconnected (reason %u)\n", reason);

	// dk_set_led_off(CON_STATUS_LED);
}

struct bt_conn_cb connection_callbacks = {
	.connected = on_connected,
	.disconnected = on_disconnected,
};

void send_data_thread(void)
{
	while (1) {
		/* Simulate data */
		/* Send notification, the function sends notifications only if a client is subscribed */
    app_sensor_value = acc[0].val1;
		if(imu_send_notify(acc, gyr)) {
      LOG_ERR("Failed to send data\n");
    }
    LOG_INF("sending data... %d \n", app_sensor_value);
    LOG_INF("AX: %d.%06d; AY: %d.%06d; AZ: %d.%06d; "
        "GX: %d.%06d; GY: %d.%06d; GZ: %d.%06d;\n",
        acc[0].val1, acc[0].val2,
        acc[1].val1, acc[1].val2,
        acc[2].val1, acc[2].val2,
        gyr[0].val1, gyr[0].val2,
        gyr[1].val1, gyr[1].val2,
        gyr[2].val1, gyr[2].val2);
		k_sleep(K_MSEC(50));
	}
}

void collect_imu_data_thread(void)
{
  while (1) {
    get_imu_data(acc, gyr);
    k_sleep(K_MSEC(100));
  }
}

static void app_led_cb(bool led_state)
{
	// dk_set_led(USER_LED, led_state);
}

static bool app_button_cb(void)
{
	return app_button_state;
}

static struct my_lbs_cb app_callbacks = {
	.led_cb = app_led_cb,
	.button_cb = app_button_cb,
};


int main(void)
{
  int blink_status = 0;
	int err;

	LOG_INF("Starting Lesson 4 - Exercise 2 \n");

	// err = dk_leds_init();
	// if (err) {
	// 	LOG_ERR("LEDs init failed (err %d)\n", err);
	// 	return -1;
	// }

  if (bmi_init()) {
    LOG_ERR("Failed to initialize IMU sensor\n");
  } else{
    LOG_INF("IMU sensor initialized\n");
  }

	err = bt_enable(NULL);
	if (err) {
		LOG_ERR("Bluetooth init failed (err %d)\n", err);
		return -1;
	}
	bt_conn_cb_register(&connection_callbacks);

  if (imu_service_init(&app_callbacks)) {
    LOG_ERR("Failed to initialize IMU service\n");
  }

  if (bt_le_adv_start(adv_param, ad, ARRAY_SIZE(ad), sd, ARRAY_SIZE(sd))) {
    LOG_ERR("Advertising failed to start\n");
  }

  for (;;) {
		// dk_set_led(RUN_STATUS_LED, (++blink_status) % 2);
		k_sleep(K_MSEC(RUN_LED_BLINK_INTERVAL));
	}

}
//define a thread
K_THREAD_DEFINE(send_data_thread_id, STACKSIZE, send_data_thread, NULL, NULL, NULL, PRIORITY, 0, 0);

K_THREAD_DEFINE(collect_imu_data_thread_id, STACKSIZE, collect_imu_data_thread, NULL, NULL, NULL, PRIORITY, 0, 0);