Shader "Custom/Post Processing/Depth Wave"
{
    Properties
    {
        [HideInInspector]_MainTex ("Albedo (RGB)", 2D) = "white" {}
        [Header(Wave)]
        _WaveColor ("Color", Color) = (1, 1, 1, 1)
        _WaveTrail ("Length of the trail", Range(0,5)) = 1
        _WaveSpeed ("Speed", Range(0, 5)) = 1
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
            sampler2D _CameraDepthTexture;
            float4 _WaveColor;
            float _WaveTrail;
            float _WaveSpeed;

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
                depth *= _ProjectionParams.z;

                fixed4 sourceColor = tex2D(_MainTex, o.uv);
                
                // If we are at the end of clipping place, don't display the wave
                if (depth >= _ProjectionParams.z)
                    return sourceColor;

                float waveDistance = (_Time.y * _WaveSpeed) % _ProjectionParams.z;
                float waveFront = step(depth, waveDistance);
                float waveTrail = smoothstep(waveDistance - _WaveTrail, waveDistance, depth);
                float wave = waveFront * waveTrail;

                return lerp(sourceColor, _WaveColor, wave);
            }

            ENDCG
        }
    }
}
