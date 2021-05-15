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

## More on whipsample.sh

So I've been thinking more about making one of those progress bars work in a real life
instance.  I've been thinking of using them in the whiptail version of my Archlinux
installer, during some of the installation routines, and it's a little tricky.  How do you
actually measure progress?  Do you just key in a range of time, and let the progress of the
function determine how much time between updates transpires?  That might be useful.  Or do
you just let the bar stop at a certain percentage of progress?  I've even created the latest
alternative where if the background function still isn't complete by 77 percent, the
percentage bar goes back to 76 percent, and then goes forward and checks again.  If the
process is not complete, the bar keeps going back and forth between 76 and 77 percent until
the background process gets removed from the PID table, and then the process quickly
completes to 100 percent!  This way, the bar always appears to be moving so it never gives
the impression of being stuck.

Another alternative is to find a way to pipe the updating output to a file and display that
via a `--textbox` switch.  That would be the most preferable yet.  Still, I have not found a
wholly satisfactory solution to this problem.

Here's my latest attempt at providing a solution:

```
specialprogressgauge(){
    calculate&
    thepid=$!
    while true; do
        showprogress1 1 65 1 3
        sleep 2
        num=66
        while $(ps aux | grep -v 'grep' | grep "$thepid" &>/dev/null); do
            echo $num 
            if [[ $num -gt 95 ]] ; then num=$(( num-1 )); fi
            #sleep 5
            showprogress1 $num $((num+1)) 
            num=$(( num+1 ))
        done
        showprogress1 99 100 3 3
        break
    done  | whiptail --title "Progress Gauge" --gauge "Calculating stuff" 6 70 0
}

# Later idea for show progress.  Little better
# Basically the 2nd parameter IS the length of time in seconds
showprogress1(){
    start=$1; end=$2; shortest=$3; longest=$4

    for n in $(seq $start $end); do
        echo $n
        pause=$(shuf -i ${shortest:=1}-${longest:=3} -n 1)  # random wait between 1 and 3 seconds
        sleep $pause
    done
}

```

Here, in *specialprogressgauge*, if `num` grows larger than 95 percent while *calculate* is
running, `num` will go back and forth between 96 and 95 percent for as long as *calculate* is
running.  Then *showprogress* will get called starting at 99 and go to 100 percent, each step
taking 3 seconds to display.  So I'm only wasting 6 seconds showing the user that his/her
process (*calculate*) is complete.  

The advantage of this version of *showprogress* is that I can alter the pause period on the
fly.  When I want to take up time in the beginning to the middle of the process, I can pass
longer wait times.  When the process is wrapping up and I want to speed to the finish of the
progress bar, I can pass in greater range numbers and longer wait times to make sure the user
sees the last values of the progress bar.  So if the user's hardware is super fast, I can
speed the progress bar ahead to the end, but if the user's hardware is slow, I can drag out
the progress bar as long as I need to.  So far, I think this might be my favorite approach
and solution.

