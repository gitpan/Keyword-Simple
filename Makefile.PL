use strict;
use warnings;
use ExtUtils::MakeMaker;

sub merge_key_into {
	my ($href, $target, $source) = @_;
	%{$href->{$target}} = (%{$href->{$target}}, %{delete $href->{$source}});
}

my %opt = (
	NAME          => 'Keyword::Simple',
	AUTHOR        => q{Lukas Mai <l.mai@web.de>},
	VERSION_FROM  => 'lib/Keyword/Simple.pm',
	ABSTRACT_FROM => 'lib/Keyword/Simple.pm',

	LICENSE => 'perl',
	PL_FILES => {},

	MIN_PERL_VERSION => '5.12.0',
	CONFIGURE_REQUIRES => {
		'strict' => 0,
		'warnings' => 0,
		'ExtUtils::MakeMaker' => '6.48',
	},
	BUILD_REQUIRES => {},
	TEST_REQUIRES => {
		'strict' => 0,
		'Dir::Self' => 0,
		'Test::More' => 0,
	},
	PREREQ_PM => {
		'Carp' => 0,
		'XSLoader' => 0,
		'warnings' => 0,
		'B::Hooks::EndOfScope' => 0,
	},

	depend => { Makefile => '$(VERSION_FROM)' },
	dist   => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
	clean  => { FILES    => 'Keyword-Simple-*' },

	META_MERGE => {
		'meta-spec' => { version => 2 },
		resources => {
			repository => {
				url => 'git://github.com/mauke/Keyword-Simple',
				web => 'https://github.com/mauke/Keyword-Simple',
				type => 'git',
			},
		},
	},
);

(my $mm_version = ExtUtils::MakeMaker->VERSION($opt{CONFIGURE_REQUIRES}{'ExtUtils::MakeMaker'})) =~ tr/_//d;

if ($mm_version < 6.67_04) {
	# Why? For the glory of satan, of course!
	no warnings qw(redefine);
	*ExtUtils::MM_Any::_add_requirements_to_meta_v1_4 = \&ExtUtils::MM_Any::_add_requirements_to_meta_v2;
}

if ($mm_version < 6.63_03) {
	merge_key_into \%opt, 'BUILD_REQUIRES', 'TEST_REQUIRES';
}

if ($mm_version < 6.55_01) {
	merge_key_into \%opt, 'CONFIGURE_REQUIRES', 'BUILD_REQUIRES';
}

if ($mm_version < 6.51_03) {
	merge_key_into \%opt, 'PREREQ_PM', 'CONFIGURE_REQUIRES';
}

WriteMakefile %opt;
