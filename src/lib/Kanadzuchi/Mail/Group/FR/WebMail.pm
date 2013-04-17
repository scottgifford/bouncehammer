# $Id: WebMail.pm,v 1.1.2.6 2013/04/15 09:33:32 ak Exp $
# Copyright (C) 2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Group::FR::
                                                   
 ##  ##         ##     ##  ##           ##  ###    
 ##  ##   ####  ##     ######   ####         ##    
 ##  ##  ##  ## #####  ######      ##  ###   ##    
 ######  ###### ##  ## ##  ##   #####   ##   ##    
 ######  ##     ##  ## ##  ##  ##  ##   ##   ##    
 ##  ##   ####  #####  ##  ##   #####  #### ####   
package Kanadzuchi::Mail::Group::FR::WebMail;
use base 'Kanadzuchi::Mail::Group';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Major company's Webmail domains in French Republic
# sub communisexemplar { return qr{[.]fr\z}; }
sub nominisexemplaria
{
	my $class = shift;
	return {
		'sfr' => [
			# SFR; http://www.sfr.fr/
			qr{\A(?:cario|guideo)[.]fr\z},
			qr{\A(?:mageos|waika9)[.]com\z},
			qr{\Afnac[.]net\z},
			qr{\Asfr[.]fr\z},
		],
		'voila' => [
			# http://www.voila.fr/
			qr{\Avoila[.]fr\z},
		],
	};
}

sub classisnomina
{
	my $class = shift;
	return {
		'sfr'		=> 'Generic',
		'voila'		=> 'Generic',
	};
}

1;
__END__
