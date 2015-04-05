# ABSTRACT: search repositories into the enman db
package App::enman::Command::search;
use App::enman -command;
use App::enman::Utils;
use LWP::Simple;

sub execute {
    my ( $self, $opts, $args ) = @_;
    my $query = join( "", @{$args} );
    my @matches = &search($query);
    notice "No matches for '$query'" and return 1 if @matches == 0;
    notice @matches . " results for '$query'";
    info "=" x 6;
    foreach my $match (@matches) {
        notice "Repository: " . $match->[0];
        info "\tConfiguration file: " . $match->[1];
    }
}

sub search {
    my ($string) = shift;
    info "Searching '$string' on the enman db...";
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
