<!-- Copyright 2011-2013 Rice University. Licensed under the Affero General Public 
     License version 3 or later.  See the COPYRIGHT file for details. -->

OpenStax Tutor
==============

OpenStax Tutor (OST) melds new cyber and social infrastructures to put powerful learning tools in the hands of educators and learners. OpenStax Tutor is an ambitious effort that combines high-quality, public-ready software with advanced research pursuits. We are still in beta and some of our features are still being developed.

Check it out at https://openstaxtutor.org

Requirements
------------

To run OpenStax Tutor, you must have the following dependencies installed:

 * Ruby 1.9.3
 
 * ImageMagick (for image uploads)        
        
License
-------

See the COPYRIGHT and LICENSING files.

Contributing
------------

Contributions to OpenStax Tutor are definitely welcome.

Note that like a bunch of other orgs (Apache, Sun, etc), we require contributors
to sign and submit a Contributor Agreement.  The Rice University Contributor Agreement
(RCA) gives Rice and you the contributor joint copyright interests in the code or
other contribution.  The contributor retains copyrights while also granting those 
rights to Rice as the project sponsor.

The RCA can be submitted for acceptance by emailing a scanned, completed, signed copy
to info@[the OpenStax Tutor domain].  Only scans of physically signed documents will be accepted.
No electronically generated 'signatures' will be accepted.

Here's how to contribute to OpenStax Tutor:

1. Send us a completed Rice Contributor Agreement
   * Download it from http://quadbase.org/rice_university_contributor_agreement_v1.pdf
   * Complete it (where "Project Name" is "OpenStax Tutor" and "Username" is your GitHub username)
   * Sign it, scan it, and email it to info@[the openstax tutor domain]
1. Fork the code from github (https://github.com/lml/ost)
2. Create a thoughtfully named topic branch to contain your change
3. Make your changes
4. Add tests and make sure everything still passes
5. If necessary, rebase your commits into logical chunks, without errors
6. Push the branch up to GitHub
7. Send a pull request for your branch

Quick Development How-To
------------------------

The best way to go is to install RVM on your machine.  Install Ruby 1.9.3 (e.g. `rvm install 1.9.3-p194`)
and install the bundler gem.  You may run into some issues where you need to install some supplemental
libraries first.

When you have RVM and bundler, fork the code and change into the ost directory.  We have a 
.rvmrc file in the top-level directory so RVM should setup things to use Ruby 1.9.3 and the 
ost gemset.

    bundle --without production
    bundle exec rake db:migrate
    bundle exec rails server
    
To upload images to questions, you'll need to have ImageMagick installed.

That's it.  You should then be able to point a web browser to http://localhost:3000.

