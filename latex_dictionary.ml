include Dictionary2

let main_commands = make [
(* spacing:: *)               (* TODO: not implemented *)
  "\\!",          (0, 0);
  "\\+",          (0, 0);
  "\\,",          (0, 0);
  "\\;",          (0, 0);
  "\\bigskip",    (0, 0);
  "\\hfill",      (0, 0);
  "\\hspace",     (0, 1);
  "\\hspace*",    (0, 1);
  "\\medskip",    (0, 0);
  "\\smallskip",  (0, 0);
  "\\vfill",      (0, 0);
  "\\vspace",     (0, 1);
  "\\vspace*",    (0, 1);
(* math miscellany:: *)       (* TODO: not implemented *)
  "\\dotfill",    (0, 0);
(* some other commands:: *)   (* TODO: not implemented *)
  "\\hrulefill",  (0, 0);
  "\\fbox",       (0, 1);
  "\\mbox",       (0, 1);
(* math-mode accents:: *)     (* TODO: not implemented *)
  "\\acute",      (0, 0);
  "\\bar",        (0, 1);
  "\\breve",      (0, 1);
  "\\check",      (0, 1);
  "\\ddot",       (0, 1);
  "\\dot",        (0, 1);
  "\\grave",      (0, 1);
  "\\hat",        (0, 1);
  "\\tilde",      (0, 1);
  "\\vec",        (0, 1);
  "\\widehat",    (0, 1);
  "\\widetilde",  (0, 1);
(* some other constructions:: *)
  "_",                (0, 1);
  "^",                (0, 1);
  "\\frac",           (0, 2);
  "\\cfrac",          (0, 2);
  "\\genfrac",        (0, 6); (* TODO: not implemented *)
  "\\binom",          (0, 2); (* TODO: not implemented *)
  "\\sqrt",           (1, 1);
(* hmm... *)
  "\\mathop",         (0, 1);
  "\\displaystyle",   (0, 0)
]

let ornaments = make [
  "\\overbrace",      ();
  "\\overleftarrow",  ();
  "\\overline",       ();
  "\\overrightarrow", ();
  "\\underbrace",     ();
  "\\underline",      ();
]

let ornament_commands =
  map (fun () -> (0, 1)) ornaments

let is_ornament command =
  exists command ornaments

let alphabets = make [ (* TODO: not implemented *)
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

let alphabet_commands = 
  map (fun () -> (0, 1)) alphabets

let is_alphabet command =
  exists command alphabets

let operators = make [
(* variable-sized math operators:: *)
  "\\bigcap",     ();
  "\\bigcup",     ();
  "\\bigodot",    ();
  "\\bigoplus",   ();
  "\\bigotimes",  ();
  "\\bigsqcup",   ();
  "\\biguplus",   ();
  "\\bigvee",     ();
  "\\bigwedge",   ();
  "\\coprod",     ();
  "\\int",        ();
  "\\oint",       ();
  "\\prod",       ();
  "\\sum",        ()
]

let operator_commands = 
  map (fun () -> (0, 0)) operators

let loglikes = make [
(* log-like symbols:: *) 
  "\\Pr",         ();
  "\\arccos",     ();
  "\\arcsin",     ();
  "\\arctan",     ();
  "\\arg",        ();
  "\\cos",        ();
  "\\cosh",       ();
  "\\cot",        ();
  "\\coth",       ();
  "\\csc",        ();
  "\\deg",        ();
  "\\det",        ();
  "\\dim",        ();
  "\\exp",        ();
  "\\gcd",        ();
  "\\hom",        ();
  "\\inf",        ();
  "\\injlim",     ();
  "\\ker",        ();
  "\\lg",         ();
  "\\lim",        ();
  "\\liminf",     ();
  "\\limsup",     ();
  "\\ln",         ();
  "\\log",        ();
  "\\max",        ();
  "\\min",        ();
  "\\projlim",    ();
  "\\sec",        ();
  "\\sin",        ();
  "\\sinh",       ();
  "\\sup",        ();
  "\\tan",        ();
  "\\tanh",       ();
  "\\varinjlim",  (); (* FIXME: erroneously implemented *)
  "\\varliminf",  (); (* FIXME: erroneously implemented *)
  "\\varlimsup",  (); (* FIXME: erroneously implemented *)
  "\\varprojlim", (); (* FIXME: erroneously implemented *)
]

let loglike_commands = 
  map (fun () -> (0, 0)) loglikes

let almostallsymbols = make [ (* FIXME: lots of 0s *)
(* LaTeX escapable special characters:: *)
  "\\#",  0x0024;
  "\\$",  0x0025;
  "\\%",  0x0026;
  "\\&",  0x0027;
  "\\\\", 0x005c;
  "\\_",  0x005f;

(* LaTeX commands defined to work both in math and text mode:: *)
  "\\P",          0x00b6;
  "\\S",          0x00a7;
  "\\copyright",  0x00a9;
  "\\dag",        0x2020;
  "\\ddag",       0x2021;
  "\\pounds",     0x00a3;

(* non-ASCII letters:: *)
  "\\aa", 0x00e5;
  "\\AA", 0x00c5;
  "\\ae", 0x00e6;
  "\\AE", 0x00c6;
  "\\DH", 0x00d0;
  "\\dh", 0x00f0;
  "\\DJ", 0x0110;
  "\\dj", 0x0111;
  "\\l",  0x0142;
  "\\L",  0x0141;
  "\\o",  0x00f8;
  "\\O",  0x00d8;
  "\\oe", 0x0153;
  "\\OE", 0x0152;
  "\\ss", 0x00df;
  "\\SS", 0;
  "\\TH", 0x00de;
  "\\th", 0x00f0;

(* predefined LaTeX text-mode commands --- TODO *)

(* binary operators:: *)
  "\\amalg",            0x08a2;
  "\\ast",              0x2217;
  "\\bigcirc",          0x25cb;
  "\\bigtriangledown",  0x25bd;
  "\\bigtriangleup",    0x25b3;
  "\\bullet",           0x2219;
  "\\cap",              0x2229;
  "\\cdot",             0x00b7;
  "\\circ",             0x2218;
  "\\cup",              0x222a;
  "\\dagger",           0x2020;
  "\\ddagger",          0x2021;
  "\\diamond",          0x22c4;
  "\\div",              0x00f7;
  "\\lhd",              0x25c1;
  "\\mp",               0x2213;  
  "\\odot",             0x2299;
  "\\ominus",           0x2296;
  "\\oplus",            0x2295;
  "\\oslash",           0x2298;
  "\\otimes",           0x2297;
  "\\pm",               0x00b1;
  "\\rhd",              0x25b7;
  "\\setminus",         0x08a8;
  "\\sqcap",            0x2293;
  "\\sqcup",            0x2294;
  "\\star",             0x22c6;
  "\\times",            0x00d7;
  "\\trangleright",     0x25b9;
  "\\triangleleft",     0x25c3;
  "\\unlhd",            0;
  "\\unrhd",            0;
  "\\uplus",            0x228e;
  "\\vee",              0x2228;
  "\\wedge",            0x2227;
  "\\wr",               0x2240;

(* relation symbols:: *)
  "\\approx",     0x2248;
  "\\asymp",      0x224d;
  "\\bowtie",     0x22c8;
  "\\cong",       0x2245;
  "\\dashv",      0x22a3;
  "\\doteq",      0x2250;
  "\\equiv",      0x2261;
  "\\frown",      0x22be;
  "\\ge",         0x2265;
  "\\geq",        0x2265;
  "\\gg",         0x226b;
  "\\in",         0x2208;
  "\\Join",       0x27d7; (* FIXME - number? *)
  "\\le",         0x2264;
  "\\leq",        0x2264;
  "\\ll",         0x226a;
  "\\mid",        0x2223;
  "\\models",     0x22a7;
  "\\ne",         0x2260;
  "\\neq",        0x2260;
  "\\ni",         0x220b;
  "\\nin",        0x2209; (* FIXME - place? *)
  "\\parallel",   0x2225;
  "\\perp",       0x22a5;
  "\\prec",       0x227a;
  "\\preceq",     0x2aaf;
  "\\propto",     0x221d;
  "\\sim",        0x223c;
  "\\simeq",      0x2243;
  "\\smile",      0x22bf;
  "\\sqsubset",   0x228f;
  "\\sqsubseteq", 0x2291;
  "\\sqsupset",   0x2290;
  "\\sqsupseteq", 0x2292;
  "\\subset",     0x2282;
  "\\subseteq",   0x2286;
  "\\succ",       0x227b;
  "\\succeq",     0x2ab0;
  "\\supset",     0x2283;
  "\\supseteq",   0x2287;
  "\\vdash",      0x22a2;

(* punctuation marks --- TODO *)
(* punctuation symbols:: *)
  "\\colon",  0x003a;
  "\\ldotp",  0x002e; (* FIXME - number? *)
  "\\cdotp",  0x00b7;

(* arrow symbols:: *)
  "\\hookleftarrow",      0x21a9;
  "\\hookrightarrow",     0x21a0;
  "\\leadsto",            0x219d;
  "\\leftarrow",          0x2190;
  "\\Leftarrow",          0x21d0;
  "\\leftharpoondown",    0x21bd;
  "\\leftharpoonup",      0x21bc;
  "\\leftrightarrow",     0x2194;
  "\\Leftrightarrow",     0x21d4;
  "\\leftrightharpoons",  0x21cb;
  "\\longleftarrow",      0x27f5;
  "\\Longleftarrow",      0x27f8;
  "\\longleftrightarrow", 0x27f7;
  "\\Longleftrightarrow", 0x27fa;
  "\\longmapsto",         0x27fc;
  "\\longrightarrow",     0x27f6;
  "\\Longrightarrow",     0x27f9;
  "\\mapsto",             0x21a6;
  "\\nearrow",            0x2197;
  "\\nwarrow",            0x2196;
  "\\rightarrow",         0x2192;
  "\\Rightarrow",         0x21d2;
  "\\rightharpoondown",   0x21c0;
  "\\rightharpoonup",     0x21c0;
  "\\rightleftharpoons",  0x21cc;
  "\\searrow",            0x2198;
  "\\swarrow",            0x2199;
  "\\to",                 0x2192; (* FIXME - place? *)

(* miscellaneous LaTeX symbols:: *)
  "\\angle",        0x2220;
  "\\bot",          0x22a5;
  "\\Box",          0x25a1;
  "\\cdots",        0x22ef;
  "\\clubsuit",     0x2663;
  "\\ddots",        0x22f1;
  "\\Diamond",      0x22c4;
  "\\diamondsuit",  0x2666;
  "\\ell",          0x2113;
  "\\emptyset",     0x2205; (* FIXME - number? *)
  "\\exists",       0x2203;
  "\\flat",         0x266d;
  "\\forall",       0x2200;
  "\\heartsuit",    0x2665;
  "\\Im",           0x2111;
  "\\imath",        0x0131;
  "\\infty",        0x221e;
  "\\jmath",        0;
  "\\dots",         0x2026;
  "\\ldots",        0x2026;
  "\\mho",          0x2127;
  "\\nabla",        0x2207;
  "\\natural",      0x266e;
  "\\neg",          0x00ac;
  "\\partial",      0x2202;
  "\\prime",        0x2032;
  "\\Re",           0x211c;
  "\\sharp",        0x266f;
  "\\spadesuit",    0x2660;
  "\\surd",         0x221a;
  "\\top",          0x22a4;
  "\\triangle",     0x21fd;
  "\\vdots",        0x22ee;
  "\\wp",           0x2118;

(* small Greek letters:: *)
  "\\alpha",      0x03b1;
  "\\beta",       0x03b2;
  "\\gamma",      0x03b3;
  "\\digamma",    0x03dc;
  "\\delta",      0x03b4;
  "\\epsilon",    0x03b5;
  "\\varepsilon", 0x220a;
  "\\zeta",       0x03b6;
  "\\eta",        0x03b7;
  "\\theta",      0x03b8;
  "\\vartheta",   0x03d1;
  "\\iota",       0x03b9;
  "\\kappa",      0x03ba;
  "\\varkappa",   0x03f0;
  "\\lambda",     0x03bb;
  "\\mu",         0x03bc;
  "\\nu",         0x03bd;
  "\\xi",         0x03be;
  "\\pi",         0x03c0;
  "\\varpi",      0x03d6;
  "\\rho",        0x03c1;
  "\\varrho",     0x03f1;
  "\\sigma",      0x03c3;
  "\\varsigma",   0x03c2;
  "\\tau",        0x03c4;
  "\\upsilon",    0x03c5;
  "\\phi",        0x03d5;
  "\\varphi",     0x03c6;
  "\\chi",        0x03c7;
  "\\psi",        0x03c8;
  "\\omega",      0x03c9;

(* big Greek letters:: *)
  "\\Gamma",      0x0393;
  "\\Delta",      0x0394;
  "\\Theta",      0x0398;
  "\\Lamdba",     0x039b;
  "\\Xi",         0x039e;
  "\\Pi",         0x03a0;
  "\\Sigma",      0x03a3;
  "\\Upsilon",    0x03a5;
  "\\Phi",        0x03a6;
  "\\Psi",        0x03a8;
  "\\Omega",      0x03a9;

(* Hebrew letters:: *)
  "\\aleph",      0x2135;
  "\\beth",       0x2136;
  "\\gimel",      0x2137;
  "\\daleth",     0x2138;
 
(* AMS arrows:: *)
  "\\circlearrowleft",      0x21ba;
  "\\circlearrowright",     0x21bb;
  "\\curvearrowleft",       0x21b6;
  "\\curvearrowright",      0x21b7;
  "\\dashleftarrow",        0;
  "\\dashrightarrow",       0;
  "\\downdownarrows",       0x21ca;
  "\\downharpoonleft",      0x21c3;
  "\\downharpoonright",     0x21c2;
  "\\leftwarrowtail",       0;
  "\\leftleftarrows",       0x21c7;
  "\\leftrightarrows",      0x21c6;
  "\\leftrightharpoons",    0x21cb;
  "\\leftrightsquigarrow",  0x21ad;
  "\\Lleftarrow",           0x21da;
  "\\looparrowleft",        0x21ab;
  "\\looparrowright",       0x21ac;
  "\\Lsh",                  0x21b0;
  "\\multimap",             0x22b8;
  "\\rightarrowtail",       0x21a3;
  "\\rightleftarrows",      0x21c4;
  "\\rightleftharpoons",    0x21cc;
  "\\rightrightarrows",     0x21c9;
  "\\rightsquigarrow",      0x219d;
  "\\Rrightarrow",          0x21db;
  "\\Rsh",                  0x21b1;
  "\\twoheadleftarrow",     0x219e;
  "\\twoheadrightarrow",    0x21a0;
  "\\upharpoonleft",        0x21bf;
  "\\upharpoonright",       0x21be;
  "\\upuparrows",           0x21c8;

(* AMS negated arrows:: *)
  "\\nLeftarrow",       0x21cd;
  "\\nleftarrow",       0x219a;
  "\\nLeftrightarrow",  0x21ce;
  "\\nleftrightarrow",  0x21ae;
  "\\nRightarrow",      0x21cf;
  "\\nrightarrow",      0x219b;

(* miscellaneous AMS symbols:: *)
  "\\backprime",          0x2035;
  "\\Bbbk",               0;
  "\\bigstar",            0x2605;
  "\\blacklozenge",       0x29eb;
  "\\blacksquare",        0x25a0;
  "\\blacktriangle",      0x25b4;
  "\\blacktriangledown",  0x25be;
  "\\checkmark",          0x2713;
  "\\circledR",           0x00ae;
  "\\circledS",           0x24c8;
  "\\complement",         0x2201;
  "\\diagdown",           0x2572;
  "\\diagup",             0x2571;
  "\\eth",                0x00f0;
  "\\Finv",               0x2132;
  "\\Game",               0x2141;
  "\\hbar",               0x0126;
  "\\hslash",             0x210f;
  "\\lozenge",            0x25ca;
  "\\maltese",            0x2720;
  "\\measuredangle",      0x2221;
  "\\nexists",            0x2204;
  "\\restriction",        0x21be;
  "\\sphericalangle",     0x2222;
  "\\square",             0x25a1;
  "\\triangledown",       0x25bf;
  "\\varnothing",         0x2205;
  "\\vartriangle",        0x25b5;

(* AMS binary operators:: *)
  "\\barwedge",        0x22bc;
  "\\boxdot",          0x22a1;
  "\\boxminus",        0x229f;
  "\\boxplus",         0x229e;
  "\\boxtimes",        0x22a0;
  "\\Cap",             0x22d2;
  "\\doublecap",       0x22d2;
  "\\centerdot",       0x00b7;
  "\\circledast",      0x229b;
  "\\circledcirc",     0x229a;
  "\\circleddash",     0x229d;
  "\\Cup",             0x22d3;
  "\\doublecup",       0x22d3;
  "\\curlyvee",        0x22cf;
  "\\curlywedge",      0x22ce;
  "\\divideontimes",   0x22c7;
  "\\dotplus",         0x2214;
  "\\doublebarwedge",  0x2306;
  "\\intercal",        0x22ba;
  "\\leftthreetimes",  0x22cb;
  "\\ltimes",          0x22c9;
  "\\rightthreetimes", 0x22cc;
  "\\rtimes",          0x22ca;
  "\\smallsetminus",   0x2216; (* FIXME - number? *)
  "\\veebar",          0x22bb;

(* AMS binary relations:: *)
  "\\approxeq",           0x224a;
  "\\backepsilon",        0x03f6;
  "\\backsim",            0x223d;
  "\\backsimeq",          0x22cd;
  "\\because",            0x2235;
  "\\between",            0x226c;
  "\\blacktriangleleft",  0x25c2;
  "\\blacktriangleright", 0x25b8;
  "\\bumpeq",             0x224f;
  "\\Bumpeq",             0x224e;
  "\\circeq",             0x2257;
  "\\curlyeqprec",        0x22de;
  "\\curlyeqsucc",        0x22df;
  "\\Doteq",              0x2251;
  "\\doteqdot",           0x2251;
  "\\eqcirc",             0x2256;
  "\\eqlslantgtr",        0x2a96;
  "\\eqsim",              0x2242;
  "\\eqslantless",        0x2a95;
  "\\fallingdotseq",      0x2252;
  "\\geqq",               0x2267;
  "\\geqslant",           0x2a7e;
  "\\ggg",                0x22d9;
  "\\gggtr",              0x22d9;
  "\\gtrapprox",          0x2a86;
  "\\gtrdot",             0x22d7;
  "\\gtreqless",          0x22db;
  "\\gtreqqless",         0x22db;
  "\\gtrless",            0x2277;
  "\\gtrsim",             0x2273;
  "\\leqq",               0x2266;
  "\\leqslant",           0x2a7d;
  "\\lessapprox",         0x2a85;
  "\\lessdot",            0x22d6;
  "\\lesseqgtr",          0x22da;
  "\\lesseqqgtr",         0x22da;
  "\\lessgtr",            0x2276;
  "\\lesssim",            0x2272;
  "\\lll",                0x22d8;
  "\\llless",             0x22d8;
  "\\pitchfork",          0x22d4;
  "\\precapprox",         0x2ab7;
  "\\preccurlyeq",        0x227c;
  "\\precsim",            0x227e;
  "\\risingdotseq",       0x2253;
  "\\shortparallel",      0x2225;
  "\\shortmid",           0x2223;
  "\\smallfrown",         0x2322;
  "\\smallsmile",         0x2323;
  "\\Subset",             0x22d0;
  "\\subseteqq",          0x2ac5;
  "\\succapprox",         0x2ab8;
  "\\succcurlyeq",        0x227d;
  "\\succsim",            0x227f;
  "\\Supset",             0x22d1;
  "\\supseteqq",          0x2ac6;
  "\\therefore",          0x2234;
  "\\thickapprox",        0x2248;
  "\\thicksim",           0x22c3;
  "\\triangleq",          0x225c;
  "\\trianglelefteq",     0x22b4;
  "\\trianglerighteq",    0x22b5;
  "\\varpropto",          0x221d;
  "\\vartriangleleft",    0x22b2;
  "\\vartriangleright",   0x22b3;
  "\\vDash",              0x22a8;
  "\\Vdash",              0x22a9;
  "\\Vvdash",             0x22aa;

(* AMS negated binary relations:: *)
  "\\gnapprox",         0x2a8a;
  "\\gneq",             0x2a88;
  "\\gneqq",            0x2269;
  "\\gnsim",            0x22e7;
  "\\gvertneqq",        0;
  "\\lnapprox",         0x2a89;
  "\\lneq",             0x2a87;
  "\\lneqq",            0x2268;
  "\\lnsim",            0x22e6;
  "\\lvertneqq",        0;
  "\\ncong",            0x2247;
  "\\newnapprox",       0; (* FIXME - what's that? *)
  "\\ngeq",             0x2271;
  "\\ngeqslant",        0;
  "\\ngtr",             0x226f;
  "\\nleq",             0x2270;
  "\\nleqslant",        0;
  "\\nless",            0x226e;
  "\\nmid",             0x2224;
  "\\nparallel",        0x2226;
  "\\nprec",            0x2280;
  "\\npreceq",          0;
  "\\nshortmid",        0;
  "\\nshortparallel",   0;
  "\\nsim",             0x2241;
  "\\nsubseteq",        0x2288;
  "\\nsubseteqq",       0; (* FIXME - what? *)
  "\\nsucc",            0x2281;
  "\\nsucceq",          0;
  "\\nsupseteq",        0x2289;
  "\\nsupseteqq",       0;
  "\\ntriangleleft",    0x22ea;
  "\\ntrianglelefteq",  0x22ec;
  "\\ntriangleright",   0x22eb;
  "\\ntrianglerighteq", 0x22ed;
  "\\nvdash",           0x22ac;
  "\\nvDash",           0x22ad;
  "\\nVdash",           0x22ae;
  "\\nVDash",           0x22af;
  "\\precnapprox",      0x2ab9;
  "\\precnsim",         0x22e8;
  "\\precneqq",         0x2ab5;
  "\\precnsim",         0x22e8;
  "\\subsetneq",        0x228a;
  "\\subsetneqq",       0x2acb;
  "\\succnapprox",      0x2aba;
  "\\succneqq",         0x2ab6;
  "\\succnsim",         0x22e9;
  "\\supsetneq",        0x228b;
  "\\supsetneqq",       0x2acc;
  "\\varsubsetneq",     0;
  "\\varsubsetneqq",    0;
  "\\varsupsetneq",     0;
  "\\varsupsetneqq",    0
]

let symbol_commands = 
  map (fun _ -> (0, 0)) almostallsymbols

let delimiters1 = make [
  "(",              0x0028;
  ")",              0x0029;
  ".",              0x0000;
  "/",              0x002f;
  "<",              0x2329;
  ">",              0x232a;
  "[",              0x005b;
  "]",              0x005d;
  "|",              0x007c;
]

let delimiters2 = make [ (* FIXME: lots of 0s *)
  "\\Arrowvert",    0;      (* TODO: not implemented *)
  "\\Downarrow",    0x21d3; (* TODO: not implemented *)
  "\\Uparrow",      0x21d1; (* TODO: not implemented *)
  "\\Updownarrow",  0x21d1; (* TODO: not implemented *)
  "\\Vert",         0x2016;
  "\\arrowvert",    0;      (* TODO: not implemented *)
  "\\backslash",    0x005c; (* TODO: not implemented *)
  "\\bracevert",    0;      (* TODO: not implemented *)
  "\\downarrow",    0x2193; (* TODO: not implemented *)
  "\\langle",       0x2329;
  "\\lbrace",       0x007b;
  "\\lbrack",       0x005b;
  "\\lceil",        0x2308;
  "\\lfloor",       0x230a;
  "\\lgroup",       0;
  "\\llcorner",     0x231e; (* TODO: not implemented *)
  "\\lmoustache",   0x23b0; (* TODO: not implemented *)
  "\\lrcorner",     0x231f; (* TODO: not implemented *)
  "\\rangle",       0x232a;
  "\\rbrace",       0x007d;
  "\\rbrack",       0x005d;
  "\\rceil",        0x2309;
  "\\rfloor",       0x230b;
  "\\rgroup",       0;
  "\\rmoustache",   0x23b1; (* TODO: not implemented *)
  "\\ulcorner",     0x231c; (* TODO: not implemented *)
  "\\uparrow",      0x215b; (* TODO: not implemented *)
  "\\updownarrow",  0x2195; (* TODO: not implemented *)
  "\\urcorner",     0x231d; (* TODO: not implemented *)
  "\\vert",         0x007c;
  "\\{",            0x007b;
  "\\|",            0x2225;
  "\\}",            0x007d;
 ]

let delimiters = union [delimiters1; delimiters2]

let delimiter_commands =
  map (fun _ -> (0, 0)) delimiters2

let commands = union [
  main_commands;
  ornament_commands;
  alphabet_commands; 
  operator_commands;
  loglike_commands; 
  symbol_commands;
  delimiter_commands
]

let symbols = union [almostallsymbols; delimiters]

(* vim: set tw=96 et ts=2 sw=2: *)
