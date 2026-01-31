---
Author: 'Tod Hansmann'
Title: "API Contracts are Everything"
PostedDate: 'Tue Feb 22 12:11:00 MST 2025'
Tags: ["society","architecture","engineering","rants"]
Hook: "<p>Good fences make good neighbors. This is the most important concept in cooperation and coordination of work. Ostensibly I'm talking about software engineering, but it's also true of everything in life. Everything.</p>"
---
## What even is an API Contract?

In some ways, I don't like the term "API Contract" at all. The trouble with software engineering is we invent a million terms and unless we get mathematical about it they lose all meaning the moment they get typed out. One might be tempted to think we need to get more mathematical about it. That way lies Haskell, and that's never a good thing. Let us not get mathematical.

Instead, let's talk about the shape of the concept. First, an API Contract has nothing to do with APIs. You do not need a function signature or an OpenAPI spec or any of that stuff. API Contracts are separation of concerns, accountability matrices, and maybe some other bits of other concepts all rolled into one. They are the way Person A and Person B can divide and come together. They say, "if you give me X, I will do Y and return you Z."  No, stop, don't go back to APIs again. I told you, this has nothing to do with APIs.

Let's talk about distributed systems. I have a whole thing about distributed systems, I'll write that up separately, but the short version of it is that distributed systems are _fucking easy_ to understand and I say it that viscerally to spell out a very important point: software engineers are morons. We think we have complexity, but every child understands how to interact with the grocery store. Grocery stores are distributed systems. You know what makes them easy to understand and operate? API Contracts.

API Contracts are best when they're generic as they can be. Every dairy farm sells dairy products. Very few sell directly to consumers for most of their goods. I buy my milk at a grocery store. The API contract I have is that I see the sign where I get it, I take it to the front, I pay the price that was on the shelf and expect that to match the price being asked by the cashier. I then walk out. That's actually several API contracts in a trenchcoat, truth be told. Little API Contracts add up to bigger API Contracts. That's the way of it. The packaging of the set is what I call "the grocery store." The packaging of a different side of the same entity (the store being that entity), is what distributors would call "grocery stores" and they include things like chargebacks (an overloaded term, don't think about it too much). If you are a person, "grocery store" means something different than if you are a worker at a distributor.

API Contracts are the working agreements, and the parts that can change in what ways. Prices change all the time. How much do you notice? If milk was ten cents more or less tomorrow, when would you notice, if ever? Is that part of the API contract? What if it went up ten dollars? API Contracts are the way I interact with my wife in the morning. We have routines, we both end up in the kitchen most mornings, we have to share the space. We've never spoken about any of this. We did negotiate extensively. We continue to do so, almost daily. Details are worked out in the moment. I need to stand slightly to the left so she can get by, because she finished her breakfast faster today for whatever reason. One of the kids is upset and needs to be addressed, changing the game a little. My coffee cup sits in this area of the counter, though, and that's not negotiable.

API Contracts are everything.

## Software API Contracts

I'm still going to reiterate that this has nothing to do with APIs. It's in the name, I get it, but it's not about APIs. That's what makes it great. The APIs are not the API Contract. Just work with me here.

If I'm writing software, I'm going to break it up into parts. There's all sorts of asinine principles we come up with on this subject. The actual value of the thing is that we make parts that have a responsibility, a job to be done if you will, and that it sticks to that job and nothing else. Features are the devil that gets us. When we have things do more and more and more, they become everything, or they necessarily need to reach outside themselves into the guts of other things to get their job done.

Imagine in a big company that you had the accounting department head somehow go over to the shipping floor and somehow make one of the employees a puppet that they used whenever they wanted to get some delivery statistics for the marketing team, because the shipping department has the information and not accounting, but some idiot thought accounting should be the responsible party. Maybe shipping is difficult to work with. Maybe marketing already had a relationship with accounting and not shipping. Maybe the business analysts just didn't want to introduce a process, so they brainwashed a sleeper agent for convenience since they saw the technique work at another company they were at.

Software engineers do this all the time. Technically, the architecture should be informing engineers on where the right responsibilities go and when they need to be broken up, but in practice this gets violated all the time. The microservice religion was supposed to be an answer to this, forcing the bifurcation at a network boundary, but of course it didn't work. Distributed monolith is the term. I like [DHH's take](https://world.hey.com/dhh/even-amazon-can-t-make-sense-of-serverless-or-microservices-59625580) but when he quotes Kelsey Hightower, that's when the key focus hits. This isn't about monoliths. This is about engineering discipline, and the way you do that is organizing things so they have good boundaries.

API Contracts are everything.

## The Key Question to Ask

There is one guiding question that has functioned to inform a great deal of helpful design in software. It's not even just API Contract boundaries, it's workflows and value and what to care about and so much more. "Could a separate org or company be providing this in a black box?" Not everything could _sustain_ a company, because a lot of software systems aren't worth paying for. You shouldn't pay for a database for instance. You might pay for the operation of one, but you should not pay for one. They are commodity. That said, if you find yourself writing a query engine for data you have, you've made very poor decisions and need to go do the harrowing work of unwinding those. We've all been there, but few of us do that work when we find ourselves there.

I like cloud native thinking as a concept. To me, the entirety of cloud native thinking can be summed up as this: every services is a url and a protocol. Why do you care if it's actually Postgres on the other end? You need the API contract to work. If they're doing it with Cockroach, or RDS, or any number of other things, that seems to be their problem. That's the black box. You don't need postgres, you need the functionality.

Why is that different when it's inside your own codebase? Why, when you can see inside the black box, is it ok somehow to reach in and call deep functions in there? This is why I hate DRY. It's so dumb. If something is useful, copy/paste it. If it is useful over and over again, make it an API contract somewhere _in the correct black box_. This is also why so many people start making a `utils` library. It's just a bag of miscellaneous functions. That's not necessarily bad. The bad is when it gets big and complicated and discoverability is gone. I have a whole rant on discoverability being the only actual problem with code organization, but that's another thing for another time. Suffice to say, `utils` is fine until it's big enough to be organized, and that's a lot sooner than most of us want to admit.

The discipline of engineering is being able to see inside the black boxes we're creating, and not build coupling between those insides. Light wiring is how we get them to interact. How much wiring is too much?

API Contracts are everything

## Why This Works So Well

There are only a handful of universal laws that can not be broken by humans without breaking our biology. So in 10,000 years, this may be different, but today and for most of our posterity we can have any influence on, such laws _must not_ be fought. Instead, we must be embracing such things.

One of these is Conway's Law. Organizations are bound to produce systems that match their communication structures.

When I'm doing my own software, I can just let things call into other things all the time. This is of course, stupid. I try to avoid this by thinking ahead to the organizational structure I would want this to lead into, and enforcing that by wearing different hats. The auth system is developed by Auth Tod. The public facing API is designed by API Tod (hey look, we did talk about APIs after all) in service of only the API layer's responsibilities. API Tod talks to a lot of other Tods. That's the communication structure I would want if I were making a big org. Hopefully this never makes me go insane somehow, but in all seriousness, I do try to think about the boundaries in everything I do and the role I would provide. I'm embracing Conway's Law.

This works out amazingly well. I've been able to hand off entire swaths of the codebase to someone else easily. It's also easy to correct mistakes when they're found by just saying, "this is the responsibility of this other set of code and should fit in nicely over there." This works well in open source and internal source too, because it's a black box from the perspective of _other code_ and not the perspective of any coders. I'm not saying to anyone "don't build that, it's so-and-so's job" because that's a coordination issue. Instead, I'm saying "go talk to so-and-so and see if your problem is solvable the way you want or if they want to solve it differently, and if you want you can do the actual work as long as you follow their design." Embracing the way humans work while enabling them to work _better_ means that yes, we have a fence here, but if you need to come get your ball that went over it, that's fine. If that happens 17 times a day, we have a different problem.

It builds dignity, it builds comraderie, it builds speed, and it builds understanding. The boundaries bring us closer and more able to work together, but entirely separately except where we need to collaborate. That's what fences are for. This is the line between our property. It will be renegotiated now and then. If we don't have this, we have an ambiguous neutral zone we'll argue about all the time instead. That's a huge coordination cost. If it works in all sorts of real life situations, it works in digital situations.

I can not stress this enough: API Contracts are everything
