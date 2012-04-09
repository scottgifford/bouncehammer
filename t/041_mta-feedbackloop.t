# $Id: 041_mta-feedbackloop.t,v 1.1.2.1 2012/04/09 06:20:13 ak Exp $
#  ____ ____ ____ ____ ____ ____ ____ ____ ____ 
# ||L |||i |||b |||r |||a |||r |||i |||e |||s ||
# ||__|||__|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
use lib qw(./t/lib ./dist/lib ./src/lib);
use strict;
use warnings;
use Kanadzuchi::Test;
use Kanadzuchi::MTA::FeedbackLoop;
use Test::More ( tests => 12 );

#  ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ 
# ||G |||l |||o |||b |||a |||l |||       |||v |||a |||r |||s ||
# ||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|
#
my $Test = new Kanadzuchi::Test(
		'class' => q|Kanadzuchi::MTA::FeedbackLoop|,
		'methods' => [ 'xsmtpagent', 'xsmtpcommand', 'xsmtpdiagnosis', 
				'xsmtprecipient', 'xsmtpcharset', 'xsmtpstatus', 
				'emailheaders', 'reperit', 'SMTPCOMMAND' ],
		'instance' => undef(),
);
my $Head = {
	'subject' => 'FW: Earn money',
	'content-type' => 'multipart/report; report-type=feedback-report; boundary="part1_13d.2e68ed54_boundary"',
	'from' => '<abusedesk@example.com>',
};

#  ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ 
# ||T |||e |||s |||t |||       |||c |||o |||d |||e |||s ||
# ||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|
#
PREPROCESS: {
	can_ok( $Test->class(), @{ $Test->methods } );
	is( $Test->class->xsmtpagent(), 'X-SMTP-Agent: FeedbackLoop'.qq(\n),
		'->xsmtpagent() = X-SMTP-Agent: FeedbackLoop' );
	is( $Test->class->xsmtpcommand(), 'X-SMTP-Command: CONN'.qq(\n),
		'->xsmtpcommand() = X-SMTP-Command: CONN' );
	is( $Test->class->xsmtpdiagnosis('Test'), 'X-SMTP-Diagnosis: Test'.qq(\n),
		'->xsmtpdiagnosis() = X-SMTP-Diagnosis: Test' );
	is( $Test->class->xsmtpstatus('5.0.0'), 'X-SMTP-Status: 5.0.0'.qq(\n),
		'->xsmtpstatus() = X-SMTP-Status: 5.0.0' );
	is( $Test->class->xsmtprecipient('user@example.jp'), 'X-SMTP-Recipient: user@example.jp'.qq(\n),
		'->xsmtprecipient() = X-SMTP-Recipient: user@example.jp' );
	isa_ok( $Test->class->emailheaders(), q|ARRAY|, '->emailheaders = []' );
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
		ok( $el, $el ) if( $el =~ m{Final-Recipient: } );
		ok( $el, $el ) if( $el =~ m{X-SMTP-Status: } );
		ok( $el, $el ) if( $el =~ m{X-SMTP-Diagnosis: } );
	}
}

__DATA__
From: <abusedesk@example.com>
Date: Thu, 8 Mar 2005 17:40:36 EDT
Subject: FW: Earn money
To: <abuse@example.net>
MIME-Version: 1.0
Content-Type: multipart/report; report-type=feedback-report;
     boundary="part1_13d.2e68ed54_boundary"
 
--part1_13d.2e68ed54_boundary
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
 
This is an email abuse report for an email message received from IP
10.67.41.167 on Thu, 8 Mar 2005 14:00:00 EDT. For more information
about this format please see http://www.mipassoc.org/arf/.
 
--part1_13d.2e68ed54_boundary
Content-Type: message/feedback-report
 
Feedback-Type: abuse
User-Agent: SomeGenerator/1.0
Version: 0.1
Original-Mail-From: <somespammer@example.net>
Original-Rcpt-To: <user@example.com>
Received-Date: Thu, 8 Mar 2005 14:00:00 EDT
Source-IP: 10.67.41.167
Authentication-Results: mail.example.com
               smtp.mail=somespammer@example.com;
               spf=fail
Reported-Domain: example.net
Reported-Uri: http://example.net/earn_money.html
Reported-Uri: mailto:user@example.com
Removal-Recipient: user@example.com
 
--part1_13d.2e68ed54_boundary
Content-Type: message/rfc822
Content-Disposition: inline
 
From: <somespammer@example.net>
Received: from mailserver.example.net (mailserver.example.net
     [10.67.41.167]) by example.com with ESMTP id M63d4137594e46;
     Thu, 8 Mar 2005 14:00:00 -0400
To: <Undisclosed Recipients>
Subject: Earn money
MIME-Version: 1.0
Content-type: text/plain
Message-ID: 8787KJKJ3K4J3K4J3K4J3.mail@example.net
Date: Thu, 2 Sep 2004 12:31:03 -0500
 
Spam Spam Spam
Spam Spam Spam
Spam Spam Spam
Spam Spam Spam
--part1_13d.2e68ed54_boundary--
