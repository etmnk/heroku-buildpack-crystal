function compile_app() {
  local git_dir_value=$GIT_DIR
  unset GIT_DIR

  cd $build_path
  output_section "Compiling"
  exec_commands

  export GIT_DIR=$git_dir_value
  cd - > /dev/null
}