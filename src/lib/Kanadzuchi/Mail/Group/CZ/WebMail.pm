# $Id: WebMail.pm,v 1.4.2.1 2013/04/15 04:20:53 ak Exp $
# Copyright (C) 2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Group::CZ::
                                                   
 ##  ##         ##     ##  ##           ##  ###    
 ##  ##   ####  ##     ######   ####         ##    
 ##  ##  ##  ## #####  ######      ##  ###   ##    
 ######  ###### ##  ## ##  ##   #####   ##   ##    
 ######  ##     ##  ## ##  ##  ##  ##   ##   ##    
 ##  ##   ####  #####  ##  ##   #####  #### ####   
package Kanadzuchi::Mail::Group::CZ::WebMail;
use base 'Kanadzuchi::Mail::Group';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Major company's Webmail domains in Czech Republic/Czechia
sub communisexemplar { return qr{[.]cz\z}; }
sub nominisexemplaria
{
	my $class = shift;
	return {
		# Seznam, http://www.seznam.cz/
		'seznam.cz' => [
			qr{\A(?:seznam|email|post|spoluzaci|stream|firmy)[.]cz\z},
		],
	};
}

sub classisnomina
{
	my $class = shift;
	return {
		'seznam.cz'	=> 'Generic',
	};
}

1;
__END__
