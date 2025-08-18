///|
priv struct Formated {
  str : String
  bg_color : Color?
  color : Color?
  formats : Array[Format]
}

///|
priv enum Format {
  Bold
  Underline
  Blink
  Inverse
  Hidden
  Strikethrough
  Italic
}

///|
priv enum Color {
  Black
  Red
  Green
  Yellow
  Blue
  Magenta
  Cyan
  White
  Default
}

///|
fn[T : Show] debug_string(value : T) -> String {
  value.to_string()
}

///|
impl Show for Formated with output(self : Formated, logger : &Logger) -> Unit {
  logger.write_string(self.to_string())
}

///|
fn Formated::to_string(self : Formated) -> String {
  let styles = []
  match self.color {
    Some(color) => styles.push(color.to_color_code())
    None => ()
  }
  match self.bg_color {
    Some(bg_color) => styles.push(bg_color.to_bg_color_code())
    None => ()
  }
  for format in self.formats {
    match format {
      Bold => styles.push("1")
      Underline => styles.push("4")
      Blink => styles.push("5")
      Inverse => styles.push("7")
      Hidden => styles.push("8")
      Strikethrough => styles.push("9")
      Italic => styles.push("3")
    }
  }
  if styles.length() > 0 {
    let style_string = styles.join(";")
    "[\{style_string}m\{self.str}[0m"
  } else {
    self.str
  }
}

///|
fn to_color_code(self : Color) -> String {
  match self {
    Black => "30"
    Red => "31"
    Green => "32"
    Yellow => "33"
    Blue => "34"
    Magenta => "35"
    Cyan => "36"
    White => "37"
    Default => "39"
  }
}

///|
fn to_bg_color_code(self : Color) -> String {
  match self {
    Black => "40"
    Red => "41"
    Green => "42"
    Yellow => "43"
    Blue => "44"
    Magenta => "45"
    Cyan => "46"
    White => "47"
    Default => "49"
  }
}

///|
fn Formated::format(str : String) -> Formated {
  { str, bg_color: None, color: None, formats: [] }
}

///|
fn red(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Red),
    formats: self.formats,
  }
}

///|
fn bg_red(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Red),
    color: self.color,
    formats: self.formats,
  }
}

///|
fn yellow(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Yellow),
    formats: self.formats,
  }
}

///|
fn bg_yellow(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Yellow),
    color: self.color,
    formats: self.formats,
  }
}

///|
fn green(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Green),
    formats: self.formats,
  }
}

///|
fn bg_green(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Green),
    color: self.color,
    formats: self.formats,
  }
}

///|
fn blue(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Blue),
    formats: self.formats,
  }
}

///|
fn bg_blue(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Blue),
    color: self.color,
    formats: self.formats,
  }
}

///|
fn magenta(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Magenta),
    formats: self.formats,
  }
}

///|
fn bg_magenta(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Magenta),
    color: self.color,
    formats: self.formats,
  }
}

///|
fn cyan(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Cyan),
    formats: self.formats,
  }
}

///|
fn bg_cyan(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Cyan),
    color: self.color,
    formats: self.formats,
  }
}

///|
fn white(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(White),
    formats: self.formats,
  }
}

///|
fn bg_white(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(White),
    color: self.color,
    formats: self.formats,
  }
}

///|
fn black(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Black),
    formats: self.formats,
  }
}

///|
fn bg_black(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Black),
    color: self.color,
    formats: self.formats,
  }
}

///|
fn default_color(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Default),
    formats: self.formats,
  }
}

///|
fn default_bg_color(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Default),
    color: self.color,
    formats: self.formats,
  }
}

///|
fn bold(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: self.color,
    formats: [Bold, ..self.formats],
  }
}

///|
fn underline(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: self.color,
    formats: [Underline, ..self.formats],
  }
}

///|
fn blink(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: self.color,
    formats: [Blink, ..self.formats],
  }
}

///|
fn inverse(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: self.color,
    formats: [Inverse, ..self.formats],
  }
}

///|
fn hidden(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: self.color,
    formats: [Hidden, ..self.formats],
  }
}

///|
fn strikethrough(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: self.color,
    formats: [Strikethrough, ..self.formats],
  }
}

///|
fn italic(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: self.color,
    formats: [Italic, ..self.formats],
  }
}
