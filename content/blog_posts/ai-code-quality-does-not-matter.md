---
Author: 'Tod Hansmann'
Title: 'AI Code Quality Does Not Matter as a Topic'
PostedDate: 'Sun Aug 31 8:58:00 MST 2025'
Tags: ['AI','engineering', 'rants']
Hook: "<p>AI coding assistants have lots of people discussing lots of perspectives on a lot of topics. I think that's great, even when many of them are a waste of time, because we have to figure out which topics are a waste of time. I posit that the topic of AI Code Quality doesn't matter. It's easy to see where code quality does and doesn't matter, and an AI tool being involved doesn't change anything.</p>"
---
## Does Quality Matter at All?

Quality is ambiguous, undefinable. Everyone has their own definition (or lack thereof, which still counts). There's overlap between definitions, and sometimes that's measurable or a stand-in for a measurement. Is a movie high quality if it's popular? Is a meal high quality if the judges on Iron Chef rate it highly? Is a knife high quality if it holds its edge over longer usage? There is no one answer to these questions, but you can see where they measure and where they don't.

Code Quality is more ambiguous because we don't know anything about code quality outside of aesthetic preference and notions of how some things affect other aspects of programming. Is this code testable? Is this code readable? Is this code well documented? I think some of these aspects matter in the universal sense and not just to me or people that overlap with my definitions. I just don't think we know which bits. It's worth continuing to explore.

## AI Code Quality

However, I don't think AI coding assistants change this. There are aspects of code quality that are ostensibly there to save time, and AI tools that are there to save time may essentially make the time-versus-quality trade-off different. The quality, though, doesn't matter to that. If the AI produces "low quality" code in that the code requires more time to refactor or it's tech debt that we'll have to pay down later, or whatever, then if the AI is saving time it makes that "quality" being low or high matter significantly less.

Some aspects of code quality still matter, at least to you or me. Great. Does the AI producing this code matter then? Constrain the output better. I have been learning Rust and using Claude Code to write [csilgen](https://github.com/catalystcommunity/csilgen) and there's two things it essentially gets wrong with every edit. First, it doesn't put the variable inside the curly brackets of format strings. Second, it almost always has an import that isn't used.

Great! Clippy yells about both of these problems, so when I have it make a plan, I have it required to pass all clippy warnings before we can mark a task complete. Is there some linting process we can't just introduce to match any given person's constraints?

## We are Managing Interns

Of course the answer is yes, there's exceptions that linting can't handle. Still doesn't matter. My linting example does make the "problem" of code quality go away if used in the loop. However, the AI aspect just doesn't change any of this. I hate the "vibe coding" scene. The whole discussion. People that don't know how to code are just accepting whatever slop, and I think that's a good thing. Write an app you run yourself that does a thing for you? Awesome! Put it on the internet for others to use? OK, now I have issues.

AI didn't change this, though. I don't care about the quality of anyone's utility scripts they use for themselves. I do care if you're trying to get those scripts built into some software package my mom is going to end up using.

This is made way easier if you just imagine AI code tools as interns. Does the quality of the intern's output matter? If it does, correct it as they go, find the prompting to prevent it, etc. If they can't learn, as many a human can't, constrain their output with tools. The fact that it's an LLM doing the production just changes the wall-clock time. You're still responsible for their output just like the intern shouldn't be putting anything in production that you aren't taking responsibiity and ownership for.

If the intern can push to production, is it the intern's fault when they create a mess? Maybe. Is it the intern's _responsibility_ to fix it? No. Never. Even if we make them do so, that's us taking responsibility by making them, they can't have the incentive to need to. They might, in fact, voluntarily do so, but it's still not their responsibility. Why on earth would I make an LLM responsible for code quality that matters?

## Hence, it Don't Matter

That's basically how I apply thinking about AI coding assistant, agents, whatever. It's an intern that is eager to please and works very fast, but they need to be mentored. They may have some hot new ideas, but they lack experience and understanding. My job is to make them productive and teach them and find a workflow that works for both of us. Many an intern or junior has benefitted from this relationship, just as I have learned and grown from them.

Reverse it, and it becomes even more ridiculous. Let's have an enormous debate about the code quality produced by recent college grads. Does that sound useful? We've done it before. We still do it in specific cases, interestingly enough, where we compare the relative "code quality" of cohorts from different universities or bootcamps. It wasn't useful then, it isn't useful now.

If it doesn't matter to discuss as a topic about interns, it doesn't matter to discuss as a topic about AI coding tools.

