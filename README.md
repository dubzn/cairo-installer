
# Cairo 1.0 Installer
This project **(no official)** install a versión of **Cairo 1.0** (the versions are specified below).

<div align="center">
<img src="https://user-images.githubusercontent.com/58611754/216784658-9dc15953-fc7e-4dd7-8ba3-03cb69d0565b.png">
</div>

## Warning ⚠️
This project was only tested on **Ubuntu 20.04**, so it is **highly recommended** to only use it on these distributions, **please make a restore point before trying this (nothing should happen but you never know).** Use it at your own risk :P

This script is not a definitive way to install Cairo 1.0, as there is currently no documentation source I tried to save people a few steps in the way that worked for me. NO need to run with sudo. 

Note that this does not remove any previous Cairo versions, but if you have one currently installed, it may cause conflicts.

## How to use
### Install
1. Clone the repo
```
git clone https://github.com/sdgalvan/cairo-installer.git
```
2. Go to the installer.sh folder
```
cd cairo-installer
```
3. Run installer.sh with cairo version 

3.a Install the latest version by simply running
```
source installer.sh
```

3.b Optionally, you can choose one of the available versions in the following table:
| [Cairo Releases](https://github.com/starkware-libs/cairo/releases/)  | Parameter |
| -------------  | ------------- |
| [v1.0.0-alpha-2](https://github.com/starkware-libs/cairo/releases/tag/v1.0.0-alpha.2)   | 1.0.0-alpha-2 |

```
source installer.sh 1.0.0-alpha-2
```
4. If everything went well, you should see something like this:
![image](https://user-images.githubusercontent.com/58611754/217097377-8883dc47-bc4a-431b-b821-b952cfcd8e8d.png)

### Change version
1. Clone the repo
```
git clone https://github.com/sdgalvan/cairo-installer.git
```
2. Go to the version-manager.sh folder
```
cd cairo-installer
```
3. Run version-manager.sh with cairo version 
| [Cairo Releases](https://github.com/starkware-libs/cairo/releases/)  | Parameter |
| -------------  | ------------- |
| [v1.0.0-alpha-2](https://github.com/starkware-libs/cairo/releases/tag/v1.0.0-alpha.2)   | 1.0.0-alpha-2 |

```
source version-manager.sh 1.0.0-alpha-2
```
4. If everything went well, you should see something like this:
![image](https://user-images.githubusercontent.com/58611754/218343764-ddf408be-0235-400a-b854-7a79e7082c7f.png)

## Video
https://user-images.githubusercontent.com/58611754/217096040-404e7f74-9d34-4a98-8b51-cb422157c271.mp4

## Special Thanks ✨

<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://twitter.com/dpinoness"><img src="https://pbs.twimg.com/profile_images/1587466995762618369/lTHHd9UL_400x400.jpg" width="100px;" alt="dpinones "/><br /><sub><b>@dpinoness</b></sub></a><br /><a href="https://twitter.com/dpinoness" title="Twitter"></a></td>
    </tr>
  </tbody>
</table>

- [dpinoness](https://github.com/dpinones): for showing me how the installation process was, I simply based myself on those steps to automate this, the credit belongs to him. Also the base project is from their [Exploring Cairo 1.0](https://github.com/dpinones/exploring-of-cairo-1) repository 🤣 (next step if you want to learn more about syntax).
