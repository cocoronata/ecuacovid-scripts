source lib/ecuacovid-scripts.nu
source tests/test_support.nu

playground "Vaccines" {
  let data = $(given { manufacturers });

  play "by manufacturer" {
    let actual = $(echo $data | where arrived_at == "20/01/2021");
    let expected = $(echo [[vaccine, total, arrived_at]; [Pfizer/BioNTech, 8190, 20/01/2021]]);

    expect $actual --to-eq $expected
  }
}

playground "Positive Cases" {
  source tests/criterios.nu 

  play "API" {
    play "data for latest (present) day" {
      let data = $(given {
        positives today
      });

      let actual = $(echo $data | select total);
      let expected = $(positives-expectations | last | select total);

      expect $actual --to-eq $expected
    }

    play "data for provinces" --tag "slow" {
      let data = $(given {
        positives provinces
      });

      let actual = $(echo $data | where provincia == Guayas && created_at == "27/03/2021" | select provincia total);
      let expected = $(echo [[provincia, total]; [Guayas, 41733]]);

      expect $actual --to-eq $expected
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