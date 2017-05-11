# SSMD

Speech Synthesis Markdown (SSMD) is an lightweight alternative syntax for [SSML](https://www.w3.org/TR/speech-synthesis/).

## Specification

SSMD is mapped to SSML using the following rules.

* [Text](#text)
* [Emphasis](#emphasis)
* [Break](#break)
* [Language](#language)
* [Mark](#mark)
* [Paragraph](#paragraph)
* [Phoneme](#phoneme)
* [Prosody](#prosody)
* [Say-as](#say-as)

***

### Text

Any text written is implicitly wrapped in a `<speak>` root element.
This will be omitted in the rest of the examples shown in this section.

SSMD:
```
text
```

SSML:
```html
<speak>text</speak>
```

***

### Emphasis

SSMD:
```
*word*
```

SSML:
```html
<emphasis>word</emphasis>
```

***

### Break

Pauses can be indicated by using `...`. Several modifications to the duration are allowed as shown below.

SSMD:
```
Hello ...      world    (default: x-strong break like after a paragraph)
Hello - ...0   world    (skip break when there would otherwise be one like after this dash)
Hello ...c     world    (medium break like after a comma)
Hello ...s     world    (strong break like after a sentence)
Hello ...p     world    (extra string break like after a paragraph)
Hello ...5s    world    (5 second break (max 10s))
Hello ...100ms world    (100 millisecond break (max 10000ms))
Hello ...100   world    (100 millisecond break (max 10000ms))
```

SSML:
```html
Hello <break strength="x-strong"/> world
Hello - <break strength="none"/> world
Hello <break strength="medium"/> world
Hello <break strength="strong"/> world
Hello <break strength="x-strong"/> world
Hello <break time="5s"/> world
Hello <break time="100ms"/> world
Hello <break time="100ms"/> world
```

***

### Language

Text passages can be annotated with ISO 639-1 language codes as shown below.
SSML expects a full code including a country. While you can provide those too
SSMD will use a sensible default in case where this is omitted.
As can be seen in the first example where `en` defaults to `en-US` and
`de` defaults to `de-DE`.

SSMD:
```
Ich sah [Guardians of the Galaxy](en) im Kino.
Ich sah [Guardians of the Galaxy](en-GB) im Kino.
I saw ["Die Häschenschule"](de) in the cinema.
```

SSML:
```html
Ich sah <lang xml:lang="en-US">Guardians of the Galaxy</lang> im Kino.
Ich sah <lang xml:lang="en-GB">Guardians of the Galaxy</lang> im Kino.
I saw <lang xml:lang="de-DE">"Die Häschenschule"</lang> in the cinema.
```

***

### Mark

Sections of text can be tagged using marks. They do not effect the synthesis but
can be returned by SSML processing engines as meta information and to emit
events during processing based on these marks.

SSMD:
```
I always wanted a @animal cat as a pet.
```

SSML:
```html
I always wanted a <mark name="animal"/> cat as a pet.
```

***

### Paragraph

Empty lines indicate a paragraph.

SSMD:
```
First prepare the ingredients.
Don't forget to wash them first.

Lastly mix them all together.
```

SSML:
```html
<p>First prepare the ingredients. Don't forget to wash them first.</p>
<p>Lastly mix them all together.</p>
```

### Phoneme

Sometimes the speech synthesis engine needs to be told how exactly to pronounce a word.
This can be done via phonemes. While SSML supports IPA, SSMD uses [X-SAMPA](https://en.wikipedia.org/wiki/X-SAMPA) by default.

SSMD:
```
The German word ["dich"](ph: dIC) does not sound like dick.
```

SSML:
```html
The German word <phoneme alphabet="ipa" ph="dɪç">"dich"</phoneme> does not sound like dick.
```

### Prosody

The prosody or rythm depends the volume, rate and pitch of the delivered text.

Each of those values can be defined by a number between 1 and 5 where those mean:

| number | volume | rate | pitch |
| ------ | ------ | ---- | ----- |
| 0 | silent | | |
| 1 | x-soft | x-slow | x-low |
| 2 | soft | slow | low |
| 3 | medium | medium | medium |
| 4 | loud | fast | high |
| 5 | x-loud | x-fast | x-high |

SSMD:
```
Sometimes what he says is way too LOUD.
[I don't like LOUD](volume: 1, rate: 4, pitch: 5), you know?
```

SSML:
```html
Sometimes what he says is way too <prosody volume="loud">loud</prosody>.
<prosody volume="x-soft" rate="fast" pitch="x-high">I don't like <prosody volume="soft">loud</prosody></prosody>, you know?
```

As seen in the example the **volume** can be increased by 1 over the current level by writing in ALL CAPITALS.
This also works when nested. Moreover changes in volume (`[louder](volume: +10dB)`) and pitch (`[lower](pitch: -4%)`) can also be given explicitly in relative values.

### Say-as

You can give the speech sythesis engine hints as to what it's supposed to read using `as`.

SSMD
```
Today is the []
