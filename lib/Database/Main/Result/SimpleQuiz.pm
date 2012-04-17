package Database::Main::Result::SimpleQuiz;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('simple_quiz');
__PACKAGE__->add_columns(qw/
quiz_id
cert_level
question
answer
/);
__PACKAGE__->set_primary_key('quiz_id');

1;
=cut
mysql> describe simple_quiz;
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| quiz_id    | int(11)      | NO   | PRI | NULL    | auto_increment |
| cert_level | varchar(250) | NO   |     | NULL    |                |
| question   | text         | NO   |     | NULL    |                |
| answer     | varchar(250) | NO   |     | NULL    |                |
+------------+--------------+------+-----+---------+----------------+
4 rows in set (0.02 sec)


