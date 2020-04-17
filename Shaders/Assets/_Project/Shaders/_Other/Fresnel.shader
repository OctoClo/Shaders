Shader "Custom/Fresnel"
{
    Properties
    {
        [Header(General)]
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        [HDR] _Emission ("Emission", color) = (0, 0, 0)
        [Header(Fresnel)]
        _FresnelColor ("Fresnel Color", Color) = (1, 1, 1, 1)
        _FresnelStep ("Fresnel Step", Range(0, 1)) = 0.4
        [IntRange]_FresnelSmoothness ("Fresnel Smoothness", Range(0, 1)) = 0
    }
    SubShader
    {
        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows

        fixed4 _Color;
        sampler2D _MainTex;
        half _Glossiness;
        half _Metallic;
        float4 _Emission;
        
        float4 _FresnelColor;
        float _FresnelStep;
        float _FresnelSmoothness;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 color = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = color.rgb;
            o.Alpha = color.a;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;

            float fresnelDot = 1 - dot(IN.worldNormal, IN.viewDir);
            float fresnel = smoothstep(0, 1 - _FresnelStep, fresnelDot) * _FresnelSmoothness;
            fresnel += (1 - step(fresnelDot, 1 - _FresnelStep)) * saturate(-_FresnelSmoothness + 1); // 0 -> 1 and 1 -> 0
            o.Emission = _Emission + fresnel * _FresnelColor;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
