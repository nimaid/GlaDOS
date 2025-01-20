<a href="https://trendshift.io/repositories/9828" target="_blank"><img src="https://trendshift.io/api/badge/repositories/9828" alt="dnhkng%2FGlaDOS | Trendshift" style="width: 250px; height: 55px;" width="250" height="55"/></a>

# GLaDOS Personality Core
This is a project dedicated to building a real-life version of GLaDOS!

NEW: If you want to chat or join the community, [Join our discord!](https://discord.com/invite/ERTDKwpjNB) If you want to support, [sponsor the project here!](https://ko-fi.com/dnhkng)

https://github.com/user-attachments/assets/c22049e4-7fba-4e84-8667-2c6657a656a0

## Update 3-1-2025 *Got GLaDOS running on an 8Gb SBC!*

https://github.com/user-attachments/assets/99e599bb-4701-438a-a311-8e6cd595796c

This is really tricky, so only for hardcore geeks! Checkout the 'rock5b' branch, and my OpenAI API for the [RK3588 NPU system](https://github.com/dnhkng/RKLLM-Gradio)
Don't expect support for this, it's in active development, and requires lots of messing about in armbian linux etc.

## Goals
*This is a hardware and software project that will create an aware, interactive, and embodied GLaDOS.*

This will entail:
- [x] Train GLaDOS voice generator
- [x] Generate a prompt that leads to a realistic "Personality Core"
- [ ] Generate a medium- and long-term memory for GLaDOS (Probably a custom vector DB in a simpy Numpy array!) 
- [ ] Give GLaDOS vision via a VLM (either a full VLM for everything, or a 'vision module' using a tiny VLM the GLaDOS can function call!)
- [ ] Create 3D-printable parts
- [ ] Design the animatronics system



## Software Architecture
The initial goals are to develop a low-latency platform, where GLaDOS can respond to voice interactions within 600ms.

To do this, the system constantly records data to a circular buffer, waiting for [voice to be detected](https://github.com/snakers4/silero-vad). When it's determined that the voice has stopped (including detection of normal pauses), it will be [transcribed quickly](https://github.com/huggingface/distil-whisper). This is then passed to streaming [local Large Language Model](https://github.com/ggerganov/llama.cpp), where the streamed text is broken by sentence, and passed to a [text-to-speech system](https://github.com/rhasspy/piper). This means further sentences can be generated while the current is playing, reducing latency substantially.

### Subgoals
 - The other aim of the project is to minimize dependencies, so this can run on constrained hardware. That means no PyTorch or other large packages.
 - As I want to fully understand the system, I have removed a large amount of redirection: which means extracting and rewriting code.

## Hardware System
This will be based on servo- and stepper-motors. 3D printable STL will be provided to create GlaDOS's body, and she will be given a set of animations to express herself. The vision system will allow her to track and turn toward people and things of interest.

# Installation Instruction
Try this simplified process, but be aware it's still in the experimental stage!  For all operating systems, you'll first need to install Ollama to run the LLM.

## Ollama Installation Process (required for all operating systems)
1. Download and install [Ollama](https://github.com/ollama/ollama) for your operating system.
2. Once installed, download a small 2B model for testing, at a terminal or command prompt use: `ollama pull llama3.2`

Note: You can use any OpenAI or Ollama compatible server, local or cloud based. Just edit the glados_config.yaml and update the completion_url, model and the api_key if necessary.

## Driver Installation Process (required for GPU acceleration)
If you are an Nvidia system running Windows, the installer will automatically install the following if they are missing: `Python`, `CUDA`, `CuDNN`. All you need to manually install is an up-to-date graphics driver.

If you are an Nvidia system running Linux or macOS, make sure you manually install the necessary drivers and CUDA, info here:
https://onnxruntime.ai/docs/install/

If you are using another accelerator (ROCm, DirectML etc.), after following the instructions below for you platform, follow up with installing the  [best onnxruntime version](https://onnxruntime.ai/docs/install/) for your system.

## Windows Installation Process
1. Download this repository, either:
   1. Download and unzip this repository somewhere in your home folder, or
   2. If you have Git set up, `git clone` this repository using `git clone github.com/dnhkng/glados.git`
2. In the repository folder, run the `install_windows.bat`, and wait until the installation in complete.
3. Double click `start_windows.bat` to start GLaDOS!

## macOS Installation Process
This is still experimental. Any issues can be addressed in the Discord server. If you create an issue related to this, you will be referred to the Discord server.  Note: I was getting Segfaults!  Please leave feedback!


1. Download this repository, either:
   1. Download and unzip this repository somewhere in your home folder, or
   2. In a terminal, `git clone` this repository using `git clone github.com/dnhkng/glados.git`
2. In a terminal, go to the repository folder and run these commands:

         chmod +x install_mac.command
         chmod +x start_mac.command

3. In the Finder, double click `install_mac.command`, and wait until the installation in complete.
4. Double click `start_mac.command` to start GLaDOS!

## Linux Installation Process
This is still experimental. Any issues can be addressed in the Discord server. If you create an issue related to this, you will be referred to the Discord server.  This has been tested on Ubuntu 24.04.1 LTS

1. Install the PortAudio library, if you don't yet have it installed:
   
         sudo apt update
         sudo apt install libportaudio2
   
2. Download this repository, either:
   1. Download and unzip this repository somewhere in your home folder, or
   2. In a terminal, `git clone` this repository using `git clone github.com/dnhkng/glados.git`
3. In a terminal, go to the repository folder and run these commands:
   
         chmod +x install_ubuntu.sh
         chmod +x start_ubuntu.sh

4. In the a terminal in the GLaODS folder, run `./install_ubuntu.sh`, and wait until the installation in complete.
5. Run  `./start_ubuntu.sh` to start GLaDOS!

## Changing the LLM Model

To use other models, use the command:
```ollama pull {modelname}```
and then add {modelname} to glados_config.yaml as the model. You can find [more models here!](https://ollama.com/library)

## Common Issues
1. If you find you are getting stuck in loops, as GLaDOS is hearing herself speak, you have two options:
   1. Solve this by upgrading your hardware. You need to you either headphone, so she can't physically hear herself speak, or a conference-style room microphone/speaker. These have hardware sound cancellation, and prevent these loops.
   2. Disable voice interruption. This means neither you nor GLaDOS can interrupt when GLaDOS is speaking. To accomplish this, edit the `glados_config.yaml`, and change `interruptible:` to  `false`.
2. If you want to the the Text UI, you should use the glados-ui.py file instead of glado.py


## Testing the submodules
You can test the systems by exploring the 'demo.ipynb'.


## Star History
[![Star History Chart](https://api.star-history.com/svg?repos=dnhkng/GlaDOS&type=Date)](https://star-history.com/#dnhkng/GlaDOS&Date)
