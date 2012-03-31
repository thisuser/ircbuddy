package Database::Main::Result::CommandReference;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('command_reference');
__PACKAGE__->add_columns(qw/
	cr_id
	problem
	solution	
/);
__PACKAGE__->set_primary_key('cr_id');

1;

=cut
mysql> describe command_reference;
+----------+--------------+------+-----+---------+----------------+
| Field    | Type         | Null | Key | Default | Extra          |
+----------+--------------+------+-----+---------+----------------+
| cr_id    | int(11)      | NO   | PRI | NULL    | auto_increment |
| problem  | varchar(250) | YES  |     | NULL    |                |
| solution | text         | NO   |     | NULL    |                |
+----------+--------------+------+-----+---------+----------------+
3 rows in set (0.05 sec)

