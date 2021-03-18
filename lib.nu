def data [block] {
  let is_present = $(pwd | path join "datos_crudos" | path exists);

  if $is_present {
    $block
  } {
    echo "No raw data available." $(char newline) | str collect
    exit
  }
}

