#!perl -w

use strict;

# use lib 'lib';
use Test::Most tests => 3;

BEGIN { use_ok('Grammar::Improver') }

isa_ok(Grammar::Improver->new(), 'Grammar::Improver', 'Creating Grammar::Improver object');
isa_ok(Grammar::Improver::new(), 'Grammar::Improver', 'Creating Grammar::Improver object');
