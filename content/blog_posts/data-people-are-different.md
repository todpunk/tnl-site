---
Author: 'Tod Hansmann'
Title: "Data People are Different"
PostedDate: 'Tue Feb 11 18:30:00 MST 2025'
Tags: ['rants', 'opinions', 'data', 'industry']
Hook: "<p>Some data people think they're just software engineers with a different focus, while some software engineers think data people have no idea how to code at all, and all of this is both true and not and silly. The confusion needs to stop, because working together is hard enough without the egos and title gore and miscommunications.</p>"
---
Let me preface this rant that the audience I'm talking to are mostly software engineers or devs or programmers or whatever people who think their primary activity is code like to call themselves. Titles are meaningless, so I'm using terms to call distinction. If the terms offend you, great, I support you! Just don't tell me, because I don't care, I'm trying to communicate, not coddle. I'm kind, not nice. (I should write a blog post about that.)

## What the heck are data people?

Data people has overlap with other coding disciplines, but not as much as some would like to think. Data folks tend to work with, you guessed it, data. In the last 20ish years, they have tried to make "big data" important, even though nobody has that, but that's not their fault. The industry bought into a hype cycle, like they often do, and it didn't deliver, like it never actually does (though we always move the goalpost on the small successful bits being what we intended all along in every tech fad).

You can tell a data person by what their data storage they work with is in. So if it's a normal database, that's a Database Administrator or someone with an "Infra" or "Devops" role (those aren't roles, but also are, yes). If it's a list of Apache Projects or anything from a "Data Warehouse/Lake/Etc" company, that's a data person. If it's someone using a Jupyter Notebook (or one of the less known but all-but-dead other Notebooks) that is definitely a data person.

Note how this isn't passing a judgement. See how that is, talking about people as they are without saying they're bad? Let's fix that. Data people can be awful, and data people can be amazing. Just like every software industry job! Except Scrum Masters or any "person" peddling "SAFe" (and yes, that's capitalized correctly, don't look it up, save yourself).

## The problems with data people

Software Engineers of all kinds tend to look at data people as a separate entity. They're often a different org, often a different reporting structure, but they also attend different conferences (unless it's a Python conference), and outside the overlapping interests tend to have a lot more interest in the data instead of the code operating on it. The problem with the people well outside the overlap isn't actually with them, it's with the rest of us. We don't get it, because _this industry is bad at basic social skills_.

You see, data people break processes of most other software engineering. Even Frontend Web Devs at least have a build and deploy step for anything they do, and they're thinking about the structure of their code as if it's important more often than not (it is, but not as much as they think). Data people can have requests that look incredibly naive to a lot of other engineers, like "can we put this notebook in production?"

Let me translate that from data person (of a particular kind, I'll note, yes) to more common software engineer parlance. "I have written a set of scripts that solve the problem, I don't know how to run this anywhere else because that is not my role and not my interest, can you help me?" Somebody is going to read this and think, "well, they should just say it like that." That person needs to sit down and think about what effort they've put into translating their own requests in their foreign audience's vernacular. Humans suck at communicating anything complex, and most of it is complex. Computer nerds like we all are tend to suck even more. Have some empathy.

The reason they don't ask that way is because they're just as human as the rest of us. Annoying? Sure, why not. Naive? For some perspectives and definitions, yes. Is any of tha that helpful? **No!**

## Data people are here to do what you can't

I once managed over half a dozen PhDs in Math and Physics. They were brilliant, and they understood the software engineering side of the equation quite well. They were usually data people who swapped to software engineering, though a couple of them were web devs that understood statistics and such. The Data Science org was just as large and had people that were much more of the traditional data people you hear people rag on, but I liked them and they tended to be more software aware than many notebook trapped folk.

You'd think they would have communicated better about software and deployments and stuff. To an extent they did, but they didn't function as well as you might expect. This is because the problems trying to be solved are _different_ and they need to be _understood_ by each other, or at least one side. I'm personally putting that on software engineering, because there's more of us and we need to be better glue. A lot of software engineers naively believe their role is about writing code. No. Code is not the value anyone wants. No business has ever hired me to write code, but I have written code at every professional job I've ever had. They might _say_ they want me to write code, but what they actually all wanted was for me to provide value, often by writing code as a leverage point to produce it.

No, that's not an obvious quip. I can't tell you the enormous majority of software devs that think their code is their worth. If you can do something with 800 lines of code and I can do it in an excel spreadsheet, which is more valuable? You can't answer that, because neither _are the value_ without the _context_ and the _problem_, but we're typically having that debate instead of what problems are valuable to solve. It's a dumb debate.

Software engineers are there to glue knowledge of one domain with knowledge of another domain, to translate the interactions between computer and _stuff_. If you don't understand how to garden, you can't automate a robotic garden. You either need to get someone to tell you how to garden, or do research and learn, and _that_ is the value you're providing.

Data people have a different goal. I hesitate to say "insights" anywhere in here except to say I don't want to say that here. What I will say is that data people are trying to manage the things an org/business/group/whatever produce as bits of different kinds of data, and turn that into something that is useful. That has a host of _very different concerns_ that turn a lot of software engineering assumptions on their head, but the key for this section of this article is this: software engineers can not do this, because they do not know how to garden, so they need the gardeners (data people) to tell them _how_, and so both are needed for success for either group.

## What's so different about data?

In a typical software engineering flow, you have a nonprod environment (where customer data does not live) and you write code and run tests on test data you might generate or whatever, or scenarios you invent, or an internal prod-like instance that isn't prod. I don't want to get into the weeds here, but suffice to say, you can write a test to say "if this input is given, does my code do the right thing?" We are fools. This is so myopic.

Here's what a data person is looking for: if N% of people write a novel, what does that do to the price of apples? You think they're writing a SQL query to tell us what percent of people write novels, because you are a good software engineer and know SQL. (If you don't know SQL, just learn it. I'm going to make fun of you in a different article. You will deserve it.) You missed the part where it did some complicated math that only works in prod because that's where the model they're making is validating through exploration of that data that we can tie novel writing to purchases of apples by looking at 17 other data sources like the number of flight attendants stuck in Florida on Thursdays.

You don't get it. It's not a function, it's a model. If the data changes, the model doesn't work. Physics is full of this stuff. We have models to describe in incredible detail the arc of every object in the galaxy, but it's all with a margin of error and none of it works inside a black hole because it turns out we didn't account for a whole slew of things. Data people are doing that with the worst data a company can "record" and learning how a git branch is different if it's merged with a rebase or a squash is _not even tangentially relevant_ to that exploration they're doing.

Our job in the software engineering world is not to make everyone conform to our tools and understanding of computers. It never has been. Data people need help to take that model, and operate it. That's why those tools (that I loathe and despise, but rants for another day) are so prevalent in the data world. They need a very different set of workflows. We need to bridge between those. Data Engineering is a half-hearted attempt to do this, but like most software engineering we don't know how any of this stuff works in the real world and business just wants the magic from the nerd floor.

## What to do about it all

I like Data Engineering as an attempt from the data world to sort of bridge the gap. Hire software engineers with a specific discipline of making the data people's lives more productive without having to hear the latest sysadmin rant about how the data team is wasting money running an expensive cluster all the time, or doesn't understand why their branch isn't pushed to github. It turns out, we're the problem, not data people.

We need two things:
- Empathy for the gardeners of data
- Solutions that hold them accountable for what they can manage, but not for what is just a waste

Sound like internal software engineering of all kinds? It is. We need more of that. Don't make other software peeps, be they data people or not, worry about what isn't valuable for them to worry about. You're just making them waste time and money, making everyone sad, and widening the gap between now and solution. I don't make you worry about what assembly instructions your code is producing through the compiler if it's not relevant to your work. Why would we do similar to anyone else?

Get in their world. Understand the whole flow and lifecycle of the things they're trying to do. Is it a batch job that needs to run every day at 3 AM? Are they asking to do that in Airflow? Maybe that's the right tool, or maybe a simple cron job or a kubernetes cron job or any other number of things is the right thing. Discuss trade-offs. That's what engineering _is_. It is _not_ discussing trade-offs that you prefer. Your tools are inadequate until your _users_ say they are adequate, not the other way around.

If you can care about it from their perspective, everyone wins. You can build nice workflows together, make sure they own the results just like any other software engineer would (if the job is failing somehow and is alerting, the data team that owns that job should be woken up too, yes). Make that a joy, which means it's not brittle, and it's not false all the time, and they can fix it easy by the same well known workflows you built together. Be on call. Change the game so it's co-op.
