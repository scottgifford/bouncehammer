# $Id: WebMail.pm,v 1.4.2.3 2013/04/17 04:55:29 ak Exp $
# Copyright (C) 2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Mail::Group::AU::
                                                   
 ##  ##         ##     ##  ##           ##  ###    
 ##  ##   ####  ##     ######   ####         ##    
 ##  ##  ##  ## #####  ######      ##  ###   ##    
 ######  ###### ##  ## ##  ##   #####   ##   ##    
 ######  ##     ##  ## ##  ##  ##  ##   ##   ##    
 ##  ##   ####  #####  ##  ##   #####  #### ####   
package Kanadzuchi::Mail::Group::AU::WebMail;
use base 'Kanadzuchi::Mail::Group';
use strict;
use warnings;

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Major company's Webmail domains in Australia
sub nominisexemplaria
{
	my $class = shift;
	return {
		'aussiemail' => [
			# Aussiemail; http://www.aussiemail.com.au/
			qr{\Aaussiemail[.]com[.]au\z},
		],
		'fastmail' => [
			# FastMail http://fastmail.fm/
			qr{\Afastmail[.](?:cn|es|fm|im|in|jp|mx|net|nl|se|to|tw|us|co[.]uk|com[.]au)\z},
			qr{\A(?:123|elite|imap|speedy)mail[.]org\z},
			qr{\A(?:fast-|internet-)mail[.]org\z},
			qr{\A(?:150|16|50|clue|theinternete|xs|myfast|mymac|opera)mail[.]com\z},
			qr{\A(?:2|imap|internet-e|ssl|swift|your)[-]mail[.]com\z},
			qr{\A(?:150|pet)ml[.]com\z},
			qr{\A(?:4|jet|just|real)email[.]net\z},
			qr{\A(?:hail|nospam|own|warp|yep|all)mail[.]net\z},
			qr{\A(?:best|faste|h-)mail[.]us\z},
			qr{\A(?:post|pro)inbox[.]com\z},
			qr{\Aemail(?:corner|engine|groups|user)[.]net\z},
			qr{\Aemail(?:engine|plus)[.]org\z},
			qr{\A(?:eml|fastest|imap)[.]cc\z},
			qr{\A(?:fea|mm)[.]st\z},
			qr{\Afast(?:[-]email|em|emailer|imap|messaging)[.]com\z},
			qr{\Amail-(?:central|page)[.]com\z},
			qr{\Amail(?:andftp|as|bolt|can|ftp|haven|ite|might|new)[.]ocm\z},
			qr{\Amail(?:c|force|sent|up)[.]net\z},
			qr{\Amail(?:ingaddress|works)[.]org\z},
			qr{\Ainternet(?:emails|mailing)[.]net\z},
			qr{\Asent[.](?:as|at|com)\z},
			qr{\Athe-(?:fastest[.]net|quickest[.]com)\z},
			qr{\Avery(?:fast[.]biz|speedy[.]net)\z},
			qr{\Areallyfast(?:biz|info)\z},
			qr{\A(?:air|speed)post[.]net\z},
			qr{\A(?:inoutbox|fmailbox|fmgirl|fmguy|promessage|rushpost)[.]com\z},
			qr{\A(?:fastmailbox|ml1|postpro|ftml)[.]net\z},
			qr{\Afmail[.]co[.]uk\z},
			qr{\Af-m[.]fm\z},
			qr{\Amailservice[.]ms\z},
			qr{\Aletterboxes[.]org\z},
		],
	};
}

sub classisnomina
{
	my $class = shift;
	return {
		'aussiemail'	=> 'Generic',
		'fastmail'	=> 'Generic',
	};
}

1;
__END__
