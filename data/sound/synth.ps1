Add-Type -AssemblyName system.speech
$speech = "I like big butts an´ I can not lie.
You otha brothas can´t deny.
That when a girl walks in wit´ a itty bitty waist an´
A round thing in yo´ face. You get SPRUNG.
Want to pull up tough, cuz you notice that butt was STUFFED.
Deep in the jeans she has wearin´.
I am hooked an´ I cannot stop starin´.
Oh baby, I want to get wit´ ya,
An´ take yo´ picta."
(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak($speech) | gm

(New-Object System.Speech.Synthesis.SpeechSynthesizer).voice
