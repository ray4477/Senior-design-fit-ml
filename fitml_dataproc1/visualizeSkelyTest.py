import numpy as np
import pandas as pd
import torch
from scipy.spatial.transform import Rotation as R
from aitviewer.viewer import Viewer
from aitviewer.models.smpl import SMPLLayer
from aitviewer.renderables.smpl import SMPLSequence
from aitviewer.configuration import CONFIG as C

# Load the formatted data
csv_path = "dip_input_formatted.csv"
data = pd.read_csv(csv_path).values

# Extract rotation matrices from CSV (first 54 columns)
rot_matrices_flat = data[:, :54]  # shape: (T, 54)
rot_matrices = rot_matrices_flat.reshape((-1, 6, 3, 3))  # (T, 6 sensors, 3, 3)

# # Head IMU correction from IMU frame (X=right, Y=forward, Z=up) to SMPL frame (X=right, Y=up, Z=forward)
# R_corr = np.array([
#     [1, 0, 0],  # X stays the same
#     [0, 0, 1],  # Y -> Z
#     [0, 1, 0],  # Z -> Y
# ])

# # Compute reference-to-SMPL transform using the first head frame
# R_head_init = rot_matrices[0, 1]  # index 1 = head
# R_ref_to_SMPL = R_corr @ R_head_init

# # Apply alignment to all sensors
# rot_matrices_aligned = np.zeros_like(rot_matrices)
# for i in range(6):
#     for t in range(rot_matrices.shape[0]):
#         rot_matrices_aligned[t, i] = R_ref_to_SMPL.T @ rot_matrices[t, i]
rot_matrices_aligned = rot_matrices

# SMPL joint indices for sensor mapping
sensor_joint_indices = {
    "left_wrist": 20,
    "right_wrist": 21,
    "left_leg": 4,      # left_knee
    "right_leg": 5,     # right_knee
    "head": 15,
    "back": 3           # pelvis
}

# Create empty pose sequence with identity rotations (T, 24, 3, 3)
T = rot_matrices.shape[0]
NUM_BODY_JOINTS = 21  # update to match your SMPL model version
pose_rotmats = np.tile(np.eye(3)[None, None, :, :], (T, NUM_BODY_JOINTS + 1, 1, 1))

# Insert aligned rotations into correct SMPL joints
sensor_order = ["left_wrist", "right_wrist", "left_leg", "right_leg", "head", "back"]
for i, sensor in enumerate(sensor_order):
    joint_idx = sensor_joint_indices[sensor] 
    pose_rotmats[:, joint_idx] = rot_matrices_aligned[:, i]

# Convert rotation matrices to axis-angle (T, 24, 3)
pose_axis_angles = R.from_matrix(pose_rotmats.reshape(-1, 3, 3)).as_rotvec()
pose_axis_angles = pose_axis_angles.reshape(T, NUM_BODY_JOINTS + 1, 3)

# Split root and body poses
poses_root = pose_axis_angles[:, 0]  # (T, 3)
poses_body = pose_axis_angles[:, 1:NUM_BODY_JOINTS + 1].reshape(T, -1)

# Create SMPL layer
smpl_layer = SMPLLayer(model_type="smplx", gender="male", device=C.device)

# Adjust poses_body to match expected dimensions
expected = smpl_layer.bm.NUM_BODY_JOINTS * 3
if poses_body.shape[1] != expected:
    print(f"[!] Adjusting pose shape from {poses_body.shape[1]} to {expected}.")
    padded = np.zeros((T, expected))
    padded[:, :poses_body.shape[1]] = poses_body
    poses_body = padded

# Create viewer and SMPLSequence
viewer = Viewer()
smpl_seq = SMPLSequence(
    poses_body=torch.from_numpy(poses_body).float().to(C.device),
    poses_root=torch.from_numpy(poses_root).float().to(C.device),
    smpl_layer=smpl_layer,
    name="SensorPose",
    color=[0.8, 0.3, 0.3, 1.0]  # RGBA
)

viewer.scene.add(smpl_seq)
viewer.run()
