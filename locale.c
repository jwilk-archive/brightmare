#include <caml/alloc.h>
#include <caml/memory.h>
#include <langinfo.h>
#include <locale.h>

static char* charmap = NULL;

void locale_initialize(void)
{
  setlocale(LC_ALL, "");
  charmap = nl_langinfo(CODESET);
}

value locale_charmap(value unit)
{
  CAMLparam1(unit);
  if (!charmap)
    locale_initialize();
  CAMLreturn(copy_string(charmap));
}

/* vim: set tw=96 et ts=2 sw=2: */

