import numpy as np
import pandas as pd
from scipy.spatial.transform import Rotation as R
import matplotlib.pyplot as plt

# Madgwick filter class remains unchanged
class MadgwickAHRS:
    def __init__(self, sampleperiod=1/256, beta=0.1):
        self.sampleperiod = sampleperiod
        self.beta = beta
        self.quaternion = np.array([1.0, 0.0, 0.0, 0.0])  # w, x, y, z

    def update_imu(self, gyro, accel):
        q = self.quaternion
        gx, gy, gz = gyro
        ax, ay, az = accel

        norm = np.linalg.norm([ax, ay, az])
        if norm == 0:
            return
        ax, ay, az = ax / norm, ay / norm, az / norm

        _2q0 = 2.0 * q[0]
        _2q1 = 2.0 * q[1]
        _2q2 = 2.0 * q[2]
        _2q3 = 2.0 * q[3]
        _4q0 = 4.0 * q[0]
        _4q1 = 4.0 * q[1]
        _4q2 = 4.0 * q[2]
        _8q1 = 8.0 * q[1]
        _8q2 = 8.0 * q[2]
        q0q0 = q[0] ** 2
        q1q1 = q[1] ** 2
        q2q2 = q[2] ** 2
        q3q3 = q[3] ** 2

        s0 = _4q0 * q2q2 + _2q2 * ax + _4q0 * q1q1 - _2q1 * ay
        s1 = _4q1 * q3q3 - _2q3 * ax + 4.0 * q0q0 * q[1] - _2q0 * ay - _4q1 + _8q1 * q1q1 + _8q1 * q2q2 + _4q1 * az
        s2 = 4.0 * q0q0 * q[2] + _2q0 * ax + _4q2 * q3q3 - _2q3 * ay - _4q2 + _8q2 * q1q1 + _8q2 * q2q2 + _4q2 * az
        s3 = 4.0 * q1q1 * q[3] - _2q1 * ax + 4.0 * q2q2 * q[3] - _2q2 * ay
        norm = np.linalg.norm([s0, s1, s2, s3])
        if norm == 0:
            return
        s = np.array([s0, s1, s2, s3]) / norm

        qDot = 0.5 * self._quaternion_product(q, [0, gx, gy, gz]) - self.beta * s
        q += qDot * self.sampleperiod
        self.quaternion = q / np.linalg.norm(q)

    def _quaternion_product(self, a, b):
        w1, x1, y1, z1 = a
        w2, x2, y2, z2 = b
        return np.array([
            w1*w2 - x1*x2 - y1*y2 - z1*z2,
            w1*x2 + x1*w2 + y1*z2 - z1*y2,
            w1*y2 - x1*z2 + y1*w2 + z1*x2,
            w1*z2 + x1*y2 - y1*x2 + z1*w2
        ])

def detect_motion_start(df, energy_thresh=1000, window=5, skip=100, plot=False, title=""):
    acc = df[['accel_x', 'accel_y', 'accel_z']].values
    gyro = df[['gyro_x', 'gyro_y', 'gyro_z']].values
    energy = np.linalg.norm(acc, axis=1)**2 + np.linalg.norm(gyro, axis=1)**2
    smoothed = pd.Series(energy).rolling(window=10, center=True).mean().fillna(method='bfill').fillna(method='ffill')
    for i in range(skip, len(smoothed) - window):
        if np.all(smoothed[i:i+window] > energy_thresh):
            # if plot:
            #     plt.figure(figsize=(10, 3))
            #     plt.plot(smoothed)
            #     plt.axvline(i, color='red')
            #     plt.title(f"Detected motion start: {title}")
            #     plt.show()
            return i
    return 0

def process_all_imus(imu_files, sensor_order, output_path="dip_input_formatted.csv", freq=60.0, preview=False):
    all_rots = []
    all_accs = []
    min_length = float('inf')
    processed = {}

    for name in sensor_order:
        dfs = [pd.read_csv(f) for f in imu_files[name]]
        df = pd.concat(dfs, ignore_index=True)
        start_idx = detect_motion_start(df, plot=preview, title=name)
        df = df.iloc[start_idx:].reset_index(drop=True)
        processed[name] = df
        min_length = min(min_length, len(df))

    for name in sensor_order:
        df = processed[name].iloc[:min_length]
        df[['gyro_x', 'gyro_y', 'gyro_z']] = np.deg2rad(df[['gyro_x', 'gyro_y', 'gyro_z']])
        accel = df[['accel_x', 'accel_y', 'accel_z']].values
        accel_norm = accel / np.linalg.norm(accel, axis=1, keepdims=True)

        madgwick = MadgwickAHRS(sampleperiod=1.0/freq)
        quats = []
        for gx, gy, gz, ax, ay, az in zip(df['gyro_x'], df['gyro_y'], df['gyro_z'],
                                          df['accel_x'], df['accel_y'], df['accel_z']):
            madgwick.update_imu([gx, gy, gz], [ax, ay, az])
            quats.append(madgwick.quaternion)

        rot_matrices = R.from_quat(np.array(quats)[:, [1, 2, 3, 0]]).as_matrix()
        all_rots.append(rot_matrices.reshape(len(rot_matrices), -1))
        all_accs.append(accel_norm)

    dip_input = np.concatenate([np.concatenate(all_rots, axis=1), np.concatenate(all_accs, axis=1)], axis=1)
    pd.DataFrame(dip_input).to_csv(output_path, index=False)
    print(f"Saved: {output_path}")

# Example usage
if __name__ == "__main__":
    imu_files = {
        "back": [r"C:\\Users\\chitr\\OneDrive\\Desktop\\Varun\\Senior Design\\Senior Design\\aitviewer\\examples\\fitml_script_tests\\anna_dance_test\\back.csv"],
        "head": [r"C:\\Users\\chitr\\OneDrive\\Desktop\\Varun\\Senior Design\\Senior Design\\aitviewer\\examples\\fitml_script_tests\\anna_dance_test\\head_1.csv",
                 r"C:\\Users\\chitr\\OneDrive\\Desktop\\Varun\\Senior Design\\Senior Design\\aitviewer\\examples\\fitml_script_tests\\anna_dance_test\\head_2.csv"],
        "left_leg": [r"C:\\Users\\chitr\\OneDrive\\Desktop\\Varun\\Senior Design\\Senior Design\\aitviewer\\examples\\fitml_script_tests\\anna_dance_test\\left_leg.csv"],
        "left_wrist": [r"C:\\Users\\chitr\\OneDrive\\Desktop\\Varun\\Senior Design\\Senior Design\\aitviewer\\examples\\fitml_script_tests\\anna_dance_test\\left_wrist_1.csv"],
        "right_leg": [r"C:\\Users\\chitr\\OneDrive\\Desktop\\Varun\\Senior Design\\Senior Design\\aitviewer\\examples\\fitml_script_tests\\anna_dance_test\\right_leg_1.csv",
                      r"C:\\Users\\chitr\\OneDrive\\Desktop\\Varun\\Senior Design\\Senior Design\\aitviewer\\examples\\fitml_script_tests\\anna_dance_test\\right_leg_2.csv"],
        "right_wrist": [r"C:\\Users\\chitr\\OneDrive\\Desktop\\Varun\\Senior Design\\Senior Design\\aitviewer\\examples\\fitml_script_tests\\anna_dance_test\\right_wrist.csv"],
    }
    sensor_order = ["left_wrist", "right_wrist", "left_leg", "right_leg", "head", "back"]
    process_all_imus(imu_files, sensor_order, output_path="dip_input_formatted.csv", preview=True)
