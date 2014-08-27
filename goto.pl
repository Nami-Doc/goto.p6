#!/usr/bin/env perl6
# Key/value store file
constant KEYVAL_FILE = 'paths.txt';
# `alias x='cd y'` file
constant ALIAS_FILE = 'paths.sh';

my %paths = slurp(KEYVAL_FILE).lines>>.split('=');

sub save-paths {
  my $keyvals = %paths.map({ "$(.key)=$(.value)" }).join("\n");
  my $aliases = %paths.map({ "alias $(.key)='cd $(.value)'" }).join("\n");

  spurt(KEYVAL_FILE, $keyvals);
  spurt(ALIAS_FILE, $aliases);
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
  say "$key is going to %paths{$key}";
}

multi MAIN(Bool :$rehash!) {
  save-paths;
}
