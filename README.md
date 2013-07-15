FlipClock
=========

A clock view displaying time with flip animation, like the HTC clock. It comes in two pattern: with or without seconds displayed

![ScreenShot](https://github.com/aceisScope/FlipClock/raw/master/screenshot.png)

##How to Use

1. Time pattern is used to describe whether the clock displays second or minute only
``` objective-c

    - (void)setTimePattern:(kFlipTimePattern)pattern;
    
```
2. Flip to a certain time, e.g. @"01-33-40" or @"20-55", note that time string here is separated by "-".
``` objective-c

    - (void)flipToTime:(NSString*)time;

```
3. Make the clock tick. Say make it flip every minute or second, to display current time.    

###Reference

* The main idea of the animation is described in a tutorial [Creating an iPad flip-clock with Core Animation](http://www.voyce.com/index.php/2010/04/10/creating-an-ipad-flip-clock-with-core-animation/) by Ian Voyce
* The most basic and important animation part is implemented by Christopher Brown in his brilliant [flipclock](https://github.com/cbowns/flipclock), or you may would also like to have a look on my own [FlipGridView](https://github.com/aceisScope/FlipGridView), which also animates in a similar sense.

