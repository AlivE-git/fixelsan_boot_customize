# fixelsan_boot_customize

This repository contains a set of utilities and batch scripts for customizing the boot.iso theme.

Usage:
- Place the '[boot.iso](https://github.com/fixelsan/3do-ode-firmware)' in the 'boot_image' folder.
- Run '1. Decompile & conversion.bat.'
- You will get a 'Data' folder with pre-converted images and music.
- After making changes, run '2. Reverse conversion & compile & sign.bat' and follow the prompts. 

For images, you can use png, jpg, or bmp. For music, mp3, wav, or ogg. 

I don't recommend changing the image resolutions to avoid any issues.

Keep the file names. For example, 'bg.IMAG.png' can be 'bg.IMAG.jpg' or 'bg.IMAG.bmp'. The same applies to music.

If you want to disable the music, copy 'bgm44.mp3' from the 'No music' folder into the 'Data' folder.

Unfortunately, I couldn't find a command-line application for proper image compilation. If you know of one, please write it in the issues :)

[3it: 3DO Image Tool](https://github.com/trapexit/3it)

[3at: 3DO Audio Tool](https://github.com/trapexit/3at)

[FFmpeg](https://ffmpeg.org)

[3do-tools](https://github.com/SaffronCR/3do-tools)

[3DO Utils](https://altmer.arts-union.ru/3DO/3do_utils.htm)