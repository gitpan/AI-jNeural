# vi:set syntax=perl:
use ExtUtils::MakeMaker;

WriteMakefile(
    'CC'           => 'g++',
    'NAME'         => 'AI::jNeural::nets::backprop',
    'VERSION_FROM' => 'backprop.pm',
    'PREREQ_PM'    => { 'AI::jNeural::util::transfer'=>0 },
    'LIBS'         => ['-ljneural -lfl'],
    'DEFINE'       => '',
    'INC'          => '',
);
