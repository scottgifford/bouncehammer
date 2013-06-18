# $Id$
# Copyright (C) 2013 Scott Gifford
# Kanadzuchi::MTA::US::Vtext
						       
package Kanadzuchi::MTA::US::Vtext;
use base 'Kanadzuchi::MTA';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ 
# ||G |||l |||o |||b |||a |||l |||	 |||v |||a |||r |||s ||
# ||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|
#
my $RxVtext = {
	'from' => qr{\Apost_master\@vtext.com\z},
	'begin' => qr{\AError message below:\z},
	'endof' => qr{\A--},
};

# TODO: What to do here?
my $RxErrors = {
	'userunknown' => [
		'550',		# The attempted recipient address does not exist.
	],
};

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||	    |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
sub version { '0.1.7' };
sub description { 'Vtext (Verizon SMS) mail' };
sub xsmtpagent { 'X-SMTP-Agent: US::Vtext'.qq(\n); }
sub reperit
{
	# +-+-+-+-+-+-+-+
	# |r|e|p|e|r|i|t|
	# +-+-+-+-+-+-+-+
	#
	# @Description	Detect an error from Vtext
	# @Param <ref>	(Ref->Hash) Message header
	# @Param <ref>	(Ref->String) Message body
	# @Return	(String) Pseudo header content
	my $class = shift;
	my $mhead = shift || return q();
	my $mbody = shift || return q();

	return q() unless $mhead->{'from'} =~ $RxVtext->{'from'};

	my $phead = q();	# (String) Pseudo email header
	my $pstat = q();	# (String) #n.n.n Status code in message body
	my $xsmtp = 'DATA';	# (String) SMTP Command in transcript of session
	my $rhostsaid = q();	# (String) Remote host said: ...
	my $rcptintxt = q();	# (String) Recipient address in message body
	my $errcode;

	EACH_LINE: foreach my $el ( split( qq{\n}, $$mbody ) )
	{
		if( ($el =~ $RxVtext->{'begin'}) .. ($el =~ $RxVtext->{'endof'}) )
		{
			next if( $errcode && $rhostsaid && $rcptintxt );
			
			if ($el =~ /\A(\d+) - (.*)\Z/) {
				$rhostsaid = $2 . substr($el,0,0);
				$errcode = $1;
			} elsif ($el =~ /\A\s+RCPT TO: (.*)\Z/) {
				$rcptintxt = $1 . substr($el,0,0);
			}
		}
	} # End of foreach(EACH_LINE)

	return q() unless $errcode;
	$$mbody = q();	# For rewriting Status: header...

	foreach my $_er ( keys %$RxErrors )
	{
		if( grep { $errcode eq $_ } @{ $RxErrors->{$_er} } )
		{
			$pstat = Kanadzuchi::RFC3463->status( $_er, 'p', 's' );
			last;
		}
	}

	$pstat ||= Kanadzuchi::RFC3463->status( 'undefined', 'p', 'i' );
	$phead	.= __PACKAGE__->xsmtprecipient( $rcptintxt );
	$phead	.= __PACKAGE__->xsmtpstatus( $pstat );
	$phead	.= __PACKAGE__->xsmtpdiagnosis( $rhostsaid );
	$phead	.= __PACKAGE__->xsmtpcommand( $xsmtp );
	$phead	.= __PACKAGE__->xsmtpagent();
	return $phead;
}

1;
__END__
