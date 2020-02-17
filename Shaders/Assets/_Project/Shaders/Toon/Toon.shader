Shader "Custom/Toon/Toon"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        [HDR] _Emission ("Emission", color) = (0, 0, 0)
        [Header(Ramp)]
        [NoScaleOffset] _Ramp ("Toon Ramp", 2D) = "white" {}
        [Header(Shadows)]
        _ShadowTint ("Shadow Color", Color) = (0, 0, 0, 1)
        [IntRange] _StepAmount ("Shadow Steps", Range(1, 16)) = 2
        _StepWidth ("Step Size", Range(0.05, 1)) = 0.25
        [Header(Specular)]
        _SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
        _SpecularSize ("Specular Size", Range(0, 1)) = 0.1
        _SpecularFalloff ("Specular Falloff", Range(0, 2)) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }
        
        CGPROGRAM

        #pragma surface surf Stepped fullforwardshadows
        #pragma target 3.0

        fixed4 _Color;
        sampler2D _MainTex;
        float4 _Emission;

        sampler2D _Ramp;

        float3 _ShadowTint;
        float _StepAmount;
        float _StepWidth;

        fixed3 _SpecularColor;
        float _SpecularSize;
        float _SpecularFalloff;

        struct Input
        {
            float2 uv_MainTex;
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
            fixed4 color = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = color.rgb;
            o.Alpha = color.a;
            o.Emission = _Emission;
            o.Specular = _SpecularColor;
        }

        float4 LightingStepped(ToonSurfaceOutput s, float3 lightDir, half3 viewDir, float shadowAttenuation)
        {
            float towardsLight = dot(s.Normal, lightDir);
            towardsLight *= tex2D(_Ramp, towardsLight).rgb;

            /** Steps **/

            // Width of steps
            towardsLight /= _StepWidth;
            float lightIntensity = floor(towardsLight);

            // Hard cut with smoothing for AA
            float change = fwidth(towardsLight);
            float smoothing = smoothstep(0, change, frac(towardsLight));
            lightIntensity += smoothing;

            // Number of steps
            lightIntensity /= _StepAmount;
            lightIntensity = saturate(lightIntensity);

            /** Shadows **/
#ifdef USING_DIRECTIONAL_LIGHT
            float attenuationChange = fwidth(shadowAttenuation) * 0.5;
            float shadow = smoothstep(0.5 - attenuationChange, 0.5 + attenuationChange, shadowAttenuation);
#else
            float attenuationChange = fwidth(shadowAttenuation);
            float shadow = smoothstep(0, attenuationChange, shadowAttenuation);
#endif
            lightIntensity *= shadow;
            float3 shadowColor = s.Albedo * _ShadowTint;

            /** Specular **/

            // Direction of reflection
            float3 reflectionDirection = reflect(lightDir, s.Normal);
            float towardsReflection = dot(viewDir, -reflectionDirection);

            // Fall off towards outside of the model (inverse Fresnel?)
            float specularFalloff = dot(viewDir, s.Normal);
            specularFalloff = pow(specularFalloff, _SpecularFalloff);
            towardsReflection *= specularFalloff;
            
            // Hard cut with smoothing for AA
            float specularChange = fwidth(towardsReflection);
            float specularIntensity = smoothstep(1 - _SpecularSize, 1 - _SpecularSize + specularChange, towardsReflection);
            specularIntensity = specularIntensity * shadow;

            /** Final color **/
            float4 color;
            color.rgb = lerp(shadowColor, s.Albedo, lightIntensity) * _LightColor0.rgb;
            color.rgb = lerp(color.rgb, s.Specular * _LightColor0.rgb, saturate(specularIntensity));
            color.a = s.Alpha;

            return color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
