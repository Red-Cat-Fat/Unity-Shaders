﻿Shader "CookBookShaders/HalfLambert"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_HalfLambertCoefValue ("Half lambert coef value", Range(0,1)) = 0
		_HalfLambertMinStepValue ("Half lambert min step value", Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf HalfLambert 

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _HalfLambertCoefValue;
        float _HalfLambertMinStepValue;

		inline float4 LightingHalfLambert (SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float difLight = max(0, dot(s.Normal, lightDir));
            float hLambert = difLight * _HalfLambertCoefValue + _HalfLambertMinStepValue;
            float4 col;
            col.rgb = s.Albedo * _LightColor0.rgb * (hLambert * atten * 2);
            col.a = s.Alpha;
            return col;
        }

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
