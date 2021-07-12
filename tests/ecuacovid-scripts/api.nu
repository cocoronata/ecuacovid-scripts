playground "API" {
  
  source tests/criterios.nu 
  
  play "data for latest (present) day" {
    let data = (given {
      positives today
    });
    
    let actual = ($data | select total);
    let expected = (positives-expectations | last | select total);

    expect $actual --to-eq $expected
  }

  play "data for provinces" --tag "slow" {
    let data = (given {
      positives provinces
    });

    let actual = ($data | where provincia == Guayas && created_at == "27/03/2021" | select provincia total);
    let expected = [[provincia, total]; [Guayas, 41733]];

    expect $actual --to-eq $expected
  }

}
