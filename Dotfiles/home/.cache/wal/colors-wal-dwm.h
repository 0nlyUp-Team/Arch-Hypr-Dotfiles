static const char norm_fg[] = "#c1c1c3";
static const char norm_bg[] = "#0a0a11";
static const char norm_border[] = "#57576b";

static const char sel_fg[] = "#c1c1c3";
static const char sel_bg[] = "#525569";
static const char sel_border[] = "#c1c1c3";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
};
