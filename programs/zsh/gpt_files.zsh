# gpt_files.zsh
#
# This script contains a function called `gpt_files`, which helps provide
# file context when working with ChatGPT in an efficient manner. The function
# accepts one or more file paths, globs, or directories as arguments and prints
# the content of the specified files in a structured format. This output can
# be easily piped to clipboard utilities like `pbcopy` and then pasted into
# the ChatGPT prompt to provide context for questions.
#
# Usage:
#   gpt_files file1 [file2 ...]       - Prints the content of the specified files
#   gpt_files glob1 [glob2 ...]       - Prints the content of files matching the specified globs
#   gpt_files dir1 [dir2 ...]         - Prints the content of files in the specified directories
#
# Example usage with clipboard utility:
#   gpt_files some_file.txt | pbcopy  - Copies the output to clipboard for pasting into ChatGPT
#
MAX_TOKENS=4096  # Set the maximum number of tokens allowed

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


  local total_tokens=0
  local file_tokens
  local file_token_counts=()

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
        file_tokens=$(wc -w < "$file")
        total_tokens=$((total_tokens + file_tokens))
        file_token_counts+=("$file:$file_tokens")
      else
        echo "Error: $file is not a file."
      fi
    done
  done

  if [ $total_tokens -gt $MAX_TOKENS ]; then
    echo "These files contain $total_tokens tokens - that is $((total_tokens - MAX_TOKENS)) too many for ChatGPT to handle"
  else
    for file in "${files[@]}"
    do
      if [ -f "$file" ]; then
        process_file "$file"
      fi
    done
  fi
}
