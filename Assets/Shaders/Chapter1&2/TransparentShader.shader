﻿Shader "CookbookShaders/TransparentShader"
{
	// Really just the default shader
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
	}
		SubShader
		{
			Tags 
			{ 
				"Queue" = "Transparent"
				"IgnoreProjector" = "True"
				"RenderType" = "Opaque"
			}
			Cull Back
			LOD 200

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard alpha:fade

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

			void surf(Input IN, inout SurfaceOutputStandard o)
			{
				float4 c = tex2D(_MainTex, IN.uv_MainTex);
				o.Albedo = c.rgb;
				o.Alpha = c.a;
			}
			ENDCG
		}
			FallBack "Diffuse"
}
