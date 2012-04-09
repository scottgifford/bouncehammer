# $Id: FeedbackLoop.pm,v 1.1.2.3 2012/04/09 06:37:52 ak Exp $
# Copyright (C) 2012 Cubicroot Co. Ltd.
# Kanadzuchi::MTA::
                                                                                   
 ######                  ## ##                  ##     ##                          
 ##     ####   ####      ## ##      ####   #### ##     ##     ####   ####  #####   
 ####  ##  ## ##  ##  ##### #####      ## ##    ## ##  ##    ##  ## ##  ## ##  ##  
 ##    ###### ###### ##  ## ##  ##  ##### ##    ####   ##    ##  ## ##  ## ##  ##  
 ##    ##     ##     ##  ## ##  ## ##  ## ##    ## ##  ##    ##  ## ##  ## #####   
 ##     ####   ####   ##### #####   #####  #### ##  ## ###### ####   ####  ##      
package Kanadzuchi::MTA::FeedbackLoop;
use base 'Kanadzuchi::MTA';
use strict;
use warnings;
#  _____                      _                      _        _ 
# | ____|_  ___ __   ___ _ __(_)_ __ ___   ___ _ __ | |_ __ _| |
# |  _| \ \/ / '_ \ / _ \ '__| | '_ ` _ \ / _ \ '_ \| __/ _` | |
# | |___ >  <| |_) |  __/ |  | | | | | | |  __/ | | | || (_| | |
# |_____/_/\_\ .__/ \___|_|  |_|_| |_| |_|\___|_| |_|\__\__,_|_|
#            |_|                                                
#  _                 _                           _        _   _             
# (_)_ __ ___  _ __ | | ___ _ __ ___   ___ _ __ | |_ __ _| |_(_) ___  _ __  
# | | '_ ` _ \| '_ \| |/ _ \ '_ ` _ \ / _ \ '_ \| __/ _` | __| |/ _ \| '_ \ 
# | | | | | | | |_) | |  __/ | | | | |  __/ | | | || (_| | |_| | (_) | | | |
# |_|_| |_| |_| .__/|_|\___|_| |_| |_|\___|_| |_|\__\__,_|\__|_|\___/|_| |_|
#             |_|                                                           
#
# http://en.wikipedia.org/wiki/Feedback_loop_(email)
# http://en.wikipedia.org/wiki/Abuse_Reporting_Format
# http://tools.ietf.org/html/draft-shafranovich-feedback-report-08
my $RxFBL = {
	'content-type' => qr{report-type=["]?feedback-report["]?},
	'subject' => [
		qr{Email Feedback Report for IP },	# AOL
		qr{complaint about message from },	# Hotmail
		qr{\A(?:FW|FWD):}i,
	],
	'from' => [
		qr{AntiSpam Feedback},			# Yahoo!
	],
	'begin' => qr{\AContent-Type: message/feedback-report},
	'endof' => qr{\AContent-Type: message/rfc822},
};

my $FeedbackTypes = {
	#'Feedback-Type:' => 'Reason'
	'abuse' => 'undefined',
	'dkim' => 'undefined',
	'fraud' => 'undefined',
	'miscategorized' => 'undefined',
	'not-spam' => 'undefined',
	'opt-out' => 'undefined',
	'virus' => 'undefined',
	'other' => 'undefined',
};

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
sub version { '0.0.1' }
sub description { '(Experimental) Feedback Loop' };
sub xsmtpagent { 'X-SMTP-Agent: FeedbackLoop'.qq(\n); }
sub reperit
{
	# +-+-+-+-+-+-+-+
	# |r|e|p|e|r|i|t|
	# +-+-+-+-+-+-+-+
	#
	# @Description	Detect an error as a Feedback Loop message
	# @Param <ref>	(Ref->Hash) Message header
	# @Param <ref>	(Ref->String) Message body
	# @Return	(String) Pseudo header content
	my $class = shift();
	my $mhead = shift() || return q();
	my $mbody = shift() || return q();
	my $isfbl = 0;

	HEADERS:while(1)
	{
		if( $mhead->{'content-type'} =~ $RxFBL->{'content-type'} )
		{
			$isfbl = 1;
			last(HEADERS);
		}

		foreach my $head ( @{ $RxFBL->{'subject'} } )
		{
			if( $mhead->{'subject'} =~ $head )
			{
				$isfbl = 1;
				last(HEADERS);
			}
		}

		foreach my $head ( @{ $RxFBL->{'from'} } )
		{
			if( $mhead->{'from'} =~ $head )
			{
				$isfbl = 1;
				last(HEADERS);
			}
		}
		last();
	}

	return q() unless $isfbl;

	my $phead = q();	# (String) Pseudo email header
	my $xsmtp = q();	# (String) SMTP Command in transcript of session
	my $endof = 0;

	my $rhostsaid = q();	# (String) Remote host said: ...
	my $rcptintxt = q();	# (String) Recipient address in message body
	my $statintxt = q();	# (String) #n.n.n Status code in message body

	# http://tools.ietf.org/html/draft-shafranovich-feedback-report-08#
	# 3.1.  Required Fields
	# 
	#    The following report header fields are REQUIRED and MUST only appear
	#    once:
	# 
	#    o  "Feedback-Type" contains the type of feedback report (as defined
	#       in the corresponding IANA registry and later in this memo).  This
	#       is intended to let report parsers distinguish among different
	#       types of reports.
	# 
	#    o  "User-Agent" indicates the name and version of the software
	#       program that generated the report.  The format of this field MUST
	#       follow section 14.43 of [HTTP].  This field is for documentation
	#       only; there is no registry of user agent names or versions, and
	#       report receivers SHOULD NOT expect user agent names to belong to a
	#       known set.
	# 
	#    o  "Version" indicates the version of specification that the report
	#       generator is using to generate the report.  The version number in
	#       this specification is set to "0.1".  [NOTE TO RFC EDITOR: This
	#       should be changed to "1" at time of publication.]
	my $fbacktype = q();	# Feedback-Type:
	my $useragent = q();	# User-Agent:
	my $rgversion = q();	# Version:
	my $fblheader = [];	# And other headers

	EACH_LINE: foreach my $el ( split( qq{\n}, $$mbody ) )
	{
		last if $endof;
		if( ($el =~ $RxFBL->{'begin'}) .. ($el =~ $RxFBL->{'endof'}) )
		{
			if( $el =~ m{\AFeedback-Type: (.+)\z} )
			{
				$fbacktype = $1;
				push @$fblheader, $el;
				next;
			}

			if( $fbacktype )
			{
				next if $el =~ m{\AReceived-Date: };

				if( $el =~ m{\AOriginal-Rcpt-To: (.+)\z} )
				{
					$rcptintxt = Kanadzuchi::Address->canonify($1);
					next();
				}
				elsif( $el =~ m{\AUser-Agent: (.+)\z} )
				{
					$useragent = $1;
					next();
				}
				elsif( $el =~ m{\AVersion: (.+)\z} )
				{
					$rgversion = $1;
					next();
				}
				elsif( $el =~ m{\A\z} )
				{
					$endof = 1;
					last;
				}

				$el =~ y{"}{}d;
				push @$fblheader, $el;
				next;
			}
		}
	}

	return q() unless $fbacktype;
	return q() unless $useragent;
	return q() unless $rgversion;

	$rhostsaid = join( ', ', @$fblheader );
	$statintxt = Kanadzuchi::RFC3463->status( $FeedbackTypes->{ $fbacktype },'p','i' );

	$phead .= __PACKAGE__->xsmtprecipient($rcptintxt) if $rcptintxt;
	$phead .= __PACKAGE__->xsmtpdiagnosis( join(', ', @$fblheader) );
	$phead .= __PACKAGE__->xsmtpcommand($xsmtp);
	$phead .= __PACKAGE__->xsmtpstatus($statintxt);
	$phead .= __PACKAGE__->xsmtpagent();

	return $phead;
}

1;
__END__

