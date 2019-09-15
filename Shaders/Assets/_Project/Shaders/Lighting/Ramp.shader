Shader "Custom/Lighting/Ramp"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        [HDR] _Emission ("Emission", color) = (0, 0, 0)
        [Header(Lighting)]
        _Ramp ("Toon Ramp", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }
        
        CGPROGRAM

        #pragma surface surf Custom fullforwardshadows
        #pragma target 3.0

        fixed4 _Color;
        sampler2D _MainTex;
        float4 _Emission;

        sampler2D _Ramp;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 color = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = color.rgb;
            o.Alpha = color.a;
            o.Emission = _Emission;
        }

        float4 LightingCustom(SurfaceOutput s, float3 lightDir, float atten)
        {
            float towardsLight = dot(s.Normal, lightDir);
            towardsLight = towardsLight * 0.5 + 0.5; // Go from -1:1 to 0:1

            float3 lightIntensity = tex2D(_Ramp, towardsLight).rgb;

            float4 color;
            color.rgb = lightIntensity * s.Albedo * atten * _LightColor0.rgb;
            color.a = s.Alpha;

            return color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
