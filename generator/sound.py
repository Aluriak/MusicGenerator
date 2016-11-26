"""Cross platform sound management,
heavily inspired from http://stackoverflow.com/a/311634.
The unix part is not enough: writing in /dev/dsp is blocking,
and implementation using multiple threads lead to threads blocking each other,
so not all notes are played.

Could require to load the snd-pcm-oss kernel module:
    sudo modprobe snd-pcm-oss

Next versions should take a look to https://wiki.python.org/moin/Audio/

"""

import threading
try:
    import winsound
    UNIX = False
except ImportError:  # we are on unix. probably.
    UNIX = True
    from wave import open as open_wave
    from ossaudiodev import open as open_oss
    try:
        from ossaudiodev import AFMT_S16_NE
    except ImportError:
        from sys import byteorder
        if byteorder == "little": AFMT_S16_NE = ossaudiodev.AFMT_S16_LE
        else:                     AFMT_S16_NE = ossaudiodev.AFMT_S16_BE

WAV_FILE_TEMPLATE = "./Matlab/PianoNote/{}.wav"


def play_midi(code:int):
    wavefile = WAV_FILE_TEMPLATE.format(code)
    if UNIX:
        with open_wave(wavefile, 'rb') as fd, open_oss('/dev/dsp', 'w') as dsp:
            nc, sw, fr, nf, comptype, compname = fd.getparams()
            dsp.setparameters(AFMT_S16_NE, nc, fr)
            data = fd.readframes(nf)
            dsp.write(data)
    else:
        winsound.PlaySound(wavefile, winsound.SND_FILENAME)
