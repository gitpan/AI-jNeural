use ExtUtils::MakeMaker;


WriteMakefile(
    'CC'           => 'g++',
    'NAME'         => 'AI::jNeural::utils::transfer',
    'VERSION_FROM' => 'transfer.pm',
    'PREREQ_PM'    => {},
    'LIBS'         => ['-ljneural -lfl'],
    'DEFINE'       => '',
    'INC'          => '',
);
