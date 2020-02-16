Shader "Custom/FX/Mask"
{
    SubShader
    {
        Tags{ "Queue" = "Transparent-1"  "IgnoreProjector" = "True" }

        ColorMask 0
        ZWrite On
        Pass{}
    }
}