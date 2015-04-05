# ABSTRACT: remove an entropy repository from your system
package App::enman::Command::remove;
use App::enman -command;
use App::enman::Utils;

sub execute {
  my ($self, $opt, $args) = @_;
    error "You must run $0 with root permissions" and return 1 if $> != 0;
    my $repo=App::enman::ETPREPO_DIR() . App::enman::ETPSUFFIX() . "@{$args}";
    if(-e $repo){
        info "removing '$repo'";
        unlink ($repo);
    } else {
        error "There is no repository '@{$args}' installed in your system";
    }
}
1;