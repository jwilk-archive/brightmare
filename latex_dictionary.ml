include Dictionary

let main_commands = make [
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
  "\\ddots",      (0, 0);
  "\\dotfill",    (0, 0);
(* -- other things -- *)
  "\\hrulefill",  (0, 0);
  "\\fbox",       (0, 1);
  "\\mbox",       (0, 1);
  "\\binom",      (0, 2);
  "_",            (0, 1);
  "^",            (0, 1);
(* math-mode accents:: *)
  "\\acute",  (0, 0);
  "\\bar",    (0, 1);
  "\\breve",  (0, 1);
  "\\check",  (0, 1);
  "\\ddot",   (0, 1);
  "\\dot",    (0, 1);
  "\\grave",  (0, 1);
  "\\hat",    (0, 1);
  "\\tilde",  (0, 1);
  "\\vec",    (0, 1);
(* some other constructions:: *)
  "\\frac",           (0, 2);
  "\\overbrace",      (0, 1);
  "\\overleftarrow",  (0, 1);
  "\\overline",       (0, 1);
  "\\overrightarrow", (0, 1);
  "\\sqrt",           (1, 1);
  "\\underbrace",     (0, 1);
  "\\underline",      (0, 1);
  "\\widehat",        (0, 1);
  "\\widetilde",      (0, 1);
]

let alphabets = make [
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

let operators = make [
(* variable-sized math operators:: *)
  "\\bigcap",     ();
  "\\bigcup",     ();
  "\\bigodot",    ();
  "\\bigoplus",   ();
  "\\bigotimes",  ();
  "\\bigsqcup",   ();
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
  "\\varinjlim",  ();
  "\\varliminf",  ();
  "\\varlimsup",  ();
  "\\varprojlim", ();
]

let loglike_commands = 
  map (fun () -> (0, 0)) loglikes

let symbols = make [
(* LaTeX escapable special characters:: *)
  "\\$",  37;
  "\\%",  38;
  "\\_",  95;
  "\\&",  39;
  "\\#",  36;

(* LaTeX commands defined to work both in math and text mode:: *)
  "\\dag",        8224;
  "\\ddag",       8225;
  "\\copyright",  169;
  "\\pounds",     163;
  "\\S",          167;
  "\\P",          182;
  "\\dots",       0;
  "\\\\",         92; (* FIXME - place? *)

(* non-ASCII letters:: *)
  "\\aa", 229;
  "\\AA", 197;
  "\\ae", 230;
  "\\AE", 198;
  "\\DH", 0;
  "\\dh", 0;
  "\\DJ", 0;
  "\\dj", 0;
  "\\l",  322;
  "\\L",  321;
  "\\o",  248;
  "\\O",  216;
  "\\oe", 339;
  "\\OE", 338;
  "\\ss", 223;
  "\\SS", 0;
  "\\TH", 0;
  "\\th", 0;

(* predefined LaTeX text-mode commands --- TODO *)

(* punctuation marks --- TODO *)

(* binary operators:: *)
  "\\amalg",            2210;
  "\\ast",              8727;
  "\\bigcirc",          9675;
  "\\bigtriangledown",  9661;
  "\\bigtriangleup",    9651;
  "\\bullet",           8729;
  "\\cap",              8745;
  "\\cdot",             183;
  "\\circ",             8728;
  "\\cup",              8746;
  "\\dagger",           8224;
  "\\ddagger",          8225;
  "\\diamond",          8900;
  "\\div",              247;
  "\\lhd",              0;
  "\\mp",               8723;  
  "\\odot",             8857;
  "\\ominus",           0x2296;
  "\\oplus",            8853;
  "\\oslash",           0x2298;
  "\\otimes",           8855;
  "\\pm",               177;
  "\\rhd",              0;
  "\\setminus",         2216;
  "\\sqcap",            0x2293;
  "\\sqcup",            0x2294;
  "\\star",             0x22C6;
  "\\times",            215;
  "\\trangleright",     9657;
  "\\triangleleft",     9667;
  "\\unlhd",            0;
  "\\unrhd",            0;
  "\\uplus",            0x228E;
  "\\vee",              8744;
  "\\wedge",            8743;
  "\\wr",               8768;

(* relation symbols:: *)
  "\\approx",     8776;
  "\\asymp",      8781;
  "\\bowtie",     0x22C8;
  "\\cong",       8773;
  "\\dashv",      8867;
  "\\doteq",      8784;
  "\\equiv",      8801;
  "\\frown",      8894;
  "\\geq",        0;
  "\\gg",         8811;
  "\\in",         8712;
  "\\Join",       0;
  "\\leq",        0;
  "\\ll",         8810;
  "\\mid",        8739;
  "\\models",     0x22A7;
  "\\ne",         8800;
  "\\neq",        8800;
  "\\ni",         8715;
  "\\nin",        8713; (* FIXME - place? *)
  "\\parallel",   8741;
  "\\perp",       0;
  "\\prec",       8826;
  "\\preceq",     10927;
  "\\propto",     8733;
  "\\sim",        8764;
  "\\simeq",      8771;
  "\\smile",      8895;
  "\\sqsubset",   8847;
  "\\sqsubseteq", 8849;
  "\\sqsupset",   8848;
  "\\sqsupseteq", 8850;
  "\\subset",     8834;
  "\\subseteq",   8838;
  "\\succ",       8827;
  "\\succeq",     10928;
  "\\supset",     8835;
  "\\supseteq",   8839;
  "\\vdash",      8866;

(* punctuation symbols:: *)
  "\\colon",  0;
  "\\ldotp",  0;
  "\\cdotp",  0;

(* arrow symbols:: *)
  "\\hookleftarrow",      0x21A9;
  "\\hookrightarrow",     0x21A0;
  "\\leadsto",            0;
  "\\leftarrow",          8592;
  "\\Leftarrow",          8656;
  "\\leftharpoondown",    8637;
  "\\leftharpoonup",      8636;
  "\\leftrightarrow",     8596;
  "\\Leftrightarrow",     8660;
  "\\leftrightharpoons",  8651;
  "\\longleftarrow",      10229;
  "\\Longleftarrow",      10232;
  "\\longleftrightarrow", 10231;
  "\\Longleftrightarrow", 10234;
  "\\longmapsto",         10236;
  "\\longrightarrow",     10230;
  "\\Longrightarrow",     10233;
  "\\mapsto",             0x21A6;
  "\\nearrow",            0x2197;
  "\\nwarrow",            0x2196;
  "\\rightarrow",         8594;
  "\\rightarrow",         8594;
  "\\Rightarrow",         8658;
  "\\rightharpoondown",   8640;
  "\\rightharpoonup",     8640;
  "\\rightleftharpoons",  8652;
  "\\searrow",            0x2198;
  "\\swarrow",            0x2199;
  "\\to",                 8594; (* FIXME - place? *)

(* miscellaneous LaTeX symbols:: *)
  "\\angle",        8736;
  "\\bot",          8869;
  "\\Box",          0;
  "\\cdots",        0;
  "\\clubsuit",     9827;
  "\\ddots",        0;
  "\\Diamond",      8900;
  "\\diamondsuit",  9830;
  "\\ell",          0x2113;
  "\\emptyset",     8709; (* FIXME - number? *)
  "\\exists",       8707;
  "\\flat",         9837;
  "\\forall",       8704;
  "\\heartsuit",    9829;
  "\\Im",           0x2111;
  "\\imath",        0x0131;
  "\\infty",        8734;
  "\\jmath",        0;
  "\\ldots",        8230;
  "\\mho",          8487;
  "\\nabla",        8711;
  "\\natural",      9838;
  "\\neg",          172;
  "\\partial",      8706;
  "\\prime",        8242;
  "\\Re",           0x211C;
  "\\sharp",        9839;
  "\\spadesuit",    9824;
  "\\surd",         8730;
  "\\top",          8868;
  "\\triangle",     0;
  "\\vdots",        0;
  "\\wp",           0x2118;

(* small Greek letters:: *)
  "\\alpha",      945;
  "\\beta",       946;
  "\\gamma",      947;
  "\\digamma",    988;
  "\\delta",      948;
  "\\epsilon",    949;
  "\\varepsilon", 8714;
  "\\zeta",       950;
  "\\eta",        951;
  "\\theta",      952;
  "\\vartheta",   977;
  "\\iota",       953;
  "\\kappa",      954;
  "\\varkappa",   1008;
  "\\lambda",     955;
  "\\mu",         956;
  "\\nu",         957;
  "\\xi",         958;
  "\\pi",         960;
  "\\varpi",      0;
  "\\rho",        961;
  "\\varrho",     1009;
  "\\sigma",      963;
  "\\varsigma",   962;
  "\\tau",        964;
  "\\upsilon",    965;
  "\\phi",        981;
  "\\varphi",     966;
  "\\chi",        967;
  "\\psi",        968;
  "\\omega",      969;

(* big Greek letters:: *)
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

(* Hebrew letters:: *)
  "\\aleph",      8501;
  "\\beth",       8502;
  "\\gimel",      8503;
  "\\daleth",     8504;
 
(* AMS arrows:: *)
  "\\circlearrowleft",      0;
  "\\circlearrowright",     0;
  "\\curvearrowleft",       0;
  "\\curvearrowright",      0;
  "\\dashleftarrow",        0;
  "\\dashrightarrow",       0;
  "\\downdownarrows",       0;
  "\\downharpoonleft",      0;
  "\\downharpoonright",     0;
  "\\leftwarrowtail",       0;
  "\\leftleftarrows",       0;
  "\\leftrightarrows",      0;
  "\\leftrightharpoons",    0;
  "\\leftrightsquigarrow",  0;
  "\\Lleftarrow",           0;
  "\\looparrowleft",        0;
  "\\looparrowright",       0;
  "\\Lsh",                  0;
  "\\multimap",             0;
  "\\rightarrowtail",       0;
  "\\rightleftarrows",      0;
  "\\rightleftharpoons",    0;
  "\\rightrightarrows",     0;
  "\\rightsquigarrow",      0;
  "\\Rrightarrow",          0;
  "\\Rsh",                  0;
  "\\twoheadleftarrow",     0;
  "\\twoheadrightarrow",    0;
  "\\uphapoonleft",         0;
  "\\upharpoonright",       0;
  "\\upuparrows",           0;

(* AMS negated arrows:: *)
  "\\nLeftarrow",       0;
  "\\nleftarrow",       0;
  "\\nLeftrightarrow",  0;
  "\\nleftrightarrow",  0;
  "\\nRightarrow",      0;
  "\\nrightarrow",      0;

(* miscellaneous AMS symbols:: *)
  "\\backprime",          0x2035;
  "\\Bbbk",               0;
  "\\bigstar",            9733;
  "\\blacklozenge",       10731;
  "\\blacksquare",        9632;
  "\\blacktriangle",      9652;
  "\\blacktriangledown",  9662;
  "\\checkmark",          0;
  "\\circledR",           0;
  "\\circledS",           9416;
  "\\complement",         8705;
  "\\diagdown",           9586;
  "\\diagup",             9585;
  "\\eth",                240;
  "\\Finv",               0;
  "\\Game",               8513;
  "\\hbar",               8463; (* FIXME - number? *)
  "\\hslash",             8463; (* FIXME - number? *)
  "\\lozenge",            9674;
  "\\maltese",            0;
  "\\measuredangle",      8737;
  "\\nexists",            8708;
  "\\restriction",        0;
  "\\sphericalangle",     8738;
  "\\squeak",             0;
  "\\triangledown",       9663;
  "\\varnothing",         8709;
  "\\vartriangle",        9653;

(* AMS binary operators:: *)
  "\\barwedge",        0x22BC;
  "\\boxdot",          8865;
  "\\boxminus",        8863;
  "\\boxplus",         8862;
  "\\boxtimes",        8864;
  "\\Cap",             0x22D2;
  "\\doublecap",       0x22D2;
  "\\centerdot",       0;
  "\\circledast",      8859;
  "\\circledcirc",     8858;
  "\\circleddash",     8861;
  "\\Cup",             0x22D3;
  "\\doublecup",       0x22D3;
  "\\curlyvee",        8911;
  "\\curlywedge",      8910;
  "\\divideontimes",   8903;
  "\\dotplus",         8724;
  "\\doublebarwedge",  8966;
  "\\intercal",        8890;
  "\\leftthreetimes",  8907;
  "\\ltimes",          8905;
  "\\rightthreetimes", 8908;
  "\\rtimes",          8906;
  "\\smallsetminus",   8726; (* FIXME - number? *)
  "\\veebar",          8891;

(* AMS binary relations:: *)
  "\\approxeq",           8778;
  "\\backepsilon",        1014;
  "\\backsim",            0;
  "\\backsimeq",          0;
  "\\because",            8757;
  "\\between",            8812;
  "\\blacktriangleleft",  9666;
  "\\blacktriangleright", 9656;
  "\\bumpeq",             0;
  "\\Bumpeq",             0;
  "\\circeq",             8791;
  "\\curlyeqprec",        0;
  "\\curlyeqsucc",        0;
  "\\Doteq",              0; (* FIXME - what's that? *)
  "\\doteqdot",           0;
  "\\eqlslantgtr",        10902;
  "\\eqsim",              8770; (* FIXME - what's that? *)
  "\\eqslantless",        10901;
  "\\fallingdotseq",      0;
  "\\geqq",               8807;
  "\\geqslant",           10878;
  "\\ggg",                8921;
  "\\gggtr",              8921;
  "\\gtrapprox",          10886;
  "\\gtrdot",             8919;
  "\\gtreqless",          8923;
  "\\gtreqqless",         8923;
  "\\gtrless",            8823;
  "\\gtrsim",             8819;
  "\\leqq",               8806;
  "\\leqslant",           10877;
  "\\lessapprox",         10885;
  "\\lessdot",            8918;
  "\\lesseqgtr",          8922;
  "\\lesseqqgtr",         8922;
  "\\lessgtr",            8822;
  "\\lesssim",            8818;
  "\\lll",                8920;
  "\\llless",             8920;
  "\\pitchfork",          8916;
  "\\precapprox",         0;
  "\\preccurlyeq",        0;
  "\\precsim",            0;
  "\\qcirc",              8790; (* FIXME - what's that? *)
  "\\risingdotseq",       0;
  "\\shartparallel",      0;
  "\\shortmid",           0;
  "\\smallfrown",         0;
  "\\smallsmile",         0;
  "\\Subset",             0;
  "\\subseteqq",          0;
  "\\succapprox",         0;
  "\\succcurlyeq",        0;
  "\\succsim",            0;
  "\\Supset",             0;
  "\\supseteqq",          0;
  "\\therefore",          8756;
  "\\thickapprox",        0;
  "\\thicksim",           0;
  "\\triangleeq",         0;
  "\\trianglelefteq",     0;
  "\\trianglerighteq",    0;
  "\\varpropto",          8733;
  "\\vartriangleleft",    0;
  "\\vartriangleright",   0;
  "\\vDash",              0;
  "\\Vdash",              0;
  "\\Vvdash",             0;

(* AMS negated binary relations:: *)
  "\\gnapprox",         0;
  "\\gneq",             0;
  "\\gneqq",            0;
  "\\gnsim",            0;
  "\\gvertneqq",        0;
  "\\lnapprox",         0;
  "\\lneq",             0;
  "\\lneqq",            0;
  "\\lnsim",            0;
  "\\lvertneqq",        0;
  "\\ncong",            0;
  "\\newnapprox",       0; (* FIXME - what's that? *)
  "\\ngeq",             0;
  "\\ngeqslant",        0;
  "\\ngtr",             0;
  "\\nleq",             0;
  "\\nleqslant",        0;
  "\\nless",            0;
  "\\nmid",             0;
  "\\nparallel",        8742;
  "\\nprec",            0;
  "\\npreceq",          0;
  "\\nshortmid",        0;
  "\\nshortparallel",   0;
  "\\nsim",             0;
  "\\nsubseteq",        0;
  "\\nsubseteqq",       0; (* FIXME - what? *)
  "\\nsucc",            0;
  "\\nsucceq",          0;
  "\\nsupseteq",        0;
  "\\nsupseteqq",       0;
  "\\ntriangleleft",    0;
  "\\ntrianglelefteq",  0;
  "\\ntriangleright",   0;
  "\\ntrianglerighteq", 0;
  "\\nvdash",           0;
  "\\nvDash",           0;
  "\\nVdash",           0;
  "\\nVDash",           0;
  "\\precnapprox",      0;
  "\\precnsim",         0;
  "\\precneqq",         0;
  "\\precnsim",         0;
  "\\subsetneq",        0;
  "\\subsetneqq",       0;
  "\\succnapprox",      0;
  "\\succneqq",         0;
  "\\succnsim",         0;
  "\\supsetneq",        0;
  "\\supsetneqq",       0;
  "\\varsubsetneq",     0;
  "\\varsubsetneqq",    0;
  "\\varsupsetneq",     0;
  "\\varsupsetneqq",    0;

(* FIXME - WAHT THE DUCK IS THAT?! *)
  "\\arcdeg",        0;
  "\\arcmin",        0;
  "\\arcsec",        0;
  "\\bv",            0;
  "\\dbond",         0;
  "\\degr",          176;
  "\\diameter",      0;
  "\\earth",         0;
  "\\farcm",         0;
  "\\farcs",         0;
  "\\fd",            0;
  "\\fdg",           0;
  "\\fh",            0;
  "\\fm",            0;
  "\\fp",            0;
  "\\fs",            0;
  "\\ga",            8819;
  "\\gtrsim",        8819;
  "\\la",            8818;
  "\\lesssim",       8818;
  "\\micron",        0;
  "\\onehalf",       188;
  "\\onequarter",    188;
  "\\onethird",      8531;
  "\\sbond",         0;
  "\\sq",            0;
  "\\sun",           0;
  "\\tbond",         0;
  "\\threequarters", 190;
  "\\twothirds",     8532;
  "\\ub",            0;
  "\\ubvr",          0;
  "\\ur",            0;
  "\\vr",            0;
]

let symbol_commands = 
  map (fun _ -> (0, 0)) symbols

let delimiters1 = make [
  ".",              0;
  "(",              40;
  ")",              41;
  "<",              9001;
  ">",              9002;
  "[",              91;
  "]",              93;
  "|",              124;
  "/",              47
]

let delimiters2 = make [
  "\\langle",       9001;
  "\\rangle",       9002;
  "\\backslash",    92;
  "\\|",            8741;
  "\\{",            123;
  "\\}",            125;
  "\\Downarrow",    0x21D3;
  "\\downarrow",    8595;
  "\\lceil",        8968;
  "\\lfloor",       8970;
  "\\llcorner",     0x231E;
  "\\lrcorner",     0x231F;
  "\\rceil",        8969;
  "\\rfloor",       8971;
  "\\ulcorner",     0x231C;
  "\\uparrow",      8539;
  "\\Uparrow",      8657;
  "\\Updownarrow",  0x21D1;
  "\\updownarrow",  8597;
  "\\urcorner",     0x231D;
  "\\vert",         124;
  "\\Vert",         8214;
  "\\rmoustache",   0;
  "\\lmoustache",   0;
  "\\lgroup",       0;
  "\\rgroup",       0;
  "\\arrowvert",    0;
  "\\Arrowvert",    0;
  "\\bracevert",    0;
]

let delimiters = merge [delimiters1; delimiters2]

let delimiter_commands =
  map (fun _ -> (0, 0)) delimiters2

let commands = merge [
  main_commands; 
  alphabet_commands; 
  operator_commands;
  loglike_commands; 
  symbol_commands;
  delimiter_commands
]

let allsymbols = merge [
  symbols;
  delimiters
]

(* vim: set tw=96 et ts=2 sw=2: *)
