# $Id: WebMail.pm,v 1.1.2.2 2013/04/15 04:20:53 ak Exp $
# Copyright (C) 2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Group::ES::
                                                   
 ##  ##         ##     ##  ##           ##  ###    
 ##  ##   ####  ##     ######   ####         ##    
 ##  ##  ##  ## #####  ######      ##  ###   ##    
 ######  ###### ##  ## ##  ##   #####   ##   ##    
 ######  ##     ##  ## ##  ##  ##  ##   ##   ##    
 ##  ##   ####  #####  ##  ##   #####  #### ####   
package Kanadzuchi::Mail::Group::ES::WebMail;
use base 'Kanadzuchi::Mail::Group';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Major company's Webmail domains in Kingdom of Spain
# sub communisexemplar { return qr{[.]es\z}; }
sub nominisexemplaria
{
	my $class = shift;
	return {
		'terra' => [
			# Terra Networks, S. A.; http://www.terra.com/
			# Terra Mail; http://correo.terra.com/
			qr{\Aterra[.](?:cl|com)\z},
			qr{\Aterra[.]com[.](?:ar|co|do|sv|gt|mx|pa|pe|uy|ve)\z},
		],
	};
}

sub classisnomina
{
	my $class = shift;
	return {
		'terra'		=> 'Generic',
	};
}

1;
__END__
