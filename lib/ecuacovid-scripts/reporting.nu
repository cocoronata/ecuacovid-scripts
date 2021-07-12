def "ecuacovid report-vaccines-by-manufacturer-since-january" [] {
  let all = (total-vaccines-by-manufacturer | get total | math sum);

  $"Desde Enero hasta hoy han llegado ($all) dosis de vacunas COVID al Ecuador."
  (char newline)

  total-vaccines-by-manufacturer | each {
      $"(char -u 1F539) ($it.vaccine): ($it.total) (char newline)"
  } | str collect
}

def "ecuacovid report-overall" [] {
  let data = (open datos_crudos/ecuacovid.json | last 2);
  let previous_day = ($data | nth 0);
  let record = ($data | nth 1);

  let date = ($record | get created_at | parse-date);
  let cases = ($record | select positivas_pcr positivas_pcr_nuevas | rename cases new_cases);
  let deaths = ($record | select muertes muertes_nuevas | rename deaths new_deaths);
  let tests = ($record | select muestras_pcr muestras_pcr_nuevas | rename tests new_tests);

  let positivity = (echo $record $previous_day | each {
    ($it.positivas_pcr / ($it.positivas_pcr + $it.negativas_pcr) * 100)
  });
  
  let positivity = ([[positivity]; [$positivity.1]] |
    insert new_positivity { 
      = $positivity.1 - $positivity.0 | into string -d 2
    } | update positivity {
      get positivity | into string -d 2
  });

  let hospitalized = (echo $record $previous_day | each {
    = $it.hospitalizadas_estables + $it.hospitalizadas_pronostico_reservadas
  });

  let hospitalized = ([[hospitalized]; [$hospitalized.1]] |
    insert new_hospitalized { 
      = $hospitalized.1 - $hospitalized.0
  });

  let vaccinated = (vaccines | last | get segunda_dosis) / 17468736 | into string -d 2;

  $"(char -u 1F1EA 1F1E8)  #Ecuador ($date.day)-($date.month)-($date.year)"
  (char newline)

  $" (char -u 1F539)Casos: ($cases.cases) ('(')($cases.new_cases)(')')"
  (char newline)

  $" (char -u 1F539)Fallecidos MSP: ($deaths.deaths) ('(')($deaths.new_deaths)(')')"
  (char newline)

  $" (char -u 1F539)Pruebas: ($tests.tests) ('(')($tests.new_tests)(')')"
  (char newline)

  $" (char -u 1F539)Positividad: ($positivity.positivity)% ('(')($positivity.new_positivity)%(')')"
  (char newline)

  $" (char -u 1F539)Hospitalizados: ($hospitalized.hospitalized) ('(')($hospitalized.new_hospitalized)(')')"
  (char newline)

  $" (char -u 1F539)Vacunados: ($vaccinated)%"
  (char newline)
}