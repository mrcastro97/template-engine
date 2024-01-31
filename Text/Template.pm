package Text::Template;
use Data::Dumper;

sub new {
  my ($class, $filename, $params) = @_;

  my $self = {
    filename => $filename,
    params => $params
  };

  bless $self, $class;

  return $self;
}

sub render {
  my ($self) = @_;

  open my $fh, '<', $self->{filename};
  read $fh, my $template, -s $fh;
  close $fh;

  my @variables = $template =~ /(\{\{ \$[\w]+ \}\})/ig;

  foreach my $var (@variables) {
    my ($var_name) = $var =~ /\$([\w]+)/ig;
    my $var_value = $self->{params}->{$var_name};
    $template =~ s/(\{\{ \$[$var_name]+ \}\})/$var_value/ig;
  }

  my @loops = $template =~ /\{\{ #forEach \$[\w]+ \}\}[\w\s\-\n\r\t\<\>\/\{\}]+\{\{ #end \}\}/ig;

  foreach my $loop (@loops) {
    my ($var_name, $content) = $loop =~ /\{\{ #forEach \$([\w]+) \}\}([\w\s\-\n\r\t\<\>\/\{\}]+)\{\{ #end \}\}/ig;
    my $compiledContent = $self->compileLoopTemplate($var_name, $content);
    $template =~ s/(\{\{ #forEach \$[$var_name]+ \}\}[\w\s\-\n\r\t\<\>\/\{\}]+\{\{ #end \}\})/$compiledContent/ig;
  }

  return $template;
}

sub compileLoopTemplate {
  my ($self, $var_name, $content) = @_;
  my $compilation = '';

  if (scalar @{$self->{params}->{$var_name}} eq 0) {
    return '';
  }

  foreach my $item (@{$self->{params}->{$var_name}}) {
    $compilation .= _replaceLoopContentValues($item, $content);
  }

  return $compilation;
}

sub _replaceLoopContentValues {
  my ($item, $content, @indexes) = @_;

  my @inner_vars = $content =~ /\{\{ ([\w]+) \}\}/ig;

  foreach my $var (@inner_vars) {
    $content =~ s/(\{\{ [$var]+ \}\})/$item->{$var}/ig;
  }

  return $content;
}

1;