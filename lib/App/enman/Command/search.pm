# ABSTRACT: search repositories into the enman db
package App::enman::Command::search;
use App::enman -command;
use App::enman::Utils;
use LWP::Simple;
use Locale::TextDomain 'App-enman';

sub execute {
    my ( $self, $opts, $args ) = @_;
    my $query = join( "", @{$args} );

    info( __x( "Searching '{query}' on the enman db...", query => $query ) );
    my @matches = &search($query);

    notice( __x( "No matches for '{query}'", query => $query ) ) and return 1
        if @matches == 0;
    notice(
        __x("{matches} results for {query}",
            matches => scalar(@matches),
            query   => $query
        )
    );
    info "=" x 6;
    foreach my $match (@matches) {
        notice(
            __x( "Repository: {repository}", repository => $match->[0] ) );

        info( "\t"
                . __x( "Configuration file: {config}", config => $match->[0] )
        );

    }
}

sub search {
    my ($string) = shift;
    my $enman = get( App::enman::ENMAN_DB() );
    my @enman_db = split( /\n/, $enman );
    my @matches;
    foreach my $repo (@enman_db) {

        #enabling regex search, not quoted
        push( @matches, [ +split( ':', $repo, 2 ) ] )
            if ( $repo =~ /$string/i );

    }
    return @matches;
}
1;
