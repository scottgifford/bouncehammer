# $Id: Smartphone.pm,v 1.1.2.2 2013/04/15 04:20:53 ak Exp $
# -Id: SmartPhone.pm,v 1.1 2009/08/29 07:33:22 ak Exp -
# Copyright (C) 2011,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Group::PA::
                                                                        
  #####                        ##          ##                           
 ###     ##  ##  ####  ##### ###### #####  ##      ####  #####   ####   
  ###    ######     ## ##  ##  ##   ##  ## #####  ##  ## ##  ## ##  ##  
   ###   ######  ##### ##      ##   ##  ## ##  ## ##  ## ##  ## ######  
    ###  ##  ## ##  ## ##      ##   #####  ##  ## ##  ## ##  ## ##      
 #####   ##  ##  ##### ##       ### ##     ##  ##  ####  ##  ##  ####   
                                    ##                                  
package Kanadzuchi::Mail::Group::PA::Smartphone;
use base 'Kanadzuchi::Mail::Group';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Major company's smaprtphone domains in Republic of Panama
# See http://www.thegremlinhunt.com/2010/01/07/list-of-blackberry-internet-service-e-mail-login-sites/
sub communisexemplar { return qr{[.]com\z}; }
sub nominisexemplaria
{
	my $class = shift;
	return {
		'claro' => [
			# Claro; http://www.claro.com.pa/
			qr{\Aclaropanama[.]blackberry[.]com\z},
		],
		'cwmovil' => [
			# Cable & Wireless Panama; http://www.cwmovil.com/
			qr{\Acwmovil[.]blackberry[.]com\z},
		],
		'digicel' => [
			# Digicel Panama; http://www.digicelpanama.com/
			qr{\Adigicel[.]blackberry[.]com\z},
		],
		'movistar' => [
			# movistar; http://movistar.com.pa/
			qr{\Amovistar[.]pa[.]blackberry[.]com\z},
		],
	};
}

sub classisnomina
{
	my $class = shift;
	return {
		'claro'		=> 'Generic',
		'cwmovil'	=> 'Generic',
		'digicel'	=> 'Generic',
		'movistar'	=> 'Generic',
	};
}

1;
__END__
