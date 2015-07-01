package ASiPool::Controller::Main;
use Mojo::Base 'Mojolicious::Controller';

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
sub article {
    my $c = shift;

    my $topic = $c->stash('topic');
    my $text = $c->_get_article_text($topic);
    $c->render(json => {
            text    => $text,
        });
} 

sub _get_article_text {
    my $c = shift;
    my ($topic) = @_;

    if($topic eq 'cats') {
        return "Cats are fluffy. They control you. Resistance is futile.";
    }
    else {
        return "Sorry - I know nothing of $topic";
    }
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
use Net::Twitter;
sub tweets {
    my $c = shift;

    my $topic = $c->stash('topic');
    my $nt = Net::Twitter->new(
        traits          => [ qw/AppAuth API::RESTv1_1/ ],
        consumer_key    => $ENV{TWITTER_PUBLIC},
        consumer_secret => $ENV{TWITTER_PRIVATE},
    );

warn "A:$ENV{TWITTER_PUBLIC},$ENV{TWITTER_PRIVATE}";
    $nt->request_access_token;
warn "B";
    my $r = $nt->search($topic);
warn "C";

    my @res;
    foreach my $status (@{$r->{statuses}}) {
        push @res, {
            screen_name => $status->{user}->{screen_name},
            date        => $status->{created_at},
            id          => $status->{id},
            text        => $status->{text},
        };
    }

warn "D";
    $c->render(json => \@res);
}

1;

