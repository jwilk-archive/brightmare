#include <caml/alloc.h>
#include <caml/memory.h>
#include <langinfo.h>
#include <locale.h>

int locale_initialized = 0;

value locale_initialize(value unit)
{
  CAMLparam1(unit);
  setlocale(LC_ALL, "");
  locale_initialized = 1;
  CAMLreturn(Val_unit);
}

value locale_charmap(value unit)
{
  CAMLparam1(unit);
  if (!locale_initialized)
    locale_initialize(Val_unit);
  CAMLreturn(caml_copy_string(nl_langinfo(CODESET)));
}

/* vim: set tw=96 et ts=2 sw=2: */

