use strict;
use warnings;
use Test::More;
use lib qw(./lib ./blib/lib);
require './t/600-lhost-code';

my $enginename = 'Postfix';
my $samplepath = sprintf("./set-of-emails/private/lhost-%s", lc $enginename);
my $enginetest = Sisimai::Lhost::Code->makeinquiry;
my $isexpected = {
    # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
    '01001' => [['5.0.0',   '550', 'filtered',        0]],
    '01002' => [['5.1.1',   '550', 'userunknown',     1]],
    '01003' => [['5.0.0',   '550', 'userunknown',     1]],
    '01004' => [['5.1.1',   '550', 'userunknown',     1]],
    '01005' => [['5.0.0',   '554', 'filtered',        0]],
    '01006' => [['5.7.1',   '550', 'userunknown',     1]],
    '01007' => [['5.0.0',   '554', 'filtered',        0]],
    '01008' => [['5.0.910', '',    'filtered',        0]],
    '01009' => [['5.0.0',   '550', 'userunknown',     1]],
    '01010' => [['5.0.0',   '',    'hostunknown',     1]],
    '01011' => [['5.0.0',   '551', 'systemerror',     0]],
    '01012' => [['5.1.1',   '550', 'userunknown',     1]],
    '01013' => [['5.0.0',   '550', 'userunknown',     1]],
    '01014' => [['5.1.1',   '',    'userunknown',     1]],
    '01015' => [['5.1.1',   '550', 'userunknown',     1]],
    '01016' => [['4.3.2',   '452', 'toomanyconn',     0]],
    '01017' => [['4.4.1',   '',    'expired',         0]],
    '01018' => [['5.4.6',   '',    'systemerror',     0]],
    '01019' => [['5.7.1',   '553', 'userunknown',     1]],
    '01020' => [['5.1.1',   '550', 'userunknown',     1]],
    '01021' => [['4.4.1',   '',    'expired',         0]],
    '01022' => [['5.1.1',   '550', 'userunknown',     1]],
    '01023' => [['5.0.0',   '550', 'blocked',         0]],
    '01024' => [['5.1.1',   '',    'userunknown',     1]],
    '01025' => [['5.0.0',   '550', 'userunknown',     1]],
    '01026' => [['4.4.1',   '',    'expired',         0]],
    '01027' => [['5.4.6',   '',    'systemerror',     0]],
    '01028' => [['5.0.0',   '551', 'suspend',         0]],
    '01029' => [['5.0.0',   '550', 'userunknown',     1]],
    '01030' => [['5.0.0',   '550', 'userunknown',     1]],
    '01031' => [['5.0.0',   '550', 'userunknown',     1]],
    '01032' => [['5.0.0',   '550', 'userunknown',     1]],
    '01033' => [['5.0.0',   '550', 'userunknown',     1]],
    '01034' => [['5.0.0',   '550', 'filtered',        0]],
    '01035' => [['4.2.2',   '',    'mailboxfull',     0]],
    '01036' => [['5.4.4',   '',    'hostunknown',     1]],
    '01037' => [['5.0.0',   '550', 'filtered',        0]],
    '01038' => [['5.0.0',   '550', 'blocked',         0]],
    '01039' => [['5.1.1',   '',    'userunknown',     1]],
    '01040' => [['5.7.1',   '550', 'userunknown',     1]],
    '01041' => [['5.1.1',   '',    'userunknown',     1]],
    '01042' => [['5.4.4',   '',    'networkerror',    0]],
    '01043' => [['5.1.6',   '550', 'hasmoved',        1]],
    '01044' => [['5.3.4',   '',    'mesgtoobig',      0]],
    '01045' => [['5.3.4',   '',    'mesgtoobig',      0]],
    '01046' => [['5.0.0',   '534', 'mesgtoobig',      0]],
    '01047' => [['5.7.1',   '554', 'mesgtoobig',      0]],
    '01048' => [['5.1.1',   '550', 'userunknown',     1],
                ['5.1.1',   '550', 'userunknown',     1],
                ['5.1.1',   '550', 'userunknown',     1],
                ['5.1.1',   '550', 'userunknown',     1],
                ['5.1.1',   '550', 'userunknown',     1]],
    '01049' => [['5.0.0',   '550', 'hostunknown',     1]],
    '01050' => [['5.0.0',   '550', 'userunknown',     1]],
    '01051' => [['5.7.1',   '553', 'norelaying',      0]],
    '01052' => [['5.7.1',   '550', 'spamdetected',    0]],
    '01053' => [['5.4.6',   '',    'systemerror',     0]],
    '01054' => [['5.1.1',   '',    'userunknown',     1]],
    '01055' => [['5.2.1',   '550', 'filtered',        0]],
    '01056' => [['5.1.1',   '',    'mailererror',     0]],
    '01057' => [['5.1.1',   '550', 'userunknown',     1],
                ['5.1.1',   '550', 'userunknown',     1]],
    '01058' => [['5.0.0',   '550', 'filtered',        0]],
    '01059' => [['5.1.1',   '550', 'userunknown',     1]],
    '01060' => [['4.1.1',   '450', 'userunknown',     1]],
    '01061' => [['5.4.4',   '',    'hostunknown',     1]],
    '01062' => [['5.0.910', '550', 'filtered',        0]],
    '01063' => [['5.1.1',   '',    'mailererror',     0]],
    '01064' => [['5.0.0',   '',    'hostunknown',     1]],
    '01065' => [['5.0.0',   '',    'networkerror',    0]],
    '01066' => [['5.0.0',   '554', 'norelaying',      0]],
    '01067' => [['5.1.1',   '550', 'userunknown',     1]],
    '01068' => [['5.0.0',   '554', 'norelaying',      0]],
    '01069' => [['5.1.1',   '550', 'userunknown',     1]],
    '01070' => [['5.0.944', '',    'networkerror',    0]],
    '01071' => [['5.0.922', '',    'mailboxfull',     0]],
    '01072' => [['5.0.901', '554', 'onhold',          0]],
    '01073' => [['4.0.0',   '452', 'mailboxfull',     0]],
    '01074' => [['5.0.0',   '550', 'mailboxfull',     0]],
    '01075' => [['5.7.0',   '',    'mailboxfull',     0]],
    '01076' => [['5.0.0',   '554', 'filtered',        0]],
    '01077' => [['5.7.1',   '553', 'norelaying',      0]],
    '01078' => [['5.0.0',   '550', 'norelaying',      0]],
    '01079' => [['5.7.1',   '550', 'spamdetected',    0]],
    '01080' => [['5.7.1',   '554', 'spamdetected',    0]],
    '01081' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01082' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01083' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01084' => [['5.7.1',   '554', 'spamdetected',    0]],
    '01085' => [['5.7.1',   '554', 'spamdetected',    0]],
    '01086' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01087' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01088' => [['5.6.0',   '554', 'spamdetected',    0]],
    '01089' => [['5.7.1',   '554', 'spamdetected',    0]],
    '01090' => [['5.7.1',   '554', 'spamdetected',    0]],
    '01091' => [['5.0.0',   '500', 'spamdetected',    0]],
    '01092' => [['5.0.0',   '554', 'spamdetected',    0]],
    '01093' => [['5.7.1',   '554', 'spamdetected',    0]],
    '01094' => [['5.7.1',   '550', 'spamdetected',    0]],
    '01095' => [['5.0.0',   '554', 'spamdetected',    0]],
    '01096' => [['5.0.0',   '554', 'spamdetected',    0]],
    '01097' => [['5.7.3',   '553', 'spamdetected',    0]],
    '01098' => [['5.7.1',   '550', 'spamdetected',    0]],
    '01099' => [['5.7.1',   '550', 'spamdetected',    0]],
    '01100' => [['5.0.0',   '554', 'spamdetected',    0]],
    '01101' => [['5.0.0',   '554', 'policyviolation', 0]],
    '01102' => [['5.7.1',   '550', 'spamdetected',    0]],
    '01103' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01104' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01105' => [['5.0.0',   '551', 'spamdetected',    0]],
    '01106' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01107' => [['5.7.1',   '554', 'spamdetected',    0]],
    '01108' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01109' => [['5.7.1',   '550', 'spamdetected',    0]],
    '01110' => [['5.7.1',   '550', 'spamdetected',    0]],
    '01111' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01112' => [['5.0.0',   '554', 'spamdetected',    0]],
    '01113' => [['5.7.1',   '550', 'spamdetected',    0]],
    '01114' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01115' => [['5.0.0',   '554', 'blocked',         0]],
    '01116' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01117' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01118' => [['5.0.0',   '554', 'spamdetected',    0]],
    '01119' => [['5.0.0',   '553', 'spamdetected',    0]],
    '01120' => [['5.7.1',   '550', 'spamdetected',    0]],
    '01121' => [['5.3.0',   '554', 'spamdetected',    0]],
    '01122' => [['5.4.4',   '',    'hostunknown',     1]],
    '01123' => [['5.7.1',   '554', 'userunknown',     1]],
    '01124' => [['5.1.1',   '550', 'userunknown',     1]],
    '01125' => [['5.2.3',   '',    'exceedlimit',     0]],
    '01126' => [['5.0.0',   '',    'systemerror',     0]],
    '01127' => [['5.7.17',  '550', 'userunknown',     1]],
    '01128' => [['5.0.0',   '550', 'userunknown',     1]],
    '01129' => [['5.0.0',   '554', 'filtered',        0]],
    '01130' => [['5.0.0',   '552', 'mailboxfull',     0]],
    '01131' => [['5.2.3',   '',    'exceedlimit',     0]],
    '01132' => [['5.0.0',   '550', 'userunknown',     1]],
    '01133' => [['5.1.1',   '550', 'userunknown',     1]],
    '01134' => [['5.0.0',   '550', 'userunknown',     1]],
    '01135' => [['5.2.1',   '550', 'suspend',         0]],
    '01136' => [['5.0.0',   '550', 'userunknown',     1]],
    '01137' => [['5.0.0',   '550', 'userunknown',     1]],
    '01138' => [['5.0.0',   '550', 'userunknown',     1]],
    '01139' => [['5.1.3',   '501', 'userunknown',     1]],
    '01140' => [['5.0.0',   '550', 'userunknown',     1]],
    '01141' => [['5.0.0',   '',    'filtered',        0]],
    '01142' => [['5.0.0',   '550', 'blocked',         0]],
    '01143' => [['5.3.0',   '553', 'userunknown',     1]],
    '01144' => [['5.0.0',   '554', 'suspend',         0]],
    '01145' => [['5.0.0',   '550', 'filtered',        0]],
    '01146' => [['5.1.3',   '',    'userunknown',     1]],
    '01147' => [['5.1.1',   '550', 'userunknown',     1]],
    '01148' => [['5.2.1',   '550', 'userunknown',     1]],
    '01149' => [['5.2.2',   '550', 'mailboxfull',     0]],
    '01150' => [['5.0.910', '',    'filtered',        0]],
    '01151' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01152' => [['5.3.0',   '553', 'blocked',         0]],
    '01153' => [['5.7.1',   '550', 'blocked',         0]],
    '01154' => [['4.7.0',   '421', 'blocked',         0]],
    '01155' => [['5.1.0',   '550', 'userunknown',     1]],
    '01156' => [['5.1.0',   '550', 'userunknown',     1]],
    '01157' => [['4.0.0',   '',    'blocked',         0]],
    '01158' => [['5.6.0',   '554', 'spamdetected',    0]],
    '01159' => [['5.0.0',   '550', 'userunknown',     1]],
    '01160' => [['4.0.0',   '451', 'systemerror',     0]],
    '01161' => [['5.0.0',   '',    'mailboxfull',     0]],
    '01162' => [['5.0.0',   '550', 'policyviolation', 0]],
    '01163' => [['5.0.0',   '550', 'policyviolation', 0]],
    '01164' => [['5.0.0',   '550', 'blocked',         0]],
    '01165' => [['5.5.0',   '550', 'userunknown',     1]],
    '01166' => [['5.0.0',   '550', 'userunknown',     1]],
    '01167' => [['4.0.0',   '',    'blocked',         0]],
    '01168' => [['5.0.0',   '571', 'rejected',        0]],
    '01169' => [['5.0.0',   '550', 'userunknown',     1]],
    '01170' => [['5.0.0',   '550', 'blocked',         0]],
    '01171' => [['5.2.0',   '',    'mailboxfull',     0]],
    '01172' => [['4.3.0',   '',    'mailererror',     0]],
    '01173' => [['4.4.2',   '',    'networkerror',    0]],
    '01174' => [['4.3.2',   '451', 'notaccept',       0]],
    '01175' => [['5.7.9',   '554', 'policyviolation', 0]],
    '01176' => [['5.7.1',   '554', 'userunknown',     1]],
    '01177' => [['5.7.1',   '550', 'userunknown',     1]],
    '01178' => [['5.7.1',   '550', 'blocked',         0]],
    '01179' => [['5.7.1',   '501', 'norelaying',      0]],
    '01180' => [['5.4.1',   '550', 'rejected',        0]],
    '01181' => [['5.1.1',   '550', 'userunknown',     1]],
    '01182' => [['5.7.0',   '550', 'spamdetected',    0]],
    '01183' => [['5.1.1',   '550', 'userunknown',     1]],
    '01184' => [['5.7.1',   '550', 'norelaying',      0]],
    '01185' => [['4.0.0',   '451', 'systemerror',     0]],
    '01186' => [['5.1.1',   '550', 'userunknown',     1]],
    '01187' => [['5.0.0',   '550', 'userunknown',     1]],
    '01188' => [['4.4.1',   '',    'expired',         0]],
    '01189' => [['5.4.4',   '',    'hostunknown',     1]],
    '01190' => [['5.1.1',   '',    'userunknown',     1]],
    '01191' => [['5.1.1',   '550', 'userunknown',     1]],
    '01192' => [['5.1.1',   '550', 'toomanyconn',     0]],
    '01193' => [['5.0.0',   '550', 'filtered',        0]],
    '01194' => [['5.0.0',   '550', 'userunknown',     1]],
    '01195' => [['4.4.1',   '',    'expired',         0]],
    '01196' => [['5.0.0',   '550', 'userunknown',     1]],
    '01197' => [['5.0.0',   '550', 'userunknown',     1]],
    '01198' => [['5.0.0',   '554', 'systemerror',     0]],
    '01199' => [['5.0.0',   '552', 'toomanyconn',     0]],
    '01200' => [['4.0.0',   '421', 'blocked',         0]],
    '01201' => [['4.0.0',   '421', 'blocked',         0]],
    '01202' => [['5.7.0',   '550', 'policyviolation', 0]],
    '01203' => [['5.0.0',   '554', 'suspend',         0]],
    '01204' => [['5.0.0',   '504', 'syntaxerror',     0]],
    '01205' => [['5.7.1',   '550', 'rejected',        0]],
    '01206' => [['5.0.0',   '552', 'toomanyconn',     0]],
    '01207' => [['5.0.0',   '550', 'toomanyconn',     0]],
    '01208' => [['5.0.0',   '550', 'toomanyconn',     0]],
    '01209' => [['4.4.2',   '',    'networkerror',    0]],
    '01210' => [['5.0.0',   '550', 'blocked',         0]],
    '01211' => [['5.1.1',   '550', 'userunknown',     1]],
    '01212' => [['5.2.1',   '550', 'userunknown',     1]],
    '01213' => [['5.1.1',   '550', 'userunknown',     1]],
    '01214' => [['5.2.1',   '550', 'exceedlimit',     0]],
    '01215' => [['5.2.1',   '550', 'exceedlimit',     0]],
    '01216' => [['4.0.0',   '',    'blocked',         0]],
    '01217' => [['4.0.0',   '',    'blocked',         0]],
    '01218' => [['4.0.0',   '',    'blocked',         0]],
    '01219' => [['5.0.0',   '550', 'suspend',         0]],
    '01220' => [['5.0.0',   '550', 'virusdetected',   0]],
    '01221' => [['5.1.1',   '',    'userunknown',     1]],
    '01222' => [['5.2.2',   '552', 'mailboxfull',     0]],
    '01223' => [['5.7.9',   '554', 'policyviolation', 0]],
    '01224' => [['5.7.9',   '554', 'policyviolation', 0]],
    '01225' => [['5.0.0',   '554', 'policyviolation', 0]],
    '01226' => [['5.7.9',   '554', 'policyviolation', 0]],
    '01227' => [['5.7.26',  '550', 'policyviolation', 0]],
    '01228' => [['5.7.1',   '554', 'policyviolation', 0]],
    '01229' => [['5.7.1',   '550', 'policyviolation', 0]],
    '01230' => [['5.7.1',   '550', 'policyviolation', 0]],
    '01231' => [['5.7.1',   '550', 'policyviolation', 0],
                ['5.7.1',   '550', 'policyviolation', 0],
                ['5.7.1',   '550', 'policyviolation', 0]],
    '01232' => [['4.7.0',   '421', 'blocked',         0]],
    '01233' => [['5.0.0',   '550', 'blocked',         0]],
    '01234' => [['5.0.0',   '553', 'blocked',         0]],
    '01235' => [['5.0.0',   '554', 'spamdetected',    0]],
    '01236' => [['5.0.0',   '550', 'blocked',         0]],
    '01237' => [['5.0.0',   '550', 'norelaying',      0]],
    '01238' => [['5.0.0',   '550', 'userunknown',     1]],
    '01239' => [['5.0.0',   '550', 'blocked',         0]],
    '01240' => [['5.0.0',   '550', 'rejected',        0]],
    '01241' => [['5.0.0',   '550', 'rejected',        0]],
    '01242' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01243' => [['5.0.0',   '554', 'blocked',         0]],
    '01244' => [['5.8.5',   '550', 'policyviolation', 0]],
    '01245' => [['5.0.0',   '554', 'blocked',         0]],
    '01246' => [['5.0.0',   '550', 'userunknown',     1]],
    '01247' => [['5.0.0',   '550', 'norelaying',      0]],
    '01248' => [['5.0.0',   '550', 'blocked',         0]],
    '01249' => [['5.0.0',   '550', 'blocked',         0]],
    '01250' => [['5.0.0',   '550', 'userunknown',     1]],
    '01251' => [['5.0.0',   '550', 'spamdetected',    0]],
    '01252' => [['5.0.0',   '',    'onhold',          0]],
    '01253' => [['5.0.0',   '554', 'spamdetected',    0]],
    '01254' => [['5.0.0',   '554', 'blocked',         0]],
    '01255' => [['5.4.6',   '554', 'systemerror',     0]],
};

plan 'skip_all', sprintf("%s not found", $samplepath) unless -d $samplepath;
$enginetest->($enginename, $isexpected, 1, 0);
done_testing;

