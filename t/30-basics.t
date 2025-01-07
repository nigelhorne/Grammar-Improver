use strict;
use warnings;
use Test::Most;
use GrammarImprover;

# Create an instance of GrammarImprover
my $improver = GrammarImprover->new(
    api_url => 'https://api.languagetool.org/v2/check',
);

# Basic test: Constructor
isa_ok($improver, 'GrammarImprover', 'Constructor returns a GrammarImprover object');

# Test grammar improvement functionality
subtest 'Grammar improvement tests' => sub {
    my $text = 'This are a sample text with mistake.';
    my $corrected_text = $improver->improve_grammar($text);

    ok($corrected_text, 'Corrected text is returned');
    is($corrected_text, 'This is a sample text with mistake.', 'Grammar is improved correctly');
};

# Test invalid input
subtest 'Error handling' => sub {
    throws_ok { $improver->improve_grammar('') } qr/Text input is required/, 'Dies on empty input';
};

# Test edge cases
subtest 'Edge cases' => sub {
    my $short_text = 'Hi.';
    my $corrected_text = $improver->improve_grammar($short_text);
    is($corrected_text, $short_text, 'Handles short input gracefully');

    my $complex_text = 'He go to the store and buys some apples.';
    $corrected_text = $improver->improve_grammar($complex_text);
    like($corrected_text, qr/He goes to the store/, 'Corrects verb agreement');
};

done_testing();
