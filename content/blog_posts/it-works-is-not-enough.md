---
Author: 'Tod Hansmann'
Title: 'It Works is Never Enough'
PostedDate: 'Sat May 31 14:30:00 MST 2025'
Tags: ['engineering','rants', 'opinions']
Hook: "<p>There are a lot of different software engineers out there, with different values. One of those values is sometimes \"speed\" measured only in the initial task work, and expressed in stupid statements like the famous \"move fast and break things.\" The attitude of creating something working and then polishing it later is a problem. It misses the point.</p>"
---
## Working Software Isn't Real

I'm a big fan of the agile manifesto, but I've never taken it religiously. I think in general people miss the nuance of the statements it make. For instance, "working software over comprehensive documentation" is a compelling one. The problem with it as a guiding principle is ambiguity that gets glossed over most of the time. What the hell does "working software" and "comprehensive documentation" even mean? Most people have an idea in their minds of each, or directionally at least. Is it the same? Does it have enough overlap to be useful? I posit here that it is not the same, and does not have enough overlap.

Working software doesn't exist. I've seen a dev produce a 12 line python script run by cron for backups. Is that working? It does what it's supposed to. It might run tomorrow. We might assume I'm talking about requirements or features it's missing. I promise, it fulfilled the requirements given, and it was made in a very short time. Something something story points. Praise was given. It might still be running to this day without issue. Who can say it isn't working software? I can.

## The Problem is Always Time

I can write a script or even a full compiled binary that does a thing. It can do it multiple times. I don't consider it software, I consider it an action set. It's not a system, it's a set of things I combined to do once or however often. Is the backup script on the cron job software? Possibly, but I'm drawing the distinction not of the scripting, but _of time itself_ being the problem. How long does it run, how much does it do, how many times am I going to run it? All of these are irrelevant when we talk about "working software" unless it fits into the requirements. Maybe the cron script is entirely appropriate.

What did we miss then? Why do I hate that script on a cron job? It's a snapshot in time. It is stuck. It can be modified, but how much has to be regained to modify it? What if the original author left the company, or just isn't contactable by the open source project or whatever else? Can someone else pick it up? It was literally 12 lines. It can't be that hard, right? This is the issue. We can't know, because we never even bothered to care. "It works" is the equivalent of "it compiles, ship it!" Day 0 operations are important, but day 1 and day 2 are the most reliable future predictions available to us. Tomorrow will come.

This is also just the software itself, the code _we wrote_ itself. Will it run on the next iteration of the server it needs to back up? Will it run on the next version of Python? Will it have security vulnerabilities we care about? Is the process of running it even scannable? What dependencies does it have and what's their update cycles? Devs avoid these questions a lot more than they should, even though they're easy to account for if you think of them early. They _will absolutely_ need to be answered, and no answer is just a cost to pay later. The life and death of this code is inevitable.

Yet more often than not, especially in the world of "working software" that life is never considered.

## Making a Baby

A lot of people enjoy the process of making a baby. As a species, what we can unequivocally say is that the _results_ of that process not being considered before the act is an extremely ill advised path. That's about as far as I'm going to take that analogy lest we get into political territory, but the key is right there: not caring about consequences or results or the future is rolling the dice for disaster. Whether or not it results in disaster or not is irrelevant. The life of the baby and all of society are improved by thinking ahead at any level, regardless of what the answers might be.

This is always my frustration with the dev world that loves making something that does whatever, but never thinks ahead, even if that wasn't going to change the resulting code or whatnot. I have often said that software is construction, and if you're building a dog house your process looks very different than building a skyscraper. Let's look at a different analogy that might illustrate more of what I'm trying to hone in on here.

## My Lessons in Woodworking

I got into amateur woodworking because my life is a cliche, but also I just wanted to build some useful things. It's worked out well, I built my kids a bunk bed that has lasted a decade so far, for instance. There's another piece of furniture I built that was fun and sturdy. I wanted to build an outdoor bench for the back patio. It needed to be weatherproof of course, and I wanted it to look good so I paid special attention to where the screws were going to be seen or not. Pocket hole screws were used (I recommend against them now, but not just because of this project).

Designs were made, some experiments of strength of joints were done, parts were acquired. It took a couple days, mostly waiting for paint to dry, but it worked and it was really comfortable. It worked! Hear me!

6 months later it was dead and I sawed it into pieces to throw away or reuse some of the lumber. What happened?

I didn't consider time. Maintenance needed to be done to keep the pocket hole screws tight before they tore the wood. The weather was different months later. I resisted rain, but I didn't think about snow and wind (we get heavy winds where I live, and it definitely wobbled and blew over). It worked, until it didn't, and I didn't make it easy to maintain in the first place. All the pocket hole screws were hidden obviously, but some of them were hidden and then _covered by other wood_. It absolutely solved the problem, but I couldn't even keep the solution running for long. Maybe that's fine, it was certainly not critical infrastructure, but it would still be there years later (and for no extra investment initially) if I had just considered the future.

## OK, What Should We Do?

My usual rule of not writing about a problem without some ideas for solutions compels me to say this one is simple: just think. Basic questions like, "how easy is this to maintain?" are enough. It's sad that we don't do the basics, and this is why it upsets me so. Ask questions like these. Is there a standard I should be following so we aren't making a bespoke thing that's harder to maintain? Is there a system that would take a little more time today but make things easier for all of the future? Is this solution simple, but not too simple? I've recently become more of a fan of doing something in Python or similar that could be done in Bash, purely because it makes it easier to maintain for myself _and others_ in the future, but it's not as simple.

Note that we haven't even done anything about documentation. Documentation is a very different subject, but we might need some. Answering what kind of documentation and how extensive becomes easier to answer _when we answer these lifetime questions_. Chances are you don't need documentation if you organize things such that it follows established patterns. If you don't have extra layers to things that's even easier (keep your modules deep and your layers shallow).

Another good measure of how maintainable the thing will be is my favorite: how many WTFs will a new dev looking at this have?

Ultimately, the advice is don't make it work, make it live.
