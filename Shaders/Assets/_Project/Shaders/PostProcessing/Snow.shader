Shader "Custom/Post Processing/Normals"
{
    Properties
    {
        [HideInInspector]_MainTex ("Albedo (RGB)", 2D) = "white" {}
        [Header(Snow)]
        _SnowColor ("Snow color", Color) = (1, 1, 1, 1)
        _SnowDirection ("Snow direction", Range(-0.5, 0.5)) = 0
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
            sampler2D _CameraDepthNormalsTexture;
            float4x4 _ViewToWorld;
            float4 _SnowColor;
            float _SnowDirection;

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
                float4 depthNormals = tex2D(_CameraDepthNormalsTexture, o.uv);

                float depth;
                float3 normals;
                DecodeDepthNormal(depthNormals, depth, normals);

                depth = depth * _ProjectionParams.z;
                normals = mul((float3x3)_ViewToWorld, normals);

                float up = dot(float3(_SnowDirection, 1, 0), normals);
                float4 sourceColor = tex2D(_MainTex, o.uv);
                float4 color = lerp(sourceColor, _SnowColor, up);

                return color;
            }

            ENDCG
        }
    }
}
