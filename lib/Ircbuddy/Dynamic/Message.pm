package Ircbuddy::Dynamic::Message;

use strict;
use warnings;




sub go {
    my ($self,$bot,$mess,$schema) = @_;

	my $message = $mess->{body};
        if ($message =~ /^message\s+new\s+\S+\s\S+/) {
                my $from_user = $mess->{who};
                my ($who,$what) = ($message =~ /^message\s+new\s+(\S+)\s+(.*)/);
                my $insert = $schema->resultset('LaterTell')->create({
                        who => $who,
                        from_user => $from_user,
                        message => $what,
                });
                if ($insert->id) {
                        my $id = $insert->id;
                        $bot->reply($mess,"I\'ll let him know. ($id)");
                }
                else {
                        $bot->reply($mess,"I can\'t, there was an error :(");
                }
        }
		elsif ($message =~ /^messages$/i) {
                my $who = $mess->{who};
                my $search = $schema->resultset('LaterTell')->search({
                        who => $who,
                });
                if ($search->count) {
                        my @ids;
                        while (my $row = $search->next) {
                                push(@ids,$row->tell_id);
                        }
                        my $join = join(',',@ids);
                        $bot->reply($mess,$join);
                }
                else {
                        $bot->reply($mess,"no messages");
                }
        }
		elsif ($message =~ /^message\s+get\s+\d+/) {
                my $who = $mess->{who};
                my ($tell_id) = ($message =~ /^message\s+get\s+(\d+)/);
                my $search = $schema->resultset('LaterTell')->search({
                        tell_id => $tell_id,
                        who => $who,
                });
                if ($search->count) {
                        my $row = $search->first;
                        $bot->reply($mess,"<".$row->from_user ."> " . $row->message);
                }
                else {
                        $bot->reply($mess,"...");
                }
        }
		elsif ($message =~ /^message\s+del\s+\d+/) {
                my $who = $mess->{who};
                my ($tell_id) = ($message =~ /^message\s+del\s+(\d+)/);
                my $search = $schema->resultset('LaterTell')->search({
                        tell_id => $tell_id,
                        who => $who,
                });
                if ($search->count) {
                        $search->delete;
                        $bot->reply($mess,"deleted");
                }
                else {
                        $bot->reply($mess,"unknown message");
                }
        }
		elsif ($message =~ /^message\s+del\s+all/) {
			my $who = $mess->{who};
            my $search = $schema->resultset('LaterTell')->search({
                    who => $who,
            });
            if ($search->count) {
                    while (my $row = $search->next) {
							$search->delete;
                    }
					$bot->reply($mess,"All messages deleted");
            }
            else {
                    $bot->reply($mess,"no messages");
            }
		}



}


1;
