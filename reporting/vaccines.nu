def by-manufacturer [] {
  data {
    open datos_crudos/vacunas/fabricantes.csv |
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
    }
  }
}

def by-manufacturer-since-january [] {
  let all = $(by-manufacturer | get records | math sum);

  = `Desde Enero hasta hoy han llegado {{$all}} dosis de vacunas COVID al Ecuador.`
  = $(char newline)

  by-manufacturer | each {
      echo 🔹 ` {{$it.vaccine}}: {{$it.records}}` $(char newline)
  } | str collect
}