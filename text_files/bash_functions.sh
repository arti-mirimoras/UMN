#!/bin/bash

print_usage() {
  echo "Usage: $0 <work_directory> <subjid> <Path_data> <path_pfm_dlabel>"
  exit 1
}

check_file_exists() {
  local file=$1
  if [[ ! -f "$file" ]]; then
    echo "Error: File not found: $file"
    exit 2
  fi
}

get_first_file() {
  local pattern=$1
  local result
  result=$(find . -type f -path "$pattern" | head -n 1)
  if [[ -z "$result" ]]; then
    echo "Error: No files matched pattern: $pattern"
    exit 3
  fi
  echo "$result"
}

run_matlab_dlabel() {
  local fig_name=$1
  local dlabel_path=$2
  local out_dir=$3

  echo "Launching MATLAB visualization for $dlabel_path"
  matlab -nodisplay -nodesktop -r \
    "addpath(genpath('$simnibs_repo')); \
     addpath_genpath_from_file('$paths_matlab_code'); \
     show_dlabels('$fig_name', '$dlabel_path', \
                  '$path_L_pial','$path_R_pial', \
                  '$path_L_atlas_inflated','$path_R_atlas_inflated', \
                  'wd', '$out_dir'); exit;"

  # Alternative with modern MATLAB (2019b+):
  # matlab -batch "show_dlabels('$fig_name', '$dlabel_path', '$path_L_pial','$path_R_pial','$path_L_atlas_inflated','$path_R_atlas_inflated', 'wd', '$out_dir')"
}