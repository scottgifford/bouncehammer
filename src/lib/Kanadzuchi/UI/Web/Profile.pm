# $Id: Profile.pm,v 1.12.2.1 2013/04/15 04:20:53 ak Exp $
# -Id: Profile.pm,v 1.2 2009/08/31 06:58:25 ak Exp -
# -Id: Profile.pm,v 1.3 2009/08/17 06:54:30 ak Exp -
# Copyright (C) 2009,2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::UI:Web::
                                              
 #####                  ###  ##  ###          
 ##  ## #####   ####   ##         ##   ####   
 ##  ## ##  ## ##  ## ##### ###   ##  ##  ##  
 #####  ##     ##  ##  ##    ##   ##  ######  
 ##     ##     ##  ##  ##    ##   ##  ##      
 ##     ##      ####   ##   #### ####  ####   
package Kanadzuchi::UI::Web::Profile;
use base 'Kanadzuchi::UI::Web';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||I |||n |||s |||t |||a |||n |||c |||e |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
sub systemprofile
{
	# +-+-+-+-+-+-+-+-+-+-+-+-+-+
	# |s|y|s|t|e|m|p|r|o|f|i|l|e|
	# +-+-+-+-+-+-+-+-+-+-+-+-+-+
	#
	# @Description	System profile page
	my $self = shift;
	my $file = 'profile.html';
	my $time = q();

	eval { $time = qx|uptime|; };

	$self->tt_params(
		'pv_sysconfig' => $self->{'sysconfig'},
		'pv_webconfig' => $self->{'webconfig'},
		'pv_systemname' => $Kanadzuchi::SYSNAME,
		'pv_sysconfpath' => $self->param('cf'),
		'pv_webconfpath' => $self->param('wf'),
		'pv_sysuptime' => $time,
		'pv_scriptengine' => $ENV{'MOD_PERL'} || 'CGI',
		'pv_serversoftware' => $ENV{'SERVER_SOFTWARE'} || 'Unknown',
		'pv_serverhost' => $ENV{'SERVER_NAME'}.':'.$ENV{'SERVER_PORT'},
	);
	return $self->tt_process($file);
}

1;
__END__
