Shader "Hidden/Depth"
{
    Properties
    {
        
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
        }

        ZTest Always
        ZWrite Off
        Blend One One

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _OverDrawColor;

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
                return _OverDrawColor;
            }

            ENDCG
        }
    }
}
