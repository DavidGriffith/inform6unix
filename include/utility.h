!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
!     Utility.h                         A library of reasonably useful
!                                       Inform 6 functions by
!       V 3.2                           L. Ross Raszewski
!
! New in 3.2: New functions: Age, DaemonRunning, TimerRunning
! New in 3.1: Automatic V6lib support, new function: LocateCursor
!               Special thanks to Jason C. Penny for V6 modifications
! New in 3.0: New function: Rmove
!             Moved Center and CenterU to Utility.h
! New in 2.1: I learned to spell "Underline"
! New in 2.0:  Symbolic constants for Emphasis system.
!              New Documentation
!              Slight change to Emphasis.
!
! I've recenly realized that I've been using functions in my libraries as if
! everyone had them, when in fact, they don't.  The surprising lack of
! commentary I've gotten on these has resulted in my not having noticed this
! sooner.  This library contains all the non-standard functions called by my
! libraries.  These functions are also available for public use.  A
! description of each appears before it
!
! e-mail me at rraszews@acm.org

System_File;
ifndef UTILITY_LIBRARY;
Constant UTILITY_LIBRARY 32;

Object temp_obj;
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Pmove - moves obj1 into obj2 as the youngest child
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
[ Pmove obj1 obj2 o;
   for (o=child(obj2):o ofclass Object: o=child(obj2)) move o to temp_obj;
   move obj1 to obj2;
   for (o=child(temp_obj):o ofclass Object: o=child(temp_obj)) move o to obj2;
];
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Rmove - moves obj1 as the immediate younger sibling of obj2
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
[ Rmove obj1 obj2 o i;
   i=parent(obj2);
   for(o=child(i):o~=obj2:o=child(i)) move o to temp_obj;
   move obj2 to temp_obj;
   move obj1 to i;
   for(o=child(temp_obj):o ofclass Object:o=child(temp_obj)) move o to i;
];
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Emphasis - changes the text emphasis setting
!          The global variable Emphasis_Color stores the color for
!          Emphasis(3);  The default is green.
!            Emphasis(0) - normal text
!            Emphasis(1) - bold
!            Emphasis(2) - Underline
!            Emphasis(3) - Color (if available)
!            Emphasis(4) - Reverse
!          To use Emphasis in a print statement, be sure to use the inform
!          format for embedded print statements:
!          "This word is in ", (Emphasis) COLOR, "color", (Emphasis) NORMAL,
!          ".";
!         The symbolic constants below can be used in place of numbers.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Constant NORMAL 0;
Constant BOLD   1;
Constant UNDERLINE 2;
Constant COLOR 3;
Constant REVERSE 4;
! Color Settings
Constant DFLT 1;
Constant BLACK 2;
Constant RED 3;
Constant GREEN 4;
Constant YELLOW 5;
Constant BLUE 6;
Constant MAGENTA 7;
Constant CYAN 8;
Constant WHITE 9;
Global Emphasis_Color=4;        ! Default color is green
[ Emphasis n;
switch(n){
0: style roman; 
#ifndef SPECTEST_AVAILABLE;
         if (standard_interpreter>=2 ) @set_colour 1 1;
#ifnot;
        if (standard_interpreter>=2 || Spec->ColorFlag) @set_colour 1 1;     
#endif;
1: style bold;
2: style underline;
3:
if (Emphasis_Color==-1) style reverse;
else if (Emphasis_Color==-2) print "*";
else {
#ifndef SPECTEST_AVAILABLE;
        if ( (standard_interpreter) >= 2&& (0->1)&1)
         @set_colour Emphasis_Color 1;
        else style underline;
#ifnot;
        if ( ((standard_interpreter) >= 2 || Spec->ColorFlag)  && (0->1)&1)
         @set_colour Emphasis_Color 1;
        else style underline;
#endif;
}
4: style reverse;
}
];

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! WaitForKey - waits for a keypress.  Takes as an argument a string to be
!              printed.  if none is given, it prints the default.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
[ WaitForKey str;
if (str==0) str="[Press Any Key]";
if (str ofclass string) print (string) str;
else if (str ofclass routine) indirect(str);
@read_char 1 0 0 str;
];


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Scion - Finds a child of certain "age"; scion(o,1) is the child of an object
!         scion(o,2) is the sibling of the child, and so on.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

[ Scion Object x i;
        if (x==0) return Object;
        x--;
        i=child(Object);
        while (x>0 && i~=nothing)
         { i=sibling(i); x--; }
        return i;
];
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Age -  Returns the "age" of a object, such that the eldest child of an
!        object has age 1, and so on; Scion(parent(x),Age(x))==x
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
[ Age obj x y;
   x=1;
   y=child(parent(obj));
   while (y~=obj)
   {
    x++;
    y=sibling(y);
   }
   return x;
];
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Center - Centers a line of text on the current line
!       Center(x); where x is a line of text or a routine to print one
!       (this routine shoud ONLY print text, as it will be called twice)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Array CenterText string 128;
[ Center instring i;
    CenterText-->0 = 128;
    @output_stream 3 CenterText;
    if (instring ofclass string)
  	print (string) instring;
    if (instring ofclass Routine)
  	indirect(instring);
    @output_stream -3;
    #Ifdef V6DEFS_H;
    i = ActiveZWindow.GetXSize();
    i = i - 0-->($30/2);
    i = i/2;
    ActiveZWindow.SetCursor(0, i);
    #Ifnot;
    i = 0->$21;
    i = i - CenterText-->0;
    i = i/2;
    font off;
    spaces(i);
    #endif;
    if (instring ofclass string)
  	print (string) instring;
    if (instring ofclass Routine)
  	indirect(instring);
   #ifndef V6DEFS_H;
    font on;
   #endif;
];


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! CenterU - Centers a line of text in the upper window
!           CenterU(x,y) where y is the line of the upper window on which to
!           print the line
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
[ CenterU instring j i;
    CenterText-->0 = 128;
    @output_stream 3 CenterText;
    if (instring ofclass string)
  	print (string) instring;
    if (instring ofclass Routine)
  	indirect(instring);
    @output_stream -3;
    #Ifdef V6DEFS_H;
    i = ActiveZWindow.GetXSize();
    i = i - 0-->($30/2);
    i = i/2;
    ActiveZWindow.SetCursorByChar(j,0);
    ActiveZWindow.SetCursor(0, i);
    #Ifnot;
    i = 0->$21;
    i = i - CenterText-->0;
    i = i/2;
    @set_cursor j i;
    #endif;
    if (instring ofclass string)
  	print (string) instring;
    if (instring ofclass Routine)
  	indirect(instring);
];
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! LocateCursor - places the cursor within the upper window
!                LocateCursor(y,x) places the cursor at position x,y on the
!                screen.  This is a version independant function, which will
!                place the cursor by characters in v5/8 or v6.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
[ LocateCursor y x;
 #Ifdef V6DEFS_H;
  StatusWin.SetCursorByChar(y,x);
 #Ifnot;
  @set_cursor y x;
 #Endif;
];
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! DaemonRunning - Returns TRUE if the object specified is currently running
!                 a daemon
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
[ DaemonRunning x i;
   for (i=0:i<active_timers:i++)
       if (the_timers-->i == $8000 + x)
           rtrue;
   rfalse;
];
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! TimerRunning - Returns TRUE if the object specified is currently running
!                 a timer
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
[ TimerRunning x i;
   for (i=0:i<active_timers:i++)
       if (the_timers-->i ==x)
           rtrue;
   rfalse;
];

endif;
