Shader "Custom/Toon/IceRefracted"
{
    Properties
    {
		_Color("Main Color", Color) = (0.49,0.94,0.64,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        [Header(Ramp)]
        [NoScaleOffset] _Ramp("Toon Ramp (RGB)", 2D) = "gray" {}
        [Header(Ice)]
		_TopColor("Top Color", Color) = (0.49,0.94,0.64,1)
		_BottomColor("Bottom Color", Color) = (0.23,0,0.95,1)
		_RimBrightness("Rim Brightness", Range(3,6)) = 3.2 
		_GradientOffset("Gradient Offset", Range(0,4)) = 3.2 
		[Toggle(ALPHA)] _ALPHA("Enable Alpha?", Float) = 0
		_BumpAmt("Distortion", range(0,10)) = 5
		_BumpMap("Normal Map", 2D) = "bump" {}
	}

    SubShader
    {
		Tags { "RenderType" = "Transparent" }

		UsePass "Custom/Toon/Frosty/FORWARD"
		UsePass "Custom/FX/Refraction/BASE"
		
	}

    Fallback "Toon/Lit"
}
