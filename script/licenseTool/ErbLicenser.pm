# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

package ErbLicenser;

use Moose;

extends 'SimpleLicenser';

has '+is_concrete' => ( is => 'ro',
                        default => 1 );

has '+prefix' => ( is => 'ro',
                   default => "    " );

has '+add_blank_line' => ( is => 'ro',
                           default => 0 );

no Moose;

sub _commentLicenseText
{
	my ($self, $licenseLinesArrayRef) = @_;

	my @licenseLines = @{$licenseLinesArrayRef};
	chomp(@licenseLines);

	my $firstLine = shift(@licenseLines);
	my $lastLine = pop(@licenseLines);

	my $bodyText = $self->SimpleLicenser::_commentLicenseText(\@licenseLines);

	my $result = "";

	if (defined($firstLine)) {
		$firstLine = "<%# " . $firstLine . "\n";
		if (defined($lastLine)) {
			$lastLine = "    " . $lastLine . " %>\n";
			$result = join("", $firstLine, $bodyText, $lastLine, "\n")
	 	} else {
			chomp($firstLine);
			$firstLine = "    " . $firstLine . " %>\n";		
			$result = $firstLine . "\n";
		}		
	}
	
	return $result;
}

1;