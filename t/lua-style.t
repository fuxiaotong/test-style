use lib 'lib';
use Test::Validator::BaseLib 'no_plan';

$ENV{INTERPRETER} = "perl";
$ENV{PROGRAM} = "lua-style.pl";

run_test();

__DATA__

=== TEST 1: test1

--- code
local x = 1  --set x = 1
--- verify
local x = 1  -- set x = 1

=== TEST 2: test2

--- code
local x=3  -- set x = 1
--- verify
local x = 3  -- set x = 1
