# $Id: SystemError.pm,v 1.1.2.2 2013/04/15 04:20:53 ak Exp $
# Copyright (C) 2009,2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Why::

  #####                  ##                ######                               
 ###     ##  ##  ##### ###### ####  ##  ## ##      #####  #####   ####  #####   
  ###    ##  ## ##       ##  ##  ## ###### ####    ##  ## ##  ## ##  ## ##  ##  
   ###   ##  ##  ####    ##  ###### ###### ##      ##     ##     ##  ## ##      
    ###   #####     ##   ##  ##     ##  ## ##      ##     ##     ##  ## ##      
 #####      ##  #####     ### ####  ##  ## ######  ##     ##      ####  ##      
         ####                                                                   
package Kanadzuchi::Mail::Why::SystemError;
use base 'Kanadzuchi::Mail::Why';

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Regular expressions of 'System Error'
sub exemplaria
{
	my $class = shift;
	return [
		qr{local error in processing},
		qr{mail system configuration error},
		qr{maximum forwarding loop count exceeded},
		qr{server configuration error},
		qr{system config error},
		qr{too many hops},
	];
}

1;
__END__
