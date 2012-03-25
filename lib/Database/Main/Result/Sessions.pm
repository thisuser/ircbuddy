package Database::Main::Result::Sessions;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('sessions');
__PACKAGE__->add_columns(qw/
	sess_id
	username
	raw_nick
	authtime
/);
__PACKAGE__->set_primary_key('sess_id');

1;
=cut
mysql> describe sessions;
+----------+------------------+------+-----+---------+----------------+
| Field    | Type             | Null | Key | Default | Extra          |
+----------+------------------+------+-----+---------+----------------+
| sess_id  | int(11)          | NO   | PRI | NULL    | auto_increment |
| username | varchar(250)     | NO   |     | NULL    |                |
| raw_nick | varchar(250)     | NO   |     | NULL    |                |
| authtime | int(15) unsigned | NO   |     | NULL    |                |
+----------+------------------+------+-----+---------+----------------+
4 rows in set (0.00 sec)




