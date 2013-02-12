#!/usr/bin/perl

my $section = 1;
my $subsection = 1;

open (OUTFILE, ">section-$section.html");
open (FH, "standard.htm");

sub copy_header
{
	open (HDR, "header.html");

	while ($hline = <HDR>)
	{
		print OUTFILE $hline;
	}
	close (HDR);
}

sub copy_footer
{
print OUTFILE "</body></html>";
}

while ($line = <FH>)
{

	if ( ($line =~ /<h1/) or ($line =~ /class=Appendix/))
	{
		copy_footer();
		close (OUTFILE);
		$section++;
		$subsection = 1;

		print "Opening section $section:$subsection\n";
		open (OUTFILE, ">section-$section-$subsection.html");
		copy_header();
	}

	if (($line =~ /<h2/) or ($line =~ /class=appendix2/))
	{
		copy_footer();
		close (OUTFILE);
		$subsection++;
		print "Opening section $section:$subsection\n";
		open (OUTFILE, ">section-$section-$subsection.html");
		copy_header();
	}

	print OUTFILE $line;
}

close (FH);
close (OUTFILE);
