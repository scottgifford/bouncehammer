# $Id: BdDR.pm,v 1.2.2.1 2013/04/15 04:20:53 ak Exp $
# Copyright (C) 2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::Statistics::Stored::
                              
 #####      ## ####   #####   
 ##  ##     ## ## ##  ##  ##  
 #####   ##### ##  ## ##  ##  
 ##  ## ##  ## ##  ## #####   
 ##  ## ##  ## ## ##  ## ##   
 #####   ##### ####   ##  ##  
package Kanadzuchi::Statistics::Stored::BdDR;
use base 'Kanadzuchi::Statistics::Stored';
use strict;
use warnings;
use Kanadzuchi::BdDR::BounceLogs;

#  ____ ____ ____ ____ ____ ____ ____ ____ ____ 
# ||A |||c |||c |||e |||s |||s |||o |||r |||s ||
# ||__|||__|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
__PACKAGE__->mk_accessors(
	'handle',	# (DBI::db) Database handle
);

#  ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||C |||l |||a |||s |||s |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
sub new
{
	# +-+-+-+
	# |n|e|w|
	# +-+-+-+
	#
	# @Description	Wrapper method of new()
	# @Param <ref>	(Ref->Hash)
	# @Return	(Kanadzuchi::Statistics::Stored::BdDR) Object
	my $class = shift;
	my $argvs = { @_ };

	# Default values
	$argvs->{'handle'} = undef unless ref($argvs->{'handle'}) eq 'DBI::db';
	return $class->SUPER::new( %$argvs );
}

#  ____ ____ ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||I |||n |||s |||t |||a |||n |||c |||e |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
sub congregat
{
	# +-+-+-+-+-+-+-+-+-+
	# |c|o|n|g|r|e|g|a|t|
	# +-+-+-+-+-+-+-+-+-+
	#
	# @Description	Count by each key of the table
	# @Param <str>	(String) Table name or alias
	# @Param <ref>	(Ref->Hash) WHERE Condition
	# @Return	(Ref->Hash)
	my $self = shift;
	my $name = shift || return undef;
	my $cond = shift || {};
	my $bddr = undef;

	return undef unless ref($self->{'handle'}) eq 'DBI::db';
	return undef if ref $name;
	return undef if( $cond && ref $cond ne q|HASH| );

	$cond = undef unless keys %$cond;
	$bddr = Kanadzuchi::BdDR::BounceLogs::Table->new( 'handle' => $self->{'handle'} );
	return $bddr->groupby( $name, $cond );
}

1;
__END__
