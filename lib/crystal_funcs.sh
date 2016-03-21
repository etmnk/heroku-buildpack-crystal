function download_crystal() {
  # If a previous download does not exist, then always re-download
  if [[ ${force_fetch} = true ]] || [ ! -f ${crystal_path}/$(crystal_download_file) ]; then
    clean_crystal_downloads
    crystal_changed=true

    output_section "Fetching crystal ${crystal_version}"

    cd $crystal_path
    local download_url="https://github.com/crystal-lang/crystal/releases/download/${crystal_version}/crystal-${crystal_version}-1-linux-x86_64.tar.gz"
    curl -sL ${download_url} -o ${cache_path}/$(crystal_download_file) || exit 1
  else
    output_section "Using cached Crystal ${crystal_version}"
  fi
}


function install_crystal() {
  output_section "Installing Crystal ${crystal_version} $crystal_changed"

  mkdir -p $(crystal_path)
  cd $(crystal_path)

  tar -xzf ${cache_path}/$(crystal_download_file) --strip-component=1

  cd - > /dev/null

  chmod +x $(crystal_path)/bin/*
  PATH=$(crystal_path)/bin:${PATH}

  export LC_CTYPE=en_US.utf8
}


function install_shards() {
  cd $build_path
  if [ -f shard.yml ]; then
    output_section "Installing Dependencies"
    crystal deps
  fi
}


function crystal_download_file() {
  echo crystal-${crystal_version}.tar.gz
}

function clean_crystal_downloads() {
  rm -rf $crystal_path/crystal*.tar.gz
}
