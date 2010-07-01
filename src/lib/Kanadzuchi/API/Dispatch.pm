# $Id: Dispatch.pm,v 1.4 2010/06/25 19:35:30 ak Exp $
# -Id: Index.pm,v 1.1 2009/08/29 09:30:33 ak Exp -
# -Id: Index.pm,v 1.3 2009/08/13 07:13:57 ak Exp -
# Copyright (C) 2009,2010 Cubicroot Co. Ltd.
# Kanadzuchi::API::
                                                     
 ####     ##                       ##        ##      
 ## ##         ##### #####  #### ###### #### ##      
 ##  ##  ###  ##     ##  ##    ##  ##  ##    #####   
 ##  ##   ##   ####  ##  ## #####  ##  ##    ##  ##  
 ## ##    ##      ## ##### ##  ##  ##  ##    ##  ##  
 ####    #### #####  ##     #####   ### #### ##  ##  
                     ##                              
package Kanadzuchi::API::Dispatch;
use strict;
use warnings;
use base 'CGI::Application::Dispatch';

#  ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ 
# ||G |||l |||o |||b |||a |||l |||       |||v |||a |||r |||s ||
# ||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|
#
my $Settings = {
	'coreconfig'	=> '__KANADZUCHIETC__/bouncehammer.cf',
	'webconfig'	=> '__KANADZUCHIETC__/webui.cf',
};

#  ____ ____ ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ 
# ||D |||i |||s |||p |||a |||t |||c |||h |||       |||T |||a |||b |||l |||e ||
# ||__|||__|||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|
#
my $DispatchTables = [
	'empty'		=> { 'app' => 'API::HTTP', 'rm' => 'Empty' },
	'query/:token?' => { 'app' => 'API::HTTP', 'rm' => 'Select' },
	'select/:token?' => { 'app' => 'API::HTTP', 'rm' => 'Select' },
];

my $DispatchArgsToNew = {
	'TMPL_PATH' => [],
	'PARAMS' => {
		'cf' => $Settings->{'coreconfig'},
		'wf' => $Settings->{'webconfig'},
	},
};

#  ____ ____ ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||I |||n |||s |||t |||a |||n |||c |||e |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
sub dispatch_args
{
	# +-+-+-+-+-+-+-+-+-+-+-+-+-+
	# |d|i|s|p|a|t|c|h|_|a|r|g|s|
	# +-+-+-+-+-+-+-+-+-+-+-+-+-+
	# 
	# @Description	CGI::Application::Dispatch::dispatch_args()
	#
	return {
		'prefix' => 'Kanadzuchi',
		'default' => 'empty',
		'table'	=> $DispatchTables,
		'args_to_new' => $DispatchArgsToNew,
	};
}

1;
__END__
