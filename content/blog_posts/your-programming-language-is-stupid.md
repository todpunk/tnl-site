---
Author: 'Tod Hansmann'
Title: 'Your Programming Language is Stupid'
PostedDate: 'Sun Sep 14 8:30:00 MST 2025'
Tags: ['rants','engineering']
Hook: "<p>So many programmers I know have their favorite language, and they really, really want to sell me on the virtues of it. The problem, every time, is that their programming language is stupid, and so is yours. It doesn't matter what it is, it's a stupid one. I know, because there aren't any programming languages that aren't stupid. There's no panacea, no golden balanced ratio. Especially yours.</p>"
---
## Values

You may think I'm being overly harsh, but you already agree with me. Every programmer also has a much longer list of programming languages they find painful, or ugly, or whatever. The difference between the language you love and the ones you hate is not a set of features, it's you. It's the value differences.

Bryan Cantrill has a wonderful talk about the [values of platforms and languages](https://www.youtube.com/watch?v=2wZ1pCpJUIM), or if you prefer reading there's a related podcast interview about software as a reflection of values](https://corecursive.com/024-software-as-a-reflection-of-values-with-bryan-cantrill/). I'd love for you to experience one or both of them. They're much nicer than my rant here, but on a different tangent or I'd just link you there and be done.

Regardless, your programming language has a set of values, and your values priority list align best with that language (so far). This doesn't mean your programming language isn't stupid, it means the particular brand of stupidity it exhibits is one you prefer to live with.

## Think Different Indeed

Some cynical moron is going to be reading this and think, "oh, Tod just wants a perfect programming language that is like Foo" and that's just the dumbest conclusion to jump to I'm not even going to address it. Just know that I see you, that's very nice, but sit down and let the adults talk. If you can't be arsed to read and understand the bigger picture I'm ranting about, that's fine, I'm not forcing you.

For the rest of us, I sadly have this role I seem to fulfill a lot in life. I build bridges between groups, I represent the other perspectives people don't see in their individual villages they're comfortable in. I'm not a provocateur, I don't want to challenge you just to challenge you. Instead, I want to share in your perspective, maybe ask some questions about the gaps I see or why one thing works over others. It is ultimately selfish, in that I'm trying to learn how to see and think from more breadth of experience than I can gain in one lifetime.

Programming languages are like this, because of course they would be, given they're expression tools. Any human expression tool is going to find itself constrained to the values most present in the context those tools sit in. Music evokes feelings for most people. However, there's no relaxing, go to sleep death metal, and even though someone can find or produce a counter example, it is the example that proves the rule. Such a musical piece would be jarringly different, to the point that you could say "yes, this definitely fits the description" while also saying "this definitely wouldn't be in the mainstream of genre or anywhere close."

## What Your Language Says About You

I know plenty of people that can't stand YAML. It seems to boil down 99% of the time to aesthetics, and nobody who hates YAML would agree with that statement. Alas, it's still true. "there's this problem or that problem" is accurate enough to be compelling, but if you think more broadly you can see that usually "this problem" or "that problem" are common and avoiding them is an optimiziation for those, while also asking for others. Everything in engineering is trade-offs.

When someone tells me they hate YAML, it tells me nothing about YAML, but gives me a great deal of information about them. It's the same when someone tells me they love a given programming language. Let's use Ruby as an example, because Ruby zealots don't have feelings.

Ruby is almost always about expressing some given thing to the point of almost being a Domain Specific Language you develop in Ruby until you have a thing that is Ruby, but really it's your own thing. Ruby on Rails is largely that for a web app, and there's smaller groupings of things for working with background tasks or database abstractions or whatever other stupid thing you want to have in Ruby so you can avoid thinking about the details of the instructions that are running on your CPU.

See how I contrasted that? That feels like I'm saying one should want to avoid Ruby so they can think about the details of the instructions that are running on your CPU. No! That's what Rubyists want to avoid. It's more "elegant" to express your intent in Ruby than to write code for a CPU to execute. So do Rubyists not know how CPUs work? Well, as a community, maybe that's a trend, but as much as I'd love to mock Rubyists, I did enough of that here already, we don't need to keep that up. The value is they want expressive code, and CPU execution is lower on their priority list.

That will breed an ecosystem that doesn't know the CPU execution as well. That's ok, that's not what they're optimizing for. Meanwhile, the C folks have the opposite problem, where everything has to be tightly controlled for some "good engineering" reason and expressivism be damned. Some C folks say that's a skill issue, and they're right, but the fact that they're right is why they won't learn how to think like a Rubyist and see where expressivism gets you benefits that are worth the costs. Of course, some C zealot is defending expressivism in C and again, I have to stress that this is _missing the point_ entirely.

## Perfectly Balanced As All Things Should Be

I don't want a perfect programming language. I regularly work in several lanaguages at any given time. I hate all languages, just some more than others. Javascript is the worst language, and Typescript doesn't change that (you have to bathe before you put on the tuxedo). Java is also very, very bad, but I'll still write Javascript while I gave up Java years ago (except maintenance, because of course).

There's this human problem where we say "I have a list of N things and they all suck, I should make another thing that has the features of the N things that are great, but none of the things that aren't" which is great until you want one programming language to rule them all. I have hopes about new languages having new trade-offs. There's things I think are universally valueless, like whatever keeps making Visual Programming try to happen (or No Code as they call it right now, but the point is we keep doing it, and I say "whatever" as if it's not explicitly to let stupid people write software which is a terrible idea).

What I think is interesting is that we tend to ask "what would the balanced thing look like" which is the entirely wrong question. There is no balanced thing. There are only balanced things. If you don't have the group, you don't have the balance, because you need multiple perspectives to see what the bigger picture even is. Why might you use Python over Rust? Why might you use C instead of Zig or Ocaml? Are those even comparable? Why should we hate Java?

We need multiple stupid answers to see how the overall result can be smarter. What I would like less of is how awesome your value is compared to other values. What I would like more of is how your value optimization has added to the craft of software for users. If your language is ideal for you and you can't make something people love with it, you're in Haskell or something equally pointless. If you can make something people love but you can't do it without any sort of efficiency, you're a marketer cosplaying as a programmer, and I hope that open source eats your career.

We need more playing in the stupid languages, but productive play. [Competitive cooperation](/tnl-blog/competitive-cooperation-thoughts.html), but for more efficient and loved software.
