use ExtUtils::MakeMaker;

WriteMakefile(
    'CC'           => 'g++',
    'NAME'         => 'AI::jNeural::arch::neuron',
    'VERSION_FROM' => 'neuron.pm',
    'PREREQ_PM'    => {},
    'LIBS'         => ['-ljneural -lfl'],
    'DEFINE'       => '',
    'INC'          => '',
);
