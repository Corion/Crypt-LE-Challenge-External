package Crypt::LE::Challenge::SSH;
use strict;
use parent 'Crypt::LE::Challenge::External';

=head1 NAME

Crypt::LE::Challenge::SSH - use ssh to complete Let's Encrypt challenges

=head1 SYNOPSIS

   le.pl --handle-with Crypt::LE::Challenge::SSH --handle-params '{"login":"user@${domain}", "directory":"./public_html/.well-known/acme-challenge/"}'

=head1 DESCRIPTION

This module will use an SSH login to create the
challenge files on a remote host. This allows you
to keep the keys on a host that is not reachable
from the public internet.

Currently this module expects the C<ssh> binary
to be available in C<$ENV{PATH}>. Later versions
might move to L<Net::OpenSSH>.

=head1 PARAMETERS

  login
  directory

=cut

sub handle_challenge_http {
    my $self = shift;
    my ($challenge, $params) = @_;
    # You can use external logger if it has been provided.
    $challenge->{logger}->info("Processing the 'http' challenge for '$challenge->{domain}' with " . __PACKAGE__) if $challenge->{logger};

    my %params = %$params;
    # We should use Net::SSH::Any or whatever...
    $params{ command } = sprintf q!ssh '%s' echo ${token}.${fingerprint} \\> %s/${token}!, $params->{login}, $params->{directory};

    $self->SUPER::handle_challenge_http( $self, \%params );
};

1;

=head1 AUTHOR

=head1 LICENSE

=cut
