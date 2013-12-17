#!/usr/bin/perl -wl
use strict;

use LWP::UserAgent;
use Image::Magick;
use POSIX qw(strftime);

my $url = 'http://static-maps.yandex.ru/1.x/?l=map,trf&ll=37.84%2C55.925&size=400%2C400&z=13';
my $browser = LWP::UserAgent->new();
my $image = Image::Magick->new();
my $timeout = 5 * 60;
my $steps = 7 * 24 * 60 * 60 / $timeout;
my $response;
my $i = 0;

while($i < $steps){
	$response = $browser->get($url);
	my $text = strftime "%Y-%m-%d %a %H:%M", localtime;
	if ($response->is_success) {
		$image->BlobToImage($response->content());
		$image->[$i]->Annotate(text => $text, gravity => 'SouthWest', x=>10, font => 'Helvetica', style => 'Oblique');
		#$image->[$i]->
	}

	sleep($timeout);
	$i++;
}

$image->Write('filename' => 'out.gif', delay => 100.0);

print "OK: gif is ready";
