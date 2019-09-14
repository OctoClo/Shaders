using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ReplacementDepth : MonoBehaviour
{
    public Shader ReplacementShader;
    public Color DepthColor = Color.white;

    private void OnValidate()
    {
        Shader.SetGlobalColor("_DepthColor", DepthColor);
    }

    private void OnEnable()
    {
        if (ReplacementShader)
            GetComponent<Camera>().SetReplacementShader(ReplacementShader, "RenderType");
    }

    private void OnDisable()
    {
        GetComponent<Camera>().ResetReplacementShader();
    }
}
