# vi:set syntax=perl:

use ExtUtils::MakeMaker;

goto SKIP if $ARGV[0] eq "skip_stuff";

open OUT, ">file.c" or die "$!";
print OUT << "EOF";
int main() {
    // yeah babby!
}
EOF
close OUT;

print "checking your g++.\n";
`g++ --version 2>/dev/null > /dev/null`; if($?) {
    print "All these makefiles and libraries and things are going\n";
    print "to fail if you don't have GNU g++ in your path.\n";
    die;
}

print "checking your flex.\n";
`g++ file.c -o file -lfl 2>/dev/null >/dev/null`; if($?) {
    print "You're going to need flex to compile this.\n";
    die;
}

print "checking your libjneural.\n";
`g++ file.c -o file -ljneural -lfl 2>/dev/null >/dev/null`; if($?) {
    print "You're going to need libjneural to pull this off.\n";
    print "Fortunately, I can help you out.\n";

    print   "tar -xf jneural*.tar\n"; 
    system  "tar -xf jneural*.tar"; 
    print   "cd jneural; ./configure --prefix=/usr/local; make && make install\n";
    system  "cd jneural; ./configure --prefix=/usr/local; make && make install";
}

`g++ file.c -o file -ljneural -lfl 2>/dev/null >/dev/null`; if($?) {
    print "You're going to need libjneural to pull this off.\n";
    print "However, soemthing went wrong with the installation.\n";
    die;
}

END {
    print "cleaning up some test files.\n";
    unlink "file.c";
    unlink "file";

    print "creating a fake jNeural.c (there's no jNeural.xs _yet_).\n";
    `touch jNeural.c`;
}

SKIP:

WriteMakefile(
    'NAME'          => 'AI::jNeural',
    'VERSION_FROM'  => 'jNeural.pm',
    'PREREQ_PM'     => {},
);
