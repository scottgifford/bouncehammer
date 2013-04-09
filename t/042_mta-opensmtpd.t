# $Id: 042_mta-opensmtpd.t,v 1.1.2.1 2013/04/08 04:35:02 ak Exp $
#  ____ ____ ____ ____ ____ ____ ____ ____ ____ 
# ||L |||i |||b |||r |||a |||r |||i |||e |||s ||
# ||__|||__|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
use lib qw(./t/lib ./dist/lib ./src/lib);
use strict;
use warnings;
use Kanadzuchi::Test;
use Kanadzuchi::MTA::OpenSMTPD;
use Test::More ( tests => 12 );

#  ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ 
# ||G |||l |||o |||b |||a |||l |||       |||v |||a |||r |||s ||
# ||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|
#
my $Test = new Kanadzuchi::Test(
		'class' => q|Kanadzuchi::MTA::OpenSMTPD|,
		'methods' => [ 'xsmtpagent', 'xsmtpcommand', 'xsmtpdiagnosis', 
				'xsmtprecipient', 'xsmtpcharset', 'xsmtpstatus', 
				'emailheaders', 'reperit', 'SMTPCOMMAND' ],
		'instance' => undef,
);
my $Head = {
	'subject' => 'Delivery status notification: error',
	'from' => 'Mailer Daemon <MAILER-DAEMON@example.jp>',
	'received' => [
		'by mta.example.jp (OpenSMTPD) with ESMTP id 3b7b0a14;'
	],
};

#  ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ 
# ||T |||e |||s |||t |||       |||c |||o |||d |||e |||s ||
# ||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|
#
PREPROCESS: {
	can_ok( $Test->class(), @{ $Test->methods } );
	is( $Test->class->xsmtpagent(), 'X-SMTP-Agent: OpenSMTPD'.qq(\n),
		'->xsmtpagent() = X-SMTP-Agent: OpenSMTPD' );
	is( $Test->class->xsmtpcommand(), 'X-SMTP-Command: CONN'.qq(\n),
		'->xsmtpcommand() = X-SMTP-Command: CONN' );
	isa_ok( $Test->class->emailheaders(), q|ARRAY|, '->emailheaders = []' );
	is( $Test->class->xsmtpdiagnosis('Test'), 'X-SMTP-Diagnosis: Test'.qq(\n),
		'->xsmtpdiagnosis() = X-SMTP-Diagnosis: Test' );
	is( $Test->class->xsmtpstatus('5.2.1'), 'X-SMTP-Status: 5.2.1'.qq(\n),
		'->xsmtpstatus() = X-SMTP-Status: 5.1.1' );
	is( $Test->class->xsmtprecipient('user@example.jp'), 'X-SMTP-Recipient: user@example.jp'.qq(\n),
		'->xsmtprecipient() = X-SMTP-Recipient: user@example.jp' );
	isa_ok( $Test->class->SMTPCOMMAND(), q|HASH|, '->SMTPCOMMAND = {}' );
}

REPERIT: {
	my $mesgbodypart = q();
	my $pseudoheader = q();

	$mesgbodypart .= $_ while( <DATA> );
	$pseudoheader = $Test->class->reperit( $Head, \$mesgbodypart );
	ok( $pseudoheader );
	
	foreach my $el ( split("\n", $pseudoheader) )
	{
		next() if( $el =~ m{\A\z} );
		ok( $el, $el ) if( $el =~ m{X-SMTP-Command: [A-Z]{4}} );
		ok( $el, $el ) if( $el =~ m{X-SMTP-Status: } );
		ok( $el, $el ) if( $el =~ m{Final-Recipient: } );
		ok( $el, $el ) if( $el =~ m{X-SMTP-Diagnosis: } );
	}
}

__DATA__
    Hi!

    This is the MAILER-DAEMON, please DO NOT REPLY to this e-mail.

    An error has occurred while attempting to deliver a message for
    the following list of recipients:

user@example.jp: 550 5.2.1 <user@example.jp>... User Unknown

    Below is a copy of the original message:

Received: from mta.example.jp (localhost [127.0.0.1]);
	by mta.example.jp (OpenSMTPD) with ESMTP id 8f800958;
	for <user@example.jp>;
	Mon, 1 Apr 2013 11:59:51 +0900 (JST)
Received: (from ak@localhost)
	by mta.example.jp (8.14.5/8.14.5/Submit) id r382xpnv008576
	for user@example.jp; Mon, 1 Apr 2013 11:59:51 +0900 (JST)
Date: Mon, 1 Apr 2013 11:59:51 +0900 (JST)
From: user <user@example.com>
Message-Id: <201304080259.r382xpnv008576@mta.example.jp>
To: user@example.jp

mta.example.jp
