# Outputs log line
#
# Usage:
#
#     output_line "Cloning repository"
#
function output_line() {
  local spacing="      "
  echo "${spacing} $1"
}

# Outputs section heading
#
# Usage:
#
#     output_section "Application tasks"
#
function output_section() {
  local indentation="----->"
  echo "${indentation} $1"
}


function load_config() {
  output_section "Checking Crystal versions"

  local custom_config_file="${build_path}/crystal_buildpack.config"

  # Source for default versions file from buildpack first
  #source "${build_pack_path}/crystal_buildpack.config"

  if [ -f $custom_config_file ];
  then
    source $custom_config_file
  else
    output_line "WARNING: crystal_buildpack.config wasn't found in the app"
    output_line "Using default config"
    source init_default_config
  fi

  output_line "Will use the following versions:"
  output_line "* Stack ${STACK}"
  output_line "* Crystal ${crystal_version[0]} ${crystal_version[1]}"
  output_line "Will export the following config vars:"
  output_line "* Config vars ${config_vars_to_export[*]}"
  output_line "* Exec commands ${build_command[*]}"
}


function init_default_config {
  crystal_version=$(curl -sI https://github.com/manastech/crystal/releases/latest | awk -F'/' '/^Location:/{print $NF}')
  always_rebuild=false
  config_vars_to_export=(DATABASE_URL)
  build_command=("make run")
}


# Make the config vars from config_vars_to_export available at slug compile time.
# Useful for compiled languages like Erlang and Elixir
function export_config_vars() {
  for config_var in ${config_vars_to_export[@]}; do
    if [ -d $env_path ] && [ -f $env_path/${config_var} ]; then
      export ${config_var}=$(cat $env_path/${config_var})
    fi
  done
}

function check_stack() {
  if [ ${STACK} = "cedar" ]; then
    echo "ERROR: cedar stack is not supported, upgrade to cedar-14"
    exit 1
  fi

  if [ ! -f "${cache_path}/stack" ] || [ $(cat "${cache_path}/stack") != ${STACK} ]; then
    output_section "Stack changed, will rebuild"
    rm -rf ${cache_path}/*
  fi

  echo ${STACK} > "${cache_path}/stack"
}

function clean_cache() {
  if [ $always_rebuild = true ]; then
    output_section "Cleaning all cache to force rebuilds"
    rm -rf $cache_path/*
  fi
}

function exec_commands() {
  for cmd in ${build_command[@]}; do
    $cmd
  done
}