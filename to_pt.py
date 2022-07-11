import torch
import torchvision
import coremltools as ct
import numpy as np
import sys
import pickle
from training.networks_stylegan2 import Generator
from torch.utils.mobile_optimizer import optimize_for_mobile

torch.set_grad_enabled(False)

try:
  file_path = sys.argv[1]
except:
  file_path = 'models/gamma16fid23.pkl'

class Model(torch.nn.Module):
    def __init__(self, file_path):
        """
        In the constructor we instantiate four parameters and assign them as
        member parameters.
        """
        super().__init__()
        self.G = Generator(z_dim=512, c_dim=0, w_dim=512, img_resolution=512, img_channels=3)
        self.G.load_state_dict(pickle.load(open(file_path, 'rb'))['G_ema'].state_dict())

    def forward(self, z):
        """
        In the forward function we accept a Tensor of input data and we must return
        a Tensor of output data. We can use Modules defined in the constructor as
        well as arbitrary operators on Tensors.
        """
        lo, hi = [-1, 1]
        img = self.G(z, None, truncation_psi=0.3, update_emas=False, noise_mode='none')
        img = (img - lo) * (255 / (hi - lo))
        return torch.round(img).clip(0, 255).to(torch.uint8) #



G = Model(file_path)
G.eval()
example_input = torch.randn(1, 512)

traced_model = torch.jit.trace(G, example_input)
torchscript_model_optimized = optimize_for_mobile(traced_model)
torchscript_model_optimized._save_for_lite_interpreter("../AdaptaboIs/YuanStyleGAN.pt")

