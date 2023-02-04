
# Cairo 1.0 Installer
This project **(no official)** install a versión of **Cairo 1.0** (the versions are specified below).

<div align="center">
<img src="https://user-images.githubusercontent.com/58611754/216784658-9dc15953-fc7e-4dd7-8ba3-03cb69d0565b.png">
</div>

## Warning ⚠️
This project was only tested on **Ubuntu 20.04**, so it is **highly recommended** to only use it on these distributions, **please make a restore point before trying this (nothing should happen but you never know).**

This script is not a definitive way to install Cairo 1.0, as there is currently no documentation source I tried to save people a few steps in the way that worked for me. NO need to run with sudo

## How to use
1. Clone the repo
```
git clone https://github.com/sdgalvan/cairo-installer.git
```
2. Go to the installer.sh folder
```
cd cairo-installer
```
3. Run installer.sh with cairo version 

The supported versions are the following:

| [Cairo Releases](https://github.com/starkware-libs/cairo/releases/)  | Parameter |
| -------------  | ------------- |
| [v1.0.0-alpha-2](https://github.com/starkware-libs/cairo/releases/tag/v1.0.0-alpha.2)   | 1.0.0-alpha-2 |
```
source ./installer.sh 1.0.0-alpha-2
```

## Video (Speed x5)
https://user-images.githubusercontent.com/58611754/216782590-761dc16f-dafe-4813-8789-f5907bba5ec9.mp4

## Special Thanks ✨

<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://twitter.com/dpinoness"><img src="https://pbs.twimg.com/profile_images/1587466995762618369/lTHHd9UL_400x400.jpg" width="100px;" alt="dpinones "/><br /><sub><b>@dpinoness</b></sub></a><br /><a href="https://twitter.com/dpinoness" title="Twitter"></a></td>
    </tr>
  </tbody>
</table>

- [dpinoness](https://github.com/dpinones): for showing me how the installation process was, I simply based myself on those steps to automate this, the credit belongs to him. Also the base project is from their [Exploring Cairo 1.0](https://github.com/dpinones/exploring-of-cairo-1) repository 🤣 (next step if you want to learn more about syntax).
