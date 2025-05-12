/* Taken from https://github.com/djpohly/dwl/issues/466 */
#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }

static const float rootcolor[]             = COLOR(0x1c1414ff);
static uint32_t colors[][3]                = {
	/*               fg          bg          border    */
	[SchemeNorm] = { 0xc6c4c4ff, 0x1c1414ff, 0x725e5eff },
	[SchemeSel]  = { 0xc6c4c4ff, 0xB06B8Aff, 0xE74675ff },
	[SchemeUrg]  = { 0xc6c4c4ff, 0xE74675ff, 0xB06B8Aff },
};
