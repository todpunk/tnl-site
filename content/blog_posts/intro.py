# -*- coding: utf-8 -*-
import os
import dateutil.parser
from pydozer import BlogPost
from slugify import slugify

first_post = BlogPost()

# These are all optional
first_post.data['author'] = 'Tod Hansmann'
first_post.data['tags'] = ['meta', 'about', 'opinions']

# These are not optional at all
first_post.data['posted_date'] = dateutil.parser.parse('Thu Oct 25 15:10:00 MST 2015')
first_post.data['title'] = 'An Intro to TnL'
first_post.data['filename'] = slugify(unicode(first_post.data['title']))
first_post.data['hook'] = """
<p>This place is Tod and Lorna Hansmann's personal writings of some opinionated nature.  The only disclaimer is that we don't plan on censoring anything, though we may change things to clarify something, and we should all keep in mind what time things were written.  If you want to cherry pick something one of us said 10 years in the past, we're probably going to ignore you as that would be a bad position for you to have.</p>
"""
first_post.data['content'] = """
<p>If you have commentary, we don't keep that on the site.  Feel free to drop us an email or hit us up on other various places.  We are busy people, so don't expect a prompt response.  Worry not, your plight is not of a life-threatening nature, and therefor should not be a priority anyway.  Let it go a bit, it will do you good.</p>
<p>Good luck, and <a href="/tnlblog/listing1.doz">read more</a> with wreckless abandon!</p>
"""
