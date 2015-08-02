URLs
====

The idea here is to make urls that are expandable for future functionality but don't
break anything in the past, so you can't just start with url.com/idoffeature/ because that
will not be the id of all features.

We've broken features into their exclusive module type things.  For now we'll start with a blog, and break out into other "apps" or features later.  Let's list some examples:

url.com/blog/parenting/
url.com/blog/<id#>/
url.com/blog/create   <--- note the lack of /
url.com/blog/ids/?ids=blah.2.58
POST url.com/blog/parenting/ \r\n\r\n { action: "delete" }

url.com/account/settings/
url.com/account/signup/
url.com/account/profile/
url.com/account/logout
url.com/account/billing/

url.com/groups/id/tnlusers/




The entire reference convo:

<TodPunk> I thought rest was a query
<yuriks> url.com/blog/todpunk/with-tags?tags=programming,deadlines,business,movies
<TodPunk> I think of resources as fairly static things
<TodPunk> rest is shit
<yuriks> I studied a bunch of REST APIs for a project I participated in last year
<yuriks> take a look at the Twitter and (tun dun dun) Dropbox APIs
<TodPunk> yuriks: yes, but they do like 4 things, and they're all bullshit I might add
<TodPunk> twitter uses : a lot
<TodPunk> -_- and underscores
<yuriks> well, you can do whatever you want, it's not like there's a REST standard document or anything. That's just what I'd do
<TodPunk> ok, so, url.com/blog/todpunk/with-tags/ and url.com/blog/multi-user/with-tags/
<yuriks> (for the record: I would not do the pure JS, that was a tought experiment)
<yuriks> what is multi-user?
<TodPunk> you want RodgerTheGreat and TodPunk's blog posts together
<TodPunk> but only their Forth tagged posts
<yuriks> so *all* users, not like, a specific shared blog between people?
<TodPunk> oh fuck
<TodPunk> no wait, that's not ruined at all
<TodPunk> so I was thinking I could have multiple blogs
<TodPunk> like a dev blog and a parenting blog or something
* yuriks would identify blogs by numeric id, but also allow substituting an alias for the id
<TodPunk> url.com/blog/todpunk/id/with-tags/ ?
<yuriks> maybe use * to search for everything then, if that's a valid character in URLs
<yuriks> TodPunk: no, just url.com/blog/todpunk/...
<TodPunk> actually, why am I tying this to users?
<TodPunk> usrl.com/blog/id/
<yuriks> but you can also have url.com/blog/12/... and that's equivalent
<TodPunk> usrl.com/blog/ids/?ids=blah.2.58
<yuriks> or url.com/blog/parenting-adventures/... which is an alias to url.com/blog/14/...
<TodPunk> and 14 can have multiple authors
<yuriks> yes
<TodPunk> SO much better
<yuriks> blogs/authorship are separated concepts
<TodPunk> yeah, that's what I was getting at by the tying it to users comment
<TodPunk> it was dumb of me
<TodPunk> url.com/calendar/id/
<TodPunk> url.com/calendar/ids/
<TodPunk> url.com/project/id/
<TodPunk> url.com/project/ids/
<yuriks> the downside is if accounts get deleted you end up with funny orphaning issues, but you could just run some garbage collection, removing un-owned blogs and giving admin rights to blogs with some other author
<TodPunk> the alias thing would be weird for all of these
<TodPunk> accounts don't get "deleted" per se
<TodPunk> actually, if it does, that's fine
<yuriks> I'm thinking this mostly in the context of github, where repos are tied to accounts and it gets weird
<TodPunk> yeah
<yuriks> upsides are you don't tie blogs to accounts so you can actually delete accounts and whatever
<TodPunk> this way if they're just separate objects, we can enforce a many-to-1 relationship if we want, but it's not inherent in the data
<yuriks> TodPunk: my idea was that you don't actually have endpoints for id or alias, it's just, if you have a number, treat as id, else it an alias
<TodPunk> mhmmm
<yuriks> or did I misunderstand the /id/ vs. /ids/ thing?
<TodPunk> no, id vs ids is single or multi
<TodPunk> different auth process, though not required
<yuriks> not sure I follow
<TodPunk> just makes processing it nicer as you can run it through a slightly different ocntroller component later
<TodPunk> rather than having to check for a ?ids= every time
<TodPunk> url routing is a LOT faster than query parsing
<yuriks> what is ids?
<TodPunk> ids is the multiple ids url, so if you want multiple blogs
<yuriks> oh, I see
<TodPunk> like constructing a single rss feed for all your blogs you want
<yuriks> mhmm
<TodPunk> now, irc
* TodPunk plays a bit
<yuriks> I dunno if I'd try to put it in the URL, but I can't think of an obviously better idea
<TodPunk> url.com/ircbot/id/
<TodPunk> url.com/irc-bouncer/server/
<TodPunk> hmmm
<yuriks> maybe url.com/blogs/todpunk+parenting-adventures/posts/? *shrug*
<yuriks> probably not a valid url, but s/+/,/
<TodPunk> yuriks: I think that just makes url parsing slower
<yuriks> it's just pattern matching against the slashes, shouldn't make much of a difference, should it?
<TodPunk> then you have to explicitly take the thing out, check if it's dotted or whatever, go through a different control path if it is
<yuriks> hm, ok then
<TodPunk> am I crazy for thinking that?
<yuriks> I think it doens't make an appreciable difference
<yuriks> hell, make the specific path part of your general path
<TodPunk> ?
<yuriks> url.com/blogs/todpunk/posts/ is just a search for posts authored only by todpunk
<TodPunk> as opposed to url.com/blogs/parenting-adventures/posts/ ?
<yuriks> er, for posts in the "todpunk" blog
<yuriks> sorry
<TodPunk> oh
<yuriks> as opposed to a multi-blog query
<TodPunk> so how do you do a multi-blog?
<TodPunk> oh
<TodPunk> the same as previous
<yuriks> url.com/blogs/todpunk,parenting-adventures/posts/
<TodPunk> mhmmm
<yuriks> though, if you're gonna use that for your RSS feed, and it'll include 20 blogs
<yuriks> that's gonna get messy
<yuriks> I don't feel this is the path to take
<TodPunk> you make a compelling anti-point to your idea
<TodPunk> id/ids it is
<TodPunk> url.com/irc-bouncer/serverid/channels/
<TodPunk> url.com/irc-bouncer/serverids/channels/
<TodPunk> hmmm
<TodPunk> nah, that just wouldn't happen
<TodPunk> url.com/tasks/listid/tasks/
<yuriks> one must be careful not to reinvent SQL :P
<TodPunk> no kidding
<TodPunk> I'm hoping to eliminate a lot of parsing of GET var states and let the url route to an appropriate action that has to do as little as possible
<yuriks> I think it's worth trading a lot of routing complexity for some GET parsing for the more complex end-points
<TodPunk> yes
<TodPunk> but you can see how a little added complexity (simple as it is) saves a ton of coding between url.com/blog/thebestblog/ and url.com/blog/ids/?ids=thebestblog+parenting-adventures+RtGs-Happy-Hour
<yuriks> oh yeah
<yuriks> the ids/ idea isn't bad at all
<yuriks> it's what I was referring to, actually. Sorry for being confusing :)
<TodPunk> I'll think of the irc complexity issue later.  Nothing's coming to me on that one and it's down the road anyway.
<yuriks> would that retrieve logs or what?
<TodPunk> url.com/account/profile/
<yuriks> I don't think doing multi channel queries is very important
<TodPunk> yuriks: irc-bouncer would be your bouncer config
<yuriks> ah
<TodPunk> and if we make a web interface, it may make sense or not, I'm not sure.  If 10 users are connected to a channel, they should get the same history
<TodPunk> but what if someone blocks Rodger?
<yuriks> client local
<TodPunk> again, complexity to deal with later
<TodPunk> yeah
<yuriks> I mean, on the bouncer
<TodPunk> yeah
<TodPunk> the web interface would be client-local, and would just be more fantastic.  Probably have to let JS do the filtering
<TodPunk> anyway
<TodPunk> url.com/account/billing/
<TodPunk> url.com/account/signup/
<TodPunk> url.com/account/services/
<yuriks> (well, you'd have the central log repository that doesn't filter anything, then you filter when returning queries for specific users, moving on)
<TodPunk> url.com/account/logout/
<yuriks> without the trailing /
<TodPunk> awww, I like the trailing /
<TodPunk> why not?
<TodPunk> it's so pretty!
<yuriks> logout doesn't have sub-things *frown*
<TodPunk> RodgerTheGreat: tell him it's pretty!
<TodPunk> yeah, that's an interesting point =c(
<TodPunk> url.com/account/settings/
<TodPunk> hmmm
<TodPunk> can add onto the account a lot I guess
<TodPunk> we'll keep it simple at first
<TodPunk> url.com/admin/users/
<TodPunk> ick
<TodPunk> url.com/blog/create/
<yuriks> REST is like procfs/sysfs. GETs are cat-ing, HEAD is stat, POST is writing to files and HTTP headers are ioctls, heh
<TodPunk> ooooh, I like create
<yuriks> TodPunk: that's a common pattern to replace PUT
<yuriks> url.com/blog/create , you need a way to disambiguiate create from a blog name
<yuriks> (or you PUT url.com/blog/ )
<TodPunk> url.com/groups/id/tnlusers/
<TodPunk> hmmmm
<TodPunk> yuriks: url.com/blog/admin/create/ ?
<TodPunk> admin is a reserved name?
<TodPunk> blegh
<TodPunk> reserved names make me cranky
<yuriks> that works, but but having create directly under blog/ is more RESTy
<TodPunk> in which case create/delete/merge are all sort of taken
<TodPunk> or just create/delete
<TodPunk> but you know users are going to ask for things
<yuriks> you can be pedantic and use the trailing slash to differentiate
<TodPunk> THINGS, yuriks 
<TodPunk> I don't think I can
<yuriks> maybe not such a brilliant idea though
<yuriks> you can
<TodPunk> url.com/blog/create/posts/
<TodPunk> url.com/blog/create
<TodPunk> that works
<TodPunk> url.com/blog/delete/posts/
<TodPunk> url.com/blog/delete
<yuriks> at least on the HTTP level, I know in Werkzeug you had to explicitly tell it if you wanted to alias create and create/
<TodPunk> We'd probably list all their blogs
<TodPunk> give them a checkbox next to each or something, confirmation page
<TodPunk> they'd never see the actual delete url from there as JS would do it
<TodPunk> though an API user could do it
<TodPunk> man, what do I put at url.com ?
<yuriks> TodPunk: another alternative is doing administrationg by posting to url.com/blog/
<TodPunk> maybe just blog.main
<TodPunk> or something
<yuriks> and url.com/blog/todpunk/, et.c
<yuriks> etc.*
<yuriks> generally, treat url as collections and scope actions as narrowly as possible
<TodPunk> yuriks: so url.com/blog/parenting/delete/
<TodPunk> or no?
<yuriks> TodPunk: rather: POST url.com/blog/parenting/ \r\n\r\n { action: "delete" }
<TodPunk> ah
<yuriks> you need to dispatch on actions inside the controller then
<TodPunk> in MVC you can decorate certain actions as requiring POST too, so you don't get to weird places unexpectedly
<yuriks> but depending on your framework you need to dispatch on HTTP methods inside the controller too, so it's not that big of a deal
<TodPunk> mhmmm
<TodPunk> well, we'll try to build a blog then
<yuriks> TodPunk: GET and POST should generally be treated as completely different endpoints that happens to share a path
<TodPunk> for the most part I plan to
* TodPunk won't implement comments -_-
<TodPunk> fuck your forums
<yuriks> for now? :P
<TodPunk> yeah, for now =c(
<TodPunk> you know I'll have to at some point
<TodPunk> though that raises an interesting point
<TodPunk> I was thinking this could be my messaging thing
<TodPunk> the website I mean
<TodPunk> so I sent a message to Lorna, it goes just to her how she wants it
<TodPunk> what happens if I sent a message to a blog, or a blog post?
<TodPunk> and what kinds of messages are there?
<yuriks> eh, I don't know
<TodPunk> email/sms/voice
<TodPunk> it gets interesting
<yuriks> IRC/IM, blog comments, forum posts, blog posts have very different mindsets
--- Disconnected (Connection reset by peer).
--- TodPunk already in use. Retrying with Tod-Autojoined..
--- Tod-Autojoined sets mode +i Tod-Autojoined
-NickServ- This nickname is registered. Please choose a different nickname, or identify via /msg NickServ identify <password>.
--- Found your IP: [50.198.177.185]
-NickServ- You are now identified for TodPunk.
--> You are now talking on #todandlorna
--- Topic for #todandlorna is You should help us here: https://github.com/todpunk/LearningProjects | Abbey (Tim/Tsuteto's wife, and Tod's Sister-In-Law) died early January 1st 2014 from complications from the car accident the previous Sunday.  Our hearts go out to family and friends during this recent tragedy. | If you're one of those that donate to such things: http://www.gofundme.com/themrshansmann
--- Topic for #todandlorna set by TodPunk!~Tod@50-198-177-185-static.hfc.comcastbusiness.net at Thu Jan 02 23:25:33 2014
-ChanServ- [#todandlorna] Find the key in the oatmeal!!!
--- #todandlorna :http://www.todandlorna.com/
--- ChanServ gives channel operator status to Tod-Autojoined
<-- TodPunk has quit (Ping timeout: 186 seconds)
<-- Lorna has quit (Ping timeout: 186 seconds)
<Tod-Autojoined> not entirely.  They're either to groups or individuals, contexts of conversations or not, meant to be replied to soon or not
--- You are now known as TodPunk
-NickServ- You are already logged in as TodPunk.
<TodPunk> Stupid router
<TodPunk> yuriks: what'd I miss?  Last thing I saw was IRC/IM, blog comments/
<TodPunk> I think it's a heat issue
<yuriks> 01:05 < yuriks> IRC/IM, blog comments, forum posts, blog posts have very different mindsets
<yuriks> 01:05 < yuriks> forum posts and blog posts are perhaps the most similar
<yuriks> 01:06 < yuriks> (because forums can be used as some sort of shared forum)
<yuriks> 01:07 < yuriks> so I don't know how useful and/or beneficial it is to unify them
<yuriks> I think my VPN issues were heat issues too. They haven't been recurring since it got colder
<TodPunk> well if you send a message to a blog, the context tells them how it would be treated
<TodPunk> but they all have the same data
* TodPunk will order a mikrotik when job things have worked out
<yuriks> you might want to have threading for comments which don't make sense for IRC/IM
<yuriks> I just don't think it's worth sharing them, at a first glance
<yuriks> except for maybe forum/blogs, as I mentioned
<TodPunk> I'm not thinking about sharing their storage, just subclassing them so they can be sent from app to app
<TodPunk> or maybe I'm overthinking that too
<TodPunk> (Since the Jive interviews I've been thinking about Unified communications, and the important thing in that is intent, really)
