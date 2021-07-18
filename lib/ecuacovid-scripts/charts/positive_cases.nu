source lib/ecuacovid-scripts/charts/positive_cases/page.nu
source lib/ecuacovid-scripts/charts/positive_cases/viz.nu

def workspace [path, block] {
  do -i { rm 'metadata.json' } { }
  bash-program $block
  do -i { ls *.png | where name =~ flag_for || name =~ chart || name =~ cases_background | each { rm $it.name } }
}

def make-positive-cases-chart [options] {
  let options = ([[SKIP, N, PAGE_NO]; [0, 10, 1]] | merge { $options });

  let SKIP = $options.SKIP;
  let N = $options.N;
  let PAGE = $options.PAGE_NO;

  let provinces = (open ../assets/provinces.yml | skip $SKIP | keep $N);

  $provinces | pull-charts;

  append (hide-ad) |
  append ($provinces | copy-flags) |
  append (blank-page) |
  append $"convert cases_background.png \" |
  append (if $SKIP < 20 {page} {last-page}) |
  append ($provinces | draw $in) |
  append $"cases_background.png
       
        cp ../assets/misc/background.png out.png

        convert cases_background.png \
          out.png -gravity northwest -geometry +0+0 -composite \
         out.png
         
        mv out.png daily_positive_cases_(as-two-digit-string $PAGE).png"
}
