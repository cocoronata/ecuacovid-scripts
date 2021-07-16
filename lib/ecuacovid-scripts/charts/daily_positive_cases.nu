source lib/ecuacovid-scripts/charts/daily_positive_cases/page.nu
source lib/ecuacovid-scripts/charts/daily_positive_cases/viz.nu

def workspace [path, block] {
  do -i { rm 'metadata.json' } { }
  bash-program $block
  do -i { ls *.png | where name =~ flag_for || name =~ chart | each { rm $it.name } }
}

def main [] {
  let provinces = (open ../assets/provinces.yml | skip $SKIP | keep $N);
  
  $provinces | pull-charts;

  append (_hide-ad) |
  append ($provinces | _copy-flags) |
  append (blank-page) |
  append $"convert cases_background.png \" |
  append (if $SKIP < 20 {page} {last-page}) |
  append ($provinces | draw) |
  append $"cases_background.png
       
        cp background.png out.png

        convert cases_background.png \
          out.png -gravity northwest -geometry +0+0 -composite \
         out.png"
}
