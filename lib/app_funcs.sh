function compile_app() {
  local git_dir_value=$GIT_DIR
  unset GIT_DIR

  cd $build_path
  output_section "Compiling"
  exec_commands

  export GIT_DIR=$git_dir_value
  cd - > /dev/null
}

function restore_app() {
  if [ $crystal_changed != true ]; then
    if [ -d $(build_backup_path) ]; then
      cp -pR $(build_backup_path) ${build_path}/_build
    fi
  fi
}

function backup_app() {
  if [ $crystal_changed != true ]; then
    if [ -d ${build_path}/_build ]; then
      cp -pR ${build_path}/_build $(build_backup_path)
    fi
  fi
}