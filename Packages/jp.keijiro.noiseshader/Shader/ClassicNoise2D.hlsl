//
// Noise Shader Library for Unity - https://github.com/keijiro/NoiseShader
//
// Original work (webgl-noise) Copyright (C) 2011 Stefan Gustavson
// Translation and modification was made by Keijiro Takahashi.
//
// This shader is based on the webgl-noise GLSL shader. For further details
// of the original shader, please see the following description from the
// original source code.
//

//
// GLSL textureless classic 2D noise "cnoise",
// with an RSL-style periodic variant "pnoise".
// Author:  Stefan Gustavson (stefan.gustavson@liu.se)
// Version: 2011-08-22
//
// Many thanks to Ian McEwan of Ashima Arts for the
// ideas for permutation and gradient selection.
//
// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/ashima/webgl-noise
//

#ifndef _INCLUDE_JP_KEIJIRO_NOISESHADER_CLASSIC_NOISE_2D_HLSL_
#define _INCLUDE_JP_KEIJIRO_NOISESHADER_CLASSIC_NOISE_2D_HLSL_

#include "Packages/jp.keijiro.noiseshader/Shader/Common.hlsl"

// Classic Perlin noise
float cnoise(float2 P)
{
  float4 Pi = floor(P.xyxy) + float4(0, 0, 1, 1);
  float4 Pf = frac (P.xyxy) - float4(0, 0, 1, 1);

  Pi = wglnoise_mod289(Pi); // To avoid truncation effects in permutation

  float4 ix = Pi.xzxz;
  float4 iy = Pi.yyww;
  float4 fx = Pf.xzxz;
  float4 fy = Pf.yyww;

  float4 i = wglnoise_permute(wglnoise_permute(ix) + iy);

  float4 x = lerp(-1, 1, frac(i / 41));
  float4 h = abs(x) - 0.5;
  float4 a0 = x - floor(x + 0.5);

  float2 g00 = normalize(float2(a0.x, h.x));
  float2 g10 = normalize(float2(a0.y, h.y));
  float2 g01 = normalize(float2(a0.z, h.z));
  float2 g11 = normalize(float2(a0.w, h.w));

  float n00 = dot(g00, float2(fx.x, fy.x));
  float n10 = dot(g10, float2(fx.y, fy.y));
  float n01 = dot(g01, float2(fx.z, fy.z));
  float n11 = dot(g11, float2(fx.w, fy.w));

  float2 fade_xy = wglnoise_fade(Pf.xy);
  float2 n_x = lerp(float2(n00, n01), float2(n10, n11), fade_xy.x);
  float n_xy = lerp(n_x.x, n_x.y, fade_xy.y);
  return n_xy;
}

// Classic Perlin noise, periodic variant
float pnoise(float2 P, float2 rep)
{
  float4 Pi = floor(P.xyxy) + float4(0, 0, 1, 1);
  float4 Pf = frac (P.xyxy) - float4(0, 0, 1, 1);

  Pi = wglnoise_mod(Pi, rep.xyxy); // To create noise with explicit period
  Pi = wglnoise_mod289(Pi);        // To avoid truncation effects in permutation

  float4 ix = Pi.xzxz;
  float4 iy = Pi.yyww;
  float4 fx = Pf.xzxz;
  float4 fy = Pf.yyww;

  float4 i = wglnoise_permute(wglnoise_permute(ix) + iy);

  float4 x = lerp(-1, 1, frac(i / 41));
  float4 h = abs(x) - 0.5;
  float4 a0 = x - floor(x + 0.5);

  float2 g00 = normalize(float2(a0.x, h.x));
  float2 g10 = normalize(float2(a0.y, h.y));
  float2 g01 = normalize(float2(a0.z, h.z));
  float2 g11 = normalize(float2(a0.w, h.w));

  float n00 = dot(g00, float2(fx.x, fy.x));
  float n10 = dot(g10, float2(fx.y, fy.y));
  float n01 = dot(g01, float2(fx.z, fy.z));
  float n11 = dot(g11, float2(fx.w, fy.w));

  float2 fade_xy = wglnoise_fade(Pf.xy);
  float2 n_x = lerp(float2(n00, n01), float2(n10, n11), fade_xy.x);
  float n_xy = lerp(n_x.x, n_x.y, fade_xy.y);
  return n_xy;
}

#endif
