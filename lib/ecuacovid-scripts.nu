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
  group-by { region }
}

def costa [] {echo ["El Oro" Esmeraldas Guayas "Los Ríos" Manabí "Santa Elena" "Sto. Domingo Tsáchilas"]}
def sierra [] {echo [Azuay Bolívar Cañar Carchi Cotopaxi Chimborazo Imbabura Loja Pichincha Tungurahua]}
def amazonia [] {echo ["Morona Santiago" Napo Orellana Pastaza Sucumbíos "Zamora Chinchipe"]}
def region-insular [] {echo [Galápagos]}

def region [] {
  each {
    if $it.provincia in [Azuay Bolívar Cañar Carchi Cotopaxi Chimborazo Imbabura Loja Pichincha Tungurahua] {
      = "sierra"
    } {
      if $it.provincia in ["El Oro" Esmeraldas Guayas "Los Ríos" Manabí "Santa Elena" "Sto. Domingo Tsáchilas"] {
        = "costa"
      } {
        if $it.provincia in ["Morona Santiago" Napo Orellana Pastaza Sucumbíos "Zamora Chinchipe"] {
          = "amazonia"
        } {
          = "region_insular"
        }
      }
    }
  }
}

def provinces [] {
  data {
    open datos_crudos/muertes/por_fecha/provincias_por_mes.json |
    select provincia
  }
}

source lib/ecuacovid-scripts/positives.nu
source lib/ecuacovid-scripts/vaccines.nu
source lib/ecuacovid-scripts/reporting.nu
