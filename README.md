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

## whipsample.sh

I'm trying to become proficient with `whiptail`, the graphical front-end for bash and other
languages???  Not sure how portable `whiptail` is, but I'm using it for bash and especially 
for my GUI version of DARCHI (Dave's ARCH Installer) that I use to install Archlinux.  I'm
hoping it will help other people to install Archlinux more easily.

## specialprogressgauge() inside whipsample.sh

The trickiest part of whiptail for me has been getting the progress gauge to work.  In case
anyone else has been having trouble with that, let me share what little wisdom I have
accrued.  First, the progress gauge has nothing to do whatever with actual progress!  That is
the most misleading part of all this.  The progress gauge function (--gauge) of whiptail
simply takes a stream of numbers between 1 and 100 and creates a gauge of that number.  When
you break out of the loop that generates those numbers, the gauge goes away.

So, there's nothing about the `--gauge` function of whiptail that automatically measures the
progress of a function.  Nothing whatsoever.  What you're supposed to do is start the process
that you want to measure the progress of, send that process to the background, and then have
some way of generating numbers between 1 and 100 that roughly correlate to when your
background process starts and completes.

If you look at the source code, you'll see the following.  There's a calculate function that
simply spends about 2 minutes outputting numbers and timestamps to a logfile.  That's all it
does.  I can easily modify it to do that for longer or shorter periods of time.  I thought
two minutes was good enough for my testing purposes.  Here's that function:

```
calculate(){
    num=1
    limit=120  # 2 minute loop
    ## remove stale logfiles
    [[ -f logfile ]] && rm logfile
    while [[ $num -lt $limit ]]; do
        date +"%D-->%H:%M:%S::%N" &>>logfile
        echo "Num: $num"  &>>logfile
        sleep 1
        num=$(( num+1 ))
    done
    echo "=== Done ===" &>>logfile
}
```

This function could be your installation routine or your disk copy routine or whatever else
you want to measure the progress of.  You can see, there're no numbers being output to STDOUT
here.  None.  So this process will have nothing that informs the `--gauge` process itself.
Whiptail will have no way of knowing this function's progress in life.  So we will have to
generate another way of telling `--gauge` how this function is progressing along.  That will
be entirely up to us how we inform `--gauge` that `function()` is progressing.

```
specialprogressgauge(){
    calculate&
    thepid=$!
    while true; do
        showprogress 'b'
        showprogress 'm'
        sleep 2
        num=66
        while $(ps aux | grep -v 'grep' | grep "$thepid" &>/dev/null); do
            echo $num 
            if [[ $num -gt 77 ]] ; then num=$(( num-1 )); fi
            sleep 5
            num=$(( num+1 ))
        done
        showprogress 'e' 
        break
    done  | whiptail --title "Progress Gauge" --gauge "Calculating stuff" 6 70 0
}

```

As you can see, `specialprogressgauge()` calls the `calculate()` function and immediately
sends it into the background.  That means `specialprogressgauge()` will not be held up by the
progress of `calculate()`.  That's important!  Without that little `&` command, the script
would not continue until `calculate()` was done, and then it would be too late to show any
progress bar!

So, next we capture the PID of the process just sent into the background with the `$!`
built-in bash function.  Then we start a while loop that will feed the whiptail program until
we break out of that while loop.

Notice that there's an extra while loop within this while loop.  The first while loops calls
something called `showprogress()` and passes an argument `b` to it.  Then that same function
gets called again, but this time passes `m` to it.  We sleep for 2 seconds, then set a `num`
variable to 66, and then start the nested while loop that looks for the PID of the
`calculate()` function and increments `num` up to 77 and holds it there for as long as the
PID of `calculate()` appears in the process table.  When the PID disappears from the process
table, we break out of the nested while loop and immediately call `showprogress()` with a
final argument, `e`, and then break out of the primary while loop that
`specialprogressgauge()` makes use of.  So the big question is, what the heck is this
`showpgrogress()` function?

```
showprogress(){
    case $1 in
        'b') arr=( 0 5 10 20 25 ) ;;
        'm') arr=( 35 45 55 65 ) ;;
        'e') arr=( 77 88 95 98 99 ) ;;
          *) arr=()
    esac

    for n in "${arr[@]}"; do
        echo $n
        sleep 3
    done

    [[ $1 == 'e' ]] && echo 100 && sleep 5
}
```

As you can see, not very special.  But this is all there is to feed progress percentage
numbers to whiptail.  I call this little sucker three times in total.  The first two times
I'm not even checking for the PID of the `calculate()` function yet.  Each time I call this
function, it takes about 15 seconds, depending on how many numbers I have inside the array.
At the very end, if `$1` is equal to `e`, or the final series of percentage numbers, only
then do I echo the `100` number and then sleep for 5 seconds.  When I call this function the
last time, I only waste about 20 seconds, then the progress gauge will time out.  It will go
away, but the `calculate()` function will be complete when it does.  So, the progress gauge
will have done its job, right?  It has given the user a rough idea of when to expect that the
`calculate()` function has started and then completed its job.  Was there a rock-solid
direct correlation between the `--gauge` and the completion of `calculate()`?  No.  Does that
make a big difference to the user?  Probably not.  Has it been helpful and informative to the
user while waiting for the `calculate()` function to complete?  Yes, probably so.  Is that
the actual purpose of the `--gauge` function in whiptail?  Yes, I think it is.  After all is
said and done.



