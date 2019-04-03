using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class BloodyScreen : MonoBehaviour
{
	#region Variables
	public Shader curShader;
	public Texture2D blendTexture;
	public float blendOpacity = 1.0f;
    public Color bloodyColor = Color.red;

	private Material curMaterial;
	#endregion

	#region Properties
	Material material
	{
		get
		{
			if(curMaterial == null)
			{
				curMaterial = new Material(curShader);
				curMaterial.hideFlags = HideFlags.HideAndDontSave;
			}
			return curMaterial;
		}
	}
	#endregion

	// Start is called before the first frame update
	void Start()
	{
		if(!SystemInfo.supportsImageEffects)
		{
			enabled = false;
			return;
		}

		if(!curShader && !curShader.isSupported)
		{
			enabled = false;
		}
	}

	// Update is called once per frame
	void Update()
	{
		blendOpacity = Mathf.Clamp(blendOpacity, 0.0f, 1.0f);
	}

	void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
	{
		if(curShader != null)
		{
			material.SetTexture("_BlendTex", blendTexture);
			material.SetFloat("_Opacity", blendOpacity);
            material.SetColor("_Color", bloodyColor);

			Graphics.Blit(sourceTexture, destTexture, material);
		}
		else
		{
			Graphics.Blit(sourceTexture, destTexture);
		}
	}

	void OnDisable()
	{
		if(curMaterial)
		{
			DestroyImmediate(curMaterial);
		}
	}
}
