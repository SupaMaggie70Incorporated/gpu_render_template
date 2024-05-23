# Shaders
## General
### Screen scaling
While not perfect, this program and the shaders attempts to scale the rendered thing not only to fit within the screen but to scale the viewport based on which areas of the fractals have anything interesting. Particularly in the generalized mandelbrot fractal, the radius of convergence changes with the power, and I resize the viewport accordingly.

The way I do it looks particularly ugly in wider windows, where instead of being centered all the content is on the left. Additionally, the burning ship fractal has some problems with zooming too far on wide screens.
### Contour-esque lines
The very visible contour-esque lines are an artifact of computer screens' weird color systems.
For the sake of seeing in the near-dark, humans are better at differentiating very dark colors. 
As a result, images and the like are often stored in sRGB, a color space which focuses more on the darker colors than the lighter colors.
This means that darker colors are given a disproportionate range of brightness values, while brighter colors are given disproportionately few.
For the sake of not having to transform images back to unscaled color manually, graphics libraries typically transform the output drawn to the screen themself.
This involves squeezing the dark parts into less values and stretching the light parts out into more.
Since this isn't done in sRGB, but is being treated like it is, the darkest colors are being squeezed into very few colors, which results in very sharp contour-lines.
I didn't handle this because it works differently on every platform, e.g. web vs desktop which uses DirectX or Vulkan. sRGB is the recommended way to do rendering, and I didn't wanna mess around with it.

### Mandelbrot
Typical mandelbrot set. For every pixel $c$ on the screen, where c is a complex number $x+yi$ for the pixel coordinates, let $z_0=0,\ z_{n+1}=z_n^2+c$. If the sequence converges, i.e. doesn't escape some radius of divergence, it is colored black. Otherwise, color it brighter colors by how long it takes to escape, which highlights the very edges more.
### Mandelbar, also called trycorn
Just like the mandelbrot set, except that the real part is negated before applying the $z_{n+1}=z_n^2+c$ transformation. It makes a weird stretched, and in my opnion ugly, mandelbrot-like shape. Note that many depictions are smoothed/scaled so that it looks less awful.
### Generalized mandelbrot
Similar to mandelbrot, except instead of $z_{n+1}=z_n^2+c$, you have $z_{n+1}=z_n^k+c$ where k is the position of your cursor, with the x normalized between 1 and 11. Beyond 11 it gets highly repetitive, and before 1 nothing ever diverges. Interestingly, the complex part seems to have no effect, at least by my crude imaginary exponent functions. Simpler higher-dimensional mandelbrots have been plotted in the past, but rarely have they shown non-integer powers.
### Julia sets
Julia sets similar to the mandelbrot. Let $k=x+yi$ be the position of the cursor on the screen as a complex number. For every pixel $c=x+yi$ on the screen, $z_0=c,\ z_{n+1}=z_n^2+k$, and just like the mandelbrot set, check if this diverges, except this time coloring the points which converge the brightest instead of black.

This family of julia sets has many connections to the mandelbrot set.
It has been proven that whether a julia set of this form is "connected", i.e. all points are connected to each other, is equal to whether the point $k$ is "within" the mandelbrot set, i.e. $z^2+c$ converges for $c=k$.
For similar reasons, positions of the cursor near the boundary of the mandelbrot set are more interesting, as they are neither clearly connected(a blob) nor entirely disconnected. I have thus provided a reference mandelbrot set.
### Burning ship
The burning ship fractal is famous for looking like, well, a burning ship, at least when zoomed into the right area. I have allowed you to zoom into this area by moving the cursor horizontally across the screen. Its formula is the same as the mandelbrot set, except that after squaring $z_n$, you take the absolute value of the resulting y, before adding in $+c$
Note that especially with the low number of iterations and low precision of the 32 bit floats used on the GPU, as well as the lack of multisampling, blending, or other anti-aliasing techniques, there is a significant amount of noise.