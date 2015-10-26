# -*- coding: utf-8 -*-
import os
from pydozer import Page

index_page = Page()
index_page.data['filename'] = os.path.basename(__file__).replace('.pyc', '').replace('.py', '')

index_page.data['title'] = "Tod and Lorna .com - Home"
index_page.data['is_home'] = True
index_page.data['content'] = """
                            <section id="one">
                                <div class="container">
                                    <header class="major">
                                        <h2>Tod and Lorna .com</h2>
                                        <p>Our (mostly Tod's) playground</p>
                                    </header>
                                    <p>If you have comments of things you'd like to see, feel free to drop us a line.  You can comment to either of us by emailing Tod or Lorna -atatatat- todandlorna.com  Until then, <a href="http://widget.mibbit.com/?settings=87cc27616662d1ec2bbc375e07dbab13&server=irc.esper.net&channel=%23todandlorna" target=_blank>get on IRC</a> and chat with the community!</p>
                                    <p>Tod's latest resume:  <a href="https://onedrive.live.com/redir?resid=4FA0F7B30127438B!3428&authkey=!AODFUYiBmfRP7PA&ithint=file%2c.pdf">PDF</a>&nbsp;&nbsp;&nbsp;<a href="https://onedrive.live.com/redir?resid=4FA0F7B30127438B!3426&authkey=!AKZtHFzUjMSu7X4&ithint=file%2c.docx">Word2013</a>
                                </div>
                            </section>
"""
