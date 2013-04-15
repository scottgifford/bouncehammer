# $Id: Cellphone.pm,v 1.1.2.2 2013/04/15 04:20:53 ak Exp $
# Copyright (C) 2009,2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Group::IL::
                                                            
  ####        ###  ###         ##                           
 ##  ##  ####  ##   ##  #####  ##      ####  #####   ####   
 ##     ##  ## ##   ##  ##  ## #####  ##  ## ##  ## ##  ##  
 ##     ###### ##   ##  ##  ## ##  ## ##  ## ##  ## ######  
 ##  ## ##     ##   ##  #####  ##  ## ##  ## ##  ## ##      
  ####   #### #### #### ##     ##  ##  ####  ##  ##  ####   
                        ##                                  
package Kanadzuchi::Mail::Group::IL::Cellphone;
use base 'Kanadzuchi::Mail::Group';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Cellular phone domains in State of Israel
# sub communisexemplar { return qr{[.]il\z}; }
sub nominisexemplaria
{
	my $self = shift;
	return {
		'spikko' => [
			# Spikko; http://spikkosms.com/
			qr{\Aspikkosms[.]com\z},
		],
	};
}

sub classisnomina
{
	my $class = shift;
	return {
		'spikko'	=> 'Generic',
	};
}

1;
__END__
