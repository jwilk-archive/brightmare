#include <caml/alloc.h>
#include <caml/memory.h>
#include <langinfo.h>
#include <locale.h>

static char* charmap = NULL;

value locale_initialize(value unit)
{
  CAMLparam1(unit);
  setlocale(LC_ALL, "");
  charmap = nl_langinfo(CODESET);
  CAMLreturn(Val_unit);
}

value locale_charmap(value unit)
{
  CAMLparam1(unit);
  if (!charmap)
    locale_initialize(Val_unit);
  CAMLreturn(caml_copy_string(charmap));
}

/* vim: set tw=96 et ts=2 sw=2: */

