#!/usr/bin/env perl -w

BEGIN
{
	$WORKING_DIR = `pwd -P`;
	chomp $WORKING_DIR;
	$WORKING_DIR =~ s!/+$!!g;
	$WORKING_DIR .= "/";

	$SCRIPT_DIR = $WORKING_DIR;
	$SCRIPT_NAME = $0;
	if ($0 =~ m!^(.*/)(.+)$!) {
		$SCRIPT_DIR = $1;
		$SCRIPT_NAME = $2;
	}
	
	# print STDOUT ("WORKING_DIR = $WORKING_DIR\n");
	# print STDOUT ("SCRIPT_DIR  = $SCRIPT_DIR\n");
	# print STDOUT ("SCRIPT_NAME = $SCRIPT_NAME\n");
	
	push(@INC, $SCRIPT_DIR);
}

use Module::Load;

my $setup = parseArgs(@ARGV);

readLicenseFile($setup);
importLicensers($setup);
readPatternsFile($setup);
processFiles($setup);

sub readLicenseFile
{
	my ($setup) = @_;
	
	die ("\n\nERROR: could not open license file ($setup->{licenseFilename}) [$!]\n\n")
	  if !open(IN, $setup->{licenseFilename});
	my @licenseLines = <IN>;
	close(IN);

	$setup->{licenseLines} = \@licenseLines;	
}

sub importLicensers
{
	my ($setup) = @_;
	
	opendir(DIR, $SCRIPT_DIR);
	my @filenames = readdir(DIR);
	closedir(DIR);
	
	foreach (@filenames)
	{
		my $curFilename = $_;

		next
			if ($curFilename !~ m/^([a-zA-Z]+)Licenser\.pm$/);
		my $licenserName = $1;
		my $className = $curFilename;
		$className =~ s/\.pm$//;

		print STDOUT ("loading $className as $licenserName\n");

		load $className;
		my $licenser = new $className;
		if (${licenser}->is_concrete()) {
			print STDOUT ("  ...and adding it as a concrete licenser\n");
			$setup->{licenserByName}->{$licenserName} = $licenser
		}
	}
}

sub readPatternsFile
{
	my ($setup) = @_;

	die ("\n\nERROR: could not open regex file ($setup->{patternFilename}) [$!]\n\n")
	  if !open(IN, $setup->{patternFilename});
	my @regexLines = <IN>;
	close(IN);

	$setup->{licenserByPattern} = {};
	$setup->{patternsArray} = [];

	foreach (@regexLines) {
		my $curLine = $_;

		$curLine =~ s/#.*//;
		$curLine =~ s/^\s+|\s+$//g;
		next
			if $curLine eq "";

		die ("\n\nERROR: invalid pattern line in $setup->{patternFilename} ($curLine)\n\n")
			if ($curLine !~ m/^(.+?)\s+(\S+)$/);

		my $regex = qr($1);
		my $licenserName = $2;
		
		die ("\n\nERROR: duplicate pattern in $setup->{patternFilename} ($regex)\n\n")
			if defined($setup->{licenserByPattern}->{$regex});

		die ("\n\nERROR: invalid licenser name in $setup->{patternFilename} ($licenserName)\n\n")
			if !defined($setup->{licenserByName}->{$licenserName});
		
		$setup->{licenserByPattern}->{$regex} = $setup->{licenserByName}->{$licenserName};
		push(@{$setup->{patternsArray}}, $regex);
	}
}

sub processFiles
{
	my ($setup) = @_;

	my $cmd = "find $setup->{fileRootDir} -type f";
	my @filenamesToProcess = `$cmd`;

	foreach (@filenamesToProcess) 
	{
		my $curFilename = $_;
		$curFilename =~ s/^\s+|\s+$//g;
		next
			if $curFilename eq "";

		my $curFilenameMatchedPattern = 0;
		my $licenser = undef;

		foreach (@{$setup->{patternsArray}})
		{
			my $curPattern = $_;
			if ($curFilename =~ m/$curPattern/) {
				$licenser = $setup->{licenserByPattern}->{$curPattern};
				last;
			}
		}

		if (defined($licenser))
		{
			if ($setup->{addLicense}) {
				$actionString = $licenser->addLicense($curFilename, $setup->{licenseLines}) ? "ADDED_LICENSE" : "NO_ACTION";
			} else {
				$actionString = $licenser->removeLicense($curFilename, $setup->{licenseLines}) ? "REMOVED_LICENSE" : "NO_ACTION";
			}
			print STDOUT (sprintf("%-20.20s %s\n", $actionString, $curFilename));
		}
		else
		{
			#print STDOUT ("\nERROR: file did not match any pattern ($curFilename)\n\n");
		}
	} # foreach (filename to process)
}

##
## SCRIPT
##

sub addLicenseScript
{
	my ($setup, $filename) = @_;
	
	open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);
	my $fileText = join("", @fileLines);
	
	my $licenseText = createLicenseTextScript(@{$setup->{licenseLines}});
	my $licenseTextEscaped = quotemeta($licenseText);
	my $firstLine = shift(@fileLines);
	my $firstLineEscaped = quotemeta($firstLine);

	my $result = 0;
	if ($fileText !~ m/^${firstLineEscaped}${licenseTextEscaped}/s) {
		$result = 1;
		my $newFileText = join("", $firstLine, $licenseText, @fileLines);
		open(OUT, ">$filename");
		print OUT ($newFileText);
		close(OUT);
	}
	return $result;
}

sub removeLicenseScript
{
	my ($setup, $filename) = @_;

	open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);
	my $fileText = join("", @fileLines);
	
	my $licenseText = createLicenseTextScript(@{$setup->{licenseLines}});
	my $licenseTextEscaped = quotemeta($licenseText);
	my $firstLine = shift(@fileLines);
	my $firstLineEscaped = quotemeta($firstLine);

	my $result = 0;
	if ($fileText =~ m/^(${firstLineEscaped})${licenseTextEscaped}(.*)$/s) {
		$result = 1;
		my $newFileText = $1 . $2;
		open(OUT, ">$filename");
		print OUT ($newFileText);
		close(OUT);
	}
	return $result;
}

sub createLicenseTextScript
{
	return "\n" . prependAndJoinLines("# ", @_);
}


##
## UTILITY METHODS
##

sub prependAndJoinLines
{
	my ($pre, @lines) = @_;
	
	foreach (@lines) {
		my $curLineRef = \$_;
		chomp(${$curLineRef});
		${$curLineRef} = $pre . ${$curLineRef} . "\n";
	}
	
	my $text = join("", @lines);
	return $text;
}

sub parseArgs
{
	my @args = @_;
	
	my $setup = {};
	$setup->{licenseFilename} = $SCRIPT_DIR . "license.txt";
	$setup->{patternFilename} = $SCRIPT_DIR . "patterns.txt";
	$setup->{fileRootDir} = $SCRIPT_DIR . "../../";
	$setup->{addLicense} = 1;

	while (defined(my $curArg = shift(@args)))
	{
		if ($curArg eq "-remove") {
			$setup->{addLicense} = 0;
		} else {
			printUsage("unknown argument ($curArg)");
		}
	}
	
	return $setup;
}

sub printUsage
{
	my ($errorMsg) = @_;
	
	open(IN, $SCRIPT_DIR . "usage.txt");
	my @lines = <IN>;
	close(IN);
	
	print STDOUT (@lines);

	if (defined($errorMsg)) {
		print STDOUT ("\nERROR: $errorMsg\n\n")		
	}
	exit(1);
}
