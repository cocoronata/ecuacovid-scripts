enter ecuacovid-nu
nu plugin --load exe
exit

source lib/ecuacovid-scripts.nu
cd ecuacovid-nu
enter .

for page in 0..<3 {
  workspace "" {
    make-positive-cases-chart ([
      [        SKIP,  N, PAGE_NO];
      [(10 * $page), 10,   $page]
    ]);
  }
}
