def data [block] {
  let is_present = $(pwd | path join "datos_crudos" | path exists);

  if $is_present {
    $block
  } {
    echo "No raw data available." $(char newline) | str collect
    exit
  }
}

def parse-date [] {
  parse {day}/{month}/{year}
}

source lib/ecuacovid-scripts/positives.nu
source lib/ecuacovid-scripts/vaccines.nu
source lib/ecuacovid-scripts/reporting.nu