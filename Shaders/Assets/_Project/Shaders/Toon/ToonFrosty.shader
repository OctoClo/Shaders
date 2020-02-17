Shader "Custom/Toon/Frosty"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        [Header(Ramp)]
        [NoScaleOffset] _Ramp ("Toon Ramp", 2D) = "white" {}
        [Header(Ice)]
        _TopColor("Top Color", Color) = (0.49, 0.94, 0.64, 1)
		_BottomColor("Bottom Color", Color) = (0.23, 0, 0.95, 1)
        _RimBrightness("Rim Brightness", Range(3, 4)) = 3.2
        _GradientOffset("Gradient Offset", Range(-4,4)) = 3.2
        [Toggle(ALPHA)] _ALPHA("Enable Alpha?", Float) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }

        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha
        
        CGPROGRAM

        #pragma shader_feature ALPHA
        #pragma surface surf Stepped keepalpha
        #pragma target 3.0

        fixed4 _Color;
        sampler2D _MainTex;

        sampler2D _Ramp;

        fixed4 _TopColor;
        fixed4 _BottomColor;
        float _RimBrightness;
        float _GradientOffset;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldPos;
        };

        struct ToonSurfaceOutput
        {
            fixed3 Albedo;
            half3 Emission;
            fixed3 Specular;
            fixed Alpha;
            fixed3 Normal;
        };

        void surf (Input IN, inout ToonSurfaceOutput o)
        {
            float3 localPos = (IN.worldPos - mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz);
            float softRim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal)) ;
            float hardRim = round(softRim);
            float innerRim = 1.5 + saturate(dot(normalize(IN.viewDir), o.Normal));
		
            float4 color;
            color.rgb = _Color * tex2D(_MainTex, IN.uv_MainTex);
            color.rgb *= pow(innerRim, 0.7) * lerp(_BottomColor, _TopColor, saturate(localPos.y + _GradientOffset));
            o.Albedo = color;
            o.Alpha = 1;
#if ALPHA
		    o.Alpha = 1 * softRim * (2 - saturate(localPos.y));
#endif
            float3 adjustLocalPos = saturate(float3(localPos.x, localPos.y, localPos.z)) + 0.4;
            o.Emission = _Color * lerp(hardRim, softRim, saturate(adjustLocalPos.x + adjustLocalPos.y ))  * lerp(0, _RimBrightness, adjustLocalPos.y);
        }

        float4 LightingStepped(ToonSurfaceOutput s, float3 lightDir, float atten)
        {
            half towardsLight = dot(s.Normal, lightDir) * 0.5 + 0.5;
            half3 ramp = tex2D(_Ramp, float2(towardsLight, towardsLight)).rgb;

            half4 color;
            color.rgb = s.Albedo * _LightColor0.rgb * ramp * (atten * 2);
            color.a = s.Alpha;
            return color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
