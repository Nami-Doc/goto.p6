#!/usr/bin/env perl6
constant FILE = 'paths.txt';
my %paths = slurp(FILE).lines>>.split('=');

sub save-paths {
  my $content = %paths.map({ "$(.key)=$(.value)" }).join("\n");
  spurt(FILE, $content);
}

multi MAIN {
  say "Paths defined: ";
  say;
  say "  $(.key) => $(.value)" for %paths;
}

multi MAIN(Str $key, Str $value, Bool :$add!) {
  %paths{$key} = $value;
  save-paths;
}

multi MAIN(Str $key, Bool :$remove!) {
  die "No such path $key" unless %paths{$key}:exists;
  %paths{$key}:delete;
  save-paths;
}

multi MAIN($key) {
  die "No such path $key" unless %paths{$key}:exists;
  say "Going to %paths{$key}";
  shell "cd %paths{$key}";
}
