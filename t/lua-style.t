use lib 'lib';
use Test::Style::BaseLib 'no_plan';


run_test();

__DATA__

=== TEST 1: test1

--- interpreter
perl
--- program
lua-style.pl
--- code
local x = 1  --hello
--- verify
local x = 1  -- hello
