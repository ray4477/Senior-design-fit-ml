#include <zephyr/types.h>
#include <stddef.h>
#include <string.h>
#include <errno.h>
#include <zephyr/sys/printk.h>
#include <zephyr/sys/byteorder.h>
#include <zephyr/kernel.h>
#include <zephyr/bluetooth/bluetooth.h>
#include <zephyr/bluetooth/hci.h>
#include <zephyr/bluetooth/conn.h>
#include <zephyr/bluetooth/uuid.h>
#include <zephyr/bluetooth/gatt.h>

#include "imu_service.h"

static struct bt_gatt_indicate_params ind_params;

static bool notify_mysensor_enabled;
static bool indicate_enabled;
static bool button_state;
static struct my_lbs_cb lbs_cb;

static void exchange_func(struct bt_conn *conn, uint8_t err,
  struct bt_gatt_exchange_params *params)
{
  if (!err) {
      /* According to 3.4.7.1 Handle Value Notification off the ATT protocol.
       * Maximum supported notification is ATT_MTU - 3 */
      uint32_t bt_max_send_len = bt_gatt_get_mtu(conn) - 3;
  }
}

// static struct bt_gatt_exchange_params {
//   struct bt_att_req *req;
//   void (*func)(struct bt_conn *conn, uint8_t err, struct bt_gatt_exchange_params *params);
// };

static struct bt_gatt_exchange_params exchange_params = {
  .func = exchange_func,
};
static int rc = 0;

void max_mtu_on_conn(struct bt_conn *current_conn) {
  /* maximize ATT MTU at peer side (CONFIG_BT_L2CAP_TX_MTU)*/
  exchange_params.func = exchange_func;
  rc = bt_gatt_exchange_mtu(current_conn, &exchange_params);
  if (rc) {
  }
}

static void mylbsbc_ccc_cfg_changed(const struct bt_gatt_attr *attr, uint16_t value)
{
	indicate_enabled = (value == BT_GATT_CCC_INDICATE);
}

/* STEP 13 - Define the configuration change callback function for the MYSENSOR characteristic */
static void mylbsbc_ccc_mysensor_cfg_changed(const struct bt_gatt_attr *attr, uint16_t value)
{
	notify_mysensor_enabled = (value == BT_GATT_CCC_NOTIFY);
}

static ssize_t write_led(struct bt_conn *conn, const struct bt_gatt_attr *attr, const void *buf,
  uint16_t len, uint16_t offset, uint8_t flags)
{

if (len != 1U) {
return BT_GATT_ERR(BT_ATT_ERR_INVALID_ATTRIBUTE_LEN);
}

if (offset != 0) {
return BT_GATT_ERR(BT_ATT_ERR_INVALID_OFFSET);
}

if (lbs_cb.led_cb) {
// Read the received value
uint8_t val = *((uint8_t *)buf);

if (val == 0x00 || val == 0x01) {
 // Call the application callback function to update the LED state
 lbs_cb.led_cb(val ? true : false);
} else {

 return BT_GATT_ERR(BT_ATT_ERR_VALUE_NOT_ALLOWED);
}
}

return len;
}

static ssize_t read_button(struct bt_conn *conn, const struct bt_gatt_attr *attr, void *buf,
    uint16_t len, uint16_t offset)
{
// get a pointer to button_state which is passed in the BT_GATT_CHARACTERISTIC() and stored in attr->user_data
const char *value = attr->user_data;


if (lbs_cb.button_cb) {
// Call the application callback function to update the get the current value of the button
button_state = lbs_cb.button_cb();
return bt_gatt_attr_read(conn, attr, buf, len, offset, value, sizeof(*value));
}

return 0;
}

BT_GATT_SERVICE_DEFINE(
	imu_svc, BT_GATT_PRIMARY_SERVICE(BT_UUID_IMU_SERVICE),

  //old code
  BT_GATT_CHARACTERISTIC(BT_UUID_LBS_BUTTON, BT_GATT_CHRC_READ | BT_GATT_CHRC_INDICATE,
    BT_GATT_PERM_READ, read_button, NULL, &button_state),
/* STEP 2 - Create and add the Client Characteristic Configuration Descriptor */
BT_GATT_CCC(mylbsbc_ccc_cfg_changed, BT_GATT_PERM_READ | BT_GATT_PERM_WRITE),

BT_GATT_CHARACTERISTIC(BT_UUID_LBS_LED, BT_GATT_CHRC_WRITE, BT_GATT_PERM_WRITE, NULL,
    write_led, NULL),


	/* STEP 12 - Create and add the MYSENSOR characteristic and its CCCD  */
	BT_GATT_CHARACTERISTIC(BT_UUID_IMU, BT_GATT_CHRC_NOTIFY, BT_GATT_PERM_NONE, NULL,
			       NULL, NULL),
	BT_GATT_CCC(mylbsbc_ccc_mysensor_cfg_changed, BT_GATT_PERM_READ | BT_GATT_PERM_WRITE),

);


int imu_service_init(struct my_lbs_cb *callbacks) {
  if (callbacks) {
		lbs_cb.led_cb = callbacks->led_cb;
		lbs_cb.button_cb = callbacks->button_cb;
	}
  return 0;

}

static uint32_t ascii_sensor_value = 0;
static char hello_world[] = "Hello, World!";

static struct wearable_packet packet;

//send imu data to the client
int imu_send_notify(struct sensor_value *acc, struct sensor_value *gyr) 
{
	if (!notify_mysensor_enabled) {
		return -EACCES;
	}

  packet.data.acc[0].integer = acc[0].val1;
  packet.data.acc[0].fraction = acc[0].val2;
  packet.data.acc[1].integer = acc[1].val1;
  packet.data.acc[1].fraction = acc[1].val2;
  packet.data.acc[2].integer = acc[2].val1;
  packet.data.acc[2].fraction = acc[2].val2;
  packet.data.gyr[0].integer = gyr[0].val1;
  packet.data.gyr[0].fraction = gyr[0].val2;
  packet.data.gyr[1].integer = gyr[1].val1;
  packet.data.gyr[1].fraction = gyr[1].val2;
  packet.data.gyr[2].integer = gyr[2].val1;
  packet.data.gyr[2].fraction = gyr[2].val2;

  packet.foot_voltage = 222;
  packet.pos = 3;

  return bt_gatt_notify(NULL, &imu_svc.attrs[7], &packet, sizeof(packet));

  //x61 to x7a
  //loop sensor value from x61 to x7a
  
  // ascii_sensor_value = (ascii_sensor_value + 1) % 26;

	// return bt_gatt_notify(NULL, &imu_svc.attrs[7], &hello_world, sizeof(hello_world));
}