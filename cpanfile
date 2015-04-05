requires 'perl';
requires 'App::Cmd';
requires 'LWP::Simple';
requires 'LWP::Protocol::https';
on 'test' => sub {
    requires 'Test::More', '0.98';
};

