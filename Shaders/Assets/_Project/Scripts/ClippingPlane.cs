using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ClippingPlane : MonoBehaviour
{
    public Material mat;

    void Update ()
    {
        Plane plane = new Plane(transform.up, transform.position);
        Vector4 planeRepresentation = new Vector4(plane.normal.x, plane.normal.y, plane.normal.z, plane.distance);
        mat.SetVector("_Plane", planeRepresentation);
    }
}
