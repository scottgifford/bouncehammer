# $Id: Search.pm,v 1.32.2.3 2013/04/15 04:20:53 ak Exp $
# -Id: Search.pm,v 1.1 2009/08/29 09:30:33 ak Exp -
# -Id: Search.pm,v 1.11 2009/08/13 07:13:58 ak Exp -
# Copyright (C) 2009,2010,2013 Cubicroot Co. Ltd.
# Kanadzuchi::UI::Web::
                                           
  #####                            ##      
 ###      ####  ####  #####   #### ##      
  ###    ##  ##    ## ##  ## ##    #####   
   ###   ###### ##### ##     ##    ##  ##  
    ###  ##    ##  ## ##     ##    ##  ##  
 #####    ####  ##### ##      #### ##  ##  
package Kanadzuchi::UI::Web::Search;

#  ____ ____ ____ ____ ____ ____ ____ ____ ____ 
# ||L |||i |||b |||r |||a |||r |||i |||e |||s ||
# ||__|||__|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
use strict;
use warnings;
use base 'Kanadzuchi::UI::Web';

#  ____ ____ ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
# ||I |||n |||s |||t |||a |||n |||c |||e |||       |||M |||e |||t |||h |||o |||d |||s ||
# ||__|||__|||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
sub putsearchform
{
	# +-+-+-+-+-+-+-+-+-+-+-+-+-+
	# |p|u|t|s|e|a|r|c|h|f|o|r|m|
	# +-+-+-+-+-+-+-+-+-+-+-+-+-+
	#
	# @Description	Search form
	# @Param	<None>
	# @Return
	my $self = shift;
	my $file = 'startsearch.html';
	return $self->tt_process($file);
}

sub onlinesearch
{
	# +-+-+-+-+-+-+-+-+-+-+-+-+
	# |o|n|l|i|n|e|s|e|a|r|c|h|
	# +-+-+-+-+-+-+-+-+-+-+-+-+
	#
	# @Description	Send query and receive results
	# @Param	<None>
	# @Return
	my $self = shift;
	my $bddr = $self->{'database'};
	my $tmpl = 'search.html';

	require Kanadzuchi::Mail::Stored::BdDR;
	require Kanadzuchi::BdDR::Page;
	require Kanadzuchi::BdDR::BounceLogs;
	require Kanadzuchi::Address;
	require Kanadzuchi::Time;
	require Kanadzuchi::Metadata;
	require Kanadzuchi::Crypt;

	my $wherecond = {};	# (Ref->Hash) WHERE Condition for sending query
	my $errorsinq = {};	# (Ref->Hash) Parameter errors in the query
	my $encrypted = q();	# (String) Encrypted condition in PAHT_INFO
	my $decrypted = q();	# (String) Decrypted condition(YAML)
	my $datformat = q();	# (String) File fotmat for downloading
	my $downloadx = 0;	# (Boolean) Flag; Download 
	my $advancedx = 0;	# (Boolean) Flag; Does advanced search use?
	my $dbrecords = 0;	# (Integer) The number of records in the db
	my $howrecent = -1;	# (Integer) How recent the mail bounced?
	my $frequency = 1;	# (Integer) Frequency
	my $paginated = new Kanadzuchi::BdDR::Page();
	my $bouncelog = new Kanadzuchi::BdDR::BounceLogs::Table('handle' => $bddr->handle());
	my $cgiqueryp = $self->query();
	my $readonlyx = $self->{'webconfig'}->{'database'}->{'table'}->{'bouncelogs'}->{'readonly'};
	my $ocryptcbc = new Kanadzuchi::Crypt(
				'key' => $self->{'webconfig'}->{'security'}->{'crypt'}->{'key'},
				'salt' => $self->{'webconfig'}->{'security'}->{'crypt'}->{'salt'},
				'cipher' => $self->{'webconfig'}->{'security'}->{'crypt'}->{'cipher'} );

	# Do not include a record that is disabled(=1)
	$wherecond->{'disabled'} = 0;

	if( $self->param('pi_condition') || $self->param('pi_recipient') )
	{
		#  _____ _   _  ____ ______   ______ _____ _____ ____  
		# | ____| \ | |/ ___|  _ \ \ / /  _ \_   _| ____|  _ \ 
		# |  _| |  \| | |   | |_) \ V /| |_) || | |  _| | | | |
		# | |___| |\  | |___|  _ < | | |  __/ | | | |___| |_| |
		# |_____|_| \_|\____|_| \_\|_| |_|    |_| |_____|____/ 
		# 
		# Check and decrypt the encrypted condition
		if( $self->param('pi_condition') )
		{
			$encrypted = $self->param('pi_condition');
			$advancedx++;
		}
		else
		{
			$encrypted = $self->param('pi_recipient');
		}

		$decrypted = $ocryptcbc->decryptit($encrypted);
		$wherecond = shift @{ Kanadzuchi::Metadata->to_object(\$decrypted) } || { 'disabled' => 0 };

		#   ___  ____  ____  _____ ____    ______   __
		#  / _ \|  _ \|  _ \| ____|  _ \  | __ ) \ / /
		# | | | | |_) | | | |  _| | |_) | |  _ \\ V / 
		# | |_| |  _ <| |_| | |___|  _ <  | |_) || |  
		#  \___/|_| \_\____/|_____|_| \_\ |____/ |_|  
		#                                             
		if( $self->param('pi_orderby') )
		{
			my $_name = q();
			my $_desc = 0;

			if( $self->param('pi_orderby') =~ m{\A(.+)[,]([01])\z} )
			{
				$_name = $1;
				$_desc = $2;
			}
			$paginated->colnameorderby( lc($_name) || 'id' );
			$paginated->descendorderby( $_desc ? 1 : 0 );
		}

		# Pagination
		$paginated->resultsperpage( $self->param('pi_rpp') || 10 );
		$paginated->set( $bouncelog->count( $wherecond ) );
		$paginated->skip( $self->param('pi_page') || 1 );

		# Downloading
		if( $ENV{'PATH_INFO'} =~ m{/download} )
		{
			$downloadx = 1;
			$datformat = lc($self->param('pi_format')) || 'yaml';
		}
	}
	else
	{
		#  ____   ___  ____ _____ _____ ____     ___  _   _ _____ ______   __
		# |  _ \ / _ \/ ___|_   _| ____|  _ \   / _ \| | | | ____|  _ \ \ / /
		# | |_) | | | \___ \ | | |  _| | | | | | | | | | | |  _| | |_) \ V / 
		# |  __/| |_| |___) || | | |___| |_| | | |_| | |_| | |___|  _ < | |  
		# |_|    \___/|____/ |_| |_____|____/   \__\_\\___/|_____|_| \_\|_|  
		#

		my $wcparams = {};			# (Ref->Hash) WHERE Condition
		my $validcnd = 0;			# (Boolean) Validation for WHERE Cond.
		my $rcptinqp = $cgiqueryp->param('fe_recipient') || q();

		# Make 'wherecond' hash reference
		if( length $rcptinqp )
		{
			# Pre-Process Recipient address
			$wcparams->{'recipient'} =  lc $rcptinqp;
			$wcparams->{'recipient'} =  Kanadzuchi::Address->canonify($wcparams->{'recipient'});
			$wherecond->{'recipient'} = $wcparams->{'recipient'} if length $wcparams->{'recipient'};
		}

		foreach my $s ( 'addresser', 'senderdomain', 'destination', 'token', 'provider' )
		{
			my $condinqp = $cgiqueryp->param('fe_'.$s) || q();
			next unless $condinqp;
			( $wcparams->{$s} = lc($condinqp) ) =~ y{;'" }{}d;
			next unless length($wcparams->{$s});

			$wherecond->{$s} = $wcparams->{$s};
			$advancedx++;
		}

		foreach my $w ( 'hostgroup', 'reason' )
		{
			my $condinqp = $cgiqueryp->param('fe_'.$w) || q();
			if( $condinqp ne '_' && $condinqp ne q() )
			{
				$wherecond->{$w} = $condinqp;
				$advancedx++;
			}
			else
			{
				$errorsinq->{$w} = 'Unselectable value';
			}
		}

		# How recent the record has been bounced
		if( $cgiqueryp->param('fe_howrecent') )
		{
			require Kanadzuchi::Time;
			$wherecond->{'bounced'} = 
				Kanadzuchi::Time->to_second($cgiqueryp->param('fe_howrecent'));
			$howrecent = int( time - $wherecond->{'bounced'} );

			if( $wherecond->{'bounced'} > 0 && $wherecond->{'bounced'} < time )
			{
				$wherecond->{'bounced'} = { '>=' => int( time - $wherecond->{'bounced'} ) };
			}
			else
			{
				$wherecond->{'bounced'} = { '>=' => 0 };
			}
		}

		# Frequency
		if( $cgiqueryp->param('fe_frequency') )
		{
			$frequency = $cgiqueryp->param('fe_frequency');
			if( $frequency > 1 )
			{
				$wherecond->{'frequency'} = { '>=' => $frequency };
				$advancedx++;
			}
		}

		# Pagination, ORDER BY
		$paginated->resultsperpage( $cgiqueryp->param('fe_resultsperpage') || 10 );
		$paginated->set( $bouncelog->count( $wherecond ) );
		$paginated->skip( $cgiqueryp->param('fe_thenextpagenum') || 1 );
		$paginated->colnameorderby( lc($cgiqueryp->param('fe_orderby')) || 'id' );
		$paginated->descendorderby( $cgiqueryp->param('fe_descend') ? 1 : 0 );

		# Crypt
		$decrypted = Kanadzuchi::Metadata->to_string($wherecond);
		$encrypted = $ocryptcbc->encryptit($decrypted);

		# Downloading
		$downloadx = $cgiqueryp->param('fe_enabledownload') ? 1 : 0;
		$datformat = $cgiqueryp->param('fe_downloadformat') || 'yaml';
	}

	if( $downloadx )
	{
		#      __    _____ ___ _     _____ 
		#      \ \  |  ___|_ _| |   | ____|
		#  _____\ \ | |_   | || |   |  _|  
		# |_____/ / |  _|  | || |___| |___ 
		#      /_/  |_|   |___|_____|_____|
		#                                  
		require Kanadzuchi::Log;
		require File::Spec;
		require Path::Class;
		require Digest::MD5;
		require Perl6::Slurp;

		my $cgiqueryp = $self->query();
		my $sysconfig = $self->{'sysconfig'};
		my $webconfig = $self->{'webconfig'};
		my $rdbconfig = $self->{'sysconfig'}->{'database'};

		#  _____ ___  ____  __  __    _  _____ 
		# |  ___/ _ \|  _ \|  \/  |  / \|_   _|
		# | |_ | | | | |_) | |\/| | / _ \ | |  
		# |  _|| |_| |  _ <| |  | |/ ___ \| |  
		# |_|   \___/|_| \_\_|  |_/_/   \_\_|  
		#                                      
		use Kanadzuchi::Archive;
		my $archivecn = q|Kanadzuchi::Archive::|;
		my $zipformat = $cgiqueryp->param('fe_compress')
				|| $webconfig->{'archive'}->{'compress'}->{'type'}
				|| Kanadzuchi::Archive->ARCHIVEFORMAT();

		if( $zipformat eq 'gzip' )
		{
			require Kanadzuchi::Archive::Gzip;
			$archivecn = q|Kanadzuchi::Archive::Gzip|;
		}
		elsif( $zipformat eq 'bzip2' )
		{
			require Kanadzuchi::Archive::Bzip2;
			$archivecn = q|Kanadzuchi::Archive::Bzip2|;
		}
		elsif( $zipformat eq 'zip' )
		{
			require Kanadzuchi::Archive::Zip;
			$archivecn = q|Kanadzuchi::Archive::Zip|;
		}

		#  ___ _   _ ____  _   _ _____ 
		# |_ _| \ | |  _ \| | | |_   _|
		#  | ||  \| | |_) | | | | | |  
		#  | || |\  |  __/| |_| | | |  
		# |___|_| \_|_|    \___/  |_|  
		#                              
		# Decide cache directory
		my $inputfile = undef;		# Input file name
		my $md5digest = undef;		# Digest::MD5 Object
		my $txtprefix = undef;		# Prefix of the text file
		my $cacheddir = -w $sysconfig->{'directory'}->{'cache'}
					? $sysconfig->{'directory'}->{'cache'}
					: File::Spec::tmpdir();

		# Prepare empty file(Prefix)
		$txtprefix = $datformat eq 'asciitable' ? 'txt' : $datformat;

		# Decide source file name
		$md5digest = Digest::MD5->new();
		$md5digest->add( $rdbconfig->{'hostname'}, $rdbconfig->{'port'}, 
				 $rdbconfig->{'dbtype'}, $rdbconfig->{'dbname'} );
		$md5digest->add( $txtprefix, $decrypted );
		$inputfile = $md5digest->hexdigest().'.'.$txtprefix;

		#   ___  _   _ _____ ____  _   _ _____ 
		#  / _ \| | | |_   _|  _ \| | | |_   _|
		# | | | | | | | | | | |_) | | | | | |  
		# | |_| | |_| | | | |  __/| |_| | | |  
		#  \___/ \___/  |_| |_|    \___/  |_|  
		#                                      
		my $basefname = lc($sysconfig->{'system'}).'.'.$self->{'datetime'}->ymd('-');
		my $cachename = $cacheddir.'/'.$inputfile;
		my $zippedobj = $archivecn->new( 
					'input' => $cachename,
					'output' => $cachename,
					'filename' => $basefname.q{.}.$txtprefix,
					'override' => 1 );
		undef $md5digest;
		undef $cacheddir;
		undef $inputfile;
		undef $basefname;
		undef $cachename;

		CREATE_FILE: {
			#  ____  _   _ __  __ ____        __  
			# |  _ \| | | |  \/  |  _ \       \ \ 
			# | | | | | | | |\/| | |_) |  _____\ \
			# | |_| | |_| | |  | |  __/  |_____/ /
			# |____/ \___/|_|  |_|_|          /_/ 
			#                                     
			require File::Copy;

			if( -e $zippedobj->output() )
			{
				# Is there a cache file?
				my $expires = Kanadzuchi::Time->to_second($webconfig->{'archive'}->{'expires'}) || 3600;
				my $zipsize = $zippedobj->output->stat->size();
				my $ziptime = $zippedobj->output->stat->mtime();
				my $zipdist = q();

				# Use and download the cache file
				if( $zipsize && ( $self->{'datetime'}->epoch() < ( $ziptime + $expires ) ))
				{
					$zipdist = $zippedobj->output->dir().'/'.$zippedobj->filename();
					File::Copy::copy( $zippedobj->output(), $zipdist );
					$zippedobj->output( new Path::Class::File($zipdist) );
					last;
				}

				# Remove old cache file
				eval { $zippedobj->output->remove(); };
			}

			SEARCH_AND_NEW: {

				my $iteratorr = undef;	# (Kanadzuchi::Iterator) Iterator object
				my $kanazcilg = undef;	# (Kanadzuchi::Log) Logger object
				my $tempstack = [];	# (Ref->Array) Retrieved objects

				# Pagination, ORDER BY, Create archive file
				$paginated->skip(1);
				$paginated->resultsperpage(1000);
				$paginated->colnameorderby( lc $cgiqueryp->param('fe_orderby') || 'id' );
				$paginated->descendorderby( $cgiqueryp->param('fe_descend') ? 1 : 0 );
				$zippedobj->input->touch();

				while(1)
				{
					# Send query and receive results
					$iteratorr = Kanadzuchi::Mail::Stored::BdDR->searchandnew(
								$bddr->handle(), $wherecond, $paginated );
					last unless $iteratorr->count();

					while( my $obj = $iteratorr->next() )
					{
						push @$tempstack, $obj;
					}

					$kanazcilg = new Kanadzuchi::Log( 
								'count'	=> scalar(@$tempstack),
								'entities' => $tempstack,
								'device' => $zippedobj->input->openw(),
								'format' => $datformat, );

					$kanazcilg->header(0);
					$kanazcilg->header(1) if $paginated->currentpagenum == 1;
					$kanazcilg->dumper();

					last unless $paginated->hasnext();
					$paginated->next();

				}

			} # End of the block(SEARCH_AND_NEW)

			return('No data') unless $zippedobj->input->stat->size();

			#   ____ ___  __  __ ____  ____  _____ ____ ____        __  
			#  / ___/ _ \|  \/  |  _ \|  _ \| ____/ ___/ ___|       \ \ 
			# | |  | | | | |\/| | |_) | |_) |  _| \___ \___ \   _____\ \
			# | |__| |_| | |  | |  __/|  _ <| |___ ___) |__) | |_____/ /
			#  \____\___/|_|  |_|_|   |_| \_\_____|____/____/       /_/ 
			#                                                           
			# Compress, and create archive file
			my $txtfilename = $zippedobj->output->dir().'/'.$zippedobj->filename();
			my $zipfilename = $txtfilename.'.'.$zippedobj->prefix();

			File::Copy::copy( $zippedobj->input(), $txtfilename );
			File::Copy::copy( $zippedobj->output(), $zipfilename );

			$zippedobj->input( new Path::Class::File($txtfilename) );
			$zippedobj->output( new Path::Class::File($zipfilename) );
			$zippedobj->cleanup(1);
			$zippedobj->override(1);
			$zippedobj->compress();
			last;

		} # End of the block(CREATE_FILE)

		# Set size of the archive file
		return 'Failed to create zip file' unless $zippedobj->output->stat->size();

		#  ____   _____        ___   _ _     ___    _    ____        __  
		# |  _ \ / _ \ \      / / \ | | |   / _ \  / \  |  _ \       \ \ 
		# | | | | | | \ \ /\ / /|  \| | |  | | | |/ _ \ | | | |  _____\ \
		# | |_| | |_| |\ V  V / | |\  | |__| |_| / ___ \| |_| | |_____/ /
		# |____/ \___/  \_/\_/  |_| \_|_____\___/_/   \_\____/       /_/ 
		#                                                                
		# eval { $_textfile->path->remove(); };
		$self->header_props(
			'-type' => q(application/octet-stream),
			'-content-disposition' => q(attachment;filename=).$zippedobj->output->basename(),
			'-content-length' => $zippedobj->output->stat->size(),
		);
		return Perl6::Slurp::slurp( $zippedobj->output->stringify() );
	}
	else
	{
		#      __    _   _ _____ __  __ _     
		#      \ \  | | | |_   _|  \/  | |    
		#  _____\ \ | |_| | | | | |\/| | |    
		# |_____/ / |  _  | | | | |  | | |___ 
		#      /_/  |_| |_| |_| |_|  |_|_____|
		#                                     
		# Send query and receive results
		my $logrecord = [];
		my $iteratorr = Kanadzuchi::Mail::Stored::BdDR->searchandnew(
					$bddr->handle(), $wherecond, $paginated );

		while( my $o = $iteratorr->next() )
		{
			my $damnedobj = $o->damn();
			$damnedobj->{'updated'}  =
				$o->updated->ymd().'('.$o->updated->wdayname().') '.$o->updated->hms();
			$damnedobj->{'bounced'}  =
				$o->bounced->ymd().'('.$o->bounced->wdayname().') '.$o->bounced->hms();
			$damnedobj->{'bounced'} .=
				' '.$o->timezoneoffset() if $o->timezoneoffset();
			push @$logrecord, $damnedobj;
		}

		# Build date string in where condition
		if( $howrecent > 0 )
		{
			my $tp = Time::Piece->new( $howrecent );
			warn $tp->epoch;
			warn $tp->cdate;
			$wherecond->{'bounced'}->{'sign'} = '>=';
			$wherecond->{'bounced'}->{'date'} = $tp->ymd().'('.$tp->wdayname().') '.$tp->hms();
		}

		if( $frequency > 1 )
		{
			$wherecond->{'frequency'}->{'sign'} = '>=';
			$wherecond->{'frequency'}->{'freq'} = $frequency;
		}

		$self->tt_params( 
			'pv_bouncemessages' => $logrecord,
			'pv_contentsname' => 'search',
			'pv_hascondition' => $advancedx,
			'pv_searchcondition' => $wherecond,
			'pv_encryptedforuri' => $encrypted,
			'pv_isreadonly' => $readonlyx,
			'pv_pagination' => $paginated,
			'pv_errorsinq' => $errorsinq );
		return $self->tt_process($tmpl);
	}
}

1;
__END__
