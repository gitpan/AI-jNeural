use ExtUtils::MakeMaker;

WriteMakefile(
    'CC'           => 'g++',
    'NAME'         => 'AI::jNeural::nets::kohonen',
    'VERSION_FROM' => 'kohonen.pm',
    'PREREQ_PM'    => {},
    'LIBS'         => ['-ljneural -lfl'],
    'DEFINE'       => '',
    'INC'          => '',
);
