def as-two-digit-string [n] {
  if $n < 10 {
    ($n | into string | str find-replace '([0-9])' '0$1')
  } {
    ($n | into string)
  }
}

def bash-program [block] {
  do $block | save --raw program.sh
  sh program.sh
  rm program.sh
}
