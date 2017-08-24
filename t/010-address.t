use strict;
use Test::More;
use lib qw(./lib ./blib/lib);
use Sisimai::Address;
use Sisimai::RFC5322;

my $PackageName = 'Sisimai::Address';
my $MethodNames = {
    'class' => [
        'new', 'find', 'parse', 's3s4', 'expand_verp', 'expand_alias', 'undisclosed',
    ],
    'object' => ['address', 'host', 'user', 'verp', 'alias', 'TO_JSON'],
};
my $NewInstance = $PackageName->new('maketest@bouncehammer.jp');

use_ok $PackageName;
isa_ok $NewInstance, $PackageName;
can_ok $NewInstance, @{ $MethodNames->{'object'} };
can_ok $PackageName, @{ $MethodNames->{'class'} };

MAKE_TEST: {
    my $emailaddrs = [
        { 'v' => '"Neko" <neko@example.jp>', 'a' => 'neko@example.jp', 'n' => 'Neko', 'c' => '' },
        { 'v' => '"=?ISO-2022-JP?B?dummy?=" <nyan@example.jp>',
          'a' => 'nyan@example.jp',
          'n' => '=?ISO-2022-JP?B?dummy?=',
          'c' => '', },
        { 'v' => '"N Y A N K O" <nyanko@example.jp>',
          'a' => 'nyanko@example.jp',
          'n' => 'N Y A N K O',
          'c' => '', },
        { 'v' => '"Shironeko Lui" <lui@example.jp>',
          'a' => 'lui@example.jp',
          'n' => 'Shironeko Lui',
          'c' => '', },
        { 'v' => '<aoi@example.jp>', 'a' => 'aoi@example.jp', 'n' => '', 'c' => '' },
        { 'v' => '<may@example.jp> may@example.jp', 'a' => 'may@example.jp', 'n' => 'may@example.jp', 'c' => '' },
        { 'v' => 'Odd-Eyes Aoki <aoki@example.jp>',
          'a' => 'aoki@example.jp',
          'n' => 'Odd-Eyes Aoki',
          'c' => '', },
        { 'v' => 'Mikeneko Shima <shima@example.jp> SHIMA@EXAMPLE.JP',
          'a' => 'shima@example.jp',
          'n' => 'Mikeneko Shima SHIMA@EXAMPLE.JP',
          'c' => '', },
        { 'v' => 'chosuke@neko <chosuke@example.jp>',
          'a' => 'chosuke@example.jp',
          'n' => 'chosuke@neko',
          'c' => '', },
        { 'v' => 'akari@chatora.neko <akari@example.jp>',
          'a' => 'akari@example.jp',
          'n' => 'akari@chatora.neko',
          'c' => '', },
        { 'v' => 'mari <mari@example.jp> mari@host.int',
          'a' => 'mari@example.jp',
          'n' => 'mari mari@host.int',
          'c' => '', },
        { 'v' => '8suke@example.gov (Mayuge-Neko)',
          'a' => '8suke@example.gov',
          'n' => '8suke@example.gov',
          'c' => '(Mayuge-Neko)', },
        { 'v' => 'Shibainu Hachibe. (Harima-no-kami) 8be@example.gov',
          'a' => '8be@example.gov',
          'n' => 'Shibainu Hachibe. 8be@example.gov',
          'c' => '(Harima-no-kami)', },
        { 'v' => 'nekochan@example.jp',
          'a' => 'nekochan@example.jp',
          'n' => 'nekochan@example.jp',
          'c' => '' },
        { 'v' => '<neko@example.com>:', 'a' => 'neko@example.com', 'n' => ':', 'c' => '' },
        { 'v' => '"<neko@example.org>"', 'a' => 'neko@example.org', 'n' => '', 'c' => '' },
        { 'v' => '"neko@example.net"',
          'a' => 'neko@example.net',
          'n' => 'neko@example.net',
          'c' => '' },
        { 'v' => q|'neko@example.edu'|,
          'a' => 'neko@example.edu',
          'n' => q|'neko@example.edu'|,
          'c' => '' },
        { 'v' => '`neko@example.cat`',
          'a' => 'neko@example.cat',
          'n' => '`neko@example.cat`',
          'c' => '' },
        { 'v' => '[neko@example.gov]',
          'a' => 'neko@example.gov',
          'n' => '[neko@example.gov]',
          'c' => '' },
        { 'v' => '{neko@example.int}',
          'a' => 'neko@example.int',
          'n' => '{neko@example.int}',
          'c' => '' },
        { 'v' => '"neko.."@example.jp',
          'a' => '"neko.."@example.jp',
          'n' => '"neko.."@example.jp',
          'c' => '' },
        { 'v' => 'Mail Delivery Subsystem <MAILER-DAEMON>',
          'a' => 'MAILER-DAEMON',
          'n' => 'Mail Delivery Subsystem',
          'c' => '', },
        { 'v' => 'postmaster', 'a' => 'postmaster', 'n' => 'postmaster', 'c' => '' },
        { 'v' => 'neko.nyaan@example.com',
          'a' => 'neko.nyaan@example.com',
          'n' => 'neko.nyaan@example.com',
          'c' => '' },
        { 'v' => 'neko.nyaan+nyan@example.com',
          'a' => 'neko.nyaan+nyan@example.com',
          'n' => 'neko.nyaan+nyan@example.com',
          'c' => '', },
        { 'v' => 'neko-nyaan@example.com',
          'a' => 'neko-nyaan@example.com',
          'n' => 'neko-nyaan@example.com',
          'c' => '' },
        { 'v' => 'neko-nyaan@example.com.',
          'a' => 'neko-nyaan@example.com.',
          'n' => 'neko-nyaan@example.com.',
          'c' => '' },
        { 'v' => 'n@example.com',
          'a' => 'n@example.com',
          'n' => 'n@example.com',
          'c' => '' },
        { 'v' => '"neko.nyaan.@.nyaan.jp"@example.com',
          'a' => '"neko.nyaan.@.nyaan.jp"@example.com',
          'n' => '"neko.nyaan.@.nyaan.jp"@example.com',
          'c' => '',
        },
#        { 'v' => q|"neko.(),:;<>[]\".NYAAN.\"neko@\\ \"neko\".nyaan"@neko.example.com|,
#          'a' => q|"neko.(),:;<>[]\".NYAAN.\"neko@\\ \"neko\".nyaan"@neko.example.com| },
#        { 'v' => q|neko-nyaan@neko-nyaan.example.com|, 'a' => 'neko-nyaan@neko-nyaan.example.com' },
#        { 'v' => q|neko@nyaan|, 'a' => 'neko@nyaan' },
#        { 'v' => q[#!$%&'*+-/=?^_`{}|~@example.org], 'a' => q[#!$%&'*+-/=?^_`{}|~@example.org] },
#        { 'v' => q*"()<>[]:,;@\\\"!#$%&'-/=?^_`{}| ~.a"@example.org*,
#          'a' => q*"()<>[]:,;@\\\"!#$%&'-/=?^_`{}| ~.a"@example.org* },
#        { 'v' => q|" "@example.org|, 'a' => '" "@example.org' },
#        { 'v' => q|neko@localhost|, 'a' => 'neko@localhost' },
#        { 'v' => q|neko@[IPv6:2001:DB8::1]|, 'a' => 'neko@[IPv6:2001:DB8::1]' },
    ];
    my $isnotemail = [
        1, 'neko', 'cat%neko.jp', '', undef, {},
    ];
    my $emailindex = 1;

    my $a = undef;
    my $n = undef;
    my $v = undef;
    my $p = 'Sisimai::Address';

    for my $e ( @$emailaddrs ) {
        $n = sprintf("[%04d/%04d]", $emailindex, scalar @$emailaddrs);
        $a = undef;

        ok length  $e->{'v'}, sprintf("%s Email(v) = %s", $n, $e->{'v'});
        ok length  $e->{'a'}, sprintf("%s Address(a) = %s", $n, $e->{'a'});
        ok defined $e->{'n'}, sprintf("%s Display name(n) = %s", $n, $e->{'n'});
        ok defined $e->{'c'}, sprintf("%s Comment(c) = %s", $n, $e->{'c'});

        PARSE: {
            # ->parse
            $v = $p->parse([$e->{'v'}]);

            is ref $v, 'ARRAY', sprintf("%s %s->parse(v)", $n, $p);
            is scalar @$v, 1, sprintf("%s %s->parse returns 1 email address", $n, $p);
            is $v->[0], $e->{'a'}, sprintf("%s Sisimai::Address->parse(v) = %s", $n, $e->{'a'});
        }

        FIND: {
            # ->find()
            $v = $p->find($e->{'v'});

            is ref $v, 'ARRAY', sprintf("%s %s->find(v)", $n, $p);
            is scalar @$v, 1, sprintf("%s %s->find(v) returns 1 email address", $n, $p);

            ok $v->[0]->{'address'}, sprintf("%s %s->find(v)->address = %s", $n, $p, $v->[0]->{'address'});
            is $v->[0]->{'address'}, $e->{'a'}, sprintf("%s %s->find(v)->address = %s", $n, $p, $e->{'a'});

            for my $f ('comment', 'name') {
                ok defined $v->[0]->{ $f }, sprintf("%s %s->find(v)->%s = %s", $n, $p, $f, $v->[0]->{ $f });
                is $v->[0]->{ $f }, $e->{ substr($f, 0, 1) }, sprintf("%s %s->find(v)->%s = %s", $n, $p, $f, $v->[0]->{ $f });
            }

            # find(v, 1)
            $v = $p->find($e->{'v'}, 1);

            is ref $v, 'ARRAY', sprintf("%s %s->find(v,1)", $n, $p);
            is scalar @$v, 1, sprintf("%s %s->find(v,1) returns 1 email address", $n, $p);

            ok $v->[0]->{'address'}, sprintf("%s %s->find(v,1)->address = %s", $n, $p, $v->[0]->{'address'});
            is $v->[0]->{'address'}, $e->{'a'}, sprintf("%s %s->find(v,1)->address = %s", $n, $p, $e->{'a'});
            is keys %{ $v->[0] }, 1, sprintf("%s %s->find(v,1) has 1 key", $n, $p);
        }

        S3S4: {
            # ->s3s4()
            $v = $p->s3s4($e->{'v'});

            ok length $v, sprintf("%s %s->s3s4 = %s", $n, $p, $v);
            is $v, $e->{'a'}, sprintf("%s %s->s3s4 = %s", $n, $p, $e->{'a'});
        }

        NEW: {
            # ->new()
            $v = $p->new($p->s3s4($e->{'v'}));
            $a = [split('@', $e->{'a'})];

            is ref $v, 'Sisimai::Address', sprintf("%s %s->new(v)", $n, $p);
            is $v->address, $e->{'a'}, sprintf("%s %s->new(v)->address= %s", $n, $p, $e->{'a'});
            is $v->user,    $a->[0],   sprintf("%s %s->new(v)->user = %s", $n, $p, $a->[0]);
            is $v->verp,    '',        sprintf("%s %s->new(v)->verp = ''", $n, $p, '');
            is $v->alias,   '',        sprintf("%s %s->new(v)->alias = ''", $n, $p, '');

            unless( Sisimai::RFC5322->is_mailerdaemon($e->{'v'}) ) {
                is $v->host, $a->[1], sprintf("%s %s->new(v)->host = %s", $n, $p, $a->[1]);
            }
        }
        $emailindex++;
    }

    VERP: {
        $a = 'nyaa+neko=example.jp@example.org';
        $v = $p->new($a);
        is $p->expand_verp($a), $v->address, sprintf("%s->expand_verp(%s) = %s", $p, $a, $v);
        is $v->verp, $a, sprintf("%s %s->new(v)->verp = %s", $n, $p, $a);
    }

    ALIAS: {
        $a = 'neko+nyaa@example.jp';
        $v = $p->new($a);

        is $p->expand_alias($a), $v->address, sprintf("%s->expand_alias(%s) = %s", $p, $a, $v);
        is $v->alias, $a, sprintf("%s %s->new(v)->alias = %s", $n, $p, $a);
    }

    TO_JSON: {
        $a = 'nyaan@example.org';
        $v = $p->new($a);
        is $v->TO_JSON, $v->address, sprintf("%s->new(v)->TO_JSON = %s", $p, $a);
    }

    for my $e ( @$isnotemail ) {
        $v = $p->parse([$e]); is $v, undef, sprintf("%s->parse([v])= undef", $p);
        $v = $p->s3s4($e);    is $v, $e,    sprintf("%s->s3s4(v)= %s", $p, $e);
        $v = $p->new($e);     is $v, undef, sprintf("%s->new(v)= undef", $p);
    }

    UNDISCLOSED: {
        my $r = 'undisclosed-recipient-in-headers@libsisimai.org.invalid';
        my $s = 'undisclosed-sender-in-headers@libsisimai.org.invalid';
        is $p->undisclosed('r'), $r,    sprintf("%s->undisclosed(r) = %s", $p, $r);
        is $p->undisclosed('s'), $s,    sprintf("%s->undisclosed(s) = %s", $p, $s);
        is $p->undisclosed(''),  undef, sprintf("%s->undisclosed() = undef", $p);
    }
}

done_testing;
