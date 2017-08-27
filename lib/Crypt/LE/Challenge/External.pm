package Crypt::LE::Challenge::External;
use strict;

=head1 NAME

Crypt::LE::Challenge::External - spawn an external process to complete Let's Encrypt challenges

=head1 SYNOPSIS

   le.pl --handle-with Crypt::LE::Challenge::External --handle-params '{"command":"ssh user@${domain} echo ${token}.${fingerprint} \\> ./public_html/.well-known/acme-challenge/${token}"}'

=head1 DESCRIPTION

=head1 PARAMETERS

  token
  fingerprint
  domain

=cut

our $VERSION = '0.01';

sub new { bless {}, shift }
 
sub handle_challenge_http {
    my $self = shift;
    my ($challenge, $params) = @_;
    # You can use external logger if it has been provided.
    $challenge->{logger}->info("Processing the 'http' challenge for '$challenge->{domain}' with " . __PACKAGE__) if $challenge->{logger};
    
    my $cmd = $params->{command};
    $cmd =~ s!\$\{(\w+)\}!$challenge->{$1}!ge;
    $challenge->{logger}->info("Launching external process [$cmd]") if $challenge->{logger};
    system( $cmd );
    return 1;
};

sub handle_challenge_tls {
    # Return 0 to indicate an error
    return 0;
}

sub handle_challenge_dns {
    return 0;
}

sub handle_verification_http {
    my $self = shift;
    my ($results, $params) = @_;
    # You can use external logger if it has been provided.
    $results->{logger}->info("Processing the 'http' verification for '$results->{domain}' with " . __PACKAGE__) if $results->{logger};
    if ($results->{valid}) {
        print "Domain verification results for '$results->{domain}': success.\n";
    } else {
        print "Domain verification results for '$results->{domain}': error. $results->{error}\n";
    }
    print "You can now delete '$results->{token}' file\n";
    return 1;
}

sub handle_verification_tls {
    1;
}

sub handle_verification_dns {
    1;
}

1;

=head1 AUTHOR

=head1 LICENSE

=cut
