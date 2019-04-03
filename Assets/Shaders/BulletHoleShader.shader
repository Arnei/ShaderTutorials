Shader "ArnesShaders/BulletHoleShader"
{
    Properties
    {
        _MainTex ("Main Albedo (RGB)", 2D) = "white" {}
		_BulletTex ("Bullet Albedo (RGB)", 2D) = "white" {}
		_HoleCoords ("Hit Coordinates from BulletHole Script", Vector) = (10, 10, 10, 10)
		_Radius ("Radius", Range(0, 1)) = 0.5

        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _BulletTex;
		fixed4 _HoleCoords;
		float _Radius;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)


		float remap(float from, float fromMin, float fromMax, float toMin, float toMax)
		{
			float fromAbs = from - fromMin;
			float fromMaxAbs = fromMax - fromMin;

			float normal = fromAbs / fromMaxAbs;

			float toMaxAbs = toMax - toMin;
			float toAbs = toMaxAbs * normal;

			float to = toAbs + toMin;

			return to;
		}

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			fixed4 mainTex = tex2D(_MainTex, IN.uv_MainTex);

			float d = distance(IN.uv_MainTex, _HoleCoords.xy);
			if (d <= _Radius)
			{
				float x = remap((IN.uv_MainTex.x - _HoleCoords.x), -_Radius, _Radius, 0, 1);
				float y = remap((IN.uv_MainTex.y - _HoleCoords.y), -_Radius, _Radius, 0, 1);

				fixed4 bulletTex = tex2D(_BulletTex, float2(x, y));

				fixed4 finalTex = lerp(mainTex, bulletTex, bulletTex.a);

				o.Albedo = finalTex.rgb;
			}
			else
				o.Albedo = mainTex;



            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
