#pragma include "shadowLinearSoft.glsl"

float getShadowPCF(
    const in sampler2D depths,
    const in vec4 size,
    const in vec2 uv,
    const in float compare,
    const in vec2 biasPCF,
    const in vec4 clampDimension,
    const in float pcf) {

     float res = 0.0;

     res += texture2DShadowLerp(depths, size, uv + biasPCF, compare, clampDimension OPT_INSTANCE_ARG_outDistance OPT_INSTANCE_ARG_jitter);

     if (pcf <= 1.0) return res;


     float dx0 = -size.z;
     float dy0 = -size.w;
     float dx1 = size.z;
     float dy1 = size.w;

#define TSF(o1,o2) texture2DShadowLerp(depths, size, uv + vec2(o1, o2) + biasPCF, compare, clampDimension OPT_INSTANCE_ARG_outDistance OPT_INSTANCE_ARG_jitter)

    res += TSF(dx0, dx0);
    res += TSF(dx0, .0);
    res += TSF(dx0, dx1);



    if (pcf <= 4.0) return res / 4.0;

    res += TSF(.0, dx0);
    res += TSF(.0, dx1);

    res += TSF(dx1, dx0);
    res += TSF(dx1, .0);
    res += TSF(dx1, dx1);

    if (pcf <= 9.0) return res / 9.0;

    float dx02 = -2.0*size.z;
    float dy02 = -2.0*size.w;
    float dx2 = 2.0*size.z;
    float dy2 = 2.0*size.w;

    // complete row above
    res += TSF(dx0, dx02);
    res += TSF(dx0, dx2);

    res += TSF(.0, dx02);
    res += TSF(.0, dx2);

    res += TSF(dx1, dx02);
    res += TSF(dx1, dx2);

    // two new col
    res += TSF(dx02, dx02);
    res += TSF(dx02, dx0);
    res += TSF(dx02, .0);
    res += TSF(dx02, dx1);
    res += TSF(dx02, dx2);

    res += TSF(dx2, dx02);
    res += TSF(dx2, dx0);
    res += TSF(dx2, .0);
    res += TSF(dx2, dx1);
    res += TSF(dx2, dx2);


    return  res / 25.0;

#undef TSF


}
/////// end Tap
