const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#1c1414", /* black   */
  [1] = "#E74675", /* red     */
  [2] = "#B06B8A", /* green   */
  [3] = "#EE5D8E", /* yellow  */
  [4] = "#988382", /* blue    */
  [5] = "#A89698", /* magenta */
  [6] = "#D39BA9", /* cyan    */
  [7] = "#c6c4c4", /* white   */

  /* 8 bright colors */
  [8]  = "#725e5e",  /* black   */
  [9]  = "#E74675",  /* red     */
  [10] = "#B06B8A", /* green   */
  [11] = "#EE5D8E", /* yellow  */
  [12] = "#988382", /* blue    */
  [13] = "#A89698", /* magenta */
  [14] = "#D39BA9", /* cyan    */
  [15] = "#c6c4c4", /* white   */

  /* special colors */
  [256] = "#1c1414", /* background */
  [257] = "#c6c4c4", /* foreground */
  [258] = "#c6c4c4",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
