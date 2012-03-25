package Database::Main::Result::MCOptions;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('mc_options');
__PACKAGE__->add_columns(qw/
	mco_id
	parent_id
	options
/);
__PACKAGE__->set_primary_key('mco_id');

1;
=cut
mysql> describe mc_options;
+-----------+------------------+------+-----+---------+----------------+
| Field     | Type             | Null | Key | Default | Extra          |
+-----------+------------------+------+-----+---------+----------------+
| mco_id    | int(11)          | NO   | PRI | NULL    | auto_increment |
| parent_id | int(10) unsigned | NO   |     | NULL    |                |
| options   | text             | NO   |     | NULL    |                |
+-----------+------------------+------+-----+---------+----------------+
3 rows in set (0.26 sec)

