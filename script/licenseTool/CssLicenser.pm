package CssLicenser;

use Moose;

extends 'SimpleLicenser';

has '+is_concrete' => ( is => 'ro',
                        default => 1 );

has '+prefix' => ( is => 'ro',
                   default => " * " );

has '+add_blank_line' => ( is => 'ro',
                           default => 0 );

no Moose;

sub _commentLicenseText
{
	my ($self, $licenseLinesArrayRef) = @_;
	
	my $bodyText = $self->SimpleLicenser::_commentLicenseText($licenseLinesArrayRef);
	return join("", "/*\n", $bodyText, " */\n", "\n");
}

1;