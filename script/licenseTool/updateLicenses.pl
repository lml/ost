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
}

my $setup = parseArgs(@ARGV);

##
## Open and read the license file.
##

die ("\n\nERROR: could not open license file ($setup->{licenseFilename}) [$!]\n\n")
  if !open(IN, $setup->{licenseFilename});
my @licenseLines = <IN>;
close(IN);

$setup->{licenseLines} = \@licenseLines;

##
## Open and read the patterns file.
##

die ("\n\nERROR: could not open regex file ($setup->{patternFilename}) [$!]\n\n")
  if !open(IN, $setup->{patternFilename});
my @regexLines = <IN>;
close(IN);

$setup->{patterns} = {};
$setup->{patternsArray} = [];
	
foreach (@regexLines) {
	my $curLine = $_;

	$curLine =~ s/#.*//;
	$curLine =~ s/^\s+|\s+$//g;
	next
		if $curLine eq "";
	
	if ($curLine =~ m/^(.+?)\s+(\S+)$/) {
		my $regex = qr($1);
		my $commentStyle = $2;
		if (!defined($setup->{patterns}->{$regex})) {
			$setup->{patterns}->{$regex} = $commentStyle;
			push(@{$setup->{patternsArray}}, $regex);
		}
		else {
			print STDERR ("\nERROR: duplicate pattern ($regex)\n\n");
		}
	}
	else {
		print STDERR ("\nERROR: invalid pattern line ($curLine)\n\n")
	}	
}

##
## Create a list of filenames to process.
##

my $cmd = "find $setup->{fileRootDir} -type f";
my @filenamesToProcess = `$cmd`;

##
## Loop through the filenames, adding the license based on the
## matching pattern in the patterns file.
##

foreach (@filenamesToProcess) 
{
	my $curFilename = $_;
	$curFilename =~ s/^\s+|\s+$//g;
	next
		if $curFilename eq "";

	my $curFilenameMatchedPattern = 0;
	my $commentStyle = "  ------  ";

	foreach (@{$setup->{patternsArray}})
	{
		my $curPattern = $_;
		#print STDOUT ("curPattern: ($curPattern)\n");
		if ($curFilename =~ m/$curPattern/) {
			$curFilenameMatchedPattern = 1;
			$commentStyle = $setup->{patterns}->{$curPattern};
			last;
		}
	}

	#print STDOUT (sprintf("%-10.10s", $commentStyle) . " $curFilename\n");
	
	if ("HTML" eq $commentStyle) {
		if ($setup->{addLicense}) {
			addLicenseHtml($setup, $curFilename);
		} else {
			removeLicenseHtml($setup, $curFilename);
		}
	} else {
		#print STDOUT ("cannot handle comment style $commentStyle\n");
	}
}

sub addLicenseHtml
{
	my ($setup, $filename) = @_;
	
	open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);
	my $fileText = join("", @fileLines);
	
	my $licenseText = createLicenseTextHtml(@{$setup->{licenseLines}});
	my $licenseTextEscaped = quotemeta($licenseText);

	if ($fileText !~ m/^$licenseTextEscaped/s) {
		print STDOUT ("adding license to $filename\n");
		open(OUT, ">$filename");
		print OUT ($licenseText, $fileText);
		close(OUT);
	} else {
		print STDOUT ("$filename already contains license\n");
	}
}

sub removeLicenseHtml
{
	my ($setup, $filename) = @_;

	open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);
	my $fileText = join("", @fileLines);
	
	my $licenseText = createLicenseTextHtml(@{$setup->{licenseLines}});
	my $licenseTextEscaped = quotemeta($licenseText);

	if ($fileText =~ m/^${licenseTextEscaped}(.*)$/s) {
		my $newFileText = $1;
		print STDOUT ("removing license from $filename\n");
		open(OUT, ">$filename");
		print OUT ($newFileText);
		close(OUT);
	} else {
		print STDOUT ("$filename does not contain the license\n");
	}
}

sub createLicenseTextHtml
{
	my @licenseLines = @_;
	
	for (my $idx=0; $idx<scalar(@licenseLines); $idx++) {
		chomp($licenseLines[$idx]);
		if (0 == $idx) {
			$licenseLines[$idx] = "<\%# " . $licenseLines[$idx] . "\n";
		} elsif (scalar(@licenseLines)-1 == $idx) {
			$licenseLines[$idx] = "    " . $licenseLines[$idx] . " %>\n";
		} else {
			$licenseLines[$idx] = "    " . $licenseLines[$idx] . "\n";			
		}
	}
	my $licenseText = join("", @licenseLines, "\n\n");
	return $licenseText;
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
