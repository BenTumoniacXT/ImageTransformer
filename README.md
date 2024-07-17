# Image Style Transformer - An Image Style Transfer Application for Mobile Devices

<h3><b>Updated version: 0.3.3 (Beta 3.3) - July 2024</b></h3>

Image Style Transformer is an Image2Image and Text2Image Style Transfer application for Mobile Devices. This application allow you to create an artistic image from a content image and a style image or from a text prompt. By using Arbitrary Style Transfer and Stable Diffusion with Quantization, we were be able to bring to model down to consumer mobile devices with compatibility for iOS and Android.

<p align="center"><img src="mobile_app/demo.png" /></p>

# Programming languages:
<p align="left"> 
    <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHgAAAB4CAYAAAA5ZDbSAAAACXBIWXMAACOuAAAjrgE9qSzlAAAE7mlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgOS4xLWMwMDIgNzkuZGJhM2RhMywgMjAyMy8xMi8xMy0wNTowNjo0OSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0RXZ0PSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VFdmVudCMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDI1LjYgKFdpbmRvd3MpIiB4bXA6Q3JlYXRlRGF0ZT0iMjAyNC0wNy0xOFQwMDowNzoxNiswNzowMCIgeG1wOk1vZGlmeURhdGU9IjIwMjQtMDctMThUMDA6MDg6NDcrMDc6MDAiIHhtcDpNZXRhZGF0YURhdGU9IjIwMjQtMDctMThUMDA6MDg6NDcrMDc6MDAiIGRjOmZvcm1hdD0iaW1hZ2UvcG5nIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjRmYjYzZGExLTE1MDEtZDU0My05NzMzLWE4N2E2MmFhNTE5NyIgeG1wTU06RG9jdW1lbnRJRD0i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" alt="Python" width="40" height="40"/> 
    <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHgAAAB4CAYAAAA5ZDbSAAAACXBIWXMAAAsTAAALEwEAmpwYAAAE7mlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgOS4xLWMwMDIgNzkuZGJhM2RhMywgMjAyMy8xMi8xMy0wNTowNjo0OSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0RXZ0PSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VFdmVudCMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDI1LjYgKFdpbmRvd3MpIiB4bXA6Q3JlYXRlRGF0ZT0iMjAyNC0wNy0xOFQwMDowNjo0OCswNzowMCIgeG1wOk1vZGlmeURhdGU9IjIwMjQtMDctMThUMDA6MDc6NDgrMDc6MDAiIHhtcDpNZXRhZGF0YURhdGU9IjIwMjQtMDctMThUMDA6MDc6NDgrMDc6MDAiIGRjOmZvcm1hdD0iaW1hZ2UvcG5nIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjVjNzU5NDBjLTBmNWEtMzM0YS05NDI0LTBhZDU3OTkzNDJiNCIgeG1wTU06RG9jdW1lbnRJRD0i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" alt="Flutter" width="40" height="40"/>
    <img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4NCjwhLS0gR2VuZXJhdG9yOiBBZG9iZSBJbGx1c3RyYXRvciAxOC4xLjEsIFNWRyBFeHBvcnQgUGx1Zy1JbiAuIFNWRyBWZXJzaW9uOiA2LjAwIEJ1aWxkIDApICAtLT4NCjxzdmcgdmVyc2lvbj0iMS4xIiBpZD0iTGF5ZXJfMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgeD0iMHB4IiB5PSIwcHgiDQoJIHdpZHRoPSIxMDYuMXB4IiBoZWlnaHQ9IjEwNi4xcHgiIHZpZXdCb3g9Ii0yNTIgMzQzLjkgMTA2LjEgMTA2LjEiIGVuYWJsZS1iYWNrZ3JvdW5kPSJuZXcgLTI1MiAzNDMuOSAxMDYuMSAxMDYuMSINCgkgeG1sOnNwYWNlPSJwcmVzZXJ2ZSI+DQo8Zz4NCgk8cGF0aCBmaWxsPSIjRjA1MTM4IiBkPSJNLTE0NS45LDM3My4zYzAtMS4xLDAtMi4xLDAtMy4yYy0wLjEtMi4zLTAuMi00LjctMC42LTdjLTAuNC0yLjMtMS4xLTQuNS0yLjItNi42Yy0xLjEtMi4xLTIuNC00LTQuMS01LjYNCgkJYy0xLjctMS43LTMuNi0zLTUuNi00LjFjLTIuMS0xLjEtNC4zLTEuOC02LjYtMi4yYy0yLjMtMC40LTQuNi0wLjYtNy0wLjZjLTEuMSwwLTIuMSwwLTMuMiwwYy0xLjMsMC0yLjUsMC0zLjgsMGgtMjguMWgtMTEuNg0KCQljLTEuMywwLTIuNSwwLTMuOCwwYy0xLjEsMC0yLjEsMC0zLjIsMGMtMC42LDAtMS4yLDAtMS43LDAuMWMtMS43LDAuMS0zLjUsMC4yLTUuMiwwLjVjLTEuNywwLjMtMy40LDAuOC01LDEuNA0KCQljLTAuNSwwLjItMS4xLDAuNS0xLjYsMC43Yy0xLjYsMC44LTMsMS44LTQuNCwyLjljLTAuNCwwLjQtMC45LDAuOC0xLjMsMS4yYy0xLjcsMS43LTMsMy42LTQuMSw1LjZjLTEuMSwyLjEtMS44LDQuMy0yLjIsNi42DQoJCWMtMC40LDIuMy0wLjUsNC42LTAuNiw3YzAsMS4xLDAsMi4xLDAsMy4yYzAsMS4zLDAsMi41LDAsMy44djE3LjN2MjIuNGMwLDEuMywwLDIuNSwwLDMuOGMwLDEuMSwwLDIuMSwwLDMuMg0KCQljMC4xLDIuMywwLjIsNC43LDAuNiw3YzAuNCwyLjMsMS4xLDQuNSwyLjIsNi42YzEuMSwyLjEsMi40LDQsNC4xLDUuNmMxLjcsMS43LDMuNiwzLDUuNiw0LjFjMi4xLDEuMSw0LjMsMS44LDYuNiwyLjINCgkJYzIuMywwLjQsNC42LDAuNiw3LDAuNmMxLjEsMCwyLjEsMCwzLjIsMGMxLjMsMCwyLjUsMCwzLjgsMGgzOS43YzEuMywwLDIuNSwwLDMuOCwwYzEuMSwwLDIuMSwwLDMuMiwwYzIuMy0wLjEsNC43LTAuMiw3LTAuNg0KCQljMi4zLTAuNCw0LjUtMS4xLDYuNi0yLjJjMi4xLTEuMSw0LTIuNCw1LjYtNC4xYzEuNy0xLjcsMy0zLjYsNC4xLTUuNmMxLjEtMi4xLDEuOC00LjMsMi4yLTYuNmMwLjQtMi4zLDAuNi00LjYsMC42LTcNCgkJYzAtMS4xLDAtMi4xLDAtMy4yYzAtMS4zLDAtMi41LDAtMy44di0zOS43Qy0xNDUuOSwzNzUuOC0xNDUuOSwzNzQuNi0xNDUuOSwzNzMuM3oiLz4NCgk8cGF0aCBmaWxsPSIjRkZGRkZGIiBkPSJNLTE2OCw0MDkuNGMwLjEtMC40LDAuMi0wLjgsMC4zLTEuMmM0LjQtMTcuNS02LjMtMzguMy0yNC41LTQ5LjJjOCwxMC44LDExLjUsMjMuOSw4LjQsMzUuMw0KCQljLTAuMywxLTAuNiwyLTEsM2MtMC40LTAuMy0wLjktMC42LTEuNi0wLjljMCwwLTE4LjEtMTEuMi0zNy43LTMwLjljLTAuNS0wLjUsMTAuNSwxNS43LDIyLjksMjguOGMtNS45LTMuMy0yMi4yLTE1LjItMzIuNi0yNC42DQoJCWMxLjMsMi4xLDIuOCw0LjIsNC40LDYuMWM4LjYsMTEsMTkuOSwyNC41LDMzLjQsMzQuOWMtOS41LDUuOC0yMi45LDYuMy0zNi4yLDBjLTMuMy0xLjUtNi40LTMuNC05LjMtNS41DQoJCWM1LjYsOSwxNC4zLDE2LjgsMjQuOSwyMS40YzEyLjYsNS40LDI1LjIsNS4xLDM0LjUsMC4xbDAsMGMwLDAsMC4xLDAsMC4xLTAuMWMwLjQtMC4yLDAuOC0wLjUsMS4yLTAuN2M0LjUtMi4zLDEzLjMtNC42LDE4LjEsNC42DQoJCUMtMTYxLjMsNDMyLjYtMTU4LjgsNDIwLjYtMTY4LDQwOS40Qy0xNjgsNDA5LjQtMTY4LDQwOS40LTE2OCw0MDkuNHoiLz4NCjwvZz4NCjwvc3ZnPg0K" alt="Swift" width="40" height="40"/> 
    <img src="data:image/png;base64,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" alt="Java" width="40" height="40"/>
</p>

- Mobile Application: Flutter with Swift and Java for Platform-specific codebases
- Model Creation: Python with Tensorflow and ONNX (Models have been distributed through ONNX Runtime and TFLite)

# Model Creation:
In order to generate models, run the selected notebook based on which model you want to create inside folder <i>model_builder</i>. Python 3.9.x or 3.10.x are recommended.

- For Stable Diffusion models, Tensorflow 2.12.x or 2.13.x are required, newer version will not work with the app due to some problems while generating models. You will also need to install keras_cv along it and config the model output directory to put inside . Due to some problems with keras_cv library, this notebook will only work on Linux (WSL is not tested).

- For Arbitrary Style Transfer, you need to run the notebook on Google Colab due to some code will not work on local machine. This also mean the need to download the model after executing the notebook.

# Compile Mobile Application
In order to compile the application, you need to have Flutter SDK installed on your machine with Android SDK for Android devices or iOS SDK for iPhone devices. After that, make sure you have every assets required inside these folder before compiling this project:

- <i>mobile_app/assets/models</i> 
- <i>mobile_app/android/app/src/main/assets/t2i/diffusion/</i> 
- <i>mobile_app/ios/Runner/Resources/T2I/Diffusion/</i> 

When finished go to mobile_app folder and compile the project to the targeted devices to run.

<b><i>Notes: This project is not optimized for Android Tablet and iPad yet, also please do not compile on Windows and macOS, it will not work apparently.</i></b>

# Future Plan

- Implement Diffusion Inpainting feature inside the application
- Optimize application for Tablet and Desktop devices
- Experiment with Stable Diffusion XL and Stable Diffusion 3 with Negative Prompt
- Improving Arbitrary Style Transfer models for better computing performance

# Contribution and References

First of all, I would like to thank you Nguyen Duy Dat, one of my longtime co-worker supported me in model creating and project planning for this project.

I would also want to credit these repositories and scientific papers, these are the references which have heavy contribution to the creation of this project:

- https://github.com/Anthrapper/On-Device-Stable-Diffusion
- https://github.com/freedomtan/keras_cv_stable_diffusion_to_tflite
- https://github.com/pguijas/artiluxio
- https://www.tensorflow.org/hub/tutorials/tf2_arbitrary_image_stylization
- https://arxiv.org/abs/1705.06830

Also, feel free to support this project. Every contribution for this project is appreciated.