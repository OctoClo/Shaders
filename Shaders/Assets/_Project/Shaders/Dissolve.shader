Shader "Custom/Dissolve"
{
    Properties
    {
        [Header(General)]
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        [HDR] _Emission ("Emission", color) = (0, 0, 0)
        [Header(Dissolve)]
        _DissolveTex ("Dissolve Texture", 2D) = "black" {}
        _DissolveSpeed ("Dissolve Speed", Range(0, 5)) = 1
        [Header(Glow)]
        [HDR] _GlowColor ("Color", Color) = (1, 1, 1, 1)
        _GlowRange ("Range", Range(0, .5)) = 0.1
        _GlowFalloff ("Falloff", Range(0, 1)) = 0.1
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        fixed4 _Color;
        sampler2D _MainTex;
        half _Glossiness;
        half _Metallic;
        float4 _Emission;
        
        sampler2D _DissolveTex;
        float _DissolveSpeed;

        float3 _GlowColor;
        float _GlowRange;
        float _GlowFalloff;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_DissolveTex;
        };        

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float dissolve = tex2D(_DissolveTex, IN.uv_DissolveTex).r;
            // Multiply by a number close to 0 to prevent white pixels from always showing
            dissolve = dissolve * 0.999;
            
            float dissolveAmount = cos(_Time.y * _DissolveSpeed) * 0.5 + 0.5;
            float isVisible = dissolve - dissolveAmount;
            clip(isVisible);

            fixed4 color = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = color.rgb;
            o.Alpha = color.a;
    
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;

            float isGlowing = smoothstep(_GlowRange + _GlowFalloff, _GlowRange, isVisible);
            float3 glow = isGlowing * _GlowColor;
            o.Emission = _Emission + glow;
        } 
        ENDCG
    }
    FallBack "Diffuse"
}
