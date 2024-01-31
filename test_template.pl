
use strict;
use warnings;
use FindBin qw($RealBin);


BEGIN {
  push @INC, $RealBin;
};

use Text::Template;

my $template = Text::Template->new("./template.html", {
  page_title => 'Templating with Perl!',
  first_name => 'Depeche',
  last_name => 'Mode',
  users => [
    {
      id => 1,
      name => "Lilian",
      email => 'lilian@whathaveyoudone.com'
    }
  ],
  contacts => [
    {
      id => 1,
      name => "Marta",
      number => '(77) 99132-2333'
    },
    {
      id => 2,
      name => "Jose",
      number => '(77) 12122-2555'
    }
  ]
});

print $template->render;
