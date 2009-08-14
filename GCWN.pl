#! /usr/bin/perl
#
# Google-Calender-Week-Numbers
#
# Developed by: Craig Wilson
# Homepage: http://cawilson.co.uk/?page_id=143 
# Contact: dev@cawilson.co.uk
#
# Description: a script to output a ical file designed to important weeknumbers to google calender
#
use Fcntl; # file control module

our $days; # Holds number of days in the specified month

our $year  = $ARGV[0]; #holds the starting year
our $month = $ARGV[1]; #holds the starting month
our $date  = $ARGV[2]; #holds the starting date

if ($ARGV[3])		#if number of weeks required was entered else use 26
{ $weeks = $ARGV[3]; }
else
{ $weeks = 26; }

if ($ARGV[4]) 		#if week number was specified set week number, loop counter and weeks as required elseset loop counter to 1
{ 
  $weekno = $ARGV[4];
  $weeks = $weeks + $weekno;
  $i = $weekno;
}
else
{ $i = 1; }

sysopen(ICAL,'WeekNumbers.ics',O_RDWR|O_EXCL|O_CREAT,0755); # open output file

printf ICAL "BEGIN:VCALENDAR\nVERSION:2.0\nX-WR-CALNAME:WEEKNUMBERS\nX-WR-TIMEZONE:Europe/Stockholm\nCALSCALE:GREGORIAN\n\n"; # print ical file header

&days; # send to days subroutine to find out how many days in the specified month

if ( $year < 2000 || $year > 2020 ) #check for valid year
{ print "please use a year between 2000 and 2020\n"; }
elsif ( $month < 1 || $month > 12 ) #check for valid month
{ print "Month Entry much be between 1 and 12\n";}
elsif ( $date < 1 || $date > $days ) #check for valid day
{ print "The date is not within a valid range for the sepcified month\n"; }
else
{
 for ($i = $i; $i <= $weeks; $i++) #for loop to cycle the specified amount
 {
  if ($date > $days) # if date is greater then the days of that month
  { 
   $date = $date - $days; #take away days of that month to get new date
   $month++; #incriment month counter
   if ($month > 12) #if month over 12 cycle back to january
   { $month = 1; } 
   &days; #find out how many days are in this month
  }

  $month = sprintf("%02d", $month); #make sure month has is in 2 diget format then print ical event info
  printf ICAL "BEGIN:VEVENT\n"; 
  printf ICAL "DTSTART;VALUE=DATE:$year$month$date\n";
  $x = $date + 1; #generate the end date for the event
  printf ICAL "DTEND;VALUE=DATE:$year$month$x\n";
  printf ICAL "SUMMARY:Week $i\n";
  printf ICAL "X-GOOGLE-CALENDAR-CONTENT-TITLE:Week $i\n";
  printf ICAL "X-GOOGLE-CALENDAR-CONTENT-ICON:http://sites.google.com/site/gcalweeknumbers/Home/week$i.png\n";
  printf ICAL "END:VEVENT\n\n";
  $date = $date + 7
  }

  printf ICAL "END:VCALENDAR"; # print ical file footer
}


####
# Sub-Routine: days
#
# Purpose: find the number of days in the specified month
#
# Variables access: $month, $year, $days
sub days
{
 if ($month == 1 || $month == 3 || $month == 5  || $month == 7 || $month == 8 || $month == 10 || $month == 12)
 { $days = 31; }
 elsif ($month == 4  || $month == 6 || $month == 9 || $month == 11)
 { $days = 30; }
 elsif ( ($year % 4 == 0) && ( ($year % 100) || ($year % 400 == 0) ) )
 { $days = 29; }
 else
 { $days = 28; }
}
