# $Id: Smartphone.pm,v 1.1.2.8 2013/04/15 04:20:53 ak Exp $
# Copyright (C) 2009-2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Group::
                                                   
  #####                        ##          ##                           
 ###     ##  ##  ####  ##### ###### #####  ##      ####  #####   ####   
  ###    ######     ## ##  ##  ##   ##  ## #####  ##  ## ##  ## ##  ##  
   ###   ######  ##### ##      ##   ##  ## ##  ## ##  ## ##  ## ######  
    ###  ##  ## ##  ## ##      ##   #####  ##  ## ##  ## ##  ## ##      
 #####   ##  ##  ##### ##       ### ##     ##  ##  ####  ##  ##  ####   
                                    ##                                  
package Kanadzuchi::Mail::Group::Smartphone;
use base 'Kanadzuchi::Mail::Group';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Major smartphone provider's domains in The World
sub nominisexemplaria
{
	my $class = shift;
	return {
		'orange' => [
			# Orange; http://www.orange.com/
			qr{\Ablackberry[.]orange[.](?:ch|es|fr|md|pl|ro|sk)\z},
			qr{\Ablackberry[.]orange[.]co[.]uk\z},
			qr{\Aorange[.]?(?:at|bw|ci|cm|do|il|jo|ke|lu|re|sn|tn|uk)[.]blackberry[.]com\z},
			qr{\Aorange(?:armenia|madagascar|mali|niger)[.]blackberry[.]com\z},
		],
		'nokia' => [
			# Ovi by Nokia, http://www.ovi.com/
			# Nokia Mail, https://www.nokiamail.com/home
			qr{\A(?:ovi|nokiamail)[.]com\z},
		],
		'vertu' => [
			# Vertu.Me; http://www.vertu.me/
			qr{\Avertu[.]me\z},
		],
		'vodafone' => [
			# Vodafone; http://www.vodafone.com/
			qr{\A360[.]com\z},	# Vodafone 360, http://vodafone360.com/
			qr{\Amobileemail[.]vodafone[.]com[.](?:au|eg|fj|gh|hr|mk|mt|my|qa|tr)\z},
			qr{\Amobileemail[.]vodafone[.](?:al|at|bg|cd|cz|de|dk|es|fr|gg|gr|hu)\z},
			qr{\Amobileemail[.]vodafone[.](?:ie|in|is|it|je|lk|lt|lv|nl|pt|ro|se|si)\z},
			qr{\Amobileemail[.]vodafone[.]net\z},
			qr{\Amobileemail[.]vodafonesa[.]co[.]za\z},
		],
	};
}

sub classisnomina
{
	my $class = shift;
	return {
		'orange'	=> 'Generic',
		'nokia'		=> 'Generic',
		'vertu'		=> 'Generic',
		'vodafone'	=> 'Generic',
	};
}

1;
__END__
