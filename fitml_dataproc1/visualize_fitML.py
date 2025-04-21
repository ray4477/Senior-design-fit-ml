import numpy as np
from aitviewer.configuration import CONFIG as C
from aitviewer.models.smpl import SMPLLayer
from aitviewer.renderables.smpl import SMPLSequence
from aitviewer.viewer import Viewer
from scipy.spatial.transform import Rotation as R

# === Load your prediction data ===
path = r"C:\Users\chitr\OneDrive\Desktop\Varun\Senior Design\Senior Design\aitviewer\examples\fitml_script_tests\inference_pose_data\custom_dipimu_sample_all_frames.npz"
data = np.load(path, allow_pickle=True)

print("Loaded keys:", list(data.keys()))
print("Prediction shape (raw):", data["prediction"].shape)

poses_rotmat = data["prediction"]  # shape: (1, T, 216)
poses_rotmat = poses_rotmat[0]     # shape: (T, 216)
print("Prediction shape after squeeze:", poses_rotmat.shape)

# === Reshape into (T, 24, 3, 3) ===
T = poses_rotmat.shape[0]
poses_reshaped = poses_rotmat.reshape(T, 24, 3, 3)  # shape: (T, 24, 3, 3)
print("Reshaped to rotation matrices:", poses_reshaped.shape)

# === Convert to axis-angle for AitViewer ===
poses_reshaped_flat = poses_reshaped.reshape(-1, 3, 3)  # shape: (T*24, 3, 3)
print("Reshaped for axis-angle conversion:", poses_reshaped_flat.shape)

poses_axis_angle = R.from_matrix(poses_reshaped_flat).as_rotvec()  # (T*24, 3)
poses_axis_angle = poses_axis_angle.reshape(T, 24, 3)              # (T, 24, 3)
print("Converted to axis-angle:", poses_axis_angle.shape)

poses_axis_angle = poses_axis_angle.reshape(T, -1)                 # (T, 72)
print("Flattened axis-angle shape:", poses_axis_angle.shape)

# === Load SMPL model ===
smpl_layer = SMPLLayer(model_type="smplx", gender="male", device=C.device)

# === Prepare SMPLSequence ===
poses_root = poses_axis_angle[:, :3]     # global orientation (T, 3)
poses_body = poses_axis_angle[:, 9:]     # body joints (T, 69)
print("Poses root shape:", poses_root.shape)
print("Poses body shape:", poses_body.shape)

smpl_seq = SMPLSequence(poses_body=poses_body, smpl_layer=smpl_layer, poses_root=poses_root)
smpl_seq.mesh_seq.color = smpl_seq.mesh_seq.color[:3] + (0.5,)  # semi-transparent

# === Launch Viewer ===
v = Viewer()
v.playback_fps = 30.0
v.scene.add(smpl_seq)
v.run()
