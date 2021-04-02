playground "Vaccines" {
  let data = $(given { manufacturers });

  play "by manufacturer" {
    let actual = $(echo $data | where arrived_at == "20/01/2021");
    let expected = $(echo [[vaccine, total, arrived_at]; [Pfizer/BioNTech, 8190, 20/01/2021]]);

    expect $actual --to-eq $expected
  }
}