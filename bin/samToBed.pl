#!/usr/bin/env perl

#Written by Justin Chu 2017
#generate a bedfile given sam file format

use strict;
use warnings;

my %chrlengths;
my %bandStr;

while (<>) {
	my @line = split( /\t/, $_ );
	print $line[2] . "\t"
	  . ( $line[3] - 1 ) . "\t"
	  . ( $line[3] - 1 + getPaddedReferenceLength( $line[5] ) ) . "\t"
	  . $line[0] . "\t"
	  . $line[4] . "\t";
	if ($line[1] & 0x10 == 0x10) {
		print "-";
	}
	else {
		print "+";
	}
	print "\t"
	  . getStartQueryAlignment( $line[5] ) . "\t"
	  . (getStartQueryAlignment($line[5]) +
	  getPaddedQueryLength( $line[5] ));
	print "\n";
}

#parse from cigar string
sub getPaddedReferenceLength {
	my $cigar    = shift;
	my $length   = 0;
	my @elements = ( $cigar =~ /(\d+)(?:M|D|N|=|X)/g );
	for my $value (@elements) {
		$length += $value;
	}
	return $length;
}

#parse from cigar string
sub getPaddedQueryLength {
	my $cigar    = shift;
	my $length   = 0;
	my @elements = ( $cigar =~ /(\d+)(?:M|I|=|X|P)/g );
	for my $value (@elements) {
		$length += $value;
	}
	return $length;
}

#get start of read alignment
sub getStartQueryAlignment {
	my $cigar = shift;
	if ( $cigar =~ /^(\d+)(?:S|G)/ ) {
		return $1 - 1;
	}
	return 0;
}

