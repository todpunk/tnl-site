---
Author: 'Tod Hansmann'
Title: 'The New Open Source'
PostedDate: 'Sat Aug 16 19:30:00 MST 2026'
Tags: ['software-engineering','rants','open-source']
Hook: "<p>Open source that I grew up with in the 90s is dead. The new open source looks more like a revolution than a new idea to rally around. I think that's important and efficient, because when I was a teenager, I could talk to devs building new ideas and features on bulwark projects. Now, most technologies already exist in multiple forms, and we're not exploring new territory as much. What we need to do is focus on the things we all need and use.</p>"
---
# The Old Ways
It's a bit of a cliche, but we did a lot of software already. We have email, forums, video conferencing, chat, data storage of all kinds, and even interchange formats. The frontier is well explored, and while there are new ideas to behold, we're not as lacking on the capabilities front. A lot of the things we did in the past were solving problems we had because there wasn't an option in the first place to build on top of. Imagine the world in which DNS was created, which was before my time, but similar to what I lived through when HTTP went through versions we take for granted.

In that time, and I don't pretend to be a significant part of any of it, we built everything the current internet exists in. We were early days for web stuff, but despite what the web would think, a new javascript framework beyond jquery hasn't been that interesting, because most of the web efforts have been the literal equivalent of making Microsoft Word or Excel into a GUI App toolkit, and hasn't advance much other than the use cases for a web browser to do things it shouldn't. Open source for the last 20 years has been about advancing what we built in the 90s and early 2000s into more features solutions.

# The Problem
Honestly, the state of software isn't as bad as many would say. We haven't made as much forward progress because we have failed in two ways. First, we haven't taken advantage of the parallelism that changed all of our core algorithms. Second, we addressed features and bugs in our current layer instead of our foundations. Part of this is because it's hard to reconcile the old. Software dev is very focused on the work of exciting new frontiers, which is ultimately naive like any physical frontier. "Look what I discovered!" says the explorer. Great, another thing we'll have to make useful to all the old systems that run everything and keep humanity afloat in your exciting domain.

Well, the exciting domain is actually less than we'd expect. Just take postgres for example. It started probably before you were born as a very different project for a different platform/existence and now it is a huge efficience and featureful tool for basically anything you'd like to store state in.

That just doesn't fix the issues underneath the convenient places we want to stay in.

# The Actual Problems

The biggest two problems in the internet today are two fold. First, identity has been passed over and given wholesale to a handful of central authorities that have the wrong incentives for identity. I'm not talking about authentication, though that is related and important, I'm talking about identity. We'll get into that and the second, separately in a moment. The second, is the actual craft of development hasn't been taken seriously by its own craftsman for a very long time and it shows. Again, we'll get there, but lets focus on the first and of course I will suggest solutions at the end like I do.

# Identity

Much has been written by many a nerd about identity. I don't mean "nerd" in a derogatory way, I'm a nerd in many ways. I mean that in a way that says "us nerds have a solution" and that's true, but it's not really useful outside of us. There's plenty of examples of this, and for the other "nerds" like me I'll give a couple solid examples as a "if we can't say this was a solution, maybe we should think about this for a minute." We have had cryptographic promises/tools for communications like email for decades. Why does nobody use PGP or GPG? It's a damning question because of course, even we nerds don't use them by and large except some zealots who can't use it with the rest of the populous.

This is the case with identity as well. Recently, my own state of Utah has passed [State Endorsed Identity](https://sedi.utah.gov/) which is probably farmed out ot some state legislator's brother or some stupid nonsense rather than an internet standard that can be independenttly audited and improved like Japan's reliance on fax machines. That sort of juxtaposition isn't political, it's fundamentally technological. We failed as technologists to create a proper alternative.

# Development as a Craft

The problem with trying to talk about software development, to say nothing of the difference with engineering, is that it's largely opinion that we are still debating how to appropriately question the values of. Does language matter? Formatting? What about process? For who? That last one is a killer. A dev that wants to be happy in the way they want to work? It's anathema to consider how the customer/user wants to experience software, especially over a long term. I know, because I feel that viscerally in my soul, but it's true just the same.

This is the current zeitgeist we find ourselves, in, where we have our many things we hold dear, the speed and dare I say "leverage" in which we find we can apply it, we are discovering very quickly how much our details do or don't matter. This isn't to say there's a clear cut way in which these things express themselves in our craft. In fact, each of thes questions matter in very specific nuanced jurisdictions, and we aren't addressing _that_ reality. Does formatting matter? Sometimes. Where? Do we even know? I'm not weighing in on where, I'm weighing in on our evaluation changing. It's not just LLMs either, I'm talking about the places where our entire thought process is being challenged because someone has brought up a compelling new way to think about the problem. Was that LLMs, or was an LLM just the accelerant to get there? I think the latter.

# Problem Solving

We need to rethink the foundations we're building on, because we just miss the forest for the trees in all of this. I did it in this article to demonstrate. I suggested Identity and Crafstmanship as problem sot be solved and many a reader honed in on them as the point of this article. They wanted to argue. Meaningless drivel. The solution is broader, more comprehensive. We need to consider our foundations now that it is easier than ever to replace them. How much changes when you know the email is absolutely from your sister's account? Like, they sent it from something authenticated as their user? How much changes when all your processed culminate in a product that someone can produce a copy of in a week or less?

When anyone can buy a spray painter and be proficient with it in a day with painters tape to cut off the ceiling/floorboards/whatever to compete with your artisinal brushstroke you were used to, the question isn't "what did your brush stroke matter for?" The question is "where did the brush stroke matter and the pain matter?" This is a harrowing discernment. Michaelangelo and the guy I hired ot paint my basement are not a comparison. People will want to be one or the other, but not both. 

The solution to this problem is differentiation and specialization. The fact that the game is changing is actually compelling to both, because for far too long, you'd hire a Michaleangelo to paint your basement and they'd be unsatisfied with the lack of color. The sad part of this is that the people that want to be an artisan don't want to pay the price, so we'll lose some of them, but overall, the game is unchanged. Choose who you want to be, adjust your price accordingly, and we'll all have a place in the craft.
