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
	
	my $actionString = "UNKNOWN STYLE";
	
	if ("HTML" eq $commentStyle) {
		if ($setup->{addLicense}) {
			$actionString = addLicenseHtml($setup, $curFilename) ? "ADDED_LICENSE" : "NO_ACTION";
		} else {
			$actionString = removeLicenseHtml($setup, $curFilename) ? "REMOVED_LICENSE" : "NO_ACTION";
		}
	} elsif ("JS" eq $commentStyle) {
		if ($setup->{addLicense}) {
			$actionString = addLicenseJs($setup, $curFilename) ? "ADDED_LICENSE" : "NO_ACTION";
		} else {
			$actionString = removeLicenseJs($setup, $curFilename) ? "REMOVED_LICENSE" : "NO_ACTION";
		}
	} elsif ("COFFEE" eq $commentStyle) {
		if ($setup->{addLicense}) {
			$actionString = addLicenseCoffee($setup, $curFilename) ? "ADDED_LICENSE" : "NO_ACTION";
		} else {
			$actionString = removeLicenseCoffee($setup, $curFilename) ? "REMOVED_LICENSE" : "NO_ACTION";
		}
	} elsif ("RUBY" eq $commentStyle) {
		if ($setup->{addLicense}) {
			$actionString = addLicenseRuby($setup, $curFilename) ? "ADDED_LICENSE" : "NO_ACTION";
		} else {
			$actionString = removeLicenseRuby($setup, $curFilename) ? "REMOVED_LICENSE" : "NO_ACTION";
		}
	} elsif ("CSS" eq $commentStyle) {
		if ($setup->{addLicense}) {
			$actionString = addLicenseCss($setup, $curFilename) ? "ADDED_LICENSE" : "NO_ACTION";
		} else {
			$actionString = removeLicenseCss($setup, $curFilename) ? "REMOVED_LICENSE" : "NO_ACTION";
		}
	} elsif ("SCSS" eq $commentStyle) {
		if ($setup->{addLicense}) {
			$actionString = addLicenseScss($setup, $curFilename) ? "ADDED_LICENSE" : "NO_ACTION";
		} else {
			$actionString = removeLicenseScss($setup, $curFilename) ? "REMOVED_LICENSE" : "NO_ACTION";
		}
	} elsif ("NONE" eq $commentStyle) {
		$actionString = "NO_ACTION"
	}
	
	print STDOUT (sprintf("%-20.20s %s\n", $actionString, $curFilename));
}

sub addLicenseCoffee
{
	my ($setup, $filename) = @_;
	
	open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);
	my $fileText = join("", @fileLines);
	
	my $licenseText = createLicenseTextCoffee(@{$setup->{licenseLines}});
	my $licenseTextEscaped = quotemeta($licenseText);

	my $result = 0;
	if ($fileText !~ m/^$licenseTextEscaped/s) {
		$result = 1;
		open(OUT, ">$filename");
		print OUT ($licenseText, $fileText);
		close(OUT);
	}
	return $result;
}

sub removeLicenseCoffee
{
	my ($setup, $filename) = @_;

	open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);
	my $fileText = join("", @fileLines);
	
	my $licenseText = createLicenseTextCoffee(@{$setup->{licenseLines}});
	my $licenseTextEscaped = quotemeta($licenseText);

	my $result = 0;
	if ($fileText =~ m/^${licenseTextEscaped}(.*)$/s) {
		$result = 1;
		my $newFileText = $1;
		open(OUT, ">$filename");
		print OUT ($newFileText);
		close(OUT);
	}
	return $result;
}

sub createLicenseTextCoffee
{
	return prependAndJoinLines("# ", @_) . "\n\n";
}

sub addLicenseCss
{
	my ($setup, $filename) = @_;
	
	open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);
	my $fileText = join("", @fileLines);
	
	my $licenseText = createLicenseTextCss(@{$setup->{licenseLines}});
	my $licenseTextEscaped = quotemeta($licenseText);

	my $result = 0;
	if ($fileText !~ m/^$licenseTextEscaped/s) {
		$result = 1;
		open(OUT, ">$filename");
		print OUT ($licenseText, $fileText);
		close(OUT);
	}
	return $result;
}

sub removeLicenseCss
{
	my ($setup, $filename) = @_;

	open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);
	my $fileText = join("", @fileLines);
	
	my $licenseText = createLicenseTextCss(@{$setup->{licenseLines}});
	my $licenseTextEscaped = quotemeta($licenseText);

	my $result = 0;
	if ($fileText =~ m/^${licenseTextEscaped}(.*)$/s) {
		$result = 1;
		my $newFileText = $1;
		open(OUT, ">$filename");
		print OUT ($newFileText);
		close(OUT);
	}
	return $result;
}

sub createLicenseTextCss
{
	return join("", "/*\n", prependAndJoinLines(" * ", @_), " */\n", "\n\n");
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

	my $result = 0;
	if ($fileText !~ m/^$licenseTextEscaped/s) {
		$result = 1;
		open(OUT, ">$filename");
		print OUT ($licenseText, $fileText);
		close(OUT);
	}
	return $result;
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

	my $result = 0;
	if ($fileText =~ m/^${licenseTextEscaped}(.*)$/s) {
		$result = 1;
		my $newFileText = $1;
		open(OUT, ">$filename");
		print OUT ($newFileText);
		close(OUT);
	}
	return $result;
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

sub addLicenseJs
{
	my ($setup, $filename) = @_;
	
	open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);
	my $fileText = join("", @fileLines);
	
	my $licenseText = createLicenseTextJs(@{$setup->{licenseLines}});
	my $licenseTextEscaped = quotemeta($licenseText);

	my $result = 0;
	if ($fileText !~ m/^$licenseTextEscaped/s) {
		my $result = 1;
		open(OUT, ">$filename");
		print OUT ($licenseText, $fileText);
		close(OUT);
	}
	return $result;
}

sub removeLicenseJs
{
	my ($setup, $filename) = @_;

	open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);
	my $fileText = join("", @fileLines);
	
	my $licenseText = createLicenseTextJs(@{$setup->{licenseLines}});
	my $licenseTextEscaped = quotemeta($licenseText);

	my $result = 0;
	if ($fileText =~ m/^${licenseTextEscaped}(.*)$/s) {
		$result = 1;
		my $newFileText = $1;
		open(OUT, ">$filename");
		print OUT ($newFileText);
		close(OUT);
	}
	return $result;
}

sub createLicenseTextJs
{
	return prependAndJoinLines("// ", @_) . "\n\n";
}

sub addLicenseRuby
{
	my ($setup, $filename) = @_;
	
	open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);
	my $fileText = join("", @fileLines);
	
	my $licenseText = createLicenseTextRuby(@{$setup->{licenseLines}});
	my $licenseTextEscaped = quotemeta($licenseText);

	my $result = 0;
	if ($fileText !~ m/^$licenseTextEscaped/s) {
		$result = 1;
		open(OUT, ">$filename");
		print OUT ($licenseText, $fileText);
		close(OUT);
	}
	return $result;
}

sub removeLicenseRuby
{
	my ($setup, $filename) = @_;

	open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);
	my $fileText = join("", @fileLines);
	
	my $licenseText = createLicenseTextRuby(@{$setup->{licenseLines}});
	my $licenseTextEscaped = quotemeta($licenseText);

	my $result = 0;
	if ($fileText =~ m/^${licenseTextEscaped}(.*)$/s) {
		$result = 1;
		my $newFileText = $1;
		open(OUT, ">$filename");
		print OUT ($newFileText);
		close(OUT);
	}
	return $result;
}

sub createLicenseTextRuby
{
	return prependAndJoinLines("# ", @_) . "\n\n";
}

sub addLicenseScss
{
	my ($setup, $filename) = @_;
	
	open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);
	my $fileText = join("", @fileLines);
	
	my $licenseText = createLicenseTextScss(@{$setup->{licenseLines}});
	my $licenseTextEscaped = quotemeta($licenseText);

	my $result = 0;
	if ($fileText !~ m/^$licenseTextEscaped/s) {
		$result = 1;
		open(OUT, ">$filename");
		print OUT ($licenseText, $fileText);
		close(OUT);
	}
	return $result;
}

sub removeLicenseScss
{
	my ($setup, $filename) = @_;

	open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);
	my $fileText = join("", @fileLines);
	
	my $licenseText = createLicenseTextScss(@{$setup->{licenseLines}});
	my $licenseTextEscaped = quotemeta($licenseText);

	my $result = 0;
	if ($fileText =~ m/^${licenseTextEscaped}(.*)$/s) {
		$result = 1;
		my $newFileText = $1;
		open(OUT, ">$filename");
		print OUT ($newFileText);
		close(OUT);
	}
	return $result;
}

sub createLicenseTextScss
{
	return prependAndJoinLines("// ", @_) . "\n\n";
}

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
