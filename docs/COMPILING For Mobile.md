# Compiling Friday Night Funkin for MOBILE'

0. Setup
    - Download Haxe from [Haxe.org](https://haxe.org)
    - Download Git from [git-scm.com](https://www.git-scm.com)
    - Do NOT download the repository using the Download ZIP button on GitHub or you may run into errors!
    - Instead, open a command prompt and do the following steps...
1. Run `git clone https://github.com/TeamX02/Funkin.git` to clone the base repository.
2. Run `git submodule update --init --recursive` to download the game's assets.
    - NOTE: By performing this operation, you are downloading Content which is proprietary and protected by national and international copyright and trademark laws. See [the LICENSE.md file for the Funkin.assets](https://github.com/FunkinCrew/funkin.assets/blob/main/LICENSE.md) repo for more information.
2. Run `haxelib --global install hmm` and then `haxelib --global run hmm setup` to install hmm.json
3. Run `hmm install` to install all haxelibs of the current branch
4. Run `haxelib run lime setup` to set up lime
5. Compiling setup
   - Download the [Visual Studio Build Tools](https://aka.ms/vs/17/release/vs_BuildTools.exe)
        - When prompted, select "Individual Components" and make sure to download the following:
        - MSVC v143 VS 2022 C++ x64/x86 build tools
        - Windows 10/11 SDK
        - Run [`lime setup android` Documentation](https://lime.openfl.org/docs/advanced-setup/android/) to setup the NDK, SDK and JDK
        - Use this [`JDK`](https://www.mediafire.com/file/gw0cvq5u3jfnj4m/jdk11aarch64.tar.xz/file) 11
        - Use this [`SDK+NDK`](https://www.mediafire.com/file/ypvbco88dvrkqtk/sdk%252Bndkr21baarch64.tar.xz/file) r21b
        - Extract on any folder
6. If you are targeting for native, you may need to run `lime rebuild android` and `lime rebuild android -debug`
7. Run `lime test android` ! Add `-debug` to enable several debug features such as time travel (`PgUp`/`PgDn` in Play State).
   - If you want just build the game normally, run `lime build android`
# Troubleshooting

- During the cloning process, you may experience an error along the lines of `error: RPC failed; curl 92 HTTP/2 stream 0 was not closed cleanly: PROTOCOL_ERROR (err 1)` due to poor connectivity. A common fix is to run ` git config --global http.postBuffer 4096M`.

