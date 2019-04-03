Shader "ArnesShaders/BloodyScreen"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BlendTex ("Boody Texture", 2D) = "white" {}
        _Opacity ("Blend Opacity", Range(0,1)) = 1
		_Color ("Color Tint", Color) = (1,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
        	CGPROGRAM
        	#pragma vertex vert_img
        	#pragma fragment frag
        	#pragma fragmentoption ARB_precision_hint_fastest
        	#include "UnityCG.cginc"

        	uniform sampler2D _MainTex;
        	uniform sampler2D _BlendTex;
        	fixed _Opacity;
			fixed4 _Color;


        	fixed4 frag(v2f_img i) : COLOR
        	{
        		// Get the colors from the RenderTexture and the UV's
        		// from the v2f_img struct
        		fixed4 renderTex = tex2D(_MainTex, i.uv);
        		fixed4 blendTex = tex2D(_BlendTex, i.uv);

				
				fixed4 greyTex = dot(blendTex.rgb, float3(0.3, 0.59, 0.11));
				if (greyTex.r < _Opacity)
				{
					fixed4 blendedMultiply = renderTex * greyTex * _Color;
					renderTex = lerp(renderTex, blendedMultiply, _Opacity);
					return renderTex;
				}
				else
					return renderTex;

				//fixed4 intensityColor = _Color * (1.0 - greyTex);



        		// Perform a multiply Blend mode
        		//fixed4 blendedMultiply = renderTex * blendTex * intensityColor;
        		//fixed4 blendedMultiply = renderTex + blendTex;
        		//fixed4 blendedMultiply = (1.0 - ((1.0 - renderTex) * (1.0 - blendTex)));

        		// Apply the Luminosity values to our render texture
        		//renderTex = lerp(renderTex, blendedMultiply, _Opacity);

				//return renderTex;
        	}

        	ENDCG
        }
    }
}
