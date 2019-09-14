Shader "Custom/Tex/Texture with Alpha + Grayscale"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
        }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;

            struct vertInput
            {
                float3 position : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct vertOutput
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            vertOutput vert(vertInput i)
            {
                vertOutput o;
                o.position = UnityObjectToClipPos(i.position);
                o.uv = i.uv;
                return o;
            }

            fixed4 frag(vertOutput o) : SV_TARGET
            {
                float4 color = tex2D(_MainTex, o.uv);
                float luminance = 0.3 * color.r + 0.59 * color.g + 0.11 * color.b;
                float4 grayscale = fixed4(luminance, luminance, luminance, color.a);
                return grayscale;
            }

            ENDCG
        }
    }
}
