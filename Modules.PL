# $Id: Modules.PL,v 1.22.2.2 2013/04/16 09:08:26 ak Exp $
# -Id: PERL-MODULES.PL,v 1.1 2009/08/29 07:32:08 ak Exp -
# -Id: PERL-MODULES,v 1.6 2009/08/12 01:57:35 ak Exp -
# Copyright (C) 2009,2010-2013 Cubicroot Co. Ltd.
use strict;
use warnings;

my $Command = lc($ARGV[0]) || q();
my $Dependencies = {
	# 'Engine' => { 'Module name' => [ version, core module, license ] },
	'Kanadzuchi' => {
		'Class::Accessor::Fast::XS' => [ 0.03, 0, 'Perl' ],
		'Compress::Zlib'	=> [ 2.023, 5.009003, 'Perl' ],
		'Crypt::CBC'		=> [ 2.30, 0, 'Unknown' ],
		'Crypt::DES'		=> [ 1.00, 0, 'Unknown' ],
		'DBIx::Skinny'		=> [ 0.0711, 0, 'Perl' ],
		'Digest::MD5'		=> [ 2.27, 5.007003, 'Perl' ],
		'Email::AddressParser'	=> [ 0.04, 0, 'Apache' ],
		'Errno'			=> [ 1.0, 5.00504, 'Perl' ],
		'Error'			=> [ 0.17015, 0, 'Perl' ],
		'File::Copy'		=> [ 2.06, 5.002, 'Perl' ],
		'File::Spec'		=> [ 0.86, 5.00405, 'Unknown' ],
		# Optional 'IO::Compress::Bzip2'	=> [ 2.023, 5.010001, 'Perl' ],
		'IO::Compress::Gzip'	=> [ 2.023, 5.009004, 'Perl' ],
		# Optional 'IO::Compress::Zip'	=> [ 2.023, 5.009004, 'Perl' ],
		'IO::File'		=> [ 1.20, 5.00307, 'Perl' ],
		'JSON::Syck'		=> [ 0.30, 0, 'MIT' ],
		'List::Util'		=> [ 1.13, 5.007003, 'Perl' ],
		'Path::Class'		=> [ 0.17, 0, 'Perl' ],
		'Perl6::Slurp'		=> [ 0.03, 0, 'Unknown' ],
		'Term::ProgressBar'	=> [ 2.09, 0, 'Perl' ],
		'Text::ASCIITable'	=> [ 0.18, 0, 'Perl' ],
		'Time::Piece'		=> [ 1.20, 5.009005, 'Unknown' ],
	},
	'UI::CLI' => {
		'Carp'			=> [ 1.01, 5.000000, 'Perl' ],
		'File::Basename'	=> [ 2.72, 5.000000, 'Perl' ],
		'File::stat'		=> [ 0.01, 5.004000, 'Unknown' ],
		'Getopt::Long'		=> [ 2.34, 5.000000, 'Unknown' ],
		'Path::Class::File::Lockable'	=> [ 0.01, 0, 'Unknown' ],
	},
	'UI::Web' => {
		'CGI::Application::Plugin::HTMLPrototype' => [ 0.20, 0, 'Perl' ],
		'CGI::Application::Plugin::Session'	=> [ 1.03, 0, 'Perl' ],
		'CGI::Application::Plugin::TT'		=> [ 1.04, 0, 'Perl' ],
		'CGI::Application::Dispatch'		=> [ 2.16, 0, 'Unknown' ],
		'CGI::Application'			=> [ 4.21, 0, 'Perl' ],
	},
	'Test' => {
		# Optional 'IPC::Cmd'	=> [ 0.25, 5.009005, 'Unknown' ],
		'Test::More'	=> [ 0.80, 5.006002, 'Perl' ],
	},
};

sub modules
{
	my $modules = undef;
	my $reqtype = shift || 'key';

	if( $reqtype eq 'key' )
	{
		$modules = [];
		push @$modules, keys( %{$Dependencies->{'Kanadzuchi'}} );
		push @$modules, keys( %{$Dependencies->{'UI::CLI'}} );
		push @$modules, keys( %{$Dependencies->{'UI::Web'}} );
		push @$modules, keys( %{$Dependencies->{'Test'}} );
		return($modules);
	}
	elsif( $reqtype eq 'hash' )
	{
		$modules = { 
			%{$Dependencies->{'Kanadzuchi'}},
			%{$Dependencies->{'UI::CLI'}},
			%{$Dependencies->{'UI::Web'}},
			%{$Dependencies->{'Test'}},
		};
		return $modules;
	}
}

sub list
{
	my $argv = shift || q();
	foreach my $m ( @{ modules() } )
	{
		next if( $argv eq 'no-webui' && $m =~ m{\ACGI::} );
		print $m."\n";
	}
}

sub check
{
	no strict 'refs';
	my $argv = shift || q();
	my $hash = modules('hash');
	my $path = q();
	my $vers = q();
	my $none = [];
	my $oldv = [];
	my $ver0 = 0;
	my $ver1 = undef;
	my $ver2 = undef;
	my $head = { 
		'installed' => ' [ OK ]',
		'missing' => '*[ NG ]',
		'warning' => '*[WARN]',
	};

	eval {
		require version;
	};
	$ver0 = 1 unless $@;

	foreach my $m ( keys %$hash )
	{
		$path =  $m;
		$path =~ s{::}{/}g;
		$path .= '.pm';

		eval { require "$path"; };
		if( $@ )
		{
			next if $argv eq 'installed';
			push @$none, $m;
			printf( STDOUT "%s %s\n", $head->{'missing'}, $m );
		}
		else
		{
			next if $argv eq 'missing';
			$vers =  ${ $m.'::VERSION' } || 0;
			$vers =~ y{_}{}d;

			if( $ver0 )
			{
				$ver1 = version->new( 'v'.$hash->{ $m }->[0] );
				$ver2 = version->new( 'v'.$vers );

				if( $ver1 && $ver2 && ( $ver2->numify < $ver1->numify ) )
				{
					push @$oldv, $m;
					printf(STDOUT "%s %s VERSION = %s is older than %s\n",
						$head->{'warning'}, $m, $ver2->stringify, $ver1->stringify );
				}
				else
				{
					printf(STDOUT "%s %s VERSION = %s\n",$head->{'installed'}, $m, $ver2 );
				}
			}
			else
			{
				if( $hash->{ $m }->[0] && $vers && ( $vers < $hash->{ $m }->[0] ) )
				{
					push @$oldv, $m;
					printf(STDOUT "%s %s VERSION = %s is older than %s\n",
						$head->{'warning'}, $m, $vers, $hash->{ $m }->[0] );
				}
				else
				{
					printf(STDOUT "%s %s VERSION = %s\n",$head->{'installed'}, $m, $vers );
				}
			}
		}
	}
	exit 1 if( scalar @$none && $argv ne 'installed' );
	exit 2 if( scalar @$oldv && $argv ne 'missing' );
	exit 0;
}

if( $Command eq 'list' )
{
	list();
}
elsif( $Command eq 'list-no-webui' )
{
	list('no-webui');
}
elsif( $Command eq 'check' )
{
	check();
}
elsif( $Command eq 'installed' || $Command eq 'missing' )
{
	check($Command);
}
else
{
	printf( STDERR "Usage: perl %s (list|list-no-webui|check|installed|missing)\n", $0 );
}

__END__
