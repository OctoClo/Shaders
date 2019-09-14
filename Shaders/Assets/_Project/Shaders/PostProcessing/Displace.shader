Shader "Custom/Post Processing/Displacement Map"
{
    Properties
    {
        [HideInInspector]_MainTex ("Albedo (RGB)", 2D) = "white" {}
        [Header(Displacement)]
        _DisplaceTex ("Displacement Map (RGB)", 2D) = "white" {}
        _Magnitude ("Magnitude", Range(0, 0.2)) = 0
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
            sampler2D _DisplaceTex;
            float _Magnitude;

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
                float2 displacement = tex2D(_DisplaceTex, o.uv).xy;
                displacement = ((displacement * 2) - 1); // Range 0:1 -> -1:1
                displacement *= _Magnitude;

                return tex2D(_MainTex, o.uv + displacement);
            }

            ENDCG
        }
    }
}
