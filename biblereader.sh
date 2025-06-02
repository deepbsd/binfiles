#!/usr/bin/env bash

##   Working from New American Bible (Catholic Edition)

# We work with an external file in the user's filesystem
external_file="$HOME/bibleplan_in_a_year.txt"

# gotta pick a version of the Bible
version="New American Bible Revised Edition (Catholic Edition)"

##  Default day when I started reading the Bible for myself most recently...
start_date='2022-06-01'   #  YYYY-MM-DD format
end_date='2023-08-01'
today=$start_date   ## at first these two are equal

## Everything depends on picking a start date
start=$(date -d $start_date +"%Y%m%d")
end=$( date -d $end_date +"%Y%m%d")

###  Update these each time you run the program as desired
###  These get updated by functions at program start
current_book="genesis"   # start from genesis or where you are at
current_chapter=1        # start from genesis 1 or where you are at
chaps_per_day=4          # overridden by user input.  Just start with something

###  Just two data structures, one array and one hash
declare -a books=( genesis exodus leviticus numbers deuteronomy joshua judges
ruth i_samuel ii_samuel i_kings ii_kings i_chronicles ii_chronicles ezra 
nehemiah tobit judith esther i_maccabees ii_maccabees job psalms proverbs 
ecclesiastes song_of_songs wisdom ben_sira isaiah jeremiah lamentations baruch 
ezekiel daniel hosea joel amos obadiah jonah micah nahum habakkuk zephaniah 
haggai zechariah malachi matthew mark luke john acts romans i_corinthians 
ii_corinthians galatians ephesians philippians colossians i_thessalonians 
ii_thessalonians i_timothy ii_timothy titus philemon hebrews james i_peter 
ii_peter i_john ii_john iii_john jude revelation ) 

declare -A chapters=( [genesis]=50 [exodus]=40 [leviticus]=27 [numbers]=36 [deuteronomy]=34 
[joshua]=24 [judges]=21 [ruth]=4 [i_samuel]=31 [ii_samuel]=24 [i_kings]=22
[ii_kings]=25 [i_chronicles]=29 [ii_chronicles]=36 [ezra]=10 [nehemiah]=13
[tobit]=14 [judith]=16 [esther]=10 [i_maccabees]=16 [ii_maccabees]=15
[job]=42 [psalms]=150 [proverbs]=31 [ecclesiastes]=12 [song_of_songs]=8
[wisdom]=19 [ben_sira]=51 [isaiah]=66 [jeremiah]=52 [lamentations]=5
[baruch]=6 [ezekiel]=48 [daniel]=14 [hosea]=14 [joel]=4 [amos]=9 [obadiah]=1
[jonah]=4 [micah]=7 [nahum]=3 [habakkuk]=3 [zephaniah]=3 [haggai]=2
[zechariah]=14 [malachi]=3 
[matthew]=28 [mark]=16 [luke]=24 [john]=21 [acts]=28 [romans]=16
[i_corinthians]=16 [ii_corinthians]=13 [galatians]=6 [ephesians]=6
[philippians]=4 [colossians]=4 [i_thessalonians]=5 [ii_thessalonians]=3
[i_timothy]=6 [ii_timothy]=4 [titus]=3 [philemon]=1 [hebrews]=13
[james]=5 [i_peter]=5 [ii_peter]=3 [i_john]=5 [ii_john]=1 [iii_john]=1
[jude]=1 [revelation]=22
)

####  FUNCTIONS

## Everything happens within the dates for loop
generate_dates(){

    while [[ $today -le $end ]];
    do
    
        # stop if we've reached the last book
        [[ -n ${chapters[$current_book]} ]] || exit_app

        echo >>$external_file

        echo $(date -d $today +"%A %m-%d-%Y") " ====> " >>$external_file
        
        ## n is number of chapters to read each day
        eval chaps_per_day=$chaps_per_day

        # create each day's worth of readings
        for ((n=1; n<=$chaps_per_day; n++)); do

            # This should update from global variable after each global update
            book="$current_book"; chapter="$current_chapter"
            print_books_chaps "$book" "$chapter"  

        done

        # echo $(date -d $today +"%A %m-%d-%Y")  # only need this for debugging...
        # update the date
        today=$(date -d"$today + 1 day" +"%Y%m%d"  )

    done 
}

####  abstract out the printing of bible books and chapters
print_books_chaps(){
    book=$1; chapter=$2
    echo "Today read: $book chapter: $chapter"  >>$external_file

    # if ${chapters[$book]} is undefined, we have finished the Bible
    [ "${chapters[$book]}" -eq "${chapters[$book]}" 2>/dev/null ] || exit_app

    if $( not_last_book "$book" "$chapter" ); then
        # next chapter
        advance_chapter
    else
        # increment book
        new_book=$(advance_book "$book")

        # if advance_book runs out of books, it means we've finished the Bible
        if [ -z $new_book ] ; then exit_app; fi

        export current_book="$new_book"   # update global variable
        export current_chapter=1        # update global variable
    fi
}

####  when we run out of chapters in one book, advance to the next book of the bible
advance_book(){
    book=$1
    new_book_index=$(( $(index_of "$book") + 1 ))
    # also return the book name to the calling function
    echo "${books[ $new_book_index ]}"
}

## advance the chapter
advance_chapter(){
    next_chapter=$((current_chapter+1))
    export current_chapter=$next_chapter
}

### Need to be able to get index value of book in books array
index_of(){
    ##  This will return the index value of the book in the books array
    book=$1
    for i in "${!books[@]}"; do
        if [[ "${books[$i]}" = "$book" ]] ; then
            echo "${i}" 
        fi
    done
}


###  Figure out if we're at the last chapter in the book yet
###    This function behaves truthy of falsy depending on whether it's on last book
not_last_book(){

    book=$1; chapter=$2

    if  [[ $chapter -le $(( ${chapters[$book]}-1 ))  ]] ; then 
        # increment chapter
        advance_chapter
        return 0   # true if not last book
    
    else
        current_chapter=1
        return 1   # false if last book
    fi
}

get_chaps_per_day(){
    echo "How many chapters per day?"; read chaps_per_day
}

delete_old_file(){
    rm "$external_file"
}

start_when(){
    echo "Start today or when? (today/yyyy-mm-dd)" 
    read startday
    if [[ "$startday" =~ 'today' ]] ; then
        start_date=$(date +"%Y%m%d")
    else
        start_date="$startday"
    fi
    #export start=$(date -d $start_date +"%Y%m%d")
    export today=$(date -d $start_date +"%Y%m%d")
}

start_book(){
    show_books
    echo
    echo
    echo "Starting book of Bible?"; read start_book
    export current_book=$start_book || current_book='genesis'
}

start_chap(){
    echo "Starting chapter?"; read start_chap
    export current_chapter=$start_chap || current_chapter=1
}

show_books(){
    echo "Display books of $version for spelling purposes?"; read yes_no
    echo
    echo
    [[ "$yes_no" =~ [yY] ]] && for name in "${books[@]}"; do
        echo -n " $name "
    done
}

create_external_file(){
    echo "Delete old Bible plan file?"; read yes_no

    ## just reuse old file if the old plan is good enough
    [[ "$yes_no" =~ [nN] ]] && exit_app
    if [[ -f "$external_file" ]]; then
        delete_old_file
    else
        touch "$external_file"
    fi
}

view_file(){
    [[ -f "$external_file" ]] && less "$external_file"
}

exit_app(){
    view_file
    exit 0
}



#############################################3
####                 MAIN
#############################################3

create_external_file
start_when
start_book
start_chap
get_chaps_per_day
generate_dates


