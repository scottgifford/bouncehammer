# $Id: Cellphone.pm,v 1.1.2.2 2013/04/15 04:20:53 ak Exp $
# Copyright (C) 2009-2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Group::IN::
                                                            
  ####        ###  ###         ##                           
 ##  ##  ####  ##   ##  #####  ##      ####  #####   ####   
 ##     ##  ## ##   ##  ##  ## #####  ##  ## ##  ## ##  ##  
 ##     ###### ##   ##  ##  ## ##  ## ##  ## ##  ## ######  
 ##  ## ##     ##   ##  #####  ##  ## ##  ## ##  ## ##      
  ####   #### #### #### ##     ##  ##  ####  ##  ##  ####   
                        ##                                  
package Kanadzuchi::Mail::Group::IN::Cellphone;
use base 'Kanadzuchi::Mail::Group';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Cellular phone domains in India
# sub communisexemplar { return qr{[.]in\z}; }
sub nominisexemplaria
{
	my $self = shift;
	return {
		'aircel' => [
			# Aircel; http://www.aircel.com/, phone-number@aircel.co.in
			qr{\Aaircel[.]co[.]in\z},
		],
		'airtel' => [
			# Bharti Airtel; http://www.airtel.com/
			qr{\Aairtel(?:ap|chennai|kerela|kk|kol|mail|)[.]com\z}, 
		],
		'ideacellular' => [
			# !DEA; http://ideacellular.net:80/IDEA.portal
			qr{\Aideacellular[.]net\z},
		],
		'loopmobile' => [
			# Loop Mobile (Formerly BPL Mobile); http://www.loopmobile.in/
			qr{\Abplmobile[.]com\z},
		],
	};
}

sub classisnomina
{
	my $class = shift;
	return {
		'aircel'	=> 'Generic',
		'airtel'	=> 'Generic',
		'ideacellular'	=> 'Generic',
		'loopmobile'	=> 'Generic',
	};
}

1;
__END__
