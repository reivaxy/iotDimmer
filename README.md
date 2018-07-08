# iotDimmer

This Xiot agent is intended to control a dimmer for a lamp.

To use it, you'll preferrably also need the iotinator master module (https://github.com/reivaxy/iotinator), or you can just use it's REST API to integrate to your own designs.

You will find <a href="https://github.com/reivaxy/iotinator/wiki/07.-Dev-environnement-and-debug">here</a> all the information to install your dev environment.


I have a 15 year old big lamp that I like a lot (it was cheap !) which is equipped with a dimmer you are supposed to operate with your feet.

It's clumsy, it produces a little buzz at low level, and it's never easy to reach. Since this lamp is the main light source of my living room beside the sun, I'd like it to be a little more user friendly.

A zero crossing detection circuit sends rising edges on a pin used to trigger an interruption.

The interruption handler then computes a delay before sending a pulse to trigger a triac, to power the load (a lamp).

This way, the load is powered only between the pulse on the triac command and the next zero crossing. Changing the delay before the pulse on the triac for an incandescent bulb results in dimming the light it emits.

<img src="https://raw.githubusercontent.com/reivaxy/iotDimmer/master/resources/28.png" width="500"/>


<img src="https://raw.githubusercontent.com/reivaxy/iotDimmer/master/resources/75.png" width="500"/>


Here is the prototype for tests:

<img src="https://raw.githubusercontent.com/reivaxy/iotDimmer/master/resources/prototype.jpg" width="500"/>



