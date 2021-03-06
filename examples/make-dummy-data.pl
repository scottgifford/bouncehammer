#!/usr/bin/perl
# $Id: make-dummy-data.pl,v 1.4 2010/10/05 14:05:00 ak Exp $
use strict;
use warnings;
use Digest::MD5;
use Time::Piece;

my $createdcount = 0;
my $howmanylines = shift() || 10; $howmanylines = 10 unless( $howmanylines =~ m{\A\d+\z} );
my $senderdomain = shift() || 'example.jp'; $senderdomain = 'example.jp' unless( $senderdomain =~ m{\A\w+[.][a-zA-Z]{2,8}\z} );
my $destinations = [
		{ 'domain' => 'cubicroot.jp', 'hostgroup' => 'pc', 'provider' => 'various' },
		{ 'domain' => 'bouncehammer.jp', 'hostgroup' => 'undefined', 'provider' => 'various' },
		{ 'domain' => 'example.com', 'hostgroup' => 'reserved', 'provider' => 'rfc2606' },
		{ 'domain' => 'example.ac.jp', 'hostgroup' => 'reserved', 'provider' => 'reserved' },
		{ 'domain' => 'aol.com', 'hostgroup' => 'webmail', 'provider' => 'aol' },
		{ 'domain' => 'msn.com', 'hostgroup' => 'webmail', 'provider' => 'microsoft' },
		{ 'domain' => 'yahoo.com' ,'hostgroup' => 'webmail', 'provider' => 'yahoo' },
		{ 'domain' => 'mail.ru', 'hostgroup' => 'webmail', 'provider' => 'runet' },
		{ 'domain' => 'me.com', 'hostgroup' => 'webmail', 'provider' => 'apple' },
		{ 'domain' => 'gmail.com', 'hostgroup' => 'webmail', 'provider' => 'google' },
		{ 'domain' => 'ovi.com', 'hostgroup' => 'webmail', 'provider' => 'nokia' },
		{ 'domain' => 'docomo.ne.jp', 'hostgroup' => 'cellphone', 'provider' => 'nttdocomo' },
		{ 'domain' => 'ezweb.ne.jp', 'hostgroup' => 'cellphone', 'provider' => 'aubykddi' },
		{ 'domain' => 'softbank.ne.jp', 'hostgroup' => 'cellphone', 'provider' => 'softbank' },
		{ 'domain' => 'willcom.com', 'hostgroup' => 'smartphone', 'provider' => 'willcom' },
		{ 'domain' => 'emnet.ne.jp', 'hostgroup' => 'smartphone', 'provider' => 'emobile' },
		{ 'domain' => 'i.softbank.jp', 'hostgroup' => 'smartphone', 'provider' => 'softbank' },
		{ 'domain' => 'docomo.blackberry.com', 'hostgroup' => 'smartphone', 'provider' => 'nttdocomo' },
	];
my $reasons = [ qw(
		undefined userunknown hostunknown hasmoved filtered
		suspend mailboxfull exceedlimit systemfull notaccept
		mesgtoobig mailererror securityerr whitelisted unstable
		onhold rejected expired contenterr systemerror
	) ];
my $outputformat = qq|- { "bounced": %d, "addresser": "%s", "recipient": "%s", |
			. qq|"senderdomain": "%s", "destination": "%s", "reason": "%s", |
			. qq|"hostgroup": "%s", "provider": "%s", "frequency": %d, |
			. qq|"description": { "deliverystatus": "5.%d.%d", "diagnosticcode": "Dummy Record", |
			. qq|"timezoneoffset": "+0900" }, "token": "%s" }\n|;


while( $createdcount < $howmanylines )
{
	my $bouncedat = Time::Piece->new->epoch() - int(rand(1e8));
	my $reasonwhy = $reasons->[ rand(1e2) % scalar(@$reasons) ];
	my $localpart = substr( Digest::MD5->new->add( rand(10) )->hexdigest(), 1, int(rand(3)) + 1 );

	my $randomindex = rand(1e2) % scalar(@$destinations);
	my $destination = $destinations->[ $randomindex ]->{'domain'};

	my $recipient = $localpart.'@'.$destination;
	my $addresser = 'bouncehammer@'.$senderdomain;

	my $messagetoken =  Digest::MD5::md5_hex( sprintf( "\x02%s\x1e%s\x03", lc($addresser), lc($recipient) ) );

	printf( STDOUT $outputformat, 
			$bouncedat, $addresser, $recipient, $senderdomain, $destination, $reasonwhy, 
			$destinations->[ $randomindex ]->{'hostgroup'}, $destinations->[ $randomindex ]->{'provider'},
			int(rand(1e3)), int(rand(1e1)), int(rand(1e1)), $messagetoken );

	$createdcount++;
}
