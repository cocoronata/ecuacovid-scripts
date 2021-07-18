def make-chart [ty, --places:any, --provinces(-p)] {
  ($nothing | ecuacovid chart --chart $ty --places $places -p)
}

def make-monthly-chart [place] {
  make-chart :monthly_positive_cases --places $place -p
}

def make-daily-chart [place] {
  make-chart :daily_positive_cases --places $place -p
}

def pull-charts [] {
  each --numbered {
    let value = $it.index * 2;
    
    let place = [
        [city, province];
        [$it.item.capital, $it.item.province]
    ];
    
    let daily = (make-daily-chart $place);
    let monthly = (make-monthly-chart $place);

    let daily_summary = ($daily |
        select average_per_day total |
        rename average_per_day total_last60_day
    );

    let monthly_summary = ($monthly |
        select total
    );

    if ('metadata.json' | path exists) {
      open metadata.json | append $daily_summary | save metadata.json
    } {
        $daily_summary | save metadata.json
    }  

    if ('metadata_per_month.json' | path exists) {
      open metadata_per_month.json | append $monthly_summary | save metadata_per_month.json
    } {
      $monthly_summary | save metadata_per_month.json
    }  

    $daily.url | each {
        fetch $it |
        save $"chart(as-two-digit-string $value).png"
    }

    $monthly.url | each {
        fetch $it |
        save $"chart(as-two-digit-string (1 + $value)).png"
    }
  }

  open metadata.json | merge {
    open metadata_per_month.json
  } | save

  rm metadata_per_month.json
}
