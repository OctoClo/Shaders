using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class PPDepthNormalsViewMatrix : MonoBehaviour
{
    public Material EffectMaterial;

    Camera cam;

    private void Start()
    {
        cam = GetComponent<Camera>();
        cam.depthTextureMode = cam.depthTextureMode | DepthTextureMode.DepthNormals;
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (EffectMaterial)
        {
            Matrix4x4 viewToWorld = cam.cameraToWorldMatrix;
            EffectMaterial.SetMatrix("_ViewToWorld", viewToWorld);
            Graphics.Blit(src, dest, EffectMaterial);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
