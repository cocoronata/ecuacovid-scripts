def hide-ad [] {
  ls *.png | where name =~ chart | each {
    $"convert ($it.name) ../assets/misc/cover.png -gravity northeast -composite ($it.name)"
  } | str collect (char newline)
}

def copy-flags [] {
  each --numbered {
    let path = ("../assets/flags/" | path join -a $it.item.img);

    $"convert ($path) -resize 30x30 flag_for_(as-two-digit-string $it.index).png"
  } | str collect (char newline)
}

def blank-page [] {
  $"convert -size 1440x1200! canvas:#fff9f5 cases_background.png"
}

def box-row [id] {
  let padding = 100;
  let y = ($id / 5 | math ceil) * 200 + $padding;

  $"chart(as-two-digit-string $id).png -gravity northwest -geometry     +0+($y) -composite \
    chart(as-two-digit-string ($id + 1)).png -gravity northwest -geometry   +350+($y) -composite \
    chart(as-two-digit-string ($id + 2)).png -gravity northwest -geometry   +720+($y) -composite \
    chart(as-two-digit-string ($id + 3)).png -gravity northwest -geometry  +1070+($y) -composite \"
}

def page [] {
  $"(box-row  0)
    (box-row  4)
    (box-row  8)
    (box-row 12)
    (box-row 16)"
}

def last-page [] {
  $"(box-row  0)
    (box-row  4)"  
}

def make-point [position, origin , padding] {
  let x = $padding.0.x + ($position mod 2 * $origin.0.x);
  let y = $padding.0.y + (($position / 2) | math floor) * $origin.0.y;

  $"+($x)+($y)"
}

def draw-flags [origin, padding] {
  for i in 0..<($in | length) {
    let flag_name = $"flag_for_(as-two-digit-string $i).png";
    let position = (make-point $i $origin $padding);

    $"($flag_name) -gravity northwest -geometry ($position) -composite"
  }
}

def draw-names [origin, padding] {
  each --numbered {
    let province_name = $it.item.province;
    let position = (make-point $it.index $origin $padding);

    $"-gravity northwest -font '../assets/fonts/Lato-Regular.ttf' -pointsize 22 -annotate ($position) '($province_name)'"
  }  
}

def draw-averages [origin, padding] {
  each --numbered {
    let content = $"($it.item.average_per_day) casos diarios ('(')promedio(')')";
    let position = (make-point $it.index $origin $padding);
    
    $"-gravity northwest -font '../assets/fonts/Lato-Regular.ttf' -gravity northwest -pointsize 16 -annotate ($position) '($content)'"
  }
}

def draw-total-cases [origin, padding] {
  each --numbered {
    let content = $"($it.item.total) casos"
    let position = (make-point $it.index $origin $padding);

    $"-gravity northwest -font '../assets/fonts/Lato-Regular.ttf' -gravity northwest -pointsize 16 -annotate ($position) '($content)'"
  }
}

def draw [provinces] {
  let origin = [
    [x,     y];
    [700, 200];
  ]

  let flag_padding = [
    [  x,   y];
    [ 30, 100]
  ];

  let province_name_padding = [
    [  x,   y];
    [ 65,  95]
  ];

  let averages_padding = [
    [  x,   y];
    [200, (5 + $province_name_padding.0.y)]
  ];

  let total_cases_padding = [
    [  x,   y];
    [600, 100]
  ];
  
  let metadata = (open metadata.json);

  let names = ($provinces | draw-names $origin $province_name_padding);
  let flags = ($provinces | draw-flags $origin $flag_padding);
  let daily_averages = ($metadata | draw-averages $origin $averages_padding);
  let total_cases = ($metadata | draw-total-cases $origin $total_cases_padding);

  (echo ($flags)
        ($names)
        ($daily_averages)
        ($total_cases)
  ) | each {
    $it + ' ' + (char -u "005C")
  } | str collect (char newline)
}
