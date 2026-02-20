# NAME

Grammar::Improver - A Perl module for improving grammar using LanguageTool API.

# VERSION

Version 0.02

# SYNOPSIS

    use Grammar::Improver;

    my $improver = Grammar::Improver->new(
            api_url => 'https://api.languagetool.org/v2/check',
            api_key => $ENV{'LANGUAGETOOL_KEY'},
    );

    my $text = 'This are a sample text with mistake.';
    my $corrected_text = $improver->improve_grammar($text);

    print "Corrected Text: $corrected_text\n";

# DESCRIPTION

The `Grammar::Improver` module interfaces with the LanguageTool API to analyze and improve grammar in text input.

# METHODS

## new

    my $improver = Grammar::Improver->new(%args);

Creates a new `Grammar::Improver` object.

## improve\_grammar($text)

    my $corrected_text = $improver->improve_grammar($text);

Analyzes, improves and corrects the grammar of the input string.
Returns the corrected string.

### API SPECIFICATION

#### INPUT

    {
      text => {
        type => 'string',
        position => 0,
        optional => 0
      }
    }

#### OUTPUT

    {
      type => 'string',
    }

# SUPPORT

This module is provided as-is without any warranty.

# AUTHOR

Nigel Horne <njh@nigelhorne.com>
