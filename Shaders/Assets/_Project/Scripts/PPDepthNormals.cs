using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class PPDepthNormals : MonoBehaviour
{
    public Material EffectMaterial;

    private void Start()
    {
        Camera cam = GetComponent<Camera>();
        cam.depthTextureMode = cam.depthTextureMode | DepthTextureMode.DepthNormals;
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (EffectMaterial)
        {
            Graphics.Blit(src, dest, EffectMaterial);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
