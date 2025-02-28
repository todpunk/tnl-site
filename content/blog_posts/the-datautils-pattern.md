---
Author: 'Tod Hansmann'
Title: "The DataUtils Pattern"
PostedDate: 'Tue Feb 24 19:32:00 MST 2025'
Tags: ["engineering", "testing", "data", "workflows"]
Hook: "<p>I have incepted a pattern at a few big tech companies that my friends worked at after they did some side stuff with me. It makes your life testing against a database way easier. You'll never look back once you've got it going.</p>"
---
Originally I can up with this while working at Mobilsense. As a Python shop, they were updating to a newer codebase than the one they started in 2002, and considered a variety of things to migrate to. The short version is we had about I believe about 8,000 tests at the time, and they all ran in under 20 minutes on a single process running against postgres as the database. No mocking of databases.

Sincerely, don't mock your database. In the age of containers especially you have no excuse, but it's also pretty easy to create a new DB from scratch. Do the work. Anyway, once you have that, how do you test against it when it's largely empty? This also isn't Python specific, but it's easy there. Let's go over it.

## Wait, Why?

The most annoying thing when setting up a test that involves the database (so most tests worth anything), is setting up the data and making sure the data doesn't bleed into every other test. That's what this is for. You want to only care about the data you need, and none of the rest, and always have it torn down (unless some sort of panic happens, then all bets are off no matter what your testing strategy). Put another way, tests are largely a set of data in the database exists, a request comes in, what should change and what should be returned? How do we make this super easy?

## Some Requirements

First, you need to know a couple requirements. You absolutely need a live database. You will have to configure that somehow from a config or environment variable. You will have to have an up to date schema that you spin up before tests run. You also can't do an actual web request because you need to share the session with the handler, which is fine. Your library or framework or whatever is absolutely doing all the parsing from HTTP request to your handlers. You just need to tap into that mechanism. It should have some helper library to do this, but if not, you could just create a dummy object and call your handlers directly. It skips the routing, but that should be testable elsewhere.

It's also nice to have a strategy for only doing it in memory so the disk isn't used. We just had a transaction run across the request handler, and we rolled it back. I highly recommend it. There were times we wanted to test performance, for those we had a committed transaction, and functions to just do a `DELETE * FROM <table>` on the right set of tables after the test. Usually a suite of them.

## Now the Meat

The magic of this pattern is that you just create a dictionary of data, and pass it to the root of the data hierarchy, starting where you need the data. That's typically the opposite, where you want a ThingA, but it requires a ThingB, and that requires a User, so you have to start with the User and work your way down.

Don't do that.

Start writing the `CreateUser` function, sure. Then write the `CreateThingB` and `CreateThingA` functions, but here's the good bit. `CreateUser` doesn't need any data. It gets passed a map or a data object of some kind, and it creates the ORM object or the SQL statement or whatever flavor you is (I told you it's not Python specific, it's also not DB approach specific). 

You will need to keep track of some number and maybe have a randomizer. So you get a `CreateUser` call with an entirely empty map. That just means that you don't care what's in it, it just needs to be valid. Great, so you create a username of "testuser1" where 1 was actually just the "usercounter" variable juxtaposed in. You also want to have one check, that if `user_id` is in the map, `CreateUser` gets that from the DB instead of creating it (or cache, or whatever you want). You'll see why in a moment.

If you want the username to be "myspecificuser1989" you include that in the map. Map takes precedence. You might even be able to just create the user dataset and then replace overrides from the map if they exist. Depends on how you marshal your data, but no biggie, either is fast.

So now you can do that starting from up the chain. Pass in a map of the data you care about to CreateThingA, and it will call CreateThingB with the exact same map, which will call CreateUser with that map. So now you can, with one map, just set all the things you want. Do you want a set of multiple ThingAs? Just loop and do it.

Do you want them all to have the same user? In the end of your loop iteration, modify the map to have the id of the first loop's user. Problem solved. Who cares if you re-override everything to the same id every loop? It's a test! Efficiency is wall clock time, don't be clever, this is fast. Want to have three different ThingBs? A bunch of ways to slice that, pick your favorite.

Oh, and now you also have your test cases result data to base off of, and you can randomize bits to tell future readers (yourself included) that the value doesn't matter. You're giving your tests easy data creation, values for validation, cleanup, and you're not coupling any of it to the data that doesn't matter. You never need to go find every test that touches a user just because you added a field. Just the ones that will care. If you are using an ORM, you can return the actual ORM object, too, so you get any libs from that ORM you might want in your test.

## Downsides

There's two downsides. First, you will feel sad if your primary keys are all called `id` because now you have to likely have a map check in every `CreateStuff` to convert the `user_id` to the ORM's `id` field, and you will be eternally reminded of your poor choice. Second, you have to have done the work of properly maintaining your DB instead of just getting a schema dump from prod or something. You did version control your schema changes and keep them useful from bare minimum the whole time, right? Of course you did. (You can fix it if you didn't, but you will need to do that or you don't get valid DB tests out of this, back to your mocks that are also not valid DB tests, but you can still pretend. This blog article can't find you. Your better engineer friends might, sadly.)

I suppose you'll also not enjoy going back to codebases that don't. I've had that problem a long time. Tests are so much more painful when you can't just setup a data scenario and see if the function call gives you what you expected.

Try it. You'll get a lot of mileage out of it even after the first test suite.
