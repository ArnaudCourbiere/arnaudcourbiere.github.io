---
layout: post
title:  "What is early z anyway?"
date:   2017-09-13 22:00:00 -0700
categories: graphics
keywords: graphics, gpu, early z
excerpt_separator: <!--more-->
---

So, Early Z is the name of my blog, but what excatly is early z?

Early z rejection is an optimization technique that enables the GPU to skip execution of the pixel shader if it can accurately determine that the given pixel will be discarded after depth testing. To do so, the GPU does depth testing and updates the dept buffer before the pixel shader. The opposite scenario, where depth testing and buffer updates are done after the pixel shader is called late z.
<!--more-->

Early z is very interesting because it can allow the GPU to discard a very large number of primitives/pixels.

To use early z, the GPU needs to be sure that pixels that would fail the depth test after the vertex shader, when only the geometry has been processed, <b>will not be visible at the end of the pipeline</b>. For example, if the pixel shader modifies the z value of the pixel it is shading, it could make a previously occluded pixel visible.

Let's list the ways in which occluded pixels (geometry-wise) could end up visible:
* Depth testing is disabled (whatever is drawn last is visible)
* Depth testing is enabled but the depth comparison functions is set to ALWAYS (depth test always passes)
* Alpha blending is enabled (a pixel that fails the depth test may be visible through another pixel)
* The pixel shader modifies the z value of the pixel (writes to SV_DEPTH)
* The pixel shader modifies the stencil buffer (stencil test passes or writes to SV_StencilRef)
* The pixel shader modifies the MSAA coverage mask (SV_Coverage)
* The pixel shader kills the pixel using the [discard](https://msdn.microsoft.com/en-us/library/windows/desktop/bb943995(v=vs.85).aspx) statement
* The pixel shader performs unordered access operations (a pixel shader that fails early depth testing but writes to a UAV still needs to be executed)

Please note that a pixel shader can force early z to be turned on using the [earlydepthstencil](https://msdn.microsoft.com/en-us/library/windows/desktop/ff471439%28v=vs.85%29.aspx?f=255&MSPPError=-2147217396) [HLSL attribute](https://msdn.microsoft.com/en-us/library/bb313969(v=xnagamestudio.31).aspx) but results may be undefined if some of the features mentionned earlier are used.

With early z on, it is useful to render a scene in way that will cause as many pixels as possible to be rejected. [This article from Intel]((https://software.intel.com/en-us/articles/early-z-rejection-sample)) shows two such techniques.

### Additional Resources
[A very nice article from Fabian Giesen going more in depth (no pun intended).](https://fgiesen.wordpress.com/2011/07/08/a-trip-through-the-graphics-pipeline-2011-part-7/)<br/>
[DirectX System-Value Semantics](https://msdn.microsoft.com/en-us/library/windows/desktop/bb509647%28v=vs.85%29.aspx?f=255&MSPPError=-2147217396#System_Value).<br/>
[More info on SV_Coverage, a seldom documented feature.](http://www.yosoygames.com.ar/wp/2017/02/beware-of-sv_coverage/)<br/>
