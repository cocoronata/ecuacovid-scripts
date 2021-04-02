playground "Positive Cases" {
  source tests/criterios.nu 

  play "lib" {
    play "checks the region" {
      let data = $(given {
        echo Azuay Bolívar Cañar Carchi Cotopaxi Chimborazo Imbabura Loja Pichincha Tungurahua |
        wrap provincia
      });

      let actual = $(echo $data | region | uniq);
      
      expect $(echo $actual | length) --to-eq 1
      expect $(echo $actual | nth 0) --to-eq "sierra"
    }
    
    play "groups by region" {
      let data = $(given {
        echo Azuay Bolívar Cañar Carchi Cotopaxi Chimborazo Imbabura Loja Pichincha Tungurahua |
        wrap provincia
      });

      let actual = $(echo $data | by-region | get sierra | length);

      expect $actual --to-eq $(echo $data | length)
     }
  }

  play "National total cases checks" {
    positives-expectations | each {
      let record_date = $it.created_at;

      play $(= `in {{$it.created_at}} (provincias.json)`) --tag "slow" {
        let source_file = $(positives path-from $it.created_at "provincias.json");
        let actual = $(open $source_file | where created_at == $record_date | select total | math sum);

        expect $actual --to-eq $(= [[total]; [$it.total]])
      }
    } | str collect

    positives-expectations | each {
      play $(= `in {{$it.created_at}} (provincias_por_dia_acumuladas.csv)`) --tag "slow" {
        let source_file = $(positives path-from $it.created_at "por_fecha/provincias_por_dia_acumuladas.csv");
        let actual = $(open $source_file | select $it.created_at | math sum | rename total);

        expect $actual --to-eq $(= [[total]; [$it.total]])
      }
    } | str collect

    positives-expectations | each {
      let record_date = $it.created_at;
  
      play $(= `in {{$it.created_at}} (ecuacovid.csv)`) {
        let actual = $(open "datos_crudos/ecuacovid.csv" | where created_at == $record_date | select positivas_pcr | rename total);

        expect $actual --to-eq $(= [[total]; [$it.total]])
      }
    } | str collect
  }
}