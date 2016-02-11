function compile_app() {
  local git_dir_value=$GIT_DIR
  unset GIT_DIR

  cd $build_path
  output_section "Compiling"
  exec_commands

  export GIT_DIR=$git_dir_value
  cd - > /dev/null
}


function post_compile_hook() {
  cd $build_path

  if [ -n "$post_compile" ]; then
    output_section "Executing post compile: $post_compile"
    $post_compile || exit 1
  fi

  cd - > /dev/null
}


function write_profile_d_script() {
  output_section "Creating .profile.d with env vars"
  mkdir -p $build_path/.profile.d

  local export_line="export PATH=\$HOME/.platform_tools:\$HOME/.platform_tools/crystal/bin:\$PATH
                     export LC_CTYPE=en_US.utf8"
  echo $export_line >> $build_path/.profile.d/crystal_buildpack_paths.sh
}