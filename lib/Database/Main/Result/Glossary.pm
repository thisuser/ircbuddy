package Database::Main::Result::Glossary;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('glossary');
__PACKAGE__->add_columns(qw/
	gid
	term
	definition 
/);
__PACKAGE__->set_primary_key('gid');

1;
=cut
mysql> describe glossary;
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| id         | int(11)      | NO   | PRI | NULL    | auto_increment |
| term       | varchar(250) | NO   |     | NULL    |                |
| definition | text         | NO   |     | NULL    |                |
+------------+--------------+------+-----+---------+----------------+
3 rows in set (0.25 sec)

