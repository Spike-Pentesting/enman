# ABSTRACT: Adds an entropy repository to your system that matches your query string
package App::enman::Command::add;
use App::enman -command;
use LWP::Simple;
use App::enman::Utils;
use Locale::TextDomain 'App-enman';

sub execute {
    my ( $self, $opts, $args ) = @_;
    error( __("You must run  enman with root permissions") ) and return 1
        if $> != 0;
    my @results = &App::enman::Command::search::search( @{$args} );
    if ( @results > 1 ) {
        info "the supplied repository matches more than one:";
        foreach my $match (@results) {
            notice "Repository: " . $match->[0];
            info "\tConfiguration file: " . $match->[1];
        }
        return 1;
    }
    my $repo_name = App::enman::ETPSUFFIX() . $results[0]->[0];
    my $repo      = get( $results[0]->[1] );
    open my $EREPO, ">" . App::enman::ETPREPO_DIR() . $repo_name;
    print $EREPO $repo;
    close($EREPO);

}
1;
