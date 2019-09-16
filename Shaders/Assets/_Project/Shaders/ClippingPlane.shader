Shader "Custom/Clipping Plane"
{
    Properties
    {
        [Header(General)]
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        [HDR] _Emission ("Emission", color) = (0, 0, 0)
        [Header(Clipping)]
        [HDR] _CutoffColor("Cutoff Color", Color) = (1, 0, 0, 0)
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }

        Cull Off
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        fixed4 _Color;
        sampler2D _MainTex;
        half _Glossiness;
        half _Metallic;
        float4 _Emission;

        float4 _Plane;
        float4 _CutoffColor;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
            float facing : VFACE;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float distance = dot(IN.worldPos, _Plane.xyz);
            distance += _Plane.w;
            clip(-distance);

            float facing = IN.facing * 0.5 + 0.5;

            fixed4 color = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = color.rgb * facing;
            o.Alpha = color.a * facing;
            o.Metallic = _Metallic * facing;
            o.Emission = lerp(_CutoffColor, _Emission, facing);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
