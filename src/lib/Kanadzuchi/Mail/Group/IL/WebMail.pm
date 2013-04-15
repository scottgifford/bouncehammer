# $Id: WebMail.pm,v 1.3.2.1 2013/04/15 04:20:53 ak Exp $
# Copyright (C) 2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Group::IL::
                                                   
 ##  ##         ##     ##  ##           ##  ###    
 ##  ##   ####  ##     ######   ####         ##    
 ##  ##  ##  ## #####  ######      ##  ###   ##    
 ######  ###### ##  ## ##  ##   #####   ##   ##    
 ######  ##     ##  ## ##  ##  ##  ##   ##   ##    
 ##  ##   ####  #####  ##  ##   #####  #### ####   
package Kanadzuchi::Mail::Group::IL::WebMail;
use base 'Kanadzuchi::Mail::Group';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Major company's Webmail domains in Israel
sub communisexemplar { return qr{[.]il\z}; }
sub nominisexemplaria
{
	my $class = shift;
	return {
		# EXPERIMENTAL(NOT TESTED)
		# Walla! Communications
		# http://www.walla.co.il/
		# http://en.wikipedia.org/wiki/Walla!
		'walla' => [
			qr{\Awalla[.]co[.]il\z},
		],
	};
}

sub classisnomina
{
	my $class = shift;
	return {
		'walla'		=> 'Generic',
	};
}

1;
__END__
