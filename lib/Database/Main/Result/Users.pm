package Database::Main::Result::Users;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('users');
__PACKAGE__->add_columns(qw/
	user_id
	username
	raw_nick
	password
	role
	
/);
__PACKAGE__->set_primary_key('user_id');

1;
=cut
mysql> describe users;
+----------+--------------+------+-----+---------+----------------+
| Field    | Type         | Null | Key | Default | Extra          |
+----------+--------------+------+-----+---------+----------------+
| user_id  | int(11)      | NO   | PRI | NULL    | auto_increment |
| username | varchar(250) | NO   |     | NULL    |                |
| raw_nick | varchar(250) | NO   |     | NULL    |                |
| password | varchar(250) | NO   |     | NULL    |                |
| role     | varchar(250) | YES  |     | NULL    |                |
+----------+--------------+------+-----+---------+----------------+
5 rows in set (0.00 sec)

