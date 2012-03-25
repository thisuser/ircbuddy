package Database::Main::Result::LaterTell;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('later_tell');
__PACKAGE__->add_columns(qw/
	tell_id
	who
	from_user
	message
	
/);
__PACKAGE__->set_primary_key('tell_id');

1;
=cut
mysql> describe later_tell;
+-----------+--------------+------+-----+---------+----------------+
| Field     | Type         | Null | Key | Default | Extra          |
+-----------+--------------+------+-----+---------+----------------+
| tell_id   | int(11)      | NO   | PRI | NULL    | auto_increment |
| who       | varchar(250) | NO   |     | NULL    |                |
| from_user | varchar(250) | NO   |     | NULL    |                |
| message   | text         | NO   |     | NULL    |                |
+-----------+--------------+------+-----+---------+----------------+
4 rows in set (0.20 sec)


