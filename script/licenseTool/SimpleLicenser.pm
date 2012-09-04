package SimpleLicenser;

use Moose;

extends 'BaseLicenser';

has 'prefix' => ( is => 'ro',
                  default => "" );

has 'add_blank_line' => ( is => 'ro',
                          default => 1 );

no Moose;

sub _commentLicenseText
{
	my ($self, $licenseLinesArrayRef) = @_;
	
	my $pre = $self->prefix();
	my @licenseLines = @{$licenseLinesArrayRef};
	foreach (@licenseLines)
	{
		chomp($_);
		$_ = $pre . $_ . "\n";
	}
	push(@licenseLines, "\n")
		if $self->add_blank_line();

	return join("", @licenseLines);
}

sub _containsCommentedLicense
{
	my ($self, $commentedLicenseText, $fileLinesArrayRef) = @_;
	
	my $fileText = join("", @{$fileLinesArrayRef});
	my $commentedLicenseEscaped = quotemeta($commentedLicenseText);

	return $fileText =~ m/^${commentedLicenseEscaped}/s;
}

sub _addCommentedLicense
{
	my ($self, $commentedLicenseText, $fileLinesArrayRef) = @_;
	my $fileText = join("", @{$fileLinesArrayRef});
	return join("", $commentedLicenseText, $fileText);
}

sub _removeCommentedLicense
{
	my ($self, $commentedLicenseText, $fileLinesArrayRef) = @_;

	my $fileText = join("", @{$fileLinesArrayRef});
	my $commentedLicenseEscaped = quotemeta($commentedLicenseText);

	$fileText =~ m/^${commentedLicenseEscaped}(.*)$/s;
	return $1;
}

1;