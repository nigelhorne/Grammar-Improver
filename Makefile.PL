use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'GrammarImprover',        # Name of the module
    VERSION_FROM => 'GrammarImprover.pm',    # Automatically fetch version from the module
    AUTHOR       => 'Your Name <your.email@example.com>', # Author information
    ABSTRACT     => 'A Perl module for improving grammar using an external API.',
    PREREQ_PM    => {                        # Dependencies (with versions)
        'LWP::UserAgent' => 0,
        'JSON'           => 0,
    },
    LICENSE      => 'perl',                  # License type (e.g., perl, gpl, etc.)
);
