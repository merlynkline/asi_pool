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

1;

