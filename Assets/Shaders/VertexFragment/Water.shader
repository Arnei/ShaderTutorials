// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "CookbookShaders/Water"
{
	Properties
	{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_NoiseTex("Noise text", 2D) = "white" {}
		_Colour ("Colour", Color) = (1,1,1,1)

		_Period("Period", Range(0,50)) = 1
		_Magnitude ("Magnitude", Range(0,0.5)) = 0.05
		_Scale ("Scale", Range(0,10)) = 1
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Opaque" }
		LOD 200

		GrabPass{ }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _GrabTexture;

			sampler2D _MainTex;
			sampler2D _NoiseTex;
			fixed4 _Colour;
			
			float _Period;
			float _Magnitude;
			float _Scale;

			struct vertInput {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct vertOutput {
				float4 vertex : POSITION;
				//fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;

				float4 worldPos : TEXCOORD2;
				float4 uvgrab : TEXCOORD1;
			};

			// Vertex function
			vertOutput vert(vertInput v) {
				vertOutput o; //= (vertOutput)0;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				return o;
			}

			// Fragment function
			fixed4 frag(vertOutput i) : COLOR{
				half4 mainColour = tex2D(_MainTex, i.texcoord);

				float sinT = sin(_Time.w / _Period);
				float2 distortion = float2(tex2D(_NoiseTex, i.worldPos.xy / _Scale + float2(sinT, 0)).r - 0.5,
										   tex2D(_NoiseTex, i.worldPos.xy / _Scale + float2(0, sinT)).r - 0.5);
				i.uvgrab.xy += distortion * _Magnitude;
				
				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				return col * mainColour * _Colour;
			}
			ENDCG
		}
	}
}
