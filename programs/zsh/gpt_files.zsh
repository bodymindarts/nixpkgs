function gpt_files() {
  if [ $# -eq 0 ]; then
    echo "Usage: gpt_files glob_or_dir1 [glob_or_dir2 ...]"
    return 1
  fi

  process_file() {
    local file="$1"
    echo "=== File: $file ==="
    echo ""
    cat "$file"
    echo ""
    echo "=== End of file: $file ==="
    echo ""
  }

  git_files() {
    git ls-files $1 && git ls-files --others --exclude-standard $1
  }

  regular_files() {
    if [ -d "$1" ]; then
      find "$1" -type f
    else
      echo "$1"
    fi
  }

  is_git_repo() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
  }

  for input in "$@"
  do
    if is_git_repo; then
      if [ -d "$input" ]; then
        files=( $(git_files "$input") )
      else
        files=( $(git_files $input) )
      fi
    else
      if [ -d "$input" ]; then
        files=( $(regular_files "$input") )
      else
        files=( $(regular_files $input) )
      fi
    fi

    if [ ${#files[@]} -eq 0 ]; then
      echo "Error: No files match input '$input'."
      continue
    fi

    for file in "${files[@]}"
    do
      if [ -f "$file" ]; then
        process_file "$file"
      else
        echo "Error: $file is not a file."
      fi
    done
  done
}
