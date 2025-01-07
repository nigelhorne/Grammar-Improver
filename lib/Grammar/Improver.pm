package Grammar::Improver;

use strict;
use warnings;
use LWP::UserAgent;
use JSON;

# Constructor
sub new {
    my ($class, %args) = @_;
    my $self = {
        api_url => $args{api_url} || 'https://api.languagetool.org/v2/check',  # LanguageTool API
        api_key => $args{api_key} || '',                                      # Optional API key
    };
    bless $self, $class;
    return $self;
}

# Method to improve grammar
sub improve_grammar {
    my ($self, $text) = @_;

    die "Text input is required" unless $text;

    # Initialize the user agent
    my $ua = LWP::UserAgent->new;
    $ua->ssl_opts(
	    SSL_verify_mode => 0,
	    verify_hostname => 0
	);

    # Create the request payload
    my $payload = {
        text     => $text,
        language => 'en-US',
    };

    # Convert the payload to URL-encoded form data
    my $response = $ua->post(
        $self->{api_url},
        Content_Type => 'application/x-www-form-urlencoded',
        Content      => $payload,
    );

    # Check for errors
    if ($response->is_success) {
        my $response_content = $response->decoded_content;
        my $response_data    = decode_json($response_content);

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
    } else {
        die 'Error: ' . $response->status_line;
    }
}

1;

__END__

=head1 NAME

GrammarImprover - A Perl module for improving grammar using LanguageTool API.

=head1 SYNOPSIS

  use GrammarImprover;

  my $improver = GrammarImprover->new(
      api_url => 'https://api.languagetool.org/v2/check',
  );

  my $text = 'This are a sample text with mistake.';
  my $corrected_text = $improver->improve_grammar($text);

  print "Corrected Text: $corrected_text\n";

=head1 DESCRIPTION

The C<GrammarImprover> module interfaces with the LanguageTool API to analyze and improve grammar in text input.

=head1 METHODS

=head2 new

  my $improver = GrammarImprover->new(%args);

Creates a new C<GrammarImprover> object.

=head2 improve_grammar

  my $corrected_text = $improver->improve_grammar($text);

Analyzes and corrects the grammar of the input text. Returns the corrected text.

=head1 AUTHOR

Your Name <your.email@example.com>

=cut
