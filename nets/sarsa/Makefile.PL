# vi:set syntax=perl:
# $Id: Makefile.PL,v 1.1 2002/12/09 20:46:34 jettero Exp $

use ExtUtils::MakeMaker;

WriteMakefile(
    'CC'           => 'g++',
    'NAME'         => 'AI::jNeural::nets::sarsa',
    'VERSION_FROM' => 'sarsa.pm',
    'PREREQ_PM'    => { 'AI::jNeural::util::transfer'=>0, 'Math::Business::SMA'=>0 },
    'LIBS'         => ['-ljneural -lfl'],
    'DEFINE'       => '',
    'INC'          => '',
);
