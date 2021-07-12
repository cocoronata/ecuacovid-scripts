playground "Positive Cases" {
  source tests/criterios.nu 

  play "lib" {

    play "checks the region" {

      play "región insular" {

        let data = (given {
          region-insular |
          wrap provincia
        });

        let actual = ($data | region | uniq);
      
        expect ($actual | length) --to-eq 1
        expect ($actual | nth 0) --to-eq "region_insular"
      }

      play "sierra" {
        let data = (given {
          sierra |
          wrap provincia
        });

        let actual = ($data | region | uniq);
      
        expect ($actual | length) --to-eq 1
        expect ($actual | nth 0) --to-eq "sierra"
      }

      play "amazonia" {
        let data = (given {
          amazonia | wrap provincia
        });

        let actual = ($data | region | uniq);
      
        expect ($actual | length) --to-eq 1
        expect ($actual | nth 0) --to-eq "amazonia"
      }

      play "costa" {
        let data = (given {
          costa | wrap provincia
        });

        let actual = ($data | region | uniq);
      
        expect ($actual | length) --to-eq 1
        expect ($actual | nth 0) --to-eq "costa"
      }
    }
    
    play "groups by region" {
      let data = (given {
        echo (costa) (sierra) (amazonia) (region-insular) |
        wrap provincia
      });

      let actual = ($data | by-region | get);

      expect $actual --to-eq (echo "costa" "sierra" "amazonia" "region_insular")
     }

  }

  play "National total cases checks" {
    
    positives-expectations | each {
      let record_date = $it.created_at;

      play $"in ($it.created_at) ('(')provincias.csv(')')" --tag "slow" {
        let source_file = (positives path-from $it.created_at "provincias.csv");
        let actual = (open $source_file | where created_at == $record_date | select total | math sum);

        expect $actual --to-eq [[total]; [$it.total]]
      }
    } | str collect

    positives-expectations | each {
      play $"in ($it.created_at) ('(')provincias_por_dia_acumuladas.csv(')')" --tag "slow" {
        let source_file = (positives path-from $it.created_at "por_fecha/provincias_por_dia_acumuladas.csv");
        let actual = (open $source_file | select $it.created_at | math sum | rename total);

        expect $actual --to-eq [[total]; [$it.total]]
      }
    } | str collect

    positives-expectations | each {
      let record_date = $it.created_at;
  
      play $"in ($it.created_at) ('(')ecuacovid.csv(')')" {
        let actual = (open "datos_crudos/ecuacovid.csv" | where created_at == $record_date | select positivas_pcr | rename total);

        expect $actual --to-eq [[total]; [$it.total]]
      }
    } | str collect

  }

}
