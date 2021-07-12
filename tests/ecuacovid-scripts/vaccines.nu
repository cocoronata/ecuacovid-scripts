playground "Vaccines" {

  let data = (given { manufacturers });

  play "by manufacturer" {
    let actual = ($data | where arrived_at == "20/01/2021");
    let expected = [[vaccine, total, arrived_at, contract]; [Pfizer/BioNTech, 8190, 20/01/2021, "Government of Ecuador with Pfizer"]];

    expect $actual --to-eq $expected
  }

}
