---
layout: post
title: Networks for Normal People
---

This article is an introduction to how computer networks work targeted at hobbyists, PC gamers and other computer-savvy people outside of professional IT who need some basic knowledge to help them troubleshoot problems on their home networks.

*Disclaimer: I'm not a network engineer, just a two-bit systems guy. I can't promise that everything in this article is 100% correct. What I can say is that this article will give you enough working knowledge to understand and solve real-world problems.*

# The Real World

We think of computers as being abstract magic boxes, but they are made from real-world materials and are bound by the laws of physics. Whenever a computer talks to another computer, it's has to do so through physical material.

- Cell phones send a radio signal to a cell tower
- Wi-fi devices send a radio signal to a wi-fi access point
- Devices plugged into Ethernet networks send electrical signals over a copper wire
- Between a typical home and the rest of the internet is a mix of copper wires and light pulses sent through optical fibers

While you don't need to understand radio protocols or know how to crimp an Ethernet cable, you should be aware of how limitations in these physical signals can cause issues. Some common examples:

- An Ethernet cable is only certified to provide a signal over 100 meters. Any further and you may experience signal loss, and will have to put some kind of powered device in the line to repeat (boost) the signal.
- Radio waves can travel through walls, but lose energy when doing so. The material and thickness of the wall influences the signal loss- drywall is thin and absorbs less than a thick foundational wall. I once worked for a company which took over the former offices of the District Attorney- their walls were armored for witness protection purposes, and wi-fi signals hardly got through!
- Radio waves bounce off walls and other surfaces. This can cause them to meet up again and interfere with themselves, causing "dead zones" in strange spots. 

![]({{ site.url }}/assets/network/wifi-map.gif)

- Many new wi-fi devices are dual-band and have options to operate at 2.4GHz or at 5GHz. Generally, 2.4GHz signals can travel father, while 5GHz signals are capable of high transfer rates. However, many consumer appliances like cordless phones and garage doors operate on 2.4GHz as well. It's not unheard of for a home's wifi to cut out when someone opens the garage!
- Speaking of interference, anyone who's lived in an apartment building knows how many devices using the same frequency can interfere with each other.
- On a larger scale, large solar flares can cause massive amounts of interference in all sorts of electrical systems. I once had an executive ask why the wifi had been terrible for a few days and found out that the sun was unusually active that week.
- Seemingly bizarre and random issues can be caused by equipment failures. A loose or broken connector or kinked wire can provide a partial signal. An overheating router might decrease its performance to protect itself from heat damaged. Ever wonder why ISP support will ask you to unplug your Ethernet, "blow the dust out" and plug it back in? They're really tricking you into making sure that the wire is securely plugged in, without making you look stupid.

## Further Reading

[The legendary case of the 500 mile email](http://www.ibiblio.org/harris/500milemail.html) is a great story about how physical limitations can cause bizarre problems.

# Hokey Religions and Ancient Weapons: Basic Communication

Telegraph networks are a great way to demonstrate how humans can communicate using electricity. A Morse telegraph is very simple. Take a long copper wire, and hang it up between the two people who want to communicate. Let's name these people Alice and Bob. Give Alice a power source and a switch that that Alice can press to connect the power source to the wire. At Bob's end, connect the wire to an electromagnet, which is then connected to a movable marker, and drag a piece of paper under the market. 

![]({{ site.url }}/assets/network/telegraph.png)

When Alice presses her switch, electricity passes through the wire and activates the electromagnet on the other end. The magnetic force can be used to move the marker down so that it touches the paper and leaves a mark. When Alice releases the switch, the magnet turns off and the marker lifts off the paper.

Bob needs more than some lines on the paper, though- he needs to know how to interpret the lines into meaningful, human communication. Alice and Bob need to agree in advance on what different marks on the paper mean. What they need to decide on is an **encoding system**.

For example, they could use the following encoding system:

```
A = Tap 1 time
B = Tap 2 times
C = Tap 3 times
D = Tap 4 times

and so on...
```

Alice could then send the message "HI" by tapping her switch eight times for letter H, pausing, and then tapping nine times for letter I. This works well until Alice asks Bob to send her a Xylophone from Zimbabwe and she develops a wrist cramp.

Samuel Morse developed Morse code to solve that problem by combining different types of presses (short, medium, and long). Computer networks solve the problem by using **binary signals**. A binary signal has two states: On and Off. In our telegraph example, those states are implemented by Alice's power switch. When a computer network reads a binary signal, it converts the "Off" state to the digit 0, and the "On" state to the digit one. (Each **b**inary dig**it** is called a **bit**, and four bits together make a **byte**). The computer also knows how many bits it should read at a time, and then converts that number to a character using the encoding system it's been told to use. For example, a computer could read the following message from a wire:

```
0110100001100101011011000110110001101111
```

This computer has been programmed to know that the signal is encoded using [ASCII](https://en.wikipedia.org/wiki/ASCII). It knows that ASCII is an 8-bit encoding, meaning every group of eight bits should be read as a number. If you like, you can look up how to convert from binary to "normal" decimal numbers. For now, just trust my conversions.

```
binary     decimal
01101000 = 104
01100101 = 101
01101100 = 108
01101100 = 108
01101111 = 111
```

The computer also contains a table which has a list of numbers and what they should be read as in ASCII:

```
# The first 32 numbers are for formatting purposes
# Also, computers count from zero, because that's how RAM works at the chip level
0   = <NULL>
1   = <START OF HEADING>
2   = <START OF TEXT>
. . .
32  = <SPACE>
33  = !
34  = "
. . .
48  = 1
49  = 2
. . .
65  = A
66  = B
67  = C
...
97  = a
98  = b
99  = c
100 = d
101 = e
102 = f
103 = g
104 = h
...
108 = l
...
111 = o
...and so on
```

Using the table, the computer knows how to convert `104 101 108 108 111` to English text: `hello`!

This demonstrates that we can send human-readable messages across a simple electrical wire. By changing our encoding, we can send any kind of information! We could use an image encoding like BMP or GIF and send positions and colors of pixels. We could use a video encoding like MP4 and send frames of video. We could even invent our own encoding format, and send all the information needed for a multiplayer computer game. As long as the two computers use the same encoding to **encode** and **decode** the data, they can talk about anything!

Of course, if they *don't* use the same encoding, it can cause problems. You can see this for yourself if you use a text editor like Notepad or TextEdit to open a JPEG file. The text editor will load bits that were written to store colors, and try to read them as text. The result is a bunch of garbage on the screen.

![]({{ site.url }}/assets/network/encoding-error.png)

In the old days, this was a common problem- Japanese programmers programmed their computers to read Japanese Hiragana, Katakana and Kanji instead of English letters, and so American computers couldn't talk to Japanese computers. These days most computers are programmed to send and receive [Unicode](https://en.wikipedia.org/wiki/Unicode), which has most of the world's alphabets in it's tables, as well as "characters" like 💗, 🏍️ and 🙃. Of course, programmers *still* deal with other types of encoding issues, and sometimes they make mistakes which cause bugs in the software you use.

## Lies

Strict ASCII is a 7-bit encoding. Extended ASCII (and the ASCII-compatible subset of Unicode) is 8-bit, though.

"On" and "Off" are usually not literally on and off. In most computers, "On" is a high power state and "Off" is a low power state, so "Off" still has a weak electrical signal. 

In some cases, such as in magnetic hard drives, 0 and 1 aren't on and off at all, but rather a change in state. [See this video for a great explanation](https://youtu.be/Wiy_eHdj8kg?t=108).

## Fun

While we can't read an encoded image as text, we can re-encode the image as text, and decode it again! Try copying and pasting [the text at this link]({{ site.url }}/assets/network/image-encoding.txt) into the decoder [on this website](https://codebeautify.org/base64-to-image-converter). Programmers use this trick to embed complex binary files into text!

## Further Reading

[Tom Scott's video on Unicode](https://www.youtube.com/watch?v=MijmeoH9LT4) goes into great detail about how ASCII and Unicode encodings work.

# MAC Addresses

Now that we know how to connect two computers and make them talk, let's build a network of several computers. Let's connect three computers together, like so:

![]({{ site.url }}/assets/network/3-computers.png)

When Alice sends a message over the wire, the electrical signal will be seen by both Bob and Carol. This is okay if the message is "Let's get burgers for lunch!" but terrible if the message is "Bob, did you order the cake for Carol's surprise party?". Clearly, we need a better solution.

Let's give each of the computers a unique number to identify it. There can be lots of computers on a network, so it needs to be a really long number. If we wrote it down in decimal, it would run off the screen, so we'll encode it in **hexadecimal**, which is more compact. This is called a **Media Access Control address**, or **MAC address** for short.

![]({{ site.url }}/assets/network/mac.png)

We also need another computer which has all of the wires plugged into it, and controls where the messages go. This device is called a **Layer 2 Network Switch**, or **dumb switch** or just **switch** for short. It's called a switch because it literally switches the path the electrical sigals travel.

![]({{ site.url }}/assets/network/l2-switch.png)

Now we program all of the computers to send two additional pieces of information with every message:

- The MAC address of the sender
- The MAC address of the intended recipient

Suppose Alice wants to send that message about Carol's surprise party to Bob. Her computer builds the following message:

```
FROM: 8D:63:5E:2D:D2:53
TO:   DD:51:C3:09:74:AD
TEXT: Bob, did you order the cake for Carol's surprise party?
```

Alice's computer sends this message to the switch. The switch sees the message on the first of its eight ports. In the switch's memory is a table where it notes down which MAC address is on which port:

```
Port | Status       | MAC
0    | CONNECTED    | 8D:63:5E:2D:D2:53
1    | CONNECTED    | ???
2    | DISCONNECTED | ???
3    | DISCONNECTED | ???
4    | CONNECTED    | ???
5    | DISCONNECTED | ???
6    | DISCONNECTED | ???
7    | DISCONNECTED | ???
```

It knows that ports 0, 1 and 4 are connected to other computers because there's a weak electrical signal on those wires even when no messages are being sent (See the Lies section under Basic Communication). It knows that the other ports are not connected because there's no signal on those lines at all. It also knows that the computer on port 0 has the MAC address `8D:63:5E:2D:D2:53`, because it was in the message. What it doesn't know is which wire the message to send. To solve this problem, it **broadcasts** the following message on every other:

```
ARE YOU DD:51:C3:09:74:AD?
```

Bob's computer sends the reply:

```
YES
```

Carol's computer simply ignores the message. The switch updates its MAC table:

```
Port | Status       | MAC
0    | CONNECTED    | 8D:63:5E:2D:D2:53
1    | CONNECTED    | ???
2    | DISCONNECTED | ???
3    | DISCONNECTED | ???
4    | CONNECTED    | DD:51:C3:09:74:AD
5    | DISCONNECTED | ???
6    | DISCONNECTED | ???
7    | DISCONNECTED | ???
```

And then sends Alice's message to Bob. Bob can send a reply:

```
FROM: DD:51:C3:09:74:AD
TO:   8D:63:5E:2D:D2:53
TEXT: I was going to bake her one myself. Does she prefer chocolate or red velvet?
```

The switch has Alice's MAC address stored in it's MAC table, and can relay the message to Alice nearly instantly. Once the switch has built up the MAC table, it's incredibly fast.

Carol is none the wiser- her computer knows that a message was passed between other computers on the network, but it doesn't know what was in the message.


## Death by a Thousand Packets: Broadcast Storms

What happens when you plug an Ethernet cable in ports 2 and 3, creating a loop?

```
Port | Status       | MAC
0    | CONNECTED    | 8D:63:5E:2D:D2:53
1    | CONNECTED    | 5B:69:40:EA:3B:45
2    | CONNECTED    | ??? (Looped to port 3)
3    | CONNECTED    | ??? (Looped to port 2)
4    | CONNECTED    | DD:51:C3:09:74:AD
5    | DISCONNECTED | ???
6    | DISCONNECTED | ???
7    | DISCONNECTED | ???
```

If any message is sent through the switch with an unknown MAC address, the switch will broadcast a on all ports, including 2 and 3... which will send the broadcasts in a loop back to the switch... where they will be broadcast again... and loop again. This loop will continue forever, until the switch is turned off and on again to clear its memory. If enough of these messages pass through the switch, the switch will run out of memory trying to hold all of the looping broadcasts and crash, taking down the network. 

This is called a **broadcast storm** and is one of the easiest ways to take down a basic network. There are ways to prevent broadcast storms from happening (such as with Spanning Tree Protocol, Layer 3 filtering, broadcast domain segmentation and smart switches), but many home and small business networks don't have those preventative measures in place!

Sometimes, a loop isn't so obvious. In this network, the loop is across three switches. Each switch propagates the broadcasts to its neighbors. It's obvious on paper, but when tracing the wires through a building in the real world it might not be so clear.

![]({{ site.url }}/assets/network/broadcast-storm.png)

## Lies

MAC addresses intended to be unique, but aren't. It's really easy to spoof a MAC address- just reprogram the computer to say "YES" to "ARE YOU \<MAC address you want to spoof\>". For this reason, MAC addresses aren't secure ways to hide messages, but when used as intended they do a great job at cutting down on network traffic without using up lots of CPU and memory.

You may notice a chicken and egg problem- how did Alice's computer know Bob's MAC address? For now, assume that Alice typed it in manually. A future section will cover how computers talk when they don't know each other's address.

Most software doesn't actually address messages by MAC address- that's handled by the operating system for the programmer. A future section will cover how applications typically address their messages.

# Coming Soon

- IP addresses (IPv4 and IPv6)
- Routing
- DHCP
- DNS
- Protocols (ICMP, TCP, and UDP)
- Firewalls
- Time (NTP)
- HTTP
- Encryption (Symmetric, Assymetric, HTTPS/Certificates)
