package Grammar::Improver;

use strict;
use warnings;

use Carp;
use JSON::MaybeXS;
use LWP::Protocol::https;
use LWP::UserAgent;
use Params::Get;
use Params::Validate::Strict;

=head1 NAME

Grammar::Improver - A Perl module for improving grammar using LanguageTool API.

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

  use Grammar::Improver;

  my $improver = Grammar::Improver->new(
	  api_url => 'https://api.languagetool.org/v2/check',
	  api_key => $ENV{'LANGUAGETOOL_KEY'},
  );

  my $text = 'This are a sample text with mistake.';
  my $corrected_text = $improver->improve_grammar($text);

  print "Corrected Text: $corrected_text\n";

=head1 DESCRIPTION

The C<Grammar::Improver> module interfaces with the LanguageTool API to analyze and improve grammar in text input.

=head1 METHODS

=head2 new

  my $improver = Grammar::Improver->new(%args);

Creates a new C<Grammar::Improver> object.

=cut

# Constructor
sub new {
	my $class = shift || __PACKAGE__;

	# Handle hash or hashref arguments
	my $params = Params::Get::get_params(undef, @_) || {};

	return bless {
		api_url => $params->{api_url} || 'https://api.languagetool.org/v2/check',	# LanguageTool API
		api_key => $params->{api_key},	# Optional API key
	}, $class;
}

=head2 improve_grammar($text)

  my $corrected_text = $improver->improve_grammar($text);

Analyzes, improves and corrects the grammar of the input string.
Returns the corrected string.

=head3 API SPECIFICATION

=head4 INPUT

  {
    text => {
      type => 'string',
      optional => 0
    }
  }

=head4 OUTPUT

  {
    type => 'string',
  }

=cut

sub improve_grammar {
	my $self = shift;

	my $args = Params::Validate::Strict::validate_strict({
		args => Params::Get::get_params('text', \@_) || {},
		schema => {
			text => {
				type => 'string',
				optional => 0
			}
		}
	});

	my $text = $args->{text};

	Carp::croak('Text input is required') unless $text;

	# Initialize the user agent
	my $ua = LWP::UserAgent->new();
	$ua->ssl_opts(
		SSL_verify_mode => 0,	# I know, I know
		verify_hostname => 0
	);

	# Create the request payload
	my $payload = {
		text => $text,
		language => 'en-US',
	};

	# Send the API key in the payload
	if($self->{api_key}) {
		$payload->{'apiKey'} = $self->{'api_key'};
	}

	# Convert the payload to URL-encoded form data
	my $response = $ua->post(
		$self->{api_url},
		Content_Type => 'application/x-www-form-urlencoded',
		Content => $payload,
	);

	# Check for errors
	if(!$response->is_success()) {
		Carp::croak('Error: ', $response->status_line());
	}

	my $response_content = $response->decoded_content;
	my $response_data = decode_json($response_content);

	# ::diag(Data::Dumper->new([$response_data])->Dump());

	# Apply corrections
	foreach my $match (reverse @{ $response_data->{matches} }) {
		my $offset = $match->{offset};
		my $length = $match->{length};
		my $replacement = $match->{replacements}[0]{value} || '';

		# print "offset = $offset, length = $length, replacement = $replacement\n";

		# Apply replacement to text
		substr($text, $offset, $length, $replacement);
	}
	return $text;
}

=head1 SUPPORT

This module is provided as-is without any warranty.

=head1 AUTHOR

Nigel Horne <njh@nigelhorne.com>

=head1 SEE ALSO

=over 4

=item * L<Test Dashboard|https://nigelhorne.github.io/Grammar-Improver/coverage/>

=back

1;

__END__
