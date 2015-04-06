# ABSTRACT: Adds an entropy repository to your system that matches your query string
package App::enman::Command::add;
use App::enman -command;
use LWP::Simple;
use App::enman::Utils;
use Locale::TextDomain 'App-enman';

sub execute {
    my ( $self, $opts, $args ) = @_;
    error( __("You must run enman with root permissions") ) and return 1
        if $> != 0;
    my @results = &App::enman::Command::search::search( @{$args} );
    if ( @results > 1 ) {
        info(
            __x("'{repository}' repository matches more than one:",
                repository => "@{$args}"
            )
        );
        foreach my $match (@results) {
            notice(
                __x( "Repository: {repository}", repository => $match->[0] )
            );

            info(
                "\t"
                    . __x(
                    "Configuration file: {config}",
                    config => $match->[0]
                    )
            );
        }
        return 1;
    }
    elsif ( !$results[0] ) {
        notice(
            __x( "No matches for '{repository}'", repository => "@{$args}" )
        );
    }
    info(
        __x("Installing '{repository}' in your system",
            repository => "@{$args}"
        )
    );
    my $repo_name = App::enman::ETPSUFFIX() . $results[0]->[0];
    my $repo      = get( $results[0]->[1] );
    open my $EREPO, ">" . App::enman::ETPREPO_DIR() . $repo_name
        or die(
        __x( "cannot write the repository file: {error}", error => $! ) );
    print $EREPO $repo;
    close($EREPO);

}
1;
