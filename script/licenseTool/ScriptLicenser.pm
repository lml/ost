# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

package ScriptLicenser;

use Moose;

extends 'SimpleLicenser';

has '+is_concrete' => ( is => 'ro',
                        default => 1 );

has '+prefix' => ( is => 'ro',
                   default => "# " );

has '+add_blank_line' => ( is => 'ro',
                           default => 0 );

no Moose;

sub _commentLicenseText
{
	my ($self, $licenseLinesArrayRef) = @_;
	
	my $bodyText = $self->SimpleLicenser::_commentLicenseText($licenseLinesArrayRef);
	return join("", "\n", $bodyText);
}

sub _containsCommentedLicense
{
	my ($self, $commentedLicenseText, $fileLinesArrayRef) = @_;
	
	if (0 != scalar(@{$fileLinesArrayRef}))
	{
		my @fileLines = @{$fileLinesArrayRef};
		my $firstLine = shift(@fileLines);
		my $fileText = join("", @{$fileLinesArrayRef});

		my $firstLineEscaped = quotemeta($firstLine);
		my $commentedLicenseEscaped = quotemeta($commentedLicenseText);

		return 1
  			if $fileText =~ m/^${firstLineEscaped}${commentedLicenseEscaped}/s;
	}
	return 0;
}

sub _addCommentedLicense
{
	my ($self, $commentedLicenseText, $fileLinesArrayRef) = @_;
	my @fileLines = @{$fileLinesArrayRef};
	my $firstLine = shift(@fileLines);
	
	return join("", $firstLine, $commentedLicenseText, @fileLines);
}

sub _removeCommentedLicense
{
	my ($self, $commentedLicenseText, $fileLinesArrayRef) = @_;

	my @fileLines = @{$fileLinesArrayRef};
	my $fileText = join("", @{$fileLinesArrayRef});
	my $firstLine = shift(@fileLines);
	
	my $firstLineEscaped = quotemeta($firstLine);
	my $commentedLicenseEscaped = quotemeta($commentedLicenseText);

	$fileText =~ m/^(${firstLineEscaped})${commentedLicenseEscaped}(.*)$/s;
	return join("", $1, $2);
}

1;