use strict;
use warnings;
use Test::More;
use lib qw(./lib ./blib/lib);
require './t/600-lhost-code';

my $enginename = 'Aol';
my $enginetest = Sisimai::Lhost::Code->makeinquiry;
my $isexpected = {
    # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
    '01' => [['5.4.4',   '',    'hostunknown',     1]],
    '02' => [['5.2.2',   '550', 'mailboxfull',     0]],
    '03' => [['5.2.2',   '550', 'mailboxfull',     0],
             ['5.1.1',   '550', 'userunknown',     1]],
    '04' => [['5.1.1',   '550', 'userunknown',     1]],
    '05' => [['5.4.4',   '',    'hostunknown',     1]],
    '06' => [['5.4.4',   '',    'notaccept',       1]],
};

$enginetest->($enginename, $isexpected);
done_testing;

