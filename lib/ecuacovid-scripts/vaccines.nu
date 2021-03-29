def total-vaccines-by-manufacturer [] {
  data {
    manufacturers |
    update vaccine {
      let words = $(get vaccine | split row "/");

      if $(echo $words | first) == "Oxford" {
        echo $words | str collect "/"
      } {
        echo $words | first
      }
    } |
    group-by vaccine |
    pivot vaccine records |
    update records {
      get records.total | math sum
    } |
    rename vaccine total
  }
}

def manufacturers [] {
  data {
    open datos_crudos/vacunas/fabricantes.csv
  }
}

def vaccines [] {
  data {
    open datos_crudos/vacunas/vacunas.csv
  }
}