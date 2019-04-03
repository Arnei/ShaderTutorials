using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BulletHole : MonoBehaviour
{
    //hit.textureCoord
    public Shader curShader;
    public Material curMaterial;

    #region Properties
    Material material
    {
        get
        {
            if (curMaterial == null)
            {
                curMaterial = new Material(curShader);
                curMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return curMaterial;
        }
    }
    #endregion

    public void drawBulletHole(Vector2 UVCoords)
    {
        curMaterial.SetVector("_HoleCoords", new Vector4(UVCoords.x, UVCoords.y, 0, 0));
    }



}
