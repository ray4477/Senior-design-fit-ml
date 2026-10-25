#include <zephyr/kernel.h>
#include <zephyr/bluetooth/bluetooth.h>
#include <zephyr/bluetooth/gap.h>
#include <zephyr/bluetooth/uuid.h>
#include <zephyr/bluetooth/conn.h>
// #include <dk_buttons_and_leds.h>
#include <zephyr/drivers/gpio.h>
#include <zephyr/drivers/adc.h>

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

/* foot pressure sensors on AIN4 (P0.28) and AIN6 (P0.30), see app1.overlay */
static const struct adc_dt_spec foot_adc[2] = {
  ADC_DT_SPEC_GET_BY_IDX(DT_PATH(zephyr_user), 0),
  ADC_DT_SPEC_GET_BY_IDX(DT_PATH(zephyr_user), 1),
};

static int foot_adc_init(void)
{
  for (int i = 0; i < 2; i++) {
    if (!adc_is_ready_dt(&foot_adc[i]) || adc_channel_setup_dt(&foot_adc[i])) {
      return -1;
    }
  }
  return 0;
}

/* sample both channels in one sequence, results in millivolts */
static int read_foot_mv(uint16_t mv_out[2])
{
  int16_t buf[2];
  struct adc_sequence seq = {
    .buffer = buf,
    .buffer_size = sizeof(buf),
  };

  adc_sequence_init_dt(&foot_adc[0], &seq);
  seq.channels |= BIT(foot_adc[1].channel_id);

  if (adc_read(foot_adc[0].dev, &seq)) {
    return -1;
  }
  for (int i = 0; i < 2; i++) {
    int32_t mv = buf[i];
    adc_raw_to_millivolts_dt(&foot_adc[i], &mv);
    mv_out[i] = mv < 0 ? 0 : mv; /* single-ended can read slightly negative */
  }
  return 0;
}

/* one sample, passed collector -> sender through imu_q so it is always consistent */
struct imu_sample {
  struct sensor_value acc[3], gyr[3];
  uint16_t foot_mv[2];
};

#define IMU_QUEUE_DEPTH 16
K_MSGQ_DEFINE(imu_q, sizeof(struct imu_sample), IMU_QUEUE_DEPTH, 4);

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
  struct imu_sample s;

	while (1) {
    k_msgq_get(&imu_q, &s, K_FOREVER);
		/* Send notification, the function sends notifications only if a client is subscribed */
		if(imu_send_notify(s.acc, s.gyr, s.foot_mv)) {
    }
	}
}

#define IMU_SAMPLE_PERIOD_MS 10

static K_SEM_DEFINE(imu_sample_sem, 0, 1);

static void imu_timer_expiry(struct k_timer *timer)
{
  k_sem_give(&imu_sample_sem);
}

static K_TIMER_DEFINE(imu_timer, imu_timer_expiry, NULL);

void collect_imu_data_thread(void)
{
  /* periodic timer reschedules from the previous expiry, so it doesn't drift */
  k_timer_start(&imu_timer, K_MSEC(IMU_SAMPLE_PERIOD_MS), K_MSEC(IMU_SAMPLE_PERIOD_MS));

  struct imu_sample s;

  while (1) {
    k_sem_take(&imu_sample_sem, K_FOREVER);
    if(get_imu_data(s.acc, s.gyr) == -1){
      // set_led(true);
      continue;
    }
    /* a failed ADC read reports 0 mV rather than dropping the IMU data */
    if (read_foot_mv(s.foot_mv)) {
      s.foot_mv[0] = s.foot_mv[1] = 0;
    }
    /* if the sender fell behind, drop the oldest sample to make room */
    while (k_msgq_put(&imu_q, &s, K_NO_WAIT) != 0) {
      struct imu_sample dropped;
      k_msgq_get(&imu_q, &dropped, K_NO_WAIT);
    }
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

  if (foot_adc_init()) {
    printk("Foot ADC init failed\n");
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