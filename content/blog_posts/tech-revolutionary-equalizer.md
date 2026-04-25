---
Author: 'Tod Hansmann'
Title: 'Tech is the Revolutionary Equalizer'
PostedDate: 'Sat Apr 25 10:30:00 MST 2026'
Tags: ['rants','technology','engineering','software','internet']
Hook: "<p>Programmers are some of the most powerful people on the planet, and not in a John Galt kind of way, that's just stupid. I mean that software has given extreme leverage to individuals and businesses alike, and the barrier to entry has always been extremely low. In the last 20 years, we have collectively given up that power and consolidated it in the hands of a few major tech companies. We did this because we're either lazy, incompetent, or more often than not, both.</p>"
---
## Programming as Community

I started programming with others in the early 90s. Before the internet, though just barely, that coordination was on BBSes or in computer clubs my dad would take me to on occasion. I didn't get to do a lot, but I got to watch a lot be developed. The internet was in theory created by Tim Berners-Lee, which fine, I'm not downplaying that. What I am saying is the internet was built by all of us, by people with ideas, who enabled others to use those ideas, for the low cost of learning and effort.

By the time I got to the internet with dialup, I was on IRC and the old newsgroups and forums of the day. I don't say all this to be a "back in my day" kind of post, I'm painting the picture of the limited landscape we operated in, and all of these things were created by people working with much more primitive tools to enable everyone else to do amazing things with this new hyper-communication path. Some businesses were taking advantage of it, sure, the browser wars were real, but if they had ever cost anything you can bet we'd never have used them. Now every browser is based on open source anyway.

This isn't about open source either, because some things are fine to pay for, but the power dynamic of the era was squarely in the hands of programmers as a balancing act against the cost. Can you imagine if the only way you could write an email is if you had to pay some central office for every delivery? What about if you could only view a web page if you paid your ISP for each request? In these days, any suggestion of that sort of thing would have sparked someone to make their own alternative, democratized for everyone to just use, and every nerd on the internet (most of the internet outside of AOL chatrooms), would be using it the next day. Where did that go? I happen to know.

## The Changing Internet

There's a few things that get touted on this subject. Some might say we got normies on the internet and they didn't want to learn the good software. Some might say it was more convenient to talk on Facebook than in email. I've even heard that the good software was actually bad software. All of these are sort of true, but miss the rest of the picture.

The reason is we stopped building when it got harder. It got harder for all of these reasons and more. Instead of building things to make it easier again, we switched to the money game.

I don't blame anyone for that, we need to eat obviously, but that game only existed because of the foundations we built first. Open source and open protocol work is most software, especially most of the software we pay for. Why did we stop building those in the age of social media?

## We Actually Kept Going

It turns out, we do in fact still do this building of open protocols thing. They just happen to suck. Federated social media is a joke, even more so because there's advocates that swear by it and have a great time with it, but we have some evidence it's not all that. First, most of us can't use it. My mom is not going to setup her own ActivityPub user somewhere and go find people on completely different ActivityPub servers and interact that way. These things also tend not to scale.

Not everything needs to scale, but Mastodon [fell on its face hard](/tnlblog/it-works-is-never-enough.html) in the minimal Twitter exodus in 2022. Mastodon is exactly like IRC clients. It's the good software, but it's awful. People can't use it. IRC was successful because it had a variety of clients for different use cases. Most non-techy folks could actually use mIRC back when IRC was peak. It was communal, too, but it was still awful software.

You know what isn't awful? Email. Everyone can use email. There's a dozen clients most adults around in the 90s have used over the years. It's simple, it scales, it's easy to intuit for non-techies. Why? Simply put, it had to be. That was the _purpose_ or _intent_ of the protocol and software. Interop as simply as possible. It just lacked authentication of any kind so spam has ruined it. That should have been easy to solve, but we didn't. We bandaided it, over and over.

So today, we're stuck with old stuff that still works better than the newer stuff, and the newer stuff is just constantly getting produced and failing to do anything of significance.

## We Also Rebuild Nonsense

Where this really gets annoying to me isn't even the social stuff. Why in the year of our Luigi 2026 do we still have to pay a company for an IDP? How many companies have invented their own feature flagging and config management system, which is always a hodgepodge nightmare to maintain and rely on? There's so much software written and maintained at a company that has nothing to do with the company's actual value production, and it could just be standard stuff from open source instead, and it would probably be better.

Not always, of course. Open source has its own problems, mostly around people thinking they need to give a damn about others when they open source something. Don't. Send it out there, and take no questions. Don't feature request. Don't look at PRs. Who cares? "Here is my offering, I will do no work for anyone else on this, you do it in your own fork if you want" is a perfectly reasonable position. Enjoy the wailing of the idiots thinking otherwise. Take it in, calmly, while you enjoy something nice to drink and the peace of being invulnerable to such entitled idiots.

The problem is that doesn't solve the issues of the internet centralizing into the hands of value extractors instead of value creators. We gave [the MBAs](/tnlblog/the-mbas-in-tech-series.html) our leverage, and some of them use it well for products we love, and some of them are awful and we whine on social media and get burned out and watch the stock price go up anyway.

## What to do Instead

We need to change this path. What was successful in the past was building _for users_ and some of that was _for businesses_. Email was not a consumer oriented protocol, but it was a user oriented protocol. It just so happened that in the 90s, users were more technical by and large, and so a lot of the stuff we built was easy to sell because it was built _for ourselves_ first and foremost. This is now a mistake.

Nobody wants to use IRC [because it's complicated](/tnlblog/your-programming-language-is-stupid.html). Nobody wants to use Mastodon or Matrix or half a dozen other things because it's complicated. Nobody wants to write a browser because it's complicated (but wait, it turns out that people are doing that, and it's not, but that's another article sometime). 

We need to build things for our parents and our companies. We need things that fight back by building across the needs. As an example, I'm building [LinkKeys](https://catalystlinkkeys.com) for everyone, from tin foil hat greybeards to my mom, but also for businesses and for nation states. I don't agree with China's Great Firewall, but I also understand that it is necessary to their view. So I want to build a thing that enables that use case, while making it difficult to pretend they aren't doing it. I think that works for China's desires, they didn't hide it in the first place, but if there's no man in the middle without easily verifying there is, that doesn't eliminate the man in the middle, it just eliminates the need to pretend the use case isn't being enacted.

Software needs to be built to give this power to everyone, not just a handful of large companies. Signal is great for [privacy nerds](/tnlblog/anonymity-vs-pseudonymity.html), but it shouldn't have to exist, it should be as distributed as email. It should be usable by my mother. It definitely shouldn't be [coupled to my phone number](/tnlblog/accounts-are-not-identities.html). How hard is it to do communications for my mom on a raspberry pi with an app I can verify is on her trusted device? How hard is it to build things that are hostable on a small quiet PC in anyone's house? How difficult should it be to give people 80% of the things they want to do on the web with privacy and cheap cost?

I could host thousands of people's email on a raspberry pi in my basement. If a company wanted more reliable hosting, I could offer that for a cost and I wouldn't need to mine their data to appease my investors making number go up quarter after quarter. You could compete by offering your own. Maybe you add calendaring or something on top. Maybe you specialize in Europe because of laws or whatnot. Maybe we both contribute to the software and protocol. Maybe we hold a FAANG at bay from splitting the protocol so they can kill privacy by just being better than they are. Why would you switch to a huge corporation's slow-moving software when you gain nothing?

Anyone in the world can do this from their basement in their spare time. The key here is they have to do the entire game now. They have to market, they have to do the empathy work with users of all kinds from individuals to corporations and governments. They have to think about UI and updates and support and ugh. That's a lot of work.

That said, we complain a lot on the internet about a handful of corporations behaving badly, and press somebody to do something about it, but literally all of the actual power has been in our hands the whole time. I don't think we have room to complain anymore.

