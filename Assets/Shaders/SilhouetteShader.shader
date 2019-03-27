﻿Shader "CookbookShaders/SilhouetteShader"
{
	// Really just the default shader
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_DotProduct("Rim effect", Range(-1,1)) = 0.25
		_Color("Color", Color) = (1, 1, 1, 1)
	}
		SubShader
		{
			Tags 
			{ 
				"Queue" = "Transparent"
				"IgnoreProjector" = "True"
				"RenderType" = "Transparent"
			}
			Cull Off
			LOD 200

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Lambert alpha:fade NoLighting

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0


			sampler2D _MainTex;
			float _DotProduct; 
			fixed4 _Color;

			struct Input
			{
				float2 uv_MainTex;
				float3 worldNormal;
				float3 viewDir;
			};



			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// #pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutput o)
			{
				float4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
				o.Albedo = c.rgb;

				float border = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));
				float alpha = (border * (1 - _DotProduct) + _DotProduct);
				o.Alpha = c.a * alpha;
			}
			ENDCG
		}
			FallBack "Diffuse"
}
