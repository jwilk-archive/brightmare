let self = Dictionary.from_list [
  (* -- spacing -- *)
  "\\!",          (0, 0);
  "\\+",          (0, 0);
  "\\,",          (0, 0);
  "\\;",          (0, 0);
  (* -- spacing, part II -- *)
  "\\hfill",      (0, 0);
  "\\vfill",      (0, 0);
  "\\hspace",     (0, 1);
  "\\hspace*",    (0, 1);
  "\\vspace",     (0, 1);
  "\\vspace*",    (0, 1);
  "\\medskip",    (0, 0);
  "\\smallskip",  (0, 0);
  "\\bigskip",    (0, 0);
  (* -- math miscellany -- *)
  "\\cdots",      (0, 0);
  "\\ddots",      (0, 0);
  "\\ldots",      (0, 0);
  "\\vdots",      (0, 0);
  "\\dotfill",    (0, 0);
  "\\frac",       (0, 2);
  "\\underbrace", (0, 1);
  "\\underline",  (0, 1);
  "\\overbrace",  (0, 1);
  "\\overline",   (0, 1);
  "\\sqrt",       (1, 1);
  (* -- greek letters -- *)
  "\\alpha",      (0, 0);
  "\\beta",       (0, 0);
  "\\gamma",      (0, 0);
  "\\delta",      (0, 0);
  (* -- other things -- *)
  "\\backslash",  (0, 0);
  "\\hrulefill",  (0, 0);
  "\\fbox",       (0, 1);
  "\\mbox",       (0, 1);
  "\\binom",      (0, 2);
  "_",            (0, 1);
  "^",            (0, 1)
  ];

(* vim: set tw=96 et ts=2 sw=2: *)
