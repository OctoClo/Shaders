Shader "Hidden/Ramp Lighting"
{
    Properties
    {
        [HideInInspector] _Color ("Color", Color) = (1,1,1,1)
        [HideInInspector] _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }

        CGPROGRAM
        #pragma surface surf Custom fullforwardshadows

        fixed4 _Color;
        sampler2D _MainTex;

        sampler2D _Ramp;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 color = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = color.rgb;
            o.Alpha = color.a;
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

    Fallback "Diffuse"
}
