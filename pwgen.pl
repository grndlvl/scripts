#!/usr/bin/perl
# call with the number and length to generate
for ($count = $ARGV[1]; $count >= 1; $count--) { @l=("a".."z","A".."Z",0..9,"@","!","[","]","{","}","?","#","&") and print join "", map $l[rand @l],0..$ARGV[0]; print "\n"}
