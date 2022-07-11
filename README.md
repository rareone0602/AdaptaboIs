# AdaptaboIs
iOS On-device sampler from styleGAN2 pkl files

# Build

1. `pod install`
1. `git clone https://github.com/NVlabs/stylegan3.git` and train a newtork like `network-snapshot-001234.pkl` checkpoint in training-runs folder in config styleGAN2
1. `mv to_pt.py stylegan3` and `cd stylegan3`
1. `python3 to_pt.py PATH_TO_YOUR_PKL_FILE`
1. Okay tried to build it on Xcode


# Todo
1. I cannot utilize GPU currently.
2. I didn't test it on other computer so if there's any issue please feel free to report

# Acknowledgement
Thank [YuanYuan](https://twitter.com/Lord_YuanYuan) for space to demo on FF39
