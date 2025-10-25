---
Author: 'Tod Hansmann'
Title: 'Stay at the Abstraction Level'
PostedDate: 'Sat Oct 25 11:30:00 MST 2025'
Tags: ['engineering','rants', 'software']
Hook: "<p>Programmers of all skill level have a tendency that bites us all: thinking they know how something should work. It makes some sense, we're there to know all the things we can to manage complexity and evaluate how well something solves a given problem. We even have a term for differentiating when someone is asking for help with a solution vs the problem they're actually trying to solve, it's called the X Y problem. We just don't tend to counter our own hubris with this notion.</p>"
---
## The Stupidity of Knowing

In actuality, the X Y problem does more to justify the judgment of others' solutions than to actually solve problems. I still think the descriptor is useful for communication and shorthand, but it fails to elucidate what the proper solution is, it mostly tells the person coming to you asking about X that they aren't good at solving Y and should listen to the expert.

That could be true, but it doesn't measure that. I think there's nuance to be had in both the idea that X isn't the right way to solve Y, and in the idea that we need to solve a problem in the first place. While I'm loathe to use car analogies in general for software engineering practices, I think this one might be a time where it makes the most sense.

Mechanics know how cars work on a deep level compared to the rest of the populous. Even if I know a lot about how cars and engines work, I just won't have the depth of someone dedicated to the craft. I know some mechanics swear by manual transmissions for a variety of reasons, like that they're more fun or they feel more in control of the vehicle with them. This is a lot like power users of a computer tweaking things like OS level shortcuts to get more subtle workflows faster.

## Programmer Hubris is a Double Edged Sword

You know what mechanics don't do? They don't add a bunch of buttons and knobs or pull levers to their console to control the choke opening just a little bit more or less at specific timings, or modify their fuel injector so they can be 4% more fuel efficient. I know plenty that will kit out their cars, but they're using parts from known manufacturers and with standard modifiers. They also don't want everyone to do it their way because it's the best, they're making this vehicle for them and their goals. Playing in the craft is a hobby.

You don't take your car to the mechanic and describe the problem and get an afterburner installed.

Programmers do this nonsense all the time. Some library or component doesn't do quite what you want, so you add a function that reaches deep into the guts of it and modifies an integer directly and setting up a script in the build system to work around the fact that this breaks some test of the API in a specific scenario, but it's OK because of course that scenario is an edge case and would never happen in production because you already check for that if your environment isn't in test.

This is as if a mechanic installed a wire reading the temperature of the exhaust and upped the fuel injector's rate by bypassing a switch in the thing, and now when you fill the gas tank you need to tilt it to the left a bit or it will leak, but that's OK because it will never catch on fire because when you're driving the air will blow it off as it leaks if you mess up.

## We do Stupid Stuff Sometimes

Every API contract has two parts. The easy path, and the power user path. The power user path is developed after the easy path, over time, as use cases evolve and real needs arise to handle, so you add a flag to enable some obscure thing, like adding a turbocharger to a specific make/model of vehicle. It's a wild thing. All sorts of mature software does this. You don't know most of the flags for `sed` at all, and you don't need to, but you've probably had to do something weird once or twice. You likewise probably don't know how to do a pivot table in Excel unless you have to do a lot of Excel reports, in which case I wonder why you're reading this, but that's the mechanic knowing the vehicle's capabilities.

What you don't do is compile your own patch to `sed` and deploy it to your fleet of servers because you use it in a deployment script and really needed that extra feature.

Except we totally do that all the time because we're fools.

## The Cost of Solutions

The advocacy here is to avoid having to do that, because it's never The Right Way™ and has enormous costs. Every line of code is a liability, but some liabilities are more than others. When you decided to patch that tool that didn't quite have the feature you wanted, you installed a fuel line modifier that someone _else_ is going to have to relearn to tilt to the left over, and they're not going to, and a year from now it's going to light on fire at a long stop light. We just assume accidents happen, and we have good enough response to mitigate them so they'll be back on the road quick enough so who cares? There's some correctness to that, but I have a better option.

Just get over ourselves. We aren't smarter than the library or module author. Especially if we actually are smarter, we aren't. That intelligence is an imprecise weapon unless its wielded, not unleashed. When we hear the advice to don't be clever in our code, we should listen, but expand that to not being clever in our processes and solutions and architectures.

The abstraction was made that way for a reason. There's all sorts of abstractions we don't cross over from, and the vast, vast majority of the time we don't need to cross over any of the ones we just happen to know how. We were too busy wondering if we could to ask if we should.

If we try to conform to the API contract, and the other side honors that API contract, we have less maintenance burden. I was just at the GoWest conference yesterday and the point was well made in a panel discussion that the Go standard library should be the thing we reach for most of the time because the Go team have been very good about not breaking that contract so you won't have to update code against it, making upgrading Go for security fixes and performance improvements that much easier.

How old is your runtime? How easy are your upgrades? Those are smells if you can't upgrade them by changing a number in a config. Most of us can't. Most of us smell. I'm guilty, too, don't worry, but that doesn't make it right to not improve.

Stay at the level of abstraction. Use an automatic transmission, and if we're a power user, use a manual, but don't add that fuel injector modification. If it's actually useful, it will be in an after market fuel injector. If our bespoke feature is that useful, we can do the work of getting it patched upstream. If not, throw it out and throw out our hubris about it as well.

Be lazy. The right kind of lazy. Your project is worth that.
