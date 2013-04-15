# $Id: SystemFull.pm,v 1.7.2.1 2013/04/15 04:20:53 ak Exp $
# -Id: SystemFull.pm,v 1.1 2009/08/29 07:33:28 ak Exp -
# -Id: SystemFull.pm,v 1.1 2009/05/04 05:17:05 ak Exp -
# Copyright (C) 2009,2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Why::
                                                                    
  #####                 ##                ######        ###  ###    
 ###    ##  ##  ##### ###### ####  ##  ## ##     ##  ##  ##   ##    
  ###   ##  ## ##       ##  ##  ## ###### ####   ##  ##  ##   ##    
   ###  ##  ##  ####    ##  ###### ###### ##     ##  ##  ##   ##    
    ###  #####     ##   ##  ##     ##  ## ##     ##  ##  ##   ##    
 #####     ##  #####     ### ####  ##  ## ##      ##### #### ####   
        ####                                                        
package Kanadzuchi::Mail::Why::SystemFull;
use base 'Kanadzuchi::Mail::Why';

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Regular expressions of 'Mail system full'
sub exemplaria
{
	my $class = shift;
	return [
		qr{mail system full},
		qr{requested mail action aborted: exceeded storage allocation}, # MS Exchange
	];
}

1;
__END__
