package JavaScriptLicenser;

use Moose;

extends 'SimpleLicenser';

has '+is_concrete' => ( is => 'ro',
                        default => 1 );

has '+prefix' => ( is => 'ro',
                   default => "// " );

no Moose;

1;