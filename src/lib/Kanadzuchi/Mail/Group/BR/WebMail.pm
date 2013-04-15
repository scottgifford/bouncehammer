# $Id: WebMail.pm,v 1.3.2.3 2013/04/15 04:20:53 ak Exp $
# Copyright (C) 2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Group::BR::
                                                   
 ##  ##         ##     ##  ##           ##  ###    
 ##  ##   ####  ##     ######   ####         ##    
 ##  ##  ##  ## #####  ######      ##  ###   ##    
 ######  ###### ##  ## ##  ##   #####   ##   ##    
 ######  ##     ##  ## ##  ##  ##  ##   ##   ##    
 ##  ##   ####  #####  ##  ##   #####  #### ####   
package Kanadzuchi::Mail::Group::BR::WebMail;
use base 'Kanadzuchi::Mail::Group';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Major company's Webmail domains in Brazil
# sub communisexemplar { return qr{[.]br\z}; }
sub nominisexemplaria
{
	my $class = shift;
	return {
		'bol' => [
			# BOL - O e-mail gratis do Brasil
			# http://www.bol.uol.com.br/
			qr{\Abol[.]com[.]br\z},
		],
		'uol' => [
			# Universo Online; http://www.uol.com.br/
			qr{\Auol[.]com[.](?:ar|br)\z},
		],
		'zipmail' => [
			# Zipmail; http://zipmail.uol.com.br/
			qr{\Azipmail[.]com[.]br\z},
		],
	};
}

sub classisnomina
{
	my $class = shift;
	return {
		'bol'		=> 'Generic',
		'uol'		=> 'Generic',
		'zipmail'	=> 'Generic',
	};
}

1;
__END__
