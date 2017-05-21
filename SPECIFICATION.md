# SSMD Specification

Here we specify how Speech Synthesis Markdown (SSMD) works.

## Syntax

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
* [Substitution](#substitution)
* [Extensions](#extensions)

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
*command* & conquer
```

SSML:
```html
<emphasis>command</emphasis> &amp; conquer
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
Hello <break strength="x-strong"/>      world    (default: x-strong break like after a paragraph)
Hello - <break strength="none"/>   world    (skip break when there would otherwise be one like after this dash)
Hello <break strength="medium"/>     world    (medium break like after a comma)
Hello <break strength="strong"/>     world    (strong break like after a sentence)
Hello <break strength="x-strong"/>     world    (extra string break like after a paragraph)
Hello <break time="5s"/>    world    (5 second break (max 10s))
Hello <break time="100ms"/> world    (100 millisecond break (max 10000ms))
Hello <break time="100ms"/>   world    (100 millisecond break (max 10000ms))
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

Don't forget to do the dishes after!
```

SSML:
```html
<p>First prepare the ingredients.
Don't forget to wash them first.</p><p>Lastly mix them all together.</p><p>Don't forget to do the dishes after!</p>
```

***

### Phoneme

Sometimes the speech synthesis engine needs to be told how exactly to pronounce a word.
This can be done via phonemes. While SSML supports IPA, SSMD uses [X-SAMPA](https://en.wikipedia.org/wiki/X-SAMPA) by default.

SSMD:
```
The German word ["dich"](ph: dIC) does not sound like dick.
You can also use IPA directly: ["dich"](ipa: dɪç)
```

SSML:
```html
The German word <phoneme alphabet="ipa" ph="dɪç">"dich"</phoneme> does not sound like dick.
You can also use IPA directly: <phoneme alphabet="ipa" ph="dɪç">"dich"</phoneme>
```

***

### Prosody

The prosody or rythm depends the volume, rate and pitch of the delivered text.

Each of those values can be defined by a number between 1 and 5 where those mean:

| number | volume | rate | pitch |
| ------ | ------ | ---- | ----- |
| 0 | silent |        |        |
| 1 | x-soft | x-slow | x-low  |
| 2 | soft   | slow   | low    |
| 3 | medium | medium | medium |
| 4 | loud   | fast   | high   |
| 5 | x-loud | x-fast | x-high |

SSMD:
```
Volume:

~silent~
--extra soft--
-soft-
medium
+loud+
++extra loud++

Rate:

<<extra slow<<
<slow<
medium
>fast>
>>extra fast>>

Pitch:

__extra low__
_low_
medium
^high^
^^extra high^^

[extra loud, fast, and high](vrp: 555) or
[extra loud, fast, and high](v: 5, r: 5, p: 5)
```

SSML:
```html
Volume:

<prosody volume="silent">silent</prosody>
<prosody volume="x-soft">extra soft</prosody>
<prosody volume="soft">soft</prosody>
medium
<prosody volume="loud">loud</prosody>
<prosody volume="x-loud">extra loud</prosody>

Rate:

<prosody rate="x-slow">extra slow</prosody>
<prosody rate="slow">slow</prosody>
medium
<prosody rate="fast">fast</prosody>
<prosody rate="x-fast">extra fast</prosody>

Pitch:

<prosody pitch="x-low">extra low</prosody>
<prosody pitch="low">low</prosody>
medium
<prosody pitch="high">high</prosody>
<prosody pitch="x-high">extra high</prosody>

<prosody volume="x-loud" rate="x-fast" pitch="x-high">extra loud, fast, and high</prosody> or
<prosody volume="x-loud" rate="x-fast" pitch="x-high">extra loud, fast, and high</prosody>
```

The shortcuts are listed first. While they can be combined, sometimes it's easier and shorter to just use
the explizit form shown in the last 2 lines. All of them can be nested, too.
Moreover changes in volume (`[louder](v: +10dB)`) and pitch (`[lower](p: -4%)`) can also be given explicitly in relative values.

***

### Say-as

You can give the speech sythesis engine hints as to what it's supposed to read using `as`.

Possible values:

* character - spell out each single character, e.g. for KGB
* number - cardinal number, e.g. 100
* ordinal - ordinal number, e.g. 1st
* digits - spell out each single digit, e.g. 123 as 1 - 2 - 3
* fraction - pronounce number as fraction, e.g. 3/4 as three quarters
* unit - e.g. 1meter
* date - read content as a date, must provide format
* time - duration in minutes and seconds
* address - read as part of an address
* telephone - read content as a telephone number
* expletive - beeps out the content

SSMD:
```
Today on [29.12.2017](as: date, format: "dd.mm.yyyy") my
telephone number is [+49 123456](as: telephone).
You can't say [fuck](as: expletive) on television.
```

SSML:
```html
Today on <say-as interpret-as="date" format="dd.mm.yyyy">29.12.2017</say-as> my
telephone number is <say-as interpret-as="telephone">+49 123456</say-as>.
You can't say <say-as interpret-as="expletive">fuck</say-as> on television.
```

***

### Substitution

Allows to substitute the pronuciation of a word, such as an acronym, with an alias.

SSMD:
```
I'd like to drink some [H2O](sub: water) now.
```

SSML:
```html
I'd like to drink some <sub alias="water">H2O</sub> now.
```

***

### Extensions

It must be possible to extend SSML with constructs specific to certain speech synthesis engines.
Registered extensions must have a unique name. They can take parameters.
For instance let's a assume we registered Amazon Polly's whisper effect in some hypothetical SSMD
library API.

```ruby
SSMD.register "whisper", "amazon:effect", name: "whispered"
```

SSMD:
```
If he [whispers](ext: whisper), he lies.
```

SSML:
```html
If he <amazon:effect name="whispered">whispers</amazon:effect>, he lies.
```

***

### Nesting and duplicate annotations

Formats can be nested. Duplicate annotations of the same type are ignored.

SSMD:
```
Der Film [Guardians of the *Galaxy*](en-GB, de, fr-FR) ist ganz [okay](en-US).
```

SSML:
```html
Der Film <lang xml:lang="en-GB">Guardians of the <emphasis>Galaxy</emphasis></lang> ist ganz <lang xml:lang="en-US">okay</lang>.
```
