# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

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