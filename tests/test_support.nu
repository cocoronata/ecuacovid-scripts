def playground [topic, block] {
  with-env [N 5 REJECT slow] {
    echo $topic " tests" $(char newline) | str collect

    $block
  }
}

def play [
  topic: any
  --tag: string
  block: block
] {
  let title = $(echo $topic);

  let tag_empty = $(= $tag | empty?);
  let run_all = $(= $nu.env | get | where $it == RUN_ALL | length);

  if $tag_empty == $true {
    $block
  } {
    if $tag == $nu.env.REJECT && $run_all == 0 {
      echo `  {{$topic}} ... {{$(ansi yellow)}}skipped{{$(ansi reset)}}` $(char newline) | str collect
    } { $block }
  }
}

def given [block] {
  $block
}

def pending [block] { }

def expect [
  actual: any
  --to-eq: any
] {
  let left_headers = $(echo $actual | get);
  let right_headers = $(echo $to-eq | get);

  let are_headers_equal = $(echo $left_headers $right_headers | uniq | each --numbered {
    if $it.item == $(echo $left_headers | nth $it.index) { = $true } { = $false }
  });

  let rows_check = $(echo $(echo $actual | each { 
    get $(= $left_headers)
  }) $(echo $to-eq | each {
    get $(= $right_headers)
  }) | uniq | length);

  let t_left = $(echo $left_headers | length);
  let t_right = $(echo $right_headers | length);

  let are_equal = $(if $(echo $are_headers_equal | where $it == $false | length) == 0 && $rows_check == $(= ($t_left + $t_right) / 2) && $(echo $actual | length) == $(echo $to-eq | length) { = $true } { = $false });

  let out = $(if $true == $are_equal { = `{{$(ansi green)}}ok{{$(ansi reset)}} {{$(char newline)}}` } { = `{{$(ansi red)}}failed{{$(ansi reset)}} {{$(char newline)}}` });

  = `  {{$title}} ... {{$out}}`
}

def items [] {
  echo $nu.env.N | str to-int
}