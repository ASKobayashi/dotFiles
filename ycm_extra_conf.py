import os
import ycm_core

YCMFLAGS_FILENAME=".ycmflags"

flags = [
    '-Wall', '-Wextra', '-fexceptions',
    '-std=c++11', '-stdlib=libc++', '-x', 'c++',
    '-I', '.',
    '-isystem', '/Library/Developer/CommandLineTools/usr/bin/../lib/c++/v1',
    '-isystem', '/Library/Developer/CommandLineTools/usr/bin/../lib/clang/5.1/include',
    '-isystem', '/Library/Developer/CommandLineTools/usr/include',
    '-isystem', '/usr/local/include',
    '-isystem', '/usr/include'
]

def DirectoryOfThisScript():
  return os.path.dirname( os.path.abspath( __file__ ) )

def MakeRelativePathsInFlagsAbsolute( flags, working_directory ):
  if not working_directory:
    return list( flags )
  new_flags = []
  make_next_absolute = False
  path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
  for flag in flags:
    new_flag = flag

    if make_next_absolute:
      make_next_absolute = False
      if not flag.startswith( '/' ):
        new_flag = os.path.join( working_directory, flag )

    for path_flag in path_flags:
      if flag == path_flag:
        make_next_absolute = True
        break

      if flag.startswith( path_flag ):
        path = flag[ len( path_flag ): ]
        new_flag = path_flag + os.path.join( working_directory, path )
        break

    if new_flag:
      new_flags.append( new_flag )
  return new_flags

def FlagsForFile( filename ):
    global flags # assign to global flags var
    relative_to = DirectoryOfThisScript()

    # Search for flagfile
    path = filename
    while path != '/':
        path = os.path.dirname(path)
        flagfile = path+"/"+YCMFLAGS_FILENAME
        if os.path.isfile(flagfile):
            flagbuffer = open(flagfile, 'r').read()
            flags += flagbuffer.strip().split()
            relative_to = path

    final_flags = MakeRelativePathsInFlagsAbsolute( flags, relative_to )

    return {
        'flags': final_flags,
        'do_cache': True
    }
