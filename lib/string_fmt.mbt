priv struct Formated {
  str : String
  bg_color : Option[Color]
  color : Option[Color]
  formats : List[Format]
}

priv enum Format {
  Bold
  Underline
  Blink
  Inverse
  Hidden
  Strikethrough
  Italic
}

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

fn debug_string[T : Debug](value : T) -> String {
  let buffer = Buffer::make(10)
  value.debug_write(buffer)
  buffer.to_string()
}

fn to_string(self : Formated) -> String {
  let mut styles = List::Nil
  match self.color {
    Some(color) => styles = List::Cons(to_color_code(color), styles)
    None => ()
  }
  match self.bg_color {
    Some(bg_color) => styles = List::Cons(to_bg_color_code(bg_color), styles)
    None => ()
  }
  let mut formats = self.formats
  loop formats {
    List::Cons(format, rest) => {
      formats = rest
      match format {
        Bold => styles = List::Cons("1", styles)
        Underline => styles = List::Cons("4", styles)
        Blink => styles = List::Cons("5", styles)
        Inverse => styles = List::Cons("7", styles)
        Hidden => styles = List::Cons("8", styles)
        Strikethrough => styles = List::Cons("9", styles)
        Italic => styles = List::Cons("3", styles)
      }
      continue rest
    }
    List::Nil => ()
  }
  match styles {
    List::Cons(_, _) => {
      let mut ans = "["
      loop styles {
        List::Cons(style, rest) => {
          styles = rest
          if ans.length() == 0 {
            ans = style
          } else {
            ans = ans + ";" + style
          }
          continue rest
        }
        List::Nil => ()
      }
      ans + "m" + self.str + "[0m"
    }
    List::Nil => self.str
  }
}

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

fn Formated::format(str : String) -> Formated {
  { str, bg_color: None, color: None, formats: List::Nil }
}

fn red(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Red),
    formats: self.formats,
  }
}

fn bg_red(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Red),
    color: self.color,
    formats: self.formats,
  }
}

fn yellow(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Yellow),
    formats: self.formats,
  }
}

fn bg_yellow(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Yellow),
    color: self.color,
    formats: self.formats,
  }
}

fn green(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Green),
    formats: self.formats,
  }
}

fn bg_green(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Green),
    color: self.color,
    formats: self.formats,
  }
}

fn blue(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Blue),
    formats: self.formats,
  }
}

fn bg_blue(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Blue),
    color: self.color,
    formats: self.formats,
  }
}

fn magenta(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Magenta),
    formats: self.formats,
  }
}

fn bg_magenta(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Magenta),
    color: self.color,
    formats: self.formats,
  }
}

fn cyan(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Cyan),
    formats: self.formats,
  }
}

fn bg_cyan(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Cyan),
    color: self.color,
    formats: self.formats,
  }
}

fn white(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(White),
    formats: self.formats,
  }
}

fn bg_white(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(White),
    color: self.color,
    formats: self.formats,
  }
}

fn black(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Black),
    formats: self.formats,
  }
}

fn bg_black(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Black),
    color: self.color,
    formats: self.formats,
  }
}

fn default_color(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: Some(Default),
    formats: self.formats,
  }
}

fn default_bg_color(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: Some(Default),
    color: self.color,
    formats: self.formats,
  }
}

fn bold(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: self.color,
    formats: List::Cons(Bold, self.formats),
  }
}

fn underline(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: self.color,
    formats: List::Cons(Underline, self.formats),
  }
}

fn blink(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: self.color,
    formats: List::Cons(Blink, self.formats),
  }
}

fn inverse(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: self.color,
    formats: List::Cons(Inverse, self.formats),
  }
}

fn hidden(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: self.color,
    formats: List::Cons(Hidden, self.formats),
  }
}

fn strikethrough(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: self.color,
    formats: List::Cons(Strikethrough, self.formats),
  }
}

fn italic(self : Formated) -> Formated {
  {
    str: self.str,
    bg_color: self.bg_color,
    color: self.color,
    formats: List::Cons(Italic, self.formats),
  }
}
