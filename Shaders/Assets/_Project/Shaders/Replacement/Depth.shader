Shader "Hidden/Depth"
{
    Properties
    {
        [HideInInspetor]_Color ("Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }

        ZWrite On

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _Color;
            float4 _DepthColor;

            struct vertInput
            {
                float3 position : POSITION;
            };

            struct vertOutput
            {
                float4 position : SV_POSITION;
                float depth : DEPTH;
            };

            vertOutput vert(vertInput i)
            {
                vertOutput o;
                o.position = UnityObjectToClipPos(i.position);
                o.depth = -UnityObjectToViewPos(i.position).z * _ProjectionParams.w;
                return o;
            }

            fixed4 frag(vertOutput o) : SV_TARGET
            {
                float invertDepth = 1 - o.depth;
                return fixed4(invertDepth, invertDepth, invertDepth, 1) * _DepthColor;
            }

            ENDCG
        }
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
        }

        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _Color;

            struct vertInput
            {
                float3 position : POSITION;
            };

            struct vertOutput
            {
                float4 position : SV_POSITION;
            };

            vertOutput vert(vertInput i)
            {
                vertOutput o;
                o.position = UnityObjectToClipPos(i.position);
                return o;
            }

            fixed4 frag(vertOutput o) : SV_TARGET
            {
                return _Color;
            }

            ENDCG
        }
    }
}
