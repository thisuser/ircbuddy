package Database::Main;
use base qw/DBIx::Class::Schema/;

__PACKAGE__->load_namespaces;
__PACKAGE__->exception_action(sub { 1 });

1;
