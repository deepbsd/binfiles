# Dave's Binfiles  

These are just some files that I might use from day to day.  Or in some cases they're files
that others have created and I happen to be studying or playing with, as is the case with
eznix's Arch installers.  Although at this point I think I have created my own Arch install
ideas that seem to work well.  But I also might want to play with other ideas, such as
whiptail and dialog.  Will comment further as time goes by.  Normally, stuff I actually use a
lot would wind up in my *.bashrc* which is part of my dotfiles repo.  But sometimes I just want
to work on some ideas before I introduce them into day-to-day use.

## `fix_monitor.sh`

I keep this as a quick reference on how to add a Modeline for a stubborn monitor, say for
Virtualbox or whatever.  You just have to find or cacluclate the appropritate Modeline for
said monitor.  This sample Modeline is for one of my stubborn DP Acer models that likes to be
a PITA.

## `internet_up.sh`

For no apparent reason and without warning, the internet shutsdown at my house sometimes.
Comcast can sometimes shut down the pipe for many hours at a time.  I wrote this script as an
attempt to keep track of my down hours.  Trouble is, I have to launch it manually.  Perhaps
in the future I can write a service that keeps track of down time.

## `update_servers.sh`

Just a little idea for updating some of my hosts here at home, which are running various
Linux distros, and which therefore must get updated using different package management
utilities.
