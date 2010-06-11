# $Id: Why.pm,v 1.6 2010/06/10 10:03:13 ak Exp $
# -Id: Pattern.pm,v 1.1 2009/08/29 07:33:13 ak Exp -
# -Id: Pattern.pm,v 1.3 2009/05/29 08:22:25 ak Exp -
# Copyright (C) 2009,2010 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::
                       
 ##  ## ##             
 ##  ## ##     ##  ##  
 ##  ## #####  ##  ##  
 ###### ##  ## ##  ##  
 ###### ##  ##  #####  
 ##  ## ##  ##    ##   
               ####    
package Kanadzuchi::Mail::Why;

#  ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ 
# ||G |||l |||o |||b |||a |||l |||       |||v |||a |||r |||s ||
# ||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|
#
# Regular expressions
#  * $Patterns is defined at Why/*.pm files.
#  * http://help.yahoo.co.jp/help/jp/mail/in_trouble/in_trouble-27.html
my $Patterns = [];

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
sub is_included
{
	#+-+-+-+-+-+-+-+-+-+-+-+
	#|i|s|_|i|n|c|l|u|d|e|d|
	#+-+-+-+-+-+-+-+-+-+-+-+
	#
	# @Description	The argument string includes the pattern or not
	# @Param <str>	(String)
	# @Return	(Integer) 1 = includes
	# @Return	(Integer) 0 = not
	my $class = shift();
	my $dtext = shift() || return(0);
	my $plist = ${"$class".'::Patterns'};

	foreach my $p ( @$plist ){ return(1) if( lc($dtext) =~ $p ); }
	return(0);
}

1;
__END__
