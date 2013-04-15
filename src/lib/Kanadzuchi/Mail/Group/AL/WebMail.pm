# $Id: WebMail.pm,v 1.1.2.2 2013/04/15 04:20:53 ak Exp $
# Copyright (C) 2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Group::AL::
                                                   
 ##  ##         ##     ##  ##           ##  ###    
 ##  ##   ####  ##     ######   ####         ##    
 ##  ##  ##  ## #####  ######      ##  ###   ##    
 ######  ###### ##  ## ##  ##   #####   ##   ##    
 ######  ##     ##  ## ##  ##  ##  ##   ##   ##    
 ##  ##   ####  #####  ##  ##   #####  #### ####   
package Kanadzuchi::Mail::Group::AL::WebMail;
use base 'Kanadzuchi::Mail::Group';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Major company's Webmail domains in Republic of Albania
# sub communisexemplar { return qr{[.]al\z}; }
sub nominisexemplaria
{
	my $class = shift;
	return {
		'primo' => [
			# primo webmail; http://mail.albaniaonline.net/
			qr{\Aalbaniaonline[.]net\z},
			qr{\Aalbmail[.]com\z},
			qr{\Aprimo[.]al\z},
			qr{\A(?:get|my)primo[.]al\z},
			qr{\Ashukelaw[.]com\z},
		],
	};
}

sub classisnomina
{
	my $class = shift;
	return {
		'primo'		=> 'Generic',
	};
}

1;
__END__
