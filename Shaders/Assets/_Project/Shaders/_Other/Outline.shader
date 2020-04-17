Shader "Custom/Outline"
{
    Properties
    {
        [Header(General)]
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        
        [Header(Outline)]
        _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
        _OutlineThickness ("Outline Thickness", Range(0,.1)) = 0.03
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG

        // Second pass for outlines
        Pass
        {
            Cull Front
            
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            fixed4 _OutlineColor;
            float _OutlineThickness;

            struct vertInput
            {
                float3 position : POSITION;
                float3 normal : NORMAL;
            };

            struct vertOutput
            {
                float4 position : SV_POSITION;
            };

            vertOutput vert(vertInput i)
            {
                vertOutput o;

                // Offset the position by normal * _OutlineThickness
                float3 normal = normalize(i.normal);
                float3 outlineOffset = normal * _OutlineThickness;
                float3 position = i.position + outlineOffset;

                o.position = UnityObjectToClipPos(position);

                return o;
            }

            fixed4 frag(vertOutput o) : SV_TARGET
            {
                return _OutlineColor;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
