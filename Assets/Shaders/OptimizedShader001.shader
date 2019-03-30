Shader "CookbookShaders/OptimizedShader001"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BlendTex ("Blend Texture", 2D) = "white"  {}
        _NormalMap ("Normal Map", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf SimpleLambert exclude_path:prepass noforwardadd

        // Use shader model 3.0 target, to get nicer looking lighting
        //#pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BlendTex;
        sampler2D _NormalMap;

        struct Input
        {
            half2 uv_MainTex;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 blendTex = tex2D(_BlendTex, IN.uv_MainTex);

            c = lerp(c, blendTex, blendTex.r);

            o.Albedo = c.rgb;
            o.Alpha = c.a;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
        }

        inline float4 LightingSimpleLambert (SurfaceOutput s, float3 lightDir, float atten)
        {
        	fixed diff = max(0, dot (s.Normal, lightDir));

        	fixed4 c;
        	c.rgb = s.Albedo * _LightColor0.rgb * (diff *atten *2);
        	c.a = s.Alpha;
        	return c;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
