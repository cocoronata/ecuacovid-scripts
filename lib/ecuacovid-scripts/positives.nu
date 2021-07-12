def "positives path-from" [date_str, ...rest] {
  let fragments = ($date_str | parse-date);
  
  if ($fragments.year | str to-int) == 2020 {
    $"datos_crudos/positivas/2020"
  } {
    $"datos_crudos/positivas"
  } | path join -a ($rest | str collect "/")
}

def "positives provinces" [] {
  echo (open datos_crudos/positivas/2020/provincias.csv) (open datos_crudos/positivas/provincias.csv)
}

def "positives today" [] {
  open datos_crudos/ecuacovid.csv | select positivas_pcr positivas_pcr_nuevas | rename total new | last
}