#include <zephyr/kernel.h>
#include <zephyr/bluetooth/bluetooth.h>
#include <zephyr/bluetooth/gap.h>
#include <zephyr/bluetooth/uuid.h>
#include <zephyr/bluetooth/conn.h>
// #include <dk_buttons_and_leds.h>
#include <zephyr/drivers/gpio.h>

#include "main.h"
#include "imu_service.h"
#include "imu_driver.h"

#define LED0_NODE DT_ALIAS(led0)
static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(LED0_NODE, gpios);

void set_led(bool led_state)
{
  if (led_state == true) {
    gpio_pin_set_dt(&led, 1);
  } else {
    gpio_pin_set_dt(&led, 0);
  }
}

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
    }

		k_sleep(K_MSEC(200));
	}
}

void collect_imu_data_thread(void)
{
  while (1) {
    if(get_imu_data(acc, gyr) == -1){
      // set_led(true);
    }
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
  //init LEDs
	int ret;
	bool led_state = true;

	if (!gpio_is_ready_dt(&led)) {
		return 0;
	}

	ret = gpio_pin_configure_dt(&led, GPIO_OUTPUT_ACTIVE);
	if (ret < 0) {
		return 0;
	}

  if (bmi_init()) {
  } else{
  }

	err = bt_enable(NULL);
	if (err) {
		return -1;
	}
	bt_conn_cb_register(&connection_callbacks);

  if (imu_service_init(&app_callbacks)) {
  }

  if (bt_le_adv_start(adv_param, ad, ARRAY_SIZE(ad), sd, ARRAY_SIZE(sd))) {
  }
  set_led(true);

  for (;;) {
    ret = gpio_pin_toggle_dt(&led);
    k_sleep(K_MSEC(RUN_LED_BLINK_INTERVAL));
	}

}
//define a thread
K_THREAD_DEFINE(send_data_thread_id, STACKSIZE, send_data_thread, NULL, NULL, NULL, PRIORITY, 0, 0);

K_THREAD_DEFINE(collect_imu_data_thread_id, STACKSIZE, collect_imu_data_thread, NULL, NULL, NULL, PRIORITY, 0, 0);