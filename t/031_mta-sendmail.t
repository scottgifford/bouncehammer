# $Id: 031_mta-sendmail.t,v 1.4.2.2 2011/10/11 03:02:51 ak Exp $
#  ____ ____ ____ ____ ____ ____ ____ ____ ____ 
# ||L |||i |||b |||r |||a |||r |||i |||e |||s ||
# ||__|||__|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
use lib qw(./t/lib ./dist/lib ./src/lib);
use strict;
use warnings;
use Kanadzuchi::Test;
use Kanadzuchi::MTA::Sendmail;
use Test::More ( tests => 10 );

#  ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ 
# ||G |||l |||o |||b |||a |||l |||       |||v |||a |||r |||s ||
# ||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|
#
my $Test = new Kanadzuchi::Test(
		'class' => q|Kanadzuchi::MTA::Sendmail|,
		'methods' => [ 'xsmtpagent', 'xsmtpcommand', 'xsmtpdiagnosis', 
				'xsmtprecipient', 'xsmtpcharset', 'xsmtpstatus', 
				'emailheaders', 'reperit', 'SMTPCOMMAND' ],
		'instance' => undef(),
);
my $Head = {
	'subject' => 'Returned mail: see transcript for details',
	'from' => 'Mail Delivery Subsystem <MAILER-DAEMON>',
};

#  ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ 
# ||T |||e |||s |||t |||       |||c |||o |||d |||e |||s ||
# ||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|
#
PREPROCESS: {
	can_ok( $Test->class(), @{ $Test->methods } );
	is( $Test->class->xsmtpagent(), 'X-SMTP-Agent: Sendmail'.qq(\n),
		'->xsmtpagent() = X-SMTP-Agent: Sendmail' );
	is( $Test->class->xsmtpcommand(), 'X-SMTP-Command: CONN'.qq(\n),
		'->xsmtpcommand() = X-SMTP-Command: CONN' );
	isa_ok( $Test->class->emailheaders(), q|ARRAY|, '->emailheaders = []' );
	is( $Test->class->xsmtpdiagnosis('Test'), 'X-SMTP-Diagnosis: Test'.qq(\n),
		'->xsmtpdiagnosis() = X-SMTP-Diagnosis: Test' );
	is( $Test->class->xsmtpstatus('5.1.1'), 'X-SMTP-Status: 5.1.1'.qq(\n),
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
	ok( $pseudoheader, 'pseudo header length = '.length($pseudoheader) );

	foreach my $el ( split("\n", $pseudoheader) )
	{
		next() if( $el =~ m{\A\z} );
		ok( $el, $el ) if( $el =~ m{\AX-SMTP-Command: [A-Z]{4}\z} );
	}
}

__DATA__
This is a MIME-encapsulated message

--n3OHmgY4025011.1274723322/mx.example.jp

The original message was received at Wed, 29 Apr 2009 02:48:42 +0900
from localhost [127.0.0.1]
with id n3OHmgY3025009

   ----- The following addresses had permanent fatal errors -----
<user@example.org>
    (reason: 550 Unknown user user@example.org)

   ----- Transcript of session follows -----
... while talking to mfsmax.docomo.ne.jp.:
>>> RCPT To:<user@example.org>
<<< 550 Unknown user user@example.org
550 5.1.1 <user@example.org>... User unknown
>>> DATA
<<< 503 Bad sequence of commands

--n3OHmgY4025011.1274723322/mx.example.jp
Content-Type: message/delivery-status

Reporting-MTA: dns; mx.example.jp
Received-From-MTA: DNS; localhost
Arrival-Date: Wed, 29 Apr 2010 02:48:42 +0900

Final-Recipient: RFC822; user@example.org
Action: failed
Status: 5.1.1
Remote-MTA: DNS; mfsmax.docomo.ne.jp
Diagnostic-Code: SMTP; 550 Unknown user user@example.org
Last-Attempt-Date: Wed, 29 Apr 2009 02:48:42 +0900

Content-Type: text/rfc822-headers

Return-Path: <sendmail@mta1.example.jp>
Received: (from sendmail@localhost)
	by mta1.example.jp (8.14.4/8.12.8/Submit) id n3OHmfrp025004
	for user@example.org; Wed, 29 Apr 2009 02:48:41 +0900
Date: Wed, 29 Apr 2009 02:48:41 +0900
Message-Id: <201005241748.n3OHmfrp025004@mta1.example.jp>
To: user@example.org
From: info@example.jp
Subject: Bounce
MIME-Version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit



