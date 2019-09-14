Shader "Custom/Post Processing/Outline"
{
    Properties
    {
        [HideInInspector]_MainTex ("Albedo (RGB)", 2D) = "white" {}
        [Header(Outline)]
        _OutlineColor ("Outline Color", Color) = (1, 1, 1, 1)
        _MainTextureVisible ("Main Texture Visible", Range(0, 1)) = 0
        _NormalsMult ("Normals Outline Multiplier", Range(0,4)) = 1
        _NormalsBias ("Normals Outline Bias", Range(1,4)) = 1
        _DepthMult ("Depth Outline Multiplier", Range(0,4)) = 1
        _DepthBias ("Depth Outline Bias", Range(1,4)) = 1
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
            float4 _CameraDepthNormalsTexture_TexelSize;

            float4 _OutlineColor;
            float _MainTextureVisible;
            float _NormalsMult;
            float _NormalsBias;
            float _DepthMult;
            float _DepthBias;

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

            void diffPixelNext(float baseDepth, float3 baseNormals, float2 uv, float2 offset, inout float depthOutline, inout float normalsOutline)
            {
                float neighborDepth;
                float3 neighborNormals;
                
                float4 neighborDepthnormals = tex2D(_CameraDepthNormalsTexture, uv + _CameraDepthNormalsTexture_TexelSize.xy * offset);
                DecodeDepthNormal(neighborDepthnormals, neighborDepth, neighborNormals);
                neighborDepth = neighborDepth * _ProjectionParams.z;

                float depthDifference = baseDepth - neighborDepth;
                depthOutline += depthDifference;

                float3 normalsDifference = baseNormals - neighborNormals;
                normalsDifference = normalsDifference.r + normalsDifference.g + normalsDifference.b;
                normalsOutline += normalsDifference;
            }

            fixed4 frag(vertOutput o) : SV_TARGET
            {
                float depth;
                float3 normals;
                
                float4 depthNormals = tex2D(_CameraDepthNormalsTexture, o.uv);
                DecodeDepthNormal(depthNormals, depth, normals);
                depth = depth * _ProjectionParams.z;

                float depthDifference = 0;
                float normalsDifference = 0;
                diffPixelNext(depth, normals, o.uv, float2(1, 0), depthDifference, normalsDifference);
                diffPixelNext(depth, normals, o.uv, float2(-1, 0), depthDifference, normalsDifference);
                diffPixelNext(depth, normals, o.uv, float2(0, 1), depthDifference, normalsDifference);
                diffPixelNext(depth, normals, o.uv, float2(0, -1), depthDifference, normalsDifference);

                depthDifference = depthDifference * _DepthMult;
                depthDifference = saturate(depthDifference);
                depthDifference = pow(depthDifference, _DepthBias);

                normalsDifference = normalsDifference * _NormalsMult;
                normalsDifference = saturate(normalsDifference);
                normalsDifference = pow(normalsDifference, _NormalsBias);

                float outline = normalsDifference + depthDifference;
                float4 sourceColor = tex2D(_MainTex, o.uv) * _MainTextureVisible;
                float4 color = lerp(sourceColor, _OutlineColor, outline);
                return color;

            }

            ENDCG
        }
    }
}
