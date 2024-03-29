
if(NOT "/home/zaki/.emacs.d/elpa/vterm-20190822.1225/build/libvterm-prefix/src/libvterm-stamp/libvterm-gitinfo.txt" IS_NEWER_THAN "/home/zaki/.emacs.d/elpa/vterm-20190822.1225/build/libvterm-prefix/src/libvterm-stamp/libvterm-gitclone-lastrun.txt")
  message(STATUS "Avoiding repeated git clone, stamp file is up to date: '/home/zaki/.emacs.d/elpa/vterm-20190822.1225/build/libvterm-prefix/src/libvterm-stamp/libvterm-gitclone-lastrun.txt'")
  return()
endif()

execute_process(
  COMMAND ${CMAKE_COMMAND} -E remove_directory "/home/zaki/.emacs.d/elpa/vterm-20190822.1225/build/libvterm-prefix/src/libvterm"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to remove directory: '/home/zaki/.emacs.d/elpa/vterm-20190822.1225/build/libvterm-prefix/src/libvterm'")
endif()

# try the clone 3 times in case there is an odd git clone issue
set(error_code 1)
set(number_of_tries 0)
while(error_code AND number_of_tries LESS 3)
  execute_process(
    COMMAND "/usr/bin/git"  clone  "https://github.com/neovim/libvterm.git" "libvterm"
    WORKING_DIRECTORY "/home/zaki/.emacs.d/elpa/vterm-20190822.1225/build/libvterm-prefix/src"
    RESULT_VARIABLE error_code
    )
  math(EXPR number_of_tries "${number_of_tries} + 1")
endwhile()
if(number_of_tries GREATER 1)
  message(STATUS "Had to git clone more than once:
          ${number_of_tries} times.")
endif()
if(error_code)
  message(FATAL_ERROR "Failed to clone repository: 'https://github.com/neovim/libvterm.git'")
endif()

execute_process(
  COMMAND "/usr/bin/git"  checkout 89675ffdda615ffc3f29d1c47a933f4f44183364 --
  WORKING_DIRECTORY "/home/zaki/.emacs.d/elpa/vterm-20190822.1225/build/libvterm-prefix/src/libvterm"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to checkout tag: '89675ffdda615ffc3f29d1c47a933f4f44183364'")
endif()

execute_process(
  COMMAND "/usr/bin/git"  submodule update --recursive --init 
  WORKING_DIRECTORY "/home/zaki/.emacs.d/elpa/vterm-20190822.1225/build/libvterm-prefix/src/libvterm"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to update submodules in: '/home/zaki/.emacs.d/elpa/vterm-20190822.1225/build/libvterm-prefix/src/libvterm'")
endif()

# Complete success, update the script-last-run stamp file:
#
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy
    "/home/zaki/.emacs.d/elpa/vterm-20190822.1225/build/libvterm-prefix/src/libvterm-stamp/libvterm-gitinfo.txt"
    "/home/zaki/.emacs.d/elpa/vterm-20190822.1225/build/libvterm-prefix/src/libvterm-stamp/libvterm-gitclone-lastrun.txt"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to copy script-last-run stamp file: '/home/zaki/.emacs.d/elpa/vterm-20190822.1225/build/libvterm-prefix/src/libvterm-stamp/libvterm-gitclone-lastrun.txt'")
endif()

