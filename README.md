CardFlip
========

FlipContainerView is a class which allows users to set a front and a back view of a 'card', and flip it over to display a detail view. 

It supports panning, so the user can 'play' with the card, pulling it down gradually or by swiping it quickly. If the user is panning, the card will
automatically flip once it gets to a specific point to prevent the user from rotating it 90 degrees, which would hide the card completely for a brief
period (since we're rotating two dimensional views with no depth).

This code was originally going to be used in a commercial project but was removed when we decided to use a different user experience flow. 
I thought this code was interesting enough to publish it in its own right. 

[![Demo](http://img.youtube.com/vi/uUrqgbIefd4/0.jpg)](http://www.youtube.com/watch?v=uUrqgbIefd4)

FlipContainerView class
-----------------------
This class is the interesting part and contains references to two <code>UIViews</code>, <code>frontView</code> and <code>backView</code>.
Set these to whatever you like; they should be the same size as each other. 

<code>frontView</code> is, surprise, the front of the card. Here, it's intended that you display a view which has contains a summary, or a small amount of 
information. 

<code>backView</code> is the back of the card. Because this will be upside down when the view is flipped, you probably shouldn't put anything useful here. A background color
is probably best. 

FlipContainerDelegate
---------------------
Your view controller should implement this delegate. Don't forget to hook it up to <code>FlipContainerView</code>.

The delegate provides the following methods:

- <code>showFront</code>
- <code>showBack</code>
- <code>didShowFront</code>
- <code>didShowBack</code>

If you look at the provided sample project, you'll see that another view, <code>DetailView</code> is shown on screen once the card flips to the back.
This is a bit of a 'fake' view, since it's meant to represent the real reverse side of the card. However, <code>FlipContainerView</code>'s <code>backView</code> will be upside down and stretched out
once a flip occurs. 

You should, again, hook up your view controller to this <code>DetailView</code> via a delegate and call <code>flipToFront</code> when
you want to close it. 

FAQs
====
**Does this require any frameworks?**

Just <code>QuartzCore</code>. Be sure to include it under the "Link Binary with Libraries" section in your project's Build Phases.

**Why does <code>DetailView</code> even exist? Why can't you use <code>backView</code>?**

Because <code>backView</code> will be upside down when you flip the card over, and I wanted <code>DetailView</code> to take up the size of the screen. In the original purpose the code was written for, 
it was more than sufficient that I blow out <code>backView</code> to a big size to fill out the entirety of the screen and sneakily do an <code>addSubview</code> of the real view.
Your purpose may be different, and you're more than free to make it do whatever you like with the code. 

**What sort of things can I put on each of the card views?**

Anything you want. They're <code>UIView</code>s after all.

**One big card isn't very useful!**

Of course, you're free to put as many of these things on screen as you wish and make them as large as you like. It was actually designed to be a view inside Nick Lockwood's amazing [iCarousel](https://github.com/nicklockwood/iCarousel).

**What iOS versions do I need?**

I tested this on iOS 5 and 6. It should theoretically work on anything that uses ARC (iOS 4.3+)

**Why does this require ARC?**

Because I wrote this in 2013.

**This isn't very customisable.**

That'd be because originally this was developed to be part of a commercial project for one very specific purpose. You can tweak it however you like (eg, sensitivity, flip direction, etc) but there are currently no built-in options for that sort of thing.

Licence
=======
This project is licenced under the MIT Licence. You may use and change as you wish. No attribution is required.

Developed by Jarrod Robins 2013.
