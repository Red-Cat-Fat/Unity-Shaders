Shader "CookBookShaders/BasicDiffuse"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_EmissiveColor ("Emissive Color", Color) = (0,1,1,1)
		_AmbientColor ("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue ("My slider value", Range(0,10)) = 2.4
		_MySliderValuePow ("My mp", Range(0,100)) = 2.4
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Resolution ("Resolution", Vector) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        float4 _EmissiveColor;
        float4 _AmbientColor;
        float _MySliderValue;
        float _MySliderValuePow;
        #pragma surface surf BasicDiffuse 

		inline float4 LightingBasicDiffuse (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
        {
            float difLight = max(0, dot(s.Normal, viewDir));
            float4 col;
            col.rgb = s.Albedo * pow(_LightColor0.rgb * (difLight * atten * _MySliderValue), _MySliderValuePow);
            col.a = s.Alpha;
            return col;
        }

        #pragma target 3.0

        sampler2D _MainTex;
        
        struct Input
        {  
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)
		
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
