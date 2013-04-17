# $Id: OpenSMTPD.pm,v 1.1.2.5 2013/04/17 04:55:29 ak Exp $
# Copyright (C) 2012-2013 Cubicroot Co. Ltd.
# Kanadzuchi::MTA::
                                                                 
  ####                        ##### ##  ## ###### #####  ####    
 ##  ## #####   ####  #####  ###    ######   ##   ##  ## ## ##   
 ##  ## ##  ## ##  ## ##  ##  ###   ######   ##   ##  ## ##  ##  
 ##  ## ##  ## ###### ##  ##   ###  ##  ##   ##   #####  ##  ##  
 ##  ## #####  ##     ##  ##    ### ##  ##   ##   ##     ## ##   
  ####  ##      ####  ##  ## #####  ##  ##   ##   ##     ####    
        ##                                                       
package Kanadzuchi::MTA::OpenSMTPD;
use base 'Kanadzuchi::MTA';
use strict;
use warnings;

# http://www.openbsd.org/cgi-bin/man.cgi?query=smtpd&sektion=8
#  ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ 
# ||G |||l |||o |||b |||a |||l |||       |||v |||a |||r |||s ||
# ||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|
#
# /usr/local/src/opensmtpd-5.3.1p1/smtpd/
# bounce.c/306:#define NOTICE_INTRO							    \
# bounce.c/307:	"    Hi!\n\n"							    \
# bounce.c/308:	"    This is the MAILER-DAEMON, please DO NOT REPLY to this e-mail.\n"
# bounce.c/309:
# bounce.c/310:const char *notice_error =
# bounce.c/311:    "    An error has occurred while attempting to deliver a message for\n"
# bounce.c/312:    "    the following list of recipients:\n\n";
# bounce.c/313:
# bounce.c/314:const char *notice_warning =
# bounce.c/315:    "    A message is delayed for more than %s for the following\n"
# bounce.c/316:    "    list of recipients:\n\n";
# bounce.c/317:
# bounce.c/318:const char *notice_warning2 =
# bounce.c/319:    "    Please note that this is only a temporary failure report.\n"
# bounce.c/320:    "    The message is kept in the queue for up to %s.\n"
# bounce.c/321:    "    You DO NOT NEED to re-send the message to these recipients.\n\n";

my $RxOpenSMTPD = {
	'from' => qr{\AMailer Daemon [<]MAILER-DAEMON[@]},
	'begin' => qr{\A\s*This is the MAILER-DAEMON, please DO NOT REPLY to this e-mail[.]\z},
	'endof' => qr{\A\s*Below is a copy of the original message:\z},
	'subject' => qr{\ADelivery status notification},
	'received' => qr{[ ][(]OpenSMTPD[)][ ]with[ ]},
};

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
sub version { '0.1.2' };
sub description { 'OpenSMTPD' };
sub xsmtpagent { 'X-SMTP-Agent: OpenSMTPD'.qq(\n); }
sub reperit
{
	# +-+-+-+-+-+-+-+
	# |r|e|p|e|r|i|t|
	# +-+-+-+-+-+-+-+
	#
	# @Description	Detect an error from OpenSMTPD(OpenBSD smtpd)
	# @Param <ref>	(Ref->Hash) Message header
	# @Param <ref>	(Ref->String) Message body
	# @Return	(String) Pseudo header content
	my $class = shift;
	my $mhead = shift || return q();
	my $mbody = shift || return q();

	return q() unless $mhead->{'subject'} =~ $RxOpenSMTPD->{'subject'};
	return q() unless $mhead->{'from'} =~ $RxOpenSMTPD->{'from'};
	return q() unless grep { $_ =~ $RxOpenSMTPD->{'received'} } @{ $mhead->{'received'} };

	my $phead = q();	# (String) Pseudo email header
	my $pstat = q();	# (String) Stauts code
	my $xsmtp = q();	# (String) SMTP Command in transcript of session
	my $causa = q();	# (String) Error reason

	my $rhostsaid = q();	# (String) Remote host said: ...
	my $rcptintxt = q();	# (String) Recipient address in message body
	my $statintxt = q();	# (String) #n.n.n Status code in message body
	my $codeintxt = q();	# (String) SMTP status, such as 550, 450,...

	EACH_LINE: foreach my $el ( split( qq{\n}, $$mbody ) )
	{
		if( ($el =~ $RxOpenSMTPD->{'begin'}) .. ($el =~ $RxOpenSMTPD->{'endof'}) )
		{
			#    Hi!
			#
			#    This is the MAILER-DAEMON, please DO NOT REPLY to this e-mail.
			#
			#    An error has occurred while attempting to deliver a message for
			#    the following list of recipients:
			#
			#local-part@domain-part: 550 5.2.2 <local-part@domain-part>... Mailbox Full
			#
			#    Below is a copy of the original message:
			$rcptintxt  = $1  if( ! length $rcptintxt && $el =~ m{\A(.+?[@].+?):?[ ]} );
			$codeintxt  = $1  if( ! length $codeintxt && $el =~ m|\A.+?[ ](\d{3})[ ]| );
			$statintxt  = $1  if( ! length $statintxt && $el =~ m|\A.+?[ ]([45][.]\d[.]\d+)| );
			$rhostsaid .= $el if $el =~ m{\A[a-zA-Z0-9_]};

			last if $rcptintxt;
		}
	}

	return q() unless $rhostsaid;
	$rhostsaid =~ y{ }{}s;
	$rhostsaid =~ s{\A }{}g;
	$rhostsaid =~ s{ \z}{}g;

	unless( length $statintxt )
	{
		if( $rhostsaid =~ m{[ ][(][#]([[45][.]\d[.]\d+)[)]\z} ||
			$rhostsaid =~ m{\b\d{3}[-\s]([45][.]\d[.]\d+)\b} ){

			# 550 5.7.1 <user@example.jp>... Access denied
			$statintxt = $1;
		}
		else
		{
			$pstat = Kanadzuchi::RFC3463->status( ( $causa || 'undefined' ), 'p', 'i' );
		}
	}

	if( Kanadzuchi::RFC2822->is_emailaddress( $rcptintxt ) )
	{
		$phead .= __PACKAGE__->xsmtprecipient( $rcptintxt );
	}
	else
	{
		$rcptintxt = Kanadzuchi::Address->canonify( $rhostsaid );
		$phead .= __PACKAGE__->xsmtprecipient( $rcptintxt )
				if Kanadzuchi::RFC2822->is_emailaddress( $rcptintxt );
	}

	# Add the pseudo Content-Type header if it does not exist.
	$mhead->{'content-type'} ||= q(message/delivery-status);

	$phead .= __PACKAGE__->xsmtpdiagnosis( $rhostsaid );
	$phead .= __PACKAGE__->xsmtpcommand( $xsmtp );
	$phead .= __PACKAGE__->xsmtpstatus( $pstat || $statintxt );
	$phead .= __PACKAGE__->xsmtpagent();

	return $phead;
}

1;
__END__
