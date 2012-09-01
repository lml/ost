package NoopLicenser;

use Moose;

extends 'BaseLicenser';

has '+is_concrete' => ( is => 'ro',
                        default => 1 );

no Moose;

sub addLicense
{
	return 0;
}

sub removeLicense
{
	return 0;
}

1;