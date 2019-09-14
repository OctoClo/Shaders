Shader "Custom/Tex/Tween between 2 textures"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SecondTex ("Second Albedo (RGB)", 2D) = "white" {}
        _Tween ("Tween", Range(0, 1)) = 0
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
            sampler2D _SecondTex;
            float _Tween;

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
                return tex2D(_MainTex, o.uv) * (1 - _Tween) + tex2D(_SecondTex, o.uv) * _Tween;
            }

            ENDCG
        }
    }
}
