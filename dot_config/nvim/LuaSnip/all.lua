local snippet = require("luasnip").snippet

return {
  snippet(
    { trig = "hi" },
    { t("Hello, world!") }
  ),

  snippet(
    { trig = "foo" },
    { t("bar") }
  ),
}
