#ifndef IMU_DRIVER_H
#define IMU_DRIVER_H
 #include <zephyr/drivers/sensor.h>
 
int get_imu_data(struct sensor_value *acc, struct sensor_value *gyr);

int bmi_init(void);

#endif