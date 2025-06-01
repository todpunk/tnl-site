---
Author: 'Tod Hansmann'
Title: 'Bazel Needs Replacing'
PostedDate: 'Sat May 31 17:30:00 MST 2025'
Tags: ['bazel','rants','software','technology', 'angry']
Hook: "<p>Bazel is the by far the most complete and popular monorepo build tool we have. It also is utter garbage and needs to be replaced.</p>"
---

I should note that like _always_, this is not reflective of my employer, even though I only started learning Bazel for work. I've had a lot of conversations about it with the local tech groups that use it in various ways, and I want to rant about it as me.

## What Bazel is Good At

While I say it's good for monorepos, I should say I think Bazel's strength is actually just any complex build system that isn't working within a single-project. This could actually be spread across multiple "repos" but I'm mostly trying to avoid defining a monorepo because that's a different can of worms. Bazel excels when you have a dependency graph that's granular and multiple toolchains to wrangle. The goal is the same as any build system, reproducibility and consistency. I have a lot of complaints here, but that's for later.

Bazel is also very good at _navigating_ that build graph by querying it or bifurcating pieces of it so you can use it for other purposes like making sure you only build things for the appropriate platform you're targeting in this run, or only things that this C library affect (including your Python app, and even then only the pieces of that app that use the C library).

Some other tools exist that aren't as popular, don't have the ecosystem, and more importantly haven't actually solved many of the issues with Bazel in a way that satisfies me. Some are unwieldy, some only work for Javascript (why does the JS ecosystem do this?), and some just straight up don't have features like querying the dependency graph.

Is that enough praise? I really, really hate Bazel, and I want to talk about that and what should replace it.

## Bazel is Overengineered

I have built massive applications with complex dependencies across language boundaries before. Our "build system" at a company that did a rugged tablet for playing media on a plane had to build the entire OS as well as our many apps on it, as well as the distribution software. That was a bunch of make files for C libs or tools, and bash. Technically another side of the system was an automated install of the server that my boss wrote in the most readable Perl I've ever laid eyes on, but that could have been bash or just a python script. I go back and forth, but it was just a single script you ran after you had installed Debian.

I could teach you how to use these tools as a junior devops engineer, soup to nuts, including the make stuff (which they had never seen), and you'd be able to start contributing in a day. I know, because I did that. Twice.

Bazel is something I've been learning for the last 6 months and I still have little to no clue how it actually works at a deep level. The jargon is confusing, they've invented words for all sorts of stuff that isn't consistent and gets tacked onto because it doesn't make sense otherwise. There's "rules" but there's also "repository rules" that are different, and "macros" which are rules that make rules but they themselves aren't rules? Every rule has an implementation that's different but takes some of the same stuff shuffled around because... I'm not sure why. Uses of rules are targets or something, depending on context.

Look, it doesn't matter, I'm sure I'm also "technically" incorrect on some of that, and it's infuriating because I know that and yet _it doesn't add any value so I don't care_. Bazel is just layers upon layers of horseshit that doesn't need to be there to accomplish its goals. It is overly complex for no reason. I want much of what it offers, but it has to be more approachable. The ecosystem isn't better either. Half the problem is I don't want to be stuck with Bazel, because it's like being an OracleDB expert, who fucking cares?

## The Bazel Ecosystem Can't Get it Together

Bazel wants you to use hermetic toolchains and hermetic build targets so if you have the same inputs you get the same bytes out at the end of the graph every time. This is theoretically possible, of course, and would be desirable but it's also expensive to do at various levels of hermeticity, and no discussion of where diminishing returns begins will be had.

Of course, the ecosystem of tools doesn't give a damn. For a long time you couldn't find a hermetic Python toolchain (since it binds to a lot of system libs at runtime), and it's still super easy to create things without a hermetic toolchain at all. Plus, if you use inputs you built elsehwere, Bazel can't know that. Not that they bother to isolate anything well anyway without extra hoop jumping.

Then of course there's the updates. Bazel does major changes all the time and the ecosystem can't upgrade to save their lives. Latest versions of Bazel are changing to a "bazelmod" system that supposedly addresses some issues I couldn't care less about at this point. Some of the rules like rules_docker were abandoned so they'll never upgrade, and other rules depend on those, and other rules just can't upgrade because they want a feature that doesn't work quite the same in new Bazel versions and more importantly to that the switch is _never straightforward_ and not always even documented. You have to figure out a lot of how things work on your own if you don't like magic black boxes (like when you're providing rules the ecosystem uses).

It's just a nightmare, and is so quintessentially Google as to be worth abandoning on that point alone. And yet, (and I can't stress this enough) it is still the best thing of its kind out there for any use case that isn't trivial. Unless you were disciplined when you built your own bespoke thing at the beginning (see story above about linux tablet company). Yet Bazel still fails at basic things so you end up with requirements like Gazelle.

## Gazelle Will Eat Your Soul

Gazelle is a way to generate all the rules you need for a given language package or whatever unit thing, with a bunch of options that can be extended to other things for whatever I don't even know anymore. Let's talk about Go. I love Go, it has things so you can know you're getting the _exact hashable version_ of dependencies you built from last time, or it will fail. These go.mod and go.sum files are great for knowing exactly what you're building and updating using your standard workflows when you need to.

Bazel doesn't work with any of that. It can not simply `go build` and copy the resulting binary for you. More accurately it could, but it would just be a script runner at that point, and no Bazel person is going to think of that as even a possibility. It has to build each individual piece and know the hash of each piece to know if it changed and needs to build and link the other pieces in the chain. If you have a more complex build where your Go binary needs to build against some specific C library and do a bunch of that sort of thing, you'll have a more complicated build anyway, but Go has facilities for that too.

In Bazel land you must use Gazelle, because the aforementioned need to build individual pieces. Turns out you can do that, yes. Gazelle will put a bunch of targets in your Go file tree, some will be for how to download and get the third party libs. I mean this without any sarcasm: Go can't do that, Bazel has to do that for it, otherwise how would it be hermetic? The unit of hermeticity would be _the whole thing_ in Go.

Bazel needs control to isolate all the variables and thus requires we reinvent everything along the way. Gazelle was needed because that's very automatable and it turns out Go uses a lot of dependencies even for small apps. Gazelle generation does also make it so you avoid cyclical dependencies so you're doing good things with code organization, but only if you go as granularly as possible. If not, you'll have a mega-package and Bazel will build the whole thing everytime anything changes, so no benefits.

Gazelle makes that whole process easier, but is also several more layers of black boxes. You'll get little help with how to use it, you basically have to read a bunch of source code and guess and maybe talk to someone at a convention or whatever. The errors it gives you, like Bazel, are meaningless unless you're a Bazel/Gazelle core dev. Even then, probably, mostly useless. A hint of the area that the problem might be in.

## OK, I've Ranted Enough, Let's Talk Solutions

My most controversial statement about Bazel is probably that I don't think you need to go granular as much as Google thinks. C and Java devs have a perspective, and it's born from blinders. There's no need for that granularity in a Go or Python app, those ecosystems have facilities to manage that themselves (maybe they're awful, but they do have them, usually several). If make is adding value, it can continue to add value to the C codebase, and the larger build system (Bazel in this case, but anything really) should be able to lean on that.

Moreover we should strive to use the standard definitions of projects for their codebases. Above I mentioned go.mod and go.sum, which Bazel doesn't use (Gazelle does, so that Bazel doesn't have to). Your editor doesn't understand Bazel, so now you have to maintain both. Just don't do that. Let Python use pyproject.toml and stop trying to do a complicated pip compile setup to convert to a requiremnts file that you then feed to Gazelle before you can ever even run Bazel.

It should be easier to query the build graph to answer basic questions like "what depends on this thing?" without having that granularity. You can separate the dependency graph data structure and the individual implementations of how to extract that information from the given setup. That API contract is more important than controlling the world (this philosophy is a key reason I can never work at Google, but that's ok, Google is awful at engineering).

Specifically, if I have a C lib in one directory, and a Python app that depends on that C lib, the C plugin should load that dependency graph tree into the larger structure, and the Python plugin should load its piece. Use placeholders for unknowns before the graph is considered complete. I don't care if it's differently implemented, the point is this is very possible. I don't need everything native Bazel to enable this. Hell, I say "Python" and it could be setuptools based for one plugin, poetry for another, uv for another, or a mix. The point is the API contract means I can do _whatever_ in a given language and make that easy without having to even involve the core build orchestration.

## What Should a Replacement Work Like?

Let's call the new thing Foo. If you want to stay somewhat close to Bazel's workflow, have a core "workspace" or "module" or whatever defining either the functions available in the namespace or the configuration for the things. Separate concepts would be better so you know if you're providing a thing for Foo to use or a thing for your repo.

You can just define the tools needed, in their entirety, and any extra libs/files, and throw them in an entirely empty container and run them per build artifact. Share them in the dependency graph, I don't care. One version of Go? Seven? Just download them all, hash them. Make it easy to say "set the hash for our specific Go 1.21 binary we download from this URL" so I don't have to do any manual steps. Call it a "setup" and just do all of them.

You could just have this codified. Call build binary packages "toolchains" that have to be singular and complete. Call third party libs "libraries" and similarly I download them and shove them in a specific directory. I can set the LD_LIBRARY_PATH for build targets or globally with overrides or whatever. Just make it simple. Assign them to a variable as a name I choose. Don't make them workspace wide, that's stupid. Why would I want to limit myself to one version of a library for my whole repo? What a stupid choice. I want reproducible builds, not totalitarian control over all binaries. That's how you get things that can't be upgraded because nobody has worked on them for a year, but that app still makes the company money.

Make targets simple. "Here's a set of inputs, the target will have X outputs we care about, let the actual tool do everything in the middle, just copy all this stuff into and out of the container, and error if there's a change." You can isolate that entirely from the network and make language plugin people provide the "setup" that downloads all the libs to the right place. I don't want Foo to know anything about Python. I want Foo to run `uv` based on the plugin I chose for it to do that with this target.

The dependency graph will be nice and chill, too. I can go granular if I want to use a plugin or write a plugin for Foo that does granular, but it's isolated, and a choice I can make based on what I'm building. I don't need to conform the entire world to Foo's philosophy. Foo works for me. It unapologetically lets me shoot myself in the foot. Since it should be simpler, it can tell me more about how it failed because the rule expected N inputs and didn't get them, or the inputs hash hasn't changed.

## This is Such a Rant

Look, I don't pretend that this is a fully baked design. I'm saying that I hate Bazel with a passion, that I want a replacement, and that if you built that replacement I'd evangelize it and use it for everything I had power to. That's not much, honestly, but all my open source tooling is a nice target, and I'd love to make it a community. I'd love to write about it, tutorialize it, whatever will help us all kill Bazel and move to something that gives us hermetic builds without the pain. I want constrained inputs of tooling, libraries, and source files to consistently build, test, and run reproducible outputs. I want to cache those results and only build/test what I need to build/test and nothing more.

I also know a hell of a lot of other people stuck with Bazel at companies both small and large are in this same boat. If it was easy to convert, you could get people instantly.

That should be doable without an overengineered Java mess that makes it hard for me to use the standard dev tools in my editor/terminal/IDE. I want to query the graph and get results, I want to have multiple targets and remote execution and simple permissions like letting devs download but not build to the cache to poison it or whatever. It just needs to be so much simpler.

Hell, I'll help build it. I just can't add it to my pile currently or I'd be doing it already. If you want to, join the [Catalyst Community](https://discord.gg/sfNb9xRjPn) and talk to me. I'll mentor you to victory on it. Or wait years until I get around to it I guess.
