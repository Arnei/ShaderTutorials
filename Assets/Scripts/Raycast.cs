using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Raycast : MonoBehaviour
{
    Camera cam;

    private Material hitMaterial;

    void Start()
    {
        cam = GetComponent<Camera>();
    }

    void Update()
    {
        RaycastHit hit;
        if (!Physics.Raycast(cam.ScreenPointToRay(Input.mousePosition), out hit))
            return;

        MeshCollider meshCollider = hit.collider as MeshCollider;
        if (meshCollider == null || meshCollider.sharedMesh == null)
            return;

        if (hit.collider.gameObject.GetComponent<BulletHole>() != null)
            hit.collider.gameObject.GetComponent<BulletHole>().drawBulletHole(hit.textureCoord);

        Mesh mesh = meshCollider.sharedMesh;
        Vector3[] vertices = mesh.vertices;
        int[] triangles = mesh.triangles;
        Vector3 p0 = vertices[triangles[hit.triangleIndex * 3 + 0]];
        Vector3 p1 = vertices[triangles[hit.triangleIndex * 3 + 1]];
        Vector3 p2 = vertices[triangles[hit.triangleIndex * 3 + 2]];
        Transform hitTransform = hit.collider.transform;
        p0 = hitTransform.TransformPoint(p0);
        p1 = hitTransform.TransformPoint(p1);
        p2 = hitTransform.TransformPoint(p2);
        Debug.DrawLine(p0, p1, Color.red);
        Debug.DrawLine(p1, p2, Color.blue);
        Debug.DrawLine(p2, p0, Color.green);
    }
}
