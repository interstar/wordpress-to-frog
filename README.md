# wordpress-to-frog

A quick and dirty Racket script to extract a list of blog-posts from a WordPress export and dump them into a Frog (Frozen Blog) format.

What?
-----

I'm having trouble with some WordPress blogs. And as I'm getting into Racket these days, I thought I'd check out [Greg Hendershott's](http://www.greghendershott.com/index.html) Frog ([Frozen Blog](https://github.com/greghendershott/frog)). A static blog generator. (Suddenly static blogs and generators are incredibly trendy. I'm sure it's a hipster thing.)

Anyway, I wanted to try moving one of my existing WP blogs to Frog. WordPress exports the blog as a list of posts in an XML file it calls "WordPress eXtended RSS". So here's a quick Racket script that can parse one of these exports and create a bunch of source files.

Use 
---

Go to your WordPress Tools -> Export and grab the WXR (xml) file.

Put in the directory where you are going to create the Frog blog. Put import-wp.rkt there too.

Make sure you've created a _src/posts subdirectory.

Open DrRacket and open the script.

Change "my-wordpress-export.xml" on line 6 to the name of you export file.

Run the program in DrRacket.

Check the files its created (under _src/posts) are OK.

On the command line

    raco frog -b
    raco frog -p
    
These will run frog to create your blog and then launch a local webserver to look at it. 


Caveats
-------

I've done the minimum to support my needs. That means extracting title, publish date, body and categories (become Frog tags). You may care about metadata that I'm not even thinking about.

I certainly didn't think anything about pictures. This is no good for galleries.

Sadly it's also not getting comments. That's probably the biggest issue. It seems Frog uses Disqus. Which is convenient, but a whole realm of complexity if you want to migrate comments from WP to Frog. Sorry, I haven't looked into that.

I'm a beginner Racket programmer and this was a quick hack. The code is probably terrible and not good Racket style or convention.

