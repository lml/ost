#!/usr/bin/perl -w

BEGIN
{
  $WORKING_DIR = `pwd -P`;
  chomp $WORKING_DIR;
  $WORKING_DIR =~ s!/+$!!g;
  $WORKING_DIR .= "/";

  $SCRIPT_DIR = $WORKING_DIR;
  if ($0 =~ m!^\.!) {
    $SCRIPT_DIR = $WORKING_DIR . $0;
  }
  elsif ($0 =~ m!^/!) {
    $SCRIPT_DIR = $0;
  }

  $SCRIPT_DIR =~ m!(^.*/)!;
  $SCRIPT_DIR = $1;

  $SCRIPT_NAME = $0;
  if ($0 =~ m!^(.*/)(.+)$!) {
    $SCRIPT_NAME = $2;
  }

  $RAILS_ROOT = $SCRIPT_DIR;
  $RAILS_ROOT =~ m!(^.*/).*/.*/!;
  $RAILS_ROOT = $1;

  # print STDOUT ("\$0         = $0\n");
  # print STDOUT ("WORKING_DIR = $WORKING_DIR\n");
  # print STDOUT ("SCRIPT_DIR  = $SCRIPT_DIR\n");
  # print STDOUT ("SCRIPT_NAME = $SCRIPT_NAME\n");
  # print STDOUT ("RAILS_ROOT  = $RAILS_ROOT\n");
    
  push(@INC, $SCRIPT_DIR);
}

my ($FILENAME) = @ARGV;

open(IN, $FILENAME);

while (<IN>)
{
  my $curLine = $_;

  if ($curLine !~ m/response_times:/)
  {
    print STDOUT $curLine;
  }
  else
  {
    while (<IN>)
    {
      my $curLine = $_;

      if ($curLine =~ m/---/)
      {
        last;
      }
    }
  }
}

close (IN);
