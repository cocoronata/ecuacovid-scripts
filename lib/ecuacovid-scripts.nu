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

def by-region [] {
  where provincia in [Azuay Bolívar Cañar Carchi Cotopaxi Chimborazo Imbabura Loja Pichincha Tungurahua] |
  wrap sierra
}

source lib/ecuacovid-scripts/positives.nu
source lib/ecuacovid-scripts/vaccines.nu
source lib/ecuacovid-scripts/reporting.nu