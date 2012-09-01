package BaseLicenser;

use Moose;

has 'is_concrete' => ( is => 'ro',
                       default => 0 );

no Moose;

sub addLicense
{
	my ($self, $filename, $licenseLinesArrayRef) = @_;
	
	die("\nERROR: could not open file ($filename) [$!]\n\n")
		if !open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);

	my $commentedLicenseText = $self->_commentLicenseText($licenseLinesArrayRef);
	#print STDOUT ("=== CLT ===\n", $commentedLicenseText);
	
	my $actionTaken = 0;
	if (!$self->_containsCommentedLicense($commentedLicenseText, \@fileLines)) 
	{		
		my $newFileText = $self->_addCommentedLicense($commentedLicenseText, \@fileLines);
		# print STDOUT ("=== CLT ===\n", $commentedLicenseText);
		# print STDOUT ("=== NFT ===\n", $newFileText);
	
		open(OUT, ">$filename");
		print OUT ($newFileText);
		close(OUT);

		$actionTaken = 1;
	}
	
	return $actionTaken;
}

sub removeLicense
{
	my ($self, $filename, $licenseLinesArrayRef) = @_;
	
	die("\nERROR: could not open file ($filename) [$!]\n\n")
		if !open(IN, $filename);
	my @fileLines = <IN>;
	close(IN);

	my $commentedLicenseText = $self->_commentLicenseText($licenseLinesArrayRef);

	my $actionTaken = 0;
	if ($self->_containsCommentedLicense($commentedLicenseText, \@fileLines)) 
	{		
		my $newFileText = $self->_removeCommentedLicense($commentedLicenseText, \@fileLines);
	
		open(OUT, ">$filename");
		print OUT ($newFileText);
		close(OUT);

		$actionTaken = 1;
	}
	
	return $actionTaken;	
}

1;