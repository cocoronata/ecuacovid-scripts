def playground [topic, block] {
  with-env [N 5 REJECT slow] {
    echo $topic " tests" (char newline) | str collect

    do $block
  }
}

def play [
  topic: any
  --tag: string
  block: block
] {
  let title = ($topic);

  let tag_empty = ($tag | empty?);
  let run_all = ($nu.env | get | where $it == RUN_ALL | length);

  if $tag_empty == $true {
    do $block
  } {
    if $tag == $nu.env.REJECT && $run_all == 0 {
      $"  ($topic) ... (ansi yellow)skipped(ansi reset) (char newline)"
    } { do $block }
  }
}

def given [block] {
  do $block
}

def pending [block] { }

def expect [
  actual: any
  --to-eq: any
] {
  let left_headers = ($actual | get);
  let right_headers = ($to-eq | get);

  let are_headers_equal = (echo $left_headers $right_headers | uniq | each --numbered {
    if $it.item == ($left_headers | nth $it.index) { $true } { $false }
  });

  let rows_check = (echo ($actual | each { get $left_headers }) ($to-eq | each { get $right_headers} ) | uniq | length);

  let t_left = ($left_headers | length);
  let t_right = ($right_headers | length);

  let first = (if ($are_headers_equal | where $it == $false | length) == 0 { $true } { $false });
  let second = (if $rows_check == ($actual | get ($actual | get) | length) { $true } { $false });
  let third = (if ($actual | get ($actual | get) | length) == ($to-eq | get ($to-eq | get) | length) { $true } { $false });

  let are_equal = ($first && $second && $third);
  
  let out = (if $true == $are_equal { $"(ansi green)ok(ansi reset) (char newline)" } { $"(ansi red)failed(ansi reset) (char newline)" });

  $"  ($title) ... ($out)"
}

def items [] {
  $nu.env.N | str to-int
}
