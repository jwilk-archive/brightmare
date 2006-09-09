#include <caml/alloc.h>
#include <caml/memory.h>
#include <langinfo.h>
#include <locale.h>

static char *charmap = NULL;

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

value utf8string_of_string(value s)
{
  char *source;
  size_t length;
  value result;
  CAMLparam1(s);
  if (!charmap)
    locale_initialize();
  source = String_val(s);
  length = 1 + mbstowcs(NULL, source, 0);
  {
    wchar_t unir[length];
    char utf8r[3 * length];
    int i, j;
    mbstowcs(unir, source, length);
    for (i = 0, j = 0; i<length; i++)
    {
      if (unir[i] < 0x80)
        utf8r[j++]=unir[i];
      else if (unir[i] < 0x800)
      {
        utf8r[j++] = 0xc0 | ((unir[i] >> 6) & 0x1f);
        utf8r[j++] = 0x80 | ( unir[i]       & 0x3f);
      }
      else if (unir[i] < 0x10000)
      {
        utf8r[j++] = 0xe0 | ((unir[i] >> 12) & 0x0f);
        utf8r[j++] = 0x80 | ((unir[i] >>  6) & 0x3f);
        utf8r[j++] = 0x80 | ( unir[i]        & 0x3f);
      }
      else
        utf8r[j++] = '?';
    }
    utf8r[j] = '\0';
    result = copy_string(utf8r);
  }
  CAMLreturn(result);
}

/* vim: set tw=96 et ts=2 sw=2: */

