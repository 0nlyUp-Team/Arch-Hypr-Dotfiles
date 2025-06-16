const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#0a0a11", /* black   */
  [1] = "#525569", /* red     */
  [2] = "#61647A", /* green   */
  [3] = "#6F738A", /* yellow  */
  [4] = "#7B7DA1", /* blue    */
  [5] = "#7E819B", /* magenta */
  [6] = "#8F8EAC", /* cyan    */
  [7] = "#c1c1c3", /* white   */

  /* 8 bright colors */
  [8]  = "#57576b",  /* black   */
  [9]  = "#525569",  /* red     */
  [10] = "#61647A", /* green   */
  [11] = "#6F738A", /* yellow  */
  [12] = "#7B7DA1", /* blue    */
  [13] = "#7E819B", /* magenta */
  [14] = "#8F8EAC", /* cyan    */
  [15] = "#c1c1c3", /* white   */

  /* special colors */
  [256] = "#0a0a11", /* background */
  [257] = "#c1c1c3", /* foreground */
  [258] = "#c1c1c3",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
