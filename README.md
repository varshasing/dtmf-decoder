## DTMF

This project studies Dual-Tone Mult-Frequency (DTMF) signaling as used in phone dialing. DTFM is used worldwide for telephone signaling to the call switching center
in the voice-frequency band. It is known by the trademarked term Touch-Tone, and is standardized
by ITU-T Recommendation Q.23. Signaling internal to the network (i.e., trunk signaling) is now
done out of the voice band using the SS7 signaling system.

DTMF is an example of a multi-frequency shift keying (MFSK) communication system. The
information being transmitted is captured through the selection of a particular set of sinusoids of
different frequencies - hence the term multi-frequency. Changes (i.e., “shifts”) in the frequencies
of the multiple sinusoids change the information being sent, hence the term “shift keying”.
Sinusoids correspond to impulses in the Fourier domain, thus DTMF information “bits”
correspond to particular patterns of impulses in the Fourier domain. As a result, Fourier analysis
methods are well suited to DTMF schemes. 

For the DTMF decoder, the system should work as follows: When the input to the filter bank is a DTMF signal, the
outputs from two of the bandpass filters should be large and the rest should be small. If we detect
which two outputs are large, then we know the two corresponding frequencies. These frequencies
are then used as row and column pointers to determine the key from the DTMF code. A good
measure of the output level of the bandpass filter is the total energy in the output signal. When the
bandpass filter is working properly it should pass only a single sinusoidal signal and the energy of
this signal is an indication of the amount of that sinusoid present in the input signal
s(t).

### Lab 4 content
- generating telephone keypad tones
- analyzing telephone keypad tones with the Fourier Transform
- designing a telephone keypad decoder

### Lab 5 content
- analyzing and designing a simple bandpass filter to be used in the filter bank part of the DTMF decoder
- creating and testing a complete DTMF decoding system
