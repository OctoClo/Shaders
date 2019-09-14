Shader "Custom/Post Processing/Displacement Map"
{
    Properties
    {
        [HideInInspector]_MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;

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

            float4 blur(sampler2D tex, float2 uv, float4 size)
            {
                // Add the color of all surrounding pixels to the currend pixel
                float4 color =  tex2D(tex, uv + float2(-size.x, -size.y)) + tex2D(tex, uv + float2(0, -size.y)) + tex2D(tex, uv + float2(size.x, -size.y)) + // left column pixels
                                tex2D(tex, uv + float2(-size.x, 0))       + tex2D(tex, uv + float2(0, 0))       + tex2D(tex, uv + float2(size.x, 0)) +       // middle column pixels
                                tex2D(tex, uv + float2(-size.x, size.y))  + tex2D(tex, uv + float2(0, size.y))  + tex2D(tex, uv + float2(size.x, size.y));   // right column pixels
                
                // Divide by the number of pixels added
                return color / 9;
            }

            fixed4 frag(vertOutput o) : SV_TARGET
            {
                return blur(_MainTex, o.uv, _MainTex_TexelSize);
            }

            ENDCG
        }
    }
}
