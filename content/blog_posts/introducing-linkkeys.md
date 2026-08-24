---
Author: 'Tod Hansmann'
Title: 'Introducing LinkKeys'
PostedDate: 'Sat Aug 22 15:30:00 MST 2026'
Tags: ['rants','software', 'internet', 'life', 'identity']
Hook: "<p>Why not just be you? On the internet even! No, sincerely. Do you have a different ID for the bar and the bank? Do your passport and your driver's license represent two different, incompatible people? So why can't your online identity work the same way, letting institutions we trust confirm attributes about you, while you decide what each site gets to see?</p>"
---
## The Pain
Personally, I hate creating new accounts. I also hate logging in somewhere with Facebook or Google or whatever. It's not convenient, and I've heard too many horror stories about someone losing their account just because some spammer used their name, or because "suspicious" activity, such as visiting Canada, got their account banned and they couldn't even email the company about it anymore.

More broadly? Bots and spam suck. Digital Identity from the government is broken as all get. Child safety is in the wrong space. These are very real problems, and we haven't even gotten to AI making bots and spam cheaper and easier.

We need to solve this, and it's going to take technologists working with normal people to do it.

## The Tool

[LinkKeys](https://github.com/catalystcommunity/linkkeys) is not a "solution," but it is the way we can solve it. Technology can't solve social problems. That said, LinkKeys could solve spam bots tomorrow. I can prove it.

Why do you get spam email? Two reasons. First, spoofing means you can't actually know that the person or domain sending you the email is the person or domain they claim to be. There's a bunch of band-aids on top, but it's not capable of being secure because it's from the '70s, before this mattered. Second, and this is a big one, even if you could verify the sender, there's no practical way to hold them accountable. Some server in another country somewhere can send you email about the most heinous things and your government wherever you are can do nothing about it, and they wouldn't because it's expensive.

That's also why you can't host your own email server anymore without extreme duress. This is the exact same reason why you get spam bots on social media and "news" (air quotes important) sites posting fake articles all over the internet.

Their identity online is reduced to an _email_ address, which represents nothing but a mailbox, not a real identity or any attributes we can trust.

LinkKeys solves _that_ problem.

## How it Works

I don't want to get technical because I want this to be used by **everyone** and understood as well as we understand how to use a driver's license. So I'll speak to the general audience here and techies can follow along just fine. Basically, you have to trust your domain. Do you trust an email more from hotbusinessideas dot ru, or microsoft dot com? Do you know everyone at either? No, of course not, but one has a reputation. Is that reputation in a computer somewhere, or was it earned over time by people working in the background?

You choose a domain based on the reputation it has built over time. Then you sign up with one you trust. Someone like me can run it for you, or you can run it yourself. I'm not here to judge. That's the point. **You** decide.

Then you get a handle, or an ID, from that domain. It could be supercoolperson@amazingdomain.com, for instance. That looks like an email, but it's separate, just like I'm TodPunk at most websites, but my email is not that, and your email is different from your Facebook ID (not your login, your ID). Great, we're all on board.

The nerdiest part is this. The domain, and your account, have "cryptographic public and private keys," which work like a wax seal that nobody else can fake without a few hundred years of crunching numbers on all the computers the world has right now, and that seal can be updated. The public key is published in DNS, where anyone can find it. Whoever runs your domain protects the private key. If you use one of my domains, that's me. If you run your own, that's you. Nobody else has any access. It has to stay private. Don't worry, that's pretty easy for a technical person, and there are ways to handle mistakes because we're human. I promise, I've been thinking about this for a decade now. I have covered many of the bases.

You enter supercoolperson@amazingdomain.com into the app. The app uses amazingdomain.com to find your LinkKeys server. It then creates a secure, one-time login request and sends you to amazingdomain.com.

You log in to amazingdomain.com, not to the app. Your domain shows you which information the app requested. If you approve, your domain sends only that information back to the app in a form the app can verify.

Oh, did I not mention claims? Oh, this is where it gets good.

## Claims are the Power

When you go to a bar, or sign for an important package, what do they want to verify about you? One wants to know that you're over a certain age (this can work for multiple countries, yes). One wants to know that your name or address or both match what they have on file. Maybe your picture. Do they need to know your eye color? Do you want them to know your eye color?

Claims are the individual pieces of information an app or website can ask for. Your domain can "sign" these pieces of information saying that your domain itself says, "This is a true fact I attest to about this ID." You don't have to give them your eye color, or your address, if they don't need it. The app _requests_ them and you get to approve those requests and know exactly what is being sent. Do you not want to be Jane Doe on KnittingEnthusiasts.com? KnittingEnthusiasts.com only cares that you're a real person, not what your real name is. It wants to keep spam bots out without forcing you to identify yourself publicly. Great, your display_name claim can be "Anonymous Aardvark" on KnittingEnthusiasts.com and nobody cares. You're still supercoolperson@amazingdomain.com but that's just a handle. Nobody can ask amazingdomain.com what else you've logged into. That's not even part of the protocol, and you _wouldn't trust a domain that added that_, would you?

That's part of the power. You can keep domains honest. People on the internet have a lot of time on their hands. They will absolutely hold domains accountable.

The real joy? Your domain does not have to be the source of every claim. A state agency could verify your age and sign an "over_21" claim for your LinkKeys identity. Amazingdomain.com can present that claim when you approve it. An app does not have to trust amazingdomain.com about your age; it can verify that the state agency signed the claim. The app learns only that you are over 21, not which ID document you used to prove it. You can provide proof you're not a bot without a captcha, and without giving up your whole driver's license to every site asking.

## The Result?

Bots and spam are still allowed, but on apps that care about bots and spam, they are much more difficult, and the apps spend less time and money on the problem. Literally as fast as we can prove we're actual people, we can do that. Will people get their accounts, prove they're humans, and still post AI slop? Yeah, but sites can report abuse to their users' domains, so you can trust that spammers will lose trust from their behavior where it matters, not some central authority's ad revenue needs. I can say in my terms of service, "thou shalt not post AI content" and moderate you or ban you if you do. Sites can block abusive accounts, and they can block an entire domain if it keeps allowing abuse. That makes every domain responsible for maintaining trust. Will that cost you? Maybe, but you'll never have to deal with bots or spam as much as you do today. Guess it depends.

That's the point. We don't solve trust. We provide tools for you to solve trust how you want.

I'm running [Catalyst LinkKeys](https://catalystlinkkeys.com), where you have to verify your email to sign up. Anyone can do so right now. We're at the "nerd adjacent" stage, ready for people who want to be part of the solution while LinkKeys is still experimental. For now, that means nerds that care about their craft who can update their apps quickly when things change.

If you're one of those nerds, join the [community, especially the Discord](https://catalystsquad.com) where we work on this and related tools, and I'll keep you up to date and coordinate with you. If you get an app going with LinkKeys authentication, I won't break it without notice. I'll make it super easy for you. You no longer have to handle authentication. I have libraries for you in 15 languages. I'm working for _you_ right now.

I want this to be a foundation we build on together, to solve real internet problems for all of us, including my mom. Let's build together.


## Postscript

Look, someone's going to want to know how it compares to other solutions. This isn't the article for two reasons.

First, I want people to understand the problem LinkKeys solves before I compare it with unfamiliar alternatives. We can do that in another article. I know several alternatives, probably more than most, and I have answers to the comparison questions, some of which don't make LinkKeys the clear winner either. If you want that article, ask me in Catalyst's Discord or email me, and I'll write it. Until then, it's not the time.

Second, and this is important, I don't care who wins. I want the solution. LinkKeys is the strongest solution I have, but not the only solution. I'm willing to put in the work to solve the problem and _not_ get paid. Do you want another solution to win? Great, let's compete and make each other better. I'll even contribute to your solution if it starts actually solving the problems, because three competing solutions that complement each other are better than no solution at all, and no solution at all is better than a solution that one company controls that will eventually fail. I want the outcome, not the player.

If you care more about who wins than solving the problem, fine, but that's not the game I'm going to play.
