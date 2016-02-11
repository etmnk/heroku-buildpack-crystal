function platform_tools_path() {
  echo "${build_path}/.platform_tools"
}

function crystal_path() {
  echo "$(platform_tools_path)/crystal"
}
