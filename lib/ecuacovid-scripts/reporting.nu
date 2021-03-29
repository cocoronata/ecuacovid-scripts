def "ecuacovid report-vaccines-by-manufacturer-since-january" [] {
  let all = $(total-vaccines-by-manufacturer | get total | math sum);

  = `Desde Enero hasta hoy han llegado {{$all}} dosis de vacunas COVID al Ecuador.`
  = $(char newline)

  total-vaccines-by-manufacturer | each {
      echo 🔹 ` {{$it.vaccine}}: {{$it.total}}` $(char newline)
  } | str collect
}

def "ecuacovid report-overall" [] {
  let data = $(open datos_crudos/ecuacovid.json | last 2);
  let previous_day = $(echo $data | nth 0);
  let record = $(echo $data | nth 1);

  let date = $(echo $record | get created_at | parse-date);
  let cases = $(echo $record | select positivas_pcr positivas_pcr_nuevas | rename cases new_cases);
  let deaths = $(echo $record | select muertes muertes_nuevas | rename deaths new_deaths);
  let tests = $(echo $record | select muestras_pcr muestras_pcr_nuevas | rename tests new_tests);

  let positivity = $(echo $record $previous_day | each {
    = ($it.positivas_pcr / ($it.positivas_pcr + $it.negativas_pcr)) * 100
  });
  
  let positivity = $(echo [[positivity]; [$positivity.1]] |
    insert new_positivity { 
      = $positivity.1 - $positivity.0 | str from -d 2
    } | update positivity {
      = $it.positivity | str from -d 2
  });

  let hospitalized = $(echo $record $previous_day | each {
    = $it.hospitalizadas_estables + $it.hospitalizadas_pronostico_reservadas
  });

  let hospitalized = $(echo [[hospitalized]; [$hospitalized.1]] |
    insert new_hospitalized { 
      = $hospitalized.1 - $hospitalized.0
  });

  let vaccinated = $(= $(vaccines | last | get segunda_dosis) / 17468736 | str from -d 2);
 
  = `🇪🇨  #Ecuador {{$date.day}}-{{$date.month}}-{{$date.year}}`
  = $(char newline)

  = ` 🔹Casos: {{$cases.cases}} ({{$cases.new_cases}})`
  = $(char newline)

  = ` 🔹Fallecidos MSP: {{$deaths.deaths}} ({{$deaths.new_deaths}})`
  = $(char newline)

  = ` 🔹Pruebas: {{$tests.tests}} ({{$tests.new_tests}})`
  = $(char newline)

  = ` 🔹Positividad: {{$positivity.positivity}}% ({{$positivity.new_positivity}}%)`
  = $(char newline)

  = ` 🔹Hospitalizados: {{$hospitalized.hospitalized}} ({{$hospitalized.new_hospitalized}})`
  = $(char newline)

  = ` 🔹Vacunados: {{$vaccinated}}%`
  = $(char newline)
}