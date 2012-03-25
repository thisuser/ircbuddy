package Database::Main::Result::MCQuestions;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('mc_questions');
__PACKAGE__->add_columns(qw/
	mc_id
	question
	answer
	categories
/);
__PACKAGE__->set_primary_key('mc_id');

1;
=cut
mysql> describe mc_questions;
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| mc_id      | int(11)      | NO   | PRI | NULL    | auto_increment |
| question   | text         | NO   |     | NULL    |                |
| answer     | varchar(250) | NO   |     | NULL    |                |
| categories | text         | YES  |     | NULL    |                |
+------------+--------------+------+-----+---------+----------------+

