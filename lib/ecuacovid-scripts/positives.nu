def "positives path-from" [date_str, ...rest] {
  let fragments = $(echo $date_str | parse-date);
  
  if $(= $fragments.year | str to-int) == 2020 {
    echo `datos_crudos/positivas/2020`
  } {
    echo `datos_crudos/positivas`
  } | path join $(echo $rest | str collect "/")
}

def "positives provinces" [] {
  echo $(open datos_crudos/positivas/2020/provincias.json) $(open datos_crudos/positivas/provincias.json)
}

def "positives today" [] {
  open datos_crudos/ecuacovid.json | select positivas_pcr positivas_pcr_nuevas | rename total new | last
}