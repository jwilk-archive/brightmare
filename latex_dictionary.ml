let commands = Dictionary.from_list [
  (* -- spacing -- *)
  "\\!",  (0, 0);
  "\\+",  (0, 0);
  "\\,",  (0, 0);
  "\\;",  (0, 0);
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
  "\\overleftarrow",
                  (0, 1);
  "\\overrightarrow",
                  (0, 1);
  "\\sqrt",       (1, 1);
 (* -- other things -- *)
  "\\backslash",  (0, 0);
  "\\hrulefill",  (0, 0);
  "\\fbox",       (0, 1);
  "\\mbox",       (0, 1);
  "\\binom",      (0, 2);
  "_",            (0, 1);
  "^",            (0, 1)
  ];;

let alphabets = Dictionary.from_list [
  "\\mathrm",     ();
  "\\mathbf",     ();
  "\\mathsf",     ();
  "\\mathtt",     ();
  "\\mathit",     ();
  "\\mathnormal", ();
  "\\mathcal",    ();
  "\\mathscr",    ();
  "\\mathbb",     ();
  "\\textrm",     ();
  "\\textit",     ();
  "\\emph",       ();
  "\\textmd",     ();
  "\\textbf",     ();
  "\\textup",     ();
  "\\textsl",     ();
  "\\textsf",     ();
  "\\testsc",     ();
  "\\texttt",     ();
  "\\textnormal", ()
]

let symbols = Dictionary.from_list [
  "\\{",          123;
  "\\}",          125;
  "\\alpha",      945;
  "\\beta",       946;
  "\\gamma",      947;
  "\\delta",      948;
  "\\epsilon",    949;
  "\\zeta",       950;
  "\\eta",        951;
  "\\theta",      952;
  "\\iota",       953;
  "\\kappa",      954;
  "\\lambda",     955;
  "\\mu",         956;
  "\\nu",         957;
  "\\xi",         958;
  "\\pi",         960;
  "\\rho",        961;
  "\\sigma",      963;
  "\\tau",        964;
  "\\upsilon",    965;
  "\\phi",        981;
  "\\chi",        967;
  "\\psi",        968;
  "\\omega",      969;
  "\\digamma",    988;
  "\\varepsilon", 8714;
  "\\vartheta",   977;
  "\\varrho",     1009;
  "\\varkappa",   1008;
  "\\varsigma",   962;
  "\\varphi",     966;
  "\\Gamma",      915;
  "\\Delta",      916;
  "\\Theta",      920;
  "\\Lamdba",     923;
  "\\Xi",         926;
  "\\Pi",         928;
  "\\Sigma",      931;
  "\\Upsilon",    933;
  "\\Phi",        934;
  "\\Psi",        936;
  "\\Omega",      937;
  "\\aleph",      8501;
  "\\beth",       8502;
  "\\gimel",      8503;
  "\\daleth",     8504;
  
  "\\pm",         177;
  "\\mp",	        0;  
  "\\setminus",	  0;
  "\\cdot",	      0;
  "\\times",	    0;
  "\\ast",	      0;
  "\\star",	      0;
  "\\diamond",	  0;
  "\\circ",	      0;
  "\\bullet",	    0;
  "\\div",	      0;
  "\\lhd",	      0;
  "\\vee",	      0;
  "\\wedge",	    0;
  "\\oplus",	    8853;
  "\\ominus",	    0;
  "\\otimes",	    8855;
  "\\oslash",	    0;
  "\\cap",	      0;
  "\\cup",	      0;
  "\\uplus",	    0;
  "\\sqcap",	    0;
  "\\sqcup",	    0;
  "\\triangleleft", 
                  0;
  "\\trangleright", 
                  0;
  "\\wr",	        0;
  "\\bigcirc",	  0;
  "\\bigtriangleup",  
                  0;
  "\\bigtriangledown",
                  0;
  "\\rhd",	      0;
  "\\odot",	      0;
  "\\dagger",	    0;
  "\\ddagger",	  0;
  "\\amalg",	    0;
  "\\unlhd",	    0;
  "\\unrhd",	    0;

  "\\varnothing", 8709;
  "\\ne",         8800;
  "\\in",         8712;
  "\\nin",        8713;
  "\\ni",         8715;
  "\\forall",     8704;
  "\\exists",     8707
];;

(* vim: set tw=96 et ts=2 sw=2: *)
