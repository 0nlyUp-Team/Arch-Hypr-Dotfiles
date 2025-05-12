static const char norm_fg[] = "#c6c4c4";
static const char norm_bg[] = "#1c1414";
static const char norm_border[] = "#725e5e";

static const char sel_fg[] = "#c6c4c4";
static const char sel_bg[] = "#B06B8A";
static const char sel_border[] = "#c6c4c4";

static const char urg_fg[] = "#c6c4c4";
static const char urg_bg[] = "#E74675";
static const char urg_border[] = "#E74675";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
