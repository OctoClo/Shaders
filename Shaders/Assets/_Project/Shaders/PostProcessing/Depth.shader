Shader "Custom/Post Processing/Depth"
{
    Properties
    {
        [Header(Depth)]
        _DepthColor ("Color", Color) = (1, 1, 1, 1)
        _DepthStrenght ("Strenght", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _CameraDepthTexture;
            float4 _DepthColor;
            float _DepthStrenght;

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
                float depth = tex2D(_CameraDepthTexture, o.uv).r;
                depth = Linear01Depth(depth);
                depth *= _ProjectionParams.z * _DepthStrenght;

                return depth * _DepthColor;
            }

            ENDCG
        }
    }
}
