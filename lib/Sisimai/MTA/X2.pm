package Sisimai::MTA::X2;
use parent 'Sisimai::MTA';
use feature ':5.10';
use strict;
use warnings;

my $Re0 = {
    'from'     => qr/MAILER-DAEMON[@]/,
    'subject'  => qr{\A(?>
         Delivery[ ]failure
        |fail(?:ure|ed)[ ]delivery
        )
    }x,
};
my $Re1 = {
    'begin'    => qr/\AUnable to deliver message to the following address/,
    'rfc822'   => qr/\A--- Original message follows/,
    'endof'    => qr/\A__END_OF_EMAIL_MESSAGE__\z/,
};
my $Indicators = __PACKAGE__->INDICATORS;

sub description { 'Unknown MTA #2' }
sub smtpagent   { 'X2' }
sub pattern     { return $Re0 }

sub scan {
    # Detect an error from Unknown MTA #2
    # @param         [Hash] mhead       Message header of a bounce email
    # @options mhead [String] from      From header
    # @options mhead [String] date      Date header
    # @options mhead [String] subject   Subject header
    # @options mhead [Array]  received  Received headers
    # @options mhead [String] others    Other required headers
    # @param         [String] mbody     Message body of a bounce email
    # @return        [Hash, Undef]      Bounce data list and message/rfc822 part
    #                                   or Undef if it failed to parse or the
    #                                   arguments are missing
    # @since v4.1.7
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless $mhead->{'from'}    =~ $Re0->{'from'};
    return undef unless $mhead->{'subject'} =~ $Re0->{'subject'};

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $v = undef;

    for my $e ( @hasdivided ) {
        # Read each line between $Re1->{'begin'} and $Re1->{'rfc822'}.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            if( $e =~ $Re1->{'begin'} ) {
                $readcursor |= $Indicators->{'deliverystatus'};
                next;
            }
        }

        unless( $readcursor & $Indicators->{'message-rfc822'} ) {
            # Beginning of the original message part
            if( $e =~ $Re1->{'rfc822'} ) {
                $readcursor |= $Indicators->{'message-rfc822'};
                next;
            }
        }

        if( $readcursor & $Indicators->{'message-rfc822'} ) {
            # After "message/rfc822"
            unless( length $e ) {
                $blanklines++;
                last if $blanklines > 2;
                next;
            }
            push @$rfc822list, $e;

        } else {
            # Before "message/rfc822"
            next unless $readcursor & $Indicators->{'deliverystatus'};
            next unless length $e;

            # Message from example.com.
            # Unable to deliver message to the following address(es).
            #
            # <kijitora@example.com>:
            # This user doesn't have a example.com account (kijitora@example.com) [0]
            $v = $dscontents->[-1];

            if( $e =~ m/\A[<]([^ ]+[@][^ ]+)[>]:\z/ ) {
                # <kijitora@example.com>:
                if( length $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $recipients++;

            } else {
                # This user doesn't have a example.com account (kijitora@example.com) [0]
                $v->{'diagnosis'} .= ' '.$e;
            }
        } # End of if: rfc822
    }

    return undef unless $recipients;
    require Sisimai::String;

    for my $e ( @$dscontents ) {
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'agent'}     = __PACKAGE__->smtpagent;
    }

    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::MTA::X2 - bounce mail parser class for C<X2>.

=head1 SYNOPSIS

    use Sisimai::MTA::X2;

=head1 DESCRIPTION

Sisimai::MTA::X2 parses a bounce email which created by Unknown MTA #2. Methods
in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::MTA::X2->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::MTA::X2->smtpagent;

=head2 C<B<scan(I<header data>, I<reference to body string>)>>

C<scan()> method parses a bounced email and return results as a array reference.
See Sisimai::Message for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut


