/* Taken from https://github.com/djpohly/dwl/issues/466 */
#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }

static const float rootcolor[]             = COLOR(0x0a0a11ff);
static uint32_t colors[][3]                = {
	/*               fg          bg          border    */
	[SchemeNorm] = { 0xc1c1c3ff, 0x0a0a11ff, 0x57576bff },
	[SchemeSel]  = { 0xc1c1c3ff, 0x61647Aff, 0x525569ff },
	[SchemeUrg]  = { 0xc1c1c3ff, 0x525569ff, 0x61647Aff },
};
