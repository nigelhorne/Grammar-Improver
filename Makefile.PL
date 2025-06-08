use strict;
use warnings;
use ExtUtils::MakeMaker;

# Test for broken smokers that don't set AUTOMATED_TESTING
if(my $reporter = $ENV{'PERL_CPAN_REPORTER_CONFIG'}) {
	if($reporter =~ /smoker/i) {
		warn 'AUTOMATED_TESTING added for you' if(!defined($ENV{'AUTOMATED_TESTING'}));
		$ENV{'AUTOMATED_TESTING'} = 1;
	}
}

my $dist = {
	COMPRESS => 'gzip -9f', # Compress tarball using gzip
	SUFFIX => 'gz',	# File suffix for tarball
};

if($^O eq 'darwin') {
	$dist->{'TAR'} = 'gtar';
}

WriteMakefile(
	NAME	 => 'Grammar::Improver',		# Name of the module
	VERSION_FROM => 'lib/Grammar/Improver.pm',	# Automatically fetch version from the module
	AUTHOR	=> 'Nigel Horne <njh@nigelhorne.com>', # Author information
	ABSTRACT	 => 'A Perl module for improving grammar using an external API.',
	((defined($ExtUtils::MakeMaker::VERSION) && ($ExtUtils::MakeMaker::VERSION >= 6.3002))
		? ('LICENSE'=> 'GPL')
		: ()),
	PREREQ_PM	=> {						# Dependencies (with versions)
		'Carp' => 0,
		'ExtUtils::MakeMaker' => 6.64,	# Minimum version for TEST_REQUIRES
		'LWP::UserAgent' => 0,
		'LWP::Protocol::https' => 0,
		'JSON::MaybeXS'	=> 0
	}, TEST_REQUIRES => {
		'Test::DescribeMe' => 0,
		'Test::Most' => 0,
		'Test::Needs' => 0,
		'Test::RequiresInternet' => 0,
		'Test::Warnings' => 0
	}, dist => $dist,
	clean	 => {
		FILES => 'Grammar-Improver-*',
	}, META_MERGE => {	# https://perldoc.perl.org/CPAN::Meta::Spec
		'meta-spec' => { version => 2 },
		resources => {
			homepage => 'https://metacpan.org/pod/Grammar::Improver',
			repository => {
				repository => 'https://github.com/nigelhorne/Grammar-Improver',
				type => 'git',
				url => 'git://github.com/nigelhorne/Grammar-Improver.git',
				web => 'https://github.com/nigelhorne/Grammar-Improver'
			}, bugtracker => {
				mailto => 'bug-Grammar-Improver@rt.cpan.org',
				url => 'https://github.com/nigelhorne/Grammar-Improver/issues',
				# web => 'https://rt.cpan.org/Public/Dist/Display.html?Name=Grammar-Improver',
				web => 'https://github.com/nigelhorne/Grammar-Improver/issues'
			}
		},
	},
	MIN_PERL_VERSION	=> '5.008'
);
